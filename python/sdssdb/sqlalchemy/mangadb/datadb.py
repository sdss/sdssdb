# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:08
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 14:43:05

from __future__ import absolute_import, division, print_function

import math
import re
from decimal import Decimal
from operator import eq, ge, gt, le, lt, ne

import numpy as np
from astropy.io import fits
from sdssdb.sqlalchemy.mangadb import MangaBase, database, sampledb
from sqlalchemy import and_, func, select
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.engine import reflection
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.ext.hybrid import hybrid_method, hybrid_property
from sqlalchemy.orm import deferred, relationship
from sqlalchemy.schema import Column
from sqlalchemy.sql import column
from sqlalchemy.types import Float, Integer, String


SCHEMA = 'mangadatadb'


class Base(AbstractConcreteBase, MangaBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class ArrayOps(object):
    ''' this class adds array functionality '''

    __table__ = None
    __tablename__ = 'arrayops'

    @property
    def cols(self):
        return list(self.__table__.columns._data.keys())

    @property
    def collist(self):
        return ['wavelength', 'flux', 'ivar', 'mask', 'xpos', 'ypos', 'specres']

    def getTableName(self):
        return self.__table__.name

    def matchIndex(self, name=None):

        # Get index of correct column
        incols = [x for x in self.cols if x in self.collist]
        if not any(incols):
            return None
        elif len(incols) == 1:
            idx = self.cols.index(incols[0])
        else:
            if not name:
                print('Multiple columns found.  Column name must be specified!')
                return None
            elif name in self.collist:
                idx = self.cols.index(name)
            else:
                return None

        return idx

    def filter(self, start, end, name=None):

        # Check input types or map string operators
        startnum = type(start) == int or type(start) == float
        endnum = type(end) == int or type(end) == float
        opdict = {'=': eq, '<': lt, '<=': le, '>': gt, '>=': ge, '!=': ne}
        if start in opdict.keys() or end in opdict.keys():
            opind = list(opdict.keys()).index(start) if start in opdict.keys() else list(opdict.keys()).index(end)
            if start in opdict.keys():
                start = opdict[list(opdict.keys())[opind]]
            if end in opdict.keys():
                end = opdict[list(opdict.keys())[opind]]

        # Get matching index
        self.idx = self.matchIndex(name=name)
        if not self.idx:
            return None

        # Perform calculation
        try:
            data = self.__getattribute__(self.cols[self.idx])
        except:
            data = None

        if data:
            if startnum and endnum:
                arr = [x for x in data if x >= start and x <= end]
            elif not startnum and endnum:
                arr = [x for x in data if start(x, end)]
            elif startnum and not endnum:
                arr = [x for x in data if end(x, start)]
            elif startnum == eq or endnum == eq:
                arr = [x for x in data if start(x, end)] if start == eq else [x for x in data if end(x, start)]
            return arr
        else:
            return None

    def equal(self, num, name=None):

        # Get matching index
        self.idx = self.matchIndex(name=name)
        if not self.idx:
            return None

        # Perform calculation
        try:
            data = self.__getattribute__(self.cols[self.idx])
        except:
            data = None

        if data:
            arr = [x for x in data if x == num]
            return arr
        else:
            return None

    def less(self, num, name=None):

        # Get matching index
        self.idx = self.matchIndex(name=name)
        if not self.idx:
            return None

        # Perform calculation
        try:
            data = self.__getattribute__(self.cols[self.idx])
        except:
            data = None

        if data:
            arr = [x for x in data if x <= num]
            return arr
        else:
            return None

    def greater(self, num, name=None):

        # Get matching index
        self.idx = self.matchIndex(name=name)
        if not self.idx:
            return None

        # Perform calculation
        try:
            data = self.__getattribute__(self.cols[self.idx])
        except:
            data = None

        if data:
            arr = [x for x in data if x >= num]
            return arr
        else:
            return None

    def getIndices(self, arr):

        if self.idx:
            indices = [self.__getattribute__(self.cols[self.idx]).index(a) for a in arr]
        else:
            return None

        return indices


class Cube(ArrayOps, Base):
    __tablename__ = 'cube'
    print_fields = ['plateifu', 'pipelineInfo.version.version']

    specres = deferred(Column(ARRAY(Float, zero_indexes=True)))
    specresd = deferred(Column(ARRAY(Float, zero_indexes=True)))
    prespecres = deferred(Column(ARRAY(Float, zero_indexes=True)))
    prespecresd = deferred(Column(ARRAY(Float, zero_indexes=True)))

    target = relationship(sampledb.MangaTarget, backref='cubes')
    carts = relationship('Cart', secondary='{0}.cart_to_cube'.format(SCHEMA), backref="cubes")

    @property
    def header(self):
        '''Returns an astropy header'''

        session = database.Session.object_session(self)
        data = session.query(FitsHeaderKeyword.label, FitsHeaderValue.value,
                             FitsHeaderValue.comment).join(FitsHeaderValue).filter(
            FitsHeaderValue.cube == self).all()

        hdr = fits.Header(data)
        return hdr

    def header_to_dict(self):
        '''Returns a simple python dictionary header'''

        values = self.headervals
        hdrdict = {str(val.keyword.label): val.value for val in values}
        return hdrdict

    @property
    def plateclass(self):
        '''Returns a plate class'''

        plate = Plate(self)

        return plate

    def testhead(self, key):
        ''' Test existence of header keyword'''

        try:
            if self.header_to_dict()[key]:
                return True
        except Exception:
            return False

    def getFlags(self, bits, name):
        from sdssdb.sqlalchemy.mangadb.auxdb import MaskBit
        session = database.Session.object_session(self)

        # if bits not a digit, return None
        if not str(bits).isdigit():
            return 'NULL'
        else:
            bits = int(bits)

        # Convert the integer value to list of bits
        bitlist = [int(i) for i in '{0:08b}'.format(bits)]
        bitlist.reverse()
        indices = [i for i, bit in enumerate(bitlist) if bit]

        labels = []
        for i in indices:
            maskbit = session.query(MaskBit).filter_by(flag=name, bit=i).one()
            labels.append(maskbit.label)

        return labels

    def getQualBits(self, stage='3d'):
        ''' get quality flags '''

        col = 'DRP2QUAL' if stage == '2d' else 'DRP3QUAL'
        hdr = self.header_to_dict()
        bits = hdr.get(col, None)
        return bits

    def getQualFlags(self, stage='3d'):
        ''' get quality flags '''

        name = 'MANGA_DRP2QUAL' if stage == '2d' else 'MANGA_DRP3QUAL'
        bits = self.getQualBits(stage=stage)

        if bits:
            return self.getFlags(bits, name)
        else:
            return None

    def getTargFlags(self, targtype=1):
        ''' get target flags '''

        name = 'MANGA_TARGET1' if targtype == 1 else 'MANGA_TARGET2' if targtype == 2 else 'MANGA_TARGET3'
        bits = self.getTargBits(targtype=targtype)
        if bits:
            return self.getFlags(bits, name)
        else:
            return None

    def getTargBits(self, targtype=1):
        ''' get target bits '''

        assert targtype in [1, 2, 3], 'target type can only 1, 2 or 3'

        hdr = self.header_to_dict()
        newcol = 'MNGTARG{0}'.format(targtype)
        oldcol = 'MNGTRG{0}'.format(targtype)
        bits = hdr.get(newcol, hdr.get(oldcol, None))
        return bits

    def get3DCube(self, extension='flux'):
        """Returns a 3D array of ``extension`` from the cube spaxels.

        For example, ``cube.get3DCube('flux')`` will return the original
        flux cube with the same ordering as the FITS data cube.

        Note that this method seems to be really slow retrieving arrays (this
        is especially serious for large IFUs).

        """

        session = database.Session.object_session(self)
        spaxels = session.query(getattr(Spaxel, extension)).filter(
            Spaxel.cube_pk == self.pk).order_by(Spaxel.x, Spaxel.y).all()

        # Assumes cubes are always square (!)
        nx = ny = int(np.sqrt(len(spaxels)))
        nwave = len(spaxels[0][0])

        spArray = np.array(spaxels)

        return spArray.transpose().reshape((nwave, ny, nx)).transpose(0, 2, 1)

    @hybrid_property
    def plateifu(self):
        '''Returns parameter plate-ifu'''
        return '{0}-{1}'.format(self.plate, self.ifu.name)

    @plateifu.expression
    def plateifu(cls):
        return func.concat(Cube.plate, '-', IFUDesign.name)

    @hybrid_property
    def restwave(self):
        if self.target:
            redshift = self.target.NSA_objects[0].z
            wave = np.array(self.wavelength.wavelength)
            restwave = wave / (1 + redshift)
            return restwave
        else:
            return None

    @restwave.expression
    def restwave(cls):
        restw = (func.rest_wavelength(sampledb.NSA.z))
        return restw

    def has_modelspaxels(self, name=None):
        if not name:
            name = '(SPX|HYB)'
        has_ms = False
        model_cubes = [f.modelcube for f in self.dapfiles if re.search('LOGCUBE-{0}'.format(name), f.filename)]
        if model_cubes:
            mc = sum(model_cubes, [])
            if mc:
                from marvin.database.models.DapModelClasses import ModelSpaxel
                session = database.Session.object_session(mc[0])
                ms = session.query(ModelSpaxel).filter_by(modelcube_pk=mc[0].pk).first()
                has_ms = True if ms else False
        return has_ms

    def has_spaxels(self):
        if len(self.spaxels) > 0:
            return True
        else:
            return False

    def has_fibers(self):
        if len(self.fibers) > 0:
            return True
        else:
            return False


def set_quality(stage):
    ''' produces cube quality flag '''

    label = 'cubequal{0}'.format(stage)
    kwarg = 'DRP{0}QUAL'.format(stage[0])

    @hybrid_property
    def quality(self):
        bits = self.getQualBits(stage=stage)
        return int(bits)

    @quality.expression
    def quality(cls):
        return select([FitsHeaderValue.value.cast(Integer)]).\
            where(and_(FitsHeaderKeyword.pk == FitsHeaderValue.fits_header_keyword_pk,
                       FitsHeaderKeyword.label.ilike(kwarg),
                       FitsHeaderValue.cube_pk == cls.pk)).\
            label(label)
    return quality


def set_manga_target(targtype):
    ''' produces manga_target flags '''

    label = 'mngtrg{0}'.format(targtype)
    kwarg = 'MNGT%RG{0}'.format(targtype)

    @hybrid_property
    def target(self):
        bits = self.getTargBits(targtype=targtype)
        return int(bits)

    @target.expression
    def target(cls):
        return select([FitsHeaderValue.value.cast(Integer)]).\
            where(and_(FitsHeaderKeyword.pk == FitsHeaderValue.fits_header_keyword_pk,
                       FitsHeaderKeyword.label.ilike(kwarg),
                       FitsHeaderValue.cube_pk == cls.pk)).\
            label(label)
    return target


setattr(Cube, 'manga_target1', set_manga_target(1))
setattr(Cube, 'manga_target2', set_manga_target(2))
setattr(Cube, 'manga_target3', set_manga_target(3))
setattr(Cube, 'quality', set_quality('3d'))


class Wavelength(Base):
    __tablename__ = 'wavelength'

    wavelength = deferred(Column(ARRAY(Float, zero_indexes=True)))

    def __repr__(self):
        return '<Wavelength (pk={0})>'.format(self.pk)


class Spaxel(ArrayOps, Base):
    __tablename__ = 'spaxel'
    print_fields = ['x', 'y']

    flux = deferred(Column(ARRAY(Float, zero_indexes=True)))
    ivar = deferred(Column(ARRAY(Float, zero_indexes=True)))
    mask = deferred(Column(ARRAY(Integer, zero_indexes=True)))
    disp = deferred(Column(ARRAY(Float, zero_indexes=True)))
    predisp = deferred(Column(ARRAY(Float, zero_indexes=True)))

    @hybrid_method
    def sum(self):
        total = sum(self.flux)
        return total

    @sum.expression
    def sum(cls):
        return select([func.sum(column('totalflux'))]).select_from(func.unnest(cls.flux).alias('totalflux'))


class RssFiber(ArrayOps, Base):
    __tablename__ = 'rssfiber'
    print_fields = ['exposure_no', 'mjd', 'fiber.fiberid']

    flux = deferred(Column(ARRAY(Float, zero_indexes=True)))
    ivar = deferred(Column(ARRAY(Float, zero_indexes=True)))
    mask = deferred(Column(ARRAY(Integer, zero_indexes=True)))
    xpos = deferred(Column(ARRAY(Float, zero_indexes=True)))
    ypos = deferred(Column(ARRAY(Float, zero_indexes=True)))
    disp = deferred(Column(ARRAY(Float, zero_indexes=True)))
    predisp = deferred(Column(ARRAY(Float, zero_indexes=True)))


class PipelineInfo(Base):
    __tablename__ = 'pipeline_info'
    print_fields = ['version.version', 'name.name']

    def __repr__(self):
        return '<Pipeline_Info (pk={0})>'.format(self.pk)


class PipelineVersion(Base):
    __tablename__ = 'pipeline_version'
    print_fields = ['version']


class PipelineStage(Base):
    __tablename__ = 'pipeline_stage'


class PipelineCompletionStatus(Base):
    __tablename__ = 'pipeline_completion_status'


class PipelineName(Base):
    __tablename__ = 'pipeline_name'


class FitsHeaderValue(Base):
    __tablename__ = 'fits_header_value'


class FitsHeaderKeyword(Base):
    __tablename__ = 'fits_header_keyword'


class IFUDesign(Base):
    __tablename__ = 'ifudesign'

    @property
    def ifuname(self):
        return self.name

    @property
    def designid(self):
        return self.name

    @property
    def ifutype(self):
        return self.name[:-2]


class IFUToBlock(Base):
    __tablename__ = 'ifu_to_block'


class SlitBlock(Base):
    __tablename__ = 'slitblock'


class Cart(Base):
    __tablename__ = 'cart'
    print_fields = ['id']


class Fibers(Base):
    __tablename__ = 'fibers'
    print_fields = ['fiberid', 'fnum']


class FiberType(Base):
    __tablename__ = 'fiber_type'


class TargetType(Base):
    __tablename__ = 'target_type'


class Sample(Base, ArrayOps):
    __tablename__ = 'sample'
    print_fields = ['cube']

    @hybrid_property
    def nsa_logmstar(self):
        try:
            return math.log10(self.nsa_mstar)
        except ValueError:
            return -9999.0
        except TypeError:
            return None

    @nsa_logmstar.expression
    def nsa_logmstar(cls):
        return func.log(cls.nsa_mstar)

    @hybrid_property
    def nsa_logmstar_el(self):
        try:
            return math.log10(self.nsa_mstar_el)
        except ValueError as e:
            return -9999.0
        except TypeError as e:
            return None

    @nsa_logmstar_el.expression
    def nsa_logmstar_el(cls):
        return func.log(cls.nsa_mstar_el)


class CartToCube(Base):
    __tablename__ = 'cart_to_cube'
    print_fields = ['cube', 'cart']


class Wcs(Base, ArrayOps):
    __tablename__ = 'wcs'
    print_fields = ['cube']

    def makeHeader(self):
        wcscols = self.cols[2:]
        newhdr = fits.Header()
        for c in wcscols:
            newhdr[c] = float(self.__getattribute__(c)) if type(self.__getattribute__(c)) == Decimal else self.__getattribute__(c)
        return newhdr


class ObsInfo(Base):
    __tablename__ = 'obsinfo'
    print_fields = ['cube']

    _expnum = Column('expnum', String)

    @hybrid_property
    def expnum(self):
        return self._expnum.strip()

    @expnum.expression
    def expnum(cls):
        return func.trim(cls._expnum)


class CubeShape(Base):
    __tablename__ = 'cube_shape'
    print_fields = ['size', 'total']

    @property
    def shape(self):
        return (self.size, self.size)

    def makeIndiceArray(self):
        ''' Return the indices array as a numpy array '''
        return np.array(self.indices)

    def getXY(self, index=None):
        ''' Get the x,y elements from a single digit index '''
        if index is not None:
            if index > self.total:
                return None, None
            else:
                i = int(index / self.size)
                j = int(index - i * self.size)
        else:
            arrind = self.makeIndiceArray()
            i = np.array(arrind / self.size, dtype=int)
            j = np.array(self.makeIndiceArray() - i * self.size, dtype=int)
        return i, j

    @hybrid_property
    def x(self):
        '''Returns parameter plate-ifu'''
        x = self.getXY()[0]
        return x

    @x.expression
    def x(cls):
        arrind = (func.unnest(cls.indices) / cls.size).label('xarrind')
        return arrind

    @hybrid_property
    def y(self):
        '''Returns parameter plate-ifu'''
        y = self.getXY()[1]
        return y

    @y.expression
    def y(cls):
        s = database.Session.object_session(cls)
        arrunnest = func.unnest(cls.indices)
        xarr = (func.unnest(cls.indices) / cls.size).label('xarrind')
        arrind = (arrunnest - xarr * cls.size).label('yarrind')
        y = s.query(arrind).select_from(cls).subquery('yarr')
        yagg = s.query(func.array_agg(y.c.yarrind))
        return yagg.as_scalar()


class Plate(object):
    ''' new plate class '''

    __tablename__ = 'myplate'

    def __init__(self, cube=None, id=None):
        self.id = cube.plate if cube else id if id else None
        self.cube = cube if cube else None
        self.drpver = None
        if self.cube:
            self._hdr = self.cube.header_to_dict()
            self.type = self.getPlateType()
            self.platetype = self._hdr.get('PLATETYP', None)
            self.surveymode = self._hdr.get('SRVYMODE', None)
            self.dateobs = self._hdr.get('DATE-OBS', None)
            self.ra = self._hdr.get('CENRA', None)
            self.dec = self._hdr.get('CENDEC', None)
            self.designid = self._hdr.get('DESIGNID', None)
            self.cartid = self._hdr.get('CARTID', None)
            self.drpver = self.cube.pipelineInfo.version.version
            self.isbright = 'APOGEE' in self.surveymode
            self.dir3d = 'mastar' if self.isbright else 'stack'

            # cast a few
            self.ra = float(self.ra) if self.ra else None
            self.dec = float(self.dec) if self.dec else None
            self.id = int(self.id) if self.id else None
            self.designid = int(self.designid) if self.designid else None

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return ('Plate (id={0}, ra={1}, dec={2}, '
                ' designid={3})'.format(self.id, self.ra, self.dec, self.designid))

    def getPlateType(self):
        ''' Get the type of MaNGA plate '''

        # try galaxy
        mngtrg = self._hdr.get('MNGTRG1', None)
        pltype = 'Galaxy' if mngtrg else None

        # try stellar
        if not pltype:
            mngtrg = self._hdr.get('MNGTRG2', None)
            pltype = 'Stellar' if mngtrg else None

        # try ancillary
        if not pltype:
            mngtrg = self._hdr.get('MNGTRG3', None)
            pltype = 'Ancillary' if mngtrg else None

        return pltype

    @property
    def cubes(self):
        ''' Get all cubes on this plate '''

        session = database.Session.object_session(self)
        if self.drpver:
            cubes = session.query(Cube).join(PipelineInfo, PipelineVersion).\
                filter(Cube.plate == self.id, PipelineVersion.version == self.drpver).all()
        else:
            cubes = session.query(Cube).filter(Cube.plate == self.id).all()
        return cubes


def define_relations():
    """Setup relationships after preparation."""

    Cube.pipelineInfo = relationship(PipelineInfo, backref="cubes")
    Cube.wavelength = relationship(Wavelength, backref="cube")
    Cube.ifu = relationship(IFUDesign, backref="cubes")
    # Cube.carts = relationship(Cart, secondary=CartToCube.__table__, backref="cubes")
    Cube.wcs = relationship(Wcs, backref='cube', uselist=False)
    Cube.shape = relationship(CubeShape, backref='cubes', uselist=False)
    Cube.obsinfo = relationship(ObsInfo, backref='cube', uselist=False)

    Sample.cube = relationship(Cube, backref="sample", uselist=False)

    FitsHeaderValue.cube = relationship(Cube, backref="headervals")
    FitsHeaderValue.keyword = relationship(FitsHeaderKeyword, backref="value")

    IFUDesign.blocks = relationship(SlitBlock, secondary=IFUToBlock.__table__, backref='ifus')
    Fibers.ifu = relationship(IFUDesign, backref="fibers")
    Fibers.fibertype = relationship(FiberType, backref="fibers")
    Fibers.targettype = relationship(TargetType, backref="fibers")

    insp = reflection.Inspector.from_engine(database.engine)
    fks = insp.get_foreign_keys(Spaxel.__table__.name, schema='mangadatadb')
    if fks:
        Spaxel.cube = relationship(Cube, backref='spaxels')
    fks = insp.get_foreign_keys(RssFiber.__table__.name, schema='mangadatadb')
    if fks:
        RssFiber.cube = relationship(Cube, backref='rssfibers')
        RssFiber.fiber = relationship(Fibers, backref='rssfibers')

    PipelineInfo.name = relationship(PipelineName, backref="pipeinfo")
    PipelineInfo.stage = relationship(PipelineStage, backref="pipeinfo")
    PipelineInfo.version = relationship(PipelineVersion, backref="pipeinfo")
    PipelineInfo.completionStatus = relationship(PipelineCompletionStatus, backref="pipeinfo")


# prepare the base
database.add_base(Base)
