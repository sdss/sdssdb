# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:50
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 16:07:58

from __future__ import absolute_import, division, print_function

import itertools
import math
import shutil

import numpy as np
from sdssdb.sqlalchemy.mangadb import MangaBase, database
from sqlalchemy import Float, ForeignKey, ForeignKeyConstraint, case, cast, func
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.ext.hybrid import hybrid_method, hybrid_property
from sqlalchemy.inspection import inspect as sa_inspect
from sqlalchemy.orm import backref, relationship
from sqlalchemy.schema import Column
from sqlalchemy.types import Integer


try:
    import cStringIO as StringIO
except ImportError:
    from io import StringIO


SCHEMA = 'mangasampledb'


class Base(AbstractConcreteBase, MangaBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}

    @classmethod
    def add_table_constraints(cls, constraints):
        ''' Add foreign key constraints

        Appends foreign key constraints to the underlying db table

        Parameters:
            constraints (list):
                A list of ForeignKeyConstraints to add to the table

        '''

        if not isinstance(constraints, (list, tuple)):
            constraints = [constraints]

        if cls.__table__.columns.keys():
            for con in constraints:
                assert isinstance(con, ForeignKeyConstraint), 'constraint must be a ForeignKeyConstraint'
                cls.__table__.append_constraint(con)


# The softening parameter for asinh magnitudes
bb = {'u': 1.4e-10,
      'g': 0.9e-10,
      'r': 1.2e-10,
      'i': 1.8e-10,
      'z': 7.4e-10}


class MangaTarget(Base):
    __tablename__ = 'manga_target'
    print_fields = ['mangaid']


class Anime(Base):
    __tablename__ = 'anime'
    print_fields = ['anime']


class Character(Base):
    __tablename__ = 'character'

    target = relationship(MangaTarget, backref='character', uselist=False)
    anime = relationship(Anime, backref='characters')

    def savePicture(self, path):
        """Saves the picture blob to disk."""

        buf = StringIO(self.picture)
        with open(path, 'w') as fd:
            buf.seek(0)
            shutil.copyfileobj(buf, fd)

        return buf


class Catalogue(Base):
    __tablename__ = 'catalogue'
    print_fields = ['catalogue_name', 'version', 'isCurrent']

    @property
    def isCurrent(self):
        return self.currentCatalogue is not None


class CurrentCatalogue(Base):
    __tablename__ = 'current_catalogue'

    catalogue = relationship(
        'Catalogue', backref=backref('currentCatalogue', uselist=False))


class MangaTargetToMangaTarget(Base):
    __tablename__ = 'manga_target_to_manga_target'


class NSA(Base):
    __tablename__ = 'nsa'
    print_fields = ['nsaid']

    catalogue_pk = Column(Integer, ForeignKey('mangasampledb.catalogue.pk'))


class MangaTargetToNSA(Base):
    __tablename__ = 'manga_target_to_nsa'

    nsa_pk = Column(Integer, ForeignKey('mangasampledb.nsa.pk'))
    manga_target_pk = Column(Integer, ForeignKey('mangasampledb.manga_target.pk'))


def HybridMag(flux_parameter, band, index=None):
    """Returns a hybrid property describing an asinh magnitude.

    ``flux_parameter`` must be a column with a flux in nanomaggies. ``band`` is
    the band name, to determine the softening parameter. If ``flux_parameter``
    is and array, ``index`` defines the position of ``band`` within the array.

    """

    @hybrid_property
    def hybridMag(self):
        if index is not None:
            flux = getattr(self, flux_parameter)[index]
        else:
            flux = getattr(self, flux_parameter)

        flux *= 1e-9  # From nanomaggies to maggies
        bb_band = bb[band]
        asinh_mag = -2.5 / np.log(10) * (np.arcsinh(flux / (2. * bb_band)) + np.log(bb_band))
        return asinh_mag

    @hybridMag.expression
    def hybridMag(cls):
        if index is not None:
            # It needs to be index + 1 because Postgresql arrays are 1-indexed.
            flux = getattr(cls, flux_parameter)[index + 1]
        else:
            flux = getattr(cls, flux_parameter)

        flux *= 1e-9
        bb_band = bb[band]
        xx = flux / (2. * bb_band)
        asinh_mag = (-2.5 / func.log(10) *
                     (func.log(xx + func.sqrt(func.pow(xx, 2) + 1)) + func.log(bb_band)))
        return cast(asinh_mag, Float)

    return hybridMag


def HybridColour(parameter):

    @hybrid_method
    def colour(self, bandA, bandB):

        for band in [bandA, bandB]:
            columnName = parameter + '_' + band
            assert hasattr(self, columnName), \
                'cannot find column {0}'.format(columnName)

        bandA_param = getattr(self, parameter + '_' + bandA)
        bandB_param = getattr(self, parameter + '_' + bandB)

        return bandA_param - bandB_param

    @colour.expression
    def colour(cls, bandA, bandB):

        for band in [bandA, bandB]:
            columnName = parameter + '_' + band
            assert hasattr(cls, columnName), \
                'cannot find column {0}'.format(columnName)

        bandA_param = getattr(cls, parameter + '_' + bandA)
        bandB_param = getattr(cls, parameter + '_' + bandB)

        return bandA_param - bandB_param

    return colour


