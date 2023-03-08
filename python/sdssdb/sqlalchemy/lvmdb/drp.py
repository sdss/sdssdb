# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#

from __future__ import absolute_import, division, print_function

from sdssdb.sqlalchemy.lvmdb import database, LVMBase
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship
from sqlalchemy.types import TypeDecorator, VARCHAR, DOUBLE_PRECISION
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy import Column, func, cast, text
from sqlalchemy.ext.hybrid import hybrid_method


SCHEMA = 'drp'


class PolygonType(TypeDecorator):
    """Represents the native polygon data type in PostgreSQL (i.e. *not* PostGIS).

    Usage::

        polygonColumnName = Column('polygon_column_name', PGPolygon)

    """

    impl = VARCHAR
    cache_ok = True

    def process_bind_param(self, value, dialect):
        """ Convert the python list if tuples into a polygon string

        Convert the python list of coordinates into a string to be
        entered into the database.  The value should be of the form,
        e.g. [ (x1,y1), (x2,y2), (x3,y3), ... ]
        """
        if not value:
            return
        return "({0})".format(",".join([str(x) for x in value]))

    def process_result_value(self, value, dialect):
        """ Convert the db result back to a python object

        Convert the db polygon value back into a Python list of
        point tuples. Incoming format looks like: '((12,34),(56,78),(90,12))'
        """
        if not value:
            return
        polygon = []
        for point in value[1:-1].split("),("): # also strip outer single quotes
            point = point.lstrip("(") # remove extra "(" ")" (first and last elements only)
            point = point.rstrip(")")
            x, y = point.split(",")
            polygon.append((float(x), float(y)))
        value = polygon
        return value

    def coerce_compared_value(self, op, value):
        return self.impl.coerce_compared_value(op, value)


class Base(AbstractConcreteBase, LVMBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class Pipeline(Base):
    __tablename__ = 'pipeline'
    print_fields = ['version', 'label', 'release']


class Header(Base):
    __tablename__ = 'header'
    print_fields = ['key', 'value']


class Fibers(Base):
    __tablename__ = 'fibers'
    print_fields = ['fiberid', 'targettype', 'ifulabel', 'finifu']


class IFU(Base):
    __tablename__ = 'ifu'
    print_fields = ['fiberid']


class ObsInfo(Base):
    __tablename__ = 'obsinfo'
    print_fields = ['expnum']


class PolySearch:
    """ Class for enabling searches using polygons """

    @hybrid_method
    def poly_search(self, poly):
        """ Returns a query with the rows that fall within a polygon region on the sky. """

        assert hasattr(self, self.ra_col) and hasattr(self, self.dec_col), \
            'this model class does not have ra/dec columns.'

        ra_attr = getattr(self, self.ra_col)
        dec_attr = getattr(self, self.dec_col)

        poly_arr = sum(map(list, poly), [])
        carr = cast(poly_arr, ARRAY(DOUBLE_PRECISION))
        return func.q3c_poly_query(ra_attr, dec_attr, carr)

    @poly_search.expression
    def poly_search(cls, poly):

        assert hasattr(cls, cls.ra_col) and hasattr(cls, cls.dec_col), \
            'this model class does not have ra/dec columns.'

        ra_attr = getattr(cls, cls.ra_col)
        dec_attr = getattr(cls, cls.dec_col)

        poly_arr = sum(map(list, poly), [])
        carr = cast(poly_arr, ARRAY(DOUBLE_PRECISION))
        return func.q3c_poly_query(ra_attr, dec_attr, carr)


class RSSFiber(PolySearch, Base):
    __tablename__ = 'rssfiber'
    ra_col = 'ra'
    dec_col = 'dec'


class RSS(PolySearch, Base):
    __tablename__ = 'rss'
    print_fields = ['tileid', 'ifura', 'ifudec']
    ra_col = 'ifura'
    dec_col = 'ifudec'

    footprint = Column('footprint', PolygonType)

    @hybrid_method
    def in_poly(self, ra, dec):
        """Returns a query with the rows where the input points falls within a tile footprint """

        assert hasattr(self, self.ra_col) and hasattr(self, self.dec_col), \
            'this model class does not have ra/dec columns.'

        return func.q3c_in_poly(ra, dec, self.footprint)

    @in_poly.expression
    def in_poly(cls, ra, dec):

        assert hasattr(cls, cls.ra_col) and hasattr(cls, cls.dec_col), \
            'this model class does not have ra/dec columns.'

        return func.q3c_in_poly(ra, dec, cls.footprint)

    @hybrid_method
    def poly_intersect(self, poly):
        """Returns a query with the rows that intersect with the input sky polygon region """

        assert hasattr(self, self.ra_col) and hasattr(self, self.dec_col), \
            'this model class does not have ra/dec columns.'
        poly_tup = f"'{tuple(poly)}'"
        return text(f"polygon {poly_tup} && drp.rss.footprint")

    @poly_intersect.expression
    def poly_intersect(cls, poly):

        assert hasattr(cls, cls.ra_col) and hasattr(cls, cls.dec_col), \
            'this model class does not have ra/dec columns.'
        poly_tup = f"'{tuple(poly)}'"
        return text(f"polygon {poly_tup} && drp.rss.footprint")

class Wavelength(Base):
    __tablename__ = 'wavelength'
    print_fields = ['index', 'value']


def define_relations():
    """Setup relationships after preparation."""

    RSS.pipeline = relationship(Pipeline, backref="rss")
    RSS.obsinfo = relationship(ObsInfo, backref='rss')
    Header.rss = relationship(RSS, backref="header")
    Fibers.ifu = relationship(IFU, backref="fibers")
    RSSFiber.rss = relationship(RSS, backref='rssfibers')
    RSSFiber.fibers = relationship(Fibers, backref='rssfibers')
    RSSFiber.wavelength = relationship(Wavelength, backref='rssfibers')
    RSSFiber.obsinfo = relationship(ObsInfo, backref='rssfibers')


# prepare the base
database.add_base(Base)