def HybridMethodToProperty(method, bandA, bandB):

    @hybrid_property
    def colour_property(self):
        return getattr(self, method)(bandA, bandB)

    return colour_property


def HybridPropertyArrayIndex(column, index):
    """Creates a hybrid property for a certain index of a column of type array."""

    @hybrid_property
    def array_band(self):
        return getattr(self, column)[index]

    return array_band


# Adds hybrid properties defining asinh magnitudes for each of the SDSS bands.
for ii, band in enumerate('ugriz'):
    propertyName = 'elpetro_mag_{0}'.format(band)
    setattr(NSA, propertyName, HybridMag('elpetro_flux', band, ii + 2))

# Creates attributes for apparent magnitudes.
setattr(NSA, 'elpetro_colour', HybridColour('elpetro_mag'))
for colour_a, colour_b in itertools.combinations('ugriz', 2):
    setattr(NSA, 'elpetro_mag_{0}_{1}'.format(colour_a, colour_b),
            HybridMethodToProperty('elpetro_colour', colour_a, colour_b))

# Expands elpetro_absmag into independent bands.
for index, band in enumerate('FNugriz'):
    setattr(NSA, 'elpetro_absmag_{0}'.format(band),
            HybridPropertyArrayIndex('elpetro_absmag', index))

setattr(NSA, 'elpetro_absmag_colour', HybridColour('elpetro_absmag'))
for colour_a, colour_b in itertools.combinations('FNugriz', 2):
    setattr(NSA, 'elpetro_absmag_{0}_{1}'.format(colour_a, colour_b),
            HybridMethodToProperty('elpetro_absmag_colour', colour_a, colour_b))


# Add stellar mass hybrid attributes to NSA catalog
def logmass(parameter):

    @hybrid_property
    def mass(self):
        par = getattr(self, parameter)
        return math.log10(par) if par > 0. else 0.

    @mass.expression
    def mass(cls):
        par = getattr(cls, parameter)
        return cast(case([(par > 0., func.log(par)),
                          (par == 0., 0.)]), Float)

    return mass


setattr(NSA, 'elpetro_logmass', logmass('elpetro_mass'))
setattr(NSA, 'sersic_logmass', logmass('sersic_mass'))


def define_relations():
    """Setup relationships after preparation."""

    NSA.mangaTargets = relationship(
        MangaTarget, backref='NSA_objects', secondary=MangaTargetToNSA.__table__)


#
# This section still needs work and does not quite work yet.
#

# class factory
def ClassFactory(name, tableName, BaseClass=Base, fks=None):
    tableArgs = []
    if fks:
        for fk in fks:
            tableArgs.insert(0, ForeignKeyConstraint([fk[0]], [fk[1]]))

    # define new class
    newclass = type(name, (BaseClass,), {'__tablename__': tableName})
    # add any constraints
    if fks:
        newclass.add_table_constraints(tableArgs)

    return newclass


def add_catalogue(classname, tablename, has_manga_target=None):
    ''' Add a catalogue model class and connect it to manga_target table '''

    catfks = [('catalogue_pk', 'mangasampledb.catalogue.pk')]
    new_class = ClassFactory(className, tablename, fks=catfks)
    new_class.catalogue = relationship(Catalogue, backref='{0}_objects'.format(tablename))
    globals()[classname] = new_class

    if has_manga_target:
        relfks = [('manga_target_pk', 'mangasampledb.manga_target.pk'),
                  ('{0}_pk'.format(tablename), 'mangasampledb.{0}.pk'.format(tablename))]
        relationalTableName = 'manga_target_to_{0}'.format(tablename)
        relationalClassName = 'MangaTargetTo{0}'.format(tablename.upper())
        new_relationalclass = ClassFactory(relationalClassName, relationalTableName,
                                           fks=relfks)
        globals()[relationalClassName] = new_relationalclass

        new_class.mangaTargets = relationship(MangaTarget, backref='{0}_objects'.format(tablename),
                                              secondary=new_relationalclass.__table__)


# Now we create any remaining catalogue tables.
insp = sa_inspect(database.engine)
allTables = insp.get_table_names(schema=SCHEMA)

done_names = list(Base.metadata.tables.keys())
for tableName in allTables:
    if SCHEMA + '.' + tableName in done_names:
        continue
    className = str(tableName).upper()

    # create a new catalogue model class and optional manga_target_to_catalogue relational model
    relational_tablename = 'manga_target_to_{0}'.format(tableName)
    has_manga_target = relational_tablename in allTables
    add_catalogue(className, tableName, has_manga_target=has_manga_target)

    # add catalog to list of dones
    done_names.append(SCHEMA + '.' + tableName)
    if has_manga_target:
        done_names.append(SCHEMA + '.' + relational_tablename)


# prepare the base
database.add_base(Base)
