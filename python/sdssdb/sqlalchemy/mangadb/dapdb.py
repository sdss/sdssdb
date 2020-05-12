# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:15
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:21:08

from __future__ import absolute_import, division, print_function

import numpy as np
from astropy.io import fits
from sdssdb.sqlalchemy.mangadb import MangaBase, datadb, database
from sqlalchemy import Column, Float, and_, case, cast, select
from sqlalchemy.engine import reflection
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import relationship
from sqlalchemy.types import Integer


SCHEMA = 'mangadapdb'


class Base(AbstractConcreteBase, MangaBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class File(Base):
    __tablename__ = 'file'
    print_fields = ['filename', 'pipelineinfo.version.version']

    @property
    def is_map(self):
        return self.filetype.value == 'MAPS'

    @property
    def ftype(self):
        return self.filetype.value

    @property
    def partner(self):
        session = database.Session.object_session(self)
        return session.query(File).join(Structure, datadb.Cube, FileType).filter(
            Structure.pk == self.structure.pk, datadb.Cube.pk == self.cube.pk,
            FileType.pk != self.filetype.pk).one()

    @property
    def primary_header(self):
        primaryhdu = [h for h in self.hdus if h.extname.name == 'PRIMARY'][0]
        return primaryhdu.header

    @property
    def flux_header(self):
        ftype = self.filetype.value
        name = 'FLUX' if ftype == 'LOGCUBE' else 'EMLINE_GFLUX'
        fluxhdu = [h for h in self.hdus if h.extname.name == name][0]
        return fluxhdu.header

    @hybrid_property
    def quality(self):
        hdr = self.primary_header
        bits = hdr.get('DAPQUAL', None)
        if bits:
            return int(bits)
        else:
            return None

    @quality.expression
    def quality(cls):
        return select([HeaderValue.value.cast(Integer)]).\
            where(and_(HeaderKeyword.pk == HeaderValue.header_keyword_pk,
                       HduToHeaderValue.header_value_pk == HeaderValue.pk,
                       HduToHeaderValue.hdu_pk == Hdu.pk,
                       Hdu.file_pk == cls.pk,
                       HeaderKeyword.name.ilike('DAPQUAL')
                       )).\
            label('dapqual')


class CurrentDefault(Base):
    __tablename__ = 'current_default'
    print_fields = ['filename']


class FileType(Base):
    __tablename__ = 'filetype'


class ExtName(Base):
    __tablename__ = 'extname'


class ExtType(Base):
    __tablename__ = 'exttype'


class ExtCol(Base):
    __tablename__ = 'extcol'


class Hdu(Base):
    __tablename__ = 'hdu'

    @property
    def header(self):
        '''Returns an astropy header'''

        session = database.Session.object_session(self)
        data = session.query(HeaderKeyword.name, HeaderValue.value,
                             HeaderValue.comment).join(HeaderValue, HduToHeaderValue).filter(
            HduToHeaderValue.header_value_pk == HeaderValue.pk,
            HduToHeaderValue.hdu_pk == self.pk).all()

        hdr = fits.Header(data)
        return hdr

    def header_to_dict(self):
        '''Returns a simple python dictionary header'''

        vals = self.header_values
        hdrdict = {str(val.keyword.name): val.value for val in vals}
        return hdrdict

    @property
    def name(self):
        return self.extname.name


class HduToExtCol(Base):
    __tablename__ = 'hdu_to_extcol'


class HduToHeaderValue(Base):
    __tablename__ = 'hdu_to_header_value'


class HeaderValue(Base):
    __tablename__ = 'header_value'


class HeaderKeyword(Base):
    __tablename__ = 'header_keyword'


def HybridRatio(line1, line2):
    ''' produces emission line ratio hybrid properties '''

    @hybrid_property
    def hybridRatio(self):

        if type(line1) == tuple:
            myline1 = getattr(self, line1[0]) + getattr(self, line1[1])
        else:
            myline1 = getattr(self, line1)

        if getattr(self, line2) > 0:
            return myline1 / getattr(self, line2)
        else:
            return -999.

    @hybridRatio.expression
    def hybridRatio(cls):

        if type(line1) == tuple:
            myline1 = getattr(cls, line1[0]) + getattr(cls, line1[1])
        else:
            myline1 = getattr(cls, line1)

        return cast(case([(getattr(cls, line2) > 0., myline1 / getattr(cls, line2)),
                          (getattr(cls, line2) == 0., -999.)]), Float)

    return hybridRatio


class SpaxelAtts(object):
    ''' New class to add attributes to all SpaxelProp classes '''
    pass


setattr(SpaxelAtts, 'ha_to_hb', HybridRatio('emline_gflux_ha_6564', 'emline_gflux_hb_4862'))
setattr(SpaxelAtts, 'nii_to_ha', HybridRatio('emline_gflux_nii_6585', 'emline_gflux_ha_6564'))
setattr(SpaxelAtts, 'oiii_to_hb', HybridRatio('emline_gflux_oiii_5008', 'emline_gflux_hb_4862'))
setattr(SpaxelAtts, 'oi_to_ha', HybridRatio('emline_gflux_oi_6302', 'emline_gflux_ha_6564'))
setattr(SpaxelAtts, 'sii_to_ha', HybridRatio(('emline_gflux_sii_6718', 'emline_gflux_sii_6732'), 'emline_gflux_ha_6564'))


# Make the classes for the DAP Spaxel Properties
def spaxel_factory(classname, clean=None):
    ''' class factory for the spaxelprop tables '''

    if clean:
        classname = 'Clean{0}'.format(classname)
    tablename = classname.lower()

    params = {'__tablename__': tablename, 'print_fields': ['file_pk']}
    if clean:
        params.update({'pk': Column(Integer, primary_key=True)})

    try:
        newclass = type(classname, (Base, SpaxelAtts,), params)
    except Exception:
        newclass = None

    return newclass


# get the spaxelprop tables in the schema
insp = reflection.Inspector.from_engine(database.engine)
tables = insp.get_table_names(schema=SCHEMA)
sptables = [t for t in tables if t.startswith('spaxelprop')]

# create the (clean)spaxel models from the DAP spaxelprop tables
for sp in sptables:
    classname = sp.replace('spaxelprop', 'SpaxelProp')
    newclass = spaxel_factory(classname)
    cleanclass = spaxel_factory(classname, clean=True)
    if newclass:
        locals()[classname] = newclass
    if cleanclass:
        locals()[cleanclass.__name__] = cleanclass

# delete extra classes from the various loops
del cleanclass
del newclass


class BinId(Base):
    __tablename__ = 'binid'
    print_fields = ['id']


class BinMode(Base):
    __tablename__ = 'binmode'


class BinType(Base):
    __tablename__ = 'bintype'


class ExecutionPlan(Base):
    __tablename__ = 'executionplan'
    print_fields = ['id']


class Template(Base):
    __tablename__ = 'template'
    print_fields = ['id']


class Structure(Base):
    __tablename__ = 'structure'
    print_fields = ['bintype.name', 'template_kin.name']

    executionplan = relationship(ExecutionPlan, backref='structures')
    binmode = relationship(BinMode, backref='structures')
    bintype = relationship(BinType, backref='structures')


class ModelCube(Base):
    __tablename__ = 'modelcube'
    print_fields = ['file_pk']

    def get3DCube(self, extension='flux'):
        """Returns a 3D array of ``extension`` from the modelcube spaxels.

        For example, ``modelcube.get3DCube('flux')`` will return the original
        flux cube with the same ordering as the FITS data cube.

        Note that this method seems to be really slow retrieving arrays (this
        is especially serious for large IFUs).

        """

        session = database.Session.object_session(self)
        spaxels = session.query(getattr(ModelSpaxel, extension)).filter(
            ModelSpaxel.modelcube_pk == self.pk).order_by(ModelSpaxel.x, ModelSpaxel.y).all()

        # Assumes cubes are always square (!)
        nx = ny = int(np.sqrt(len(spaxels)))
        nwave = len(spaxels[0][0])

        spArray = np.array(spaxels)

        return spArray.transpose().reshape((nwave, ny, nx)).transpose(0, 2, 1)


class ModelSpaxel(Base):
    __tablename__ = 'modelspaxel'
    print_fields = ['modelcube_pk']


class RedCorr(Base):
    __tablename__ = 'redcorr'
    print_fields = ['modelcube_pk']


class DapAll(Base):
    __tablename__ = 'dapall'
    print_fields = ['file_pk']


def define_relations():
    """Setup relationships after preparation."""

    File.cube = relationship(datadb.Cube, backref='dapfiles')
    File.pipelineinfo = relationship(datadb.PipelineInfo, backref='dapfiles')
    File.filetype = relationship(FileType, backref='files')
    File.structure = relationship(Structure, backref='files')
    CurrentDefault.file = relationship(File, uselist=False, backref='current_default')
    Hdu.file = relationship(File, backref='hdus')
    Hdu.extname = relationship(ExtName, backref='hdus')
    Hdu.exttype = relationship(ExtType, backref='hdus')
    Hdu.extcols = relationship(ExtCol, secondary=HduToExtCol.__table__, backref='hdus')
    Hdu.header_values = relationship(HeaderValue,
                                     secondary=HduToHeaderValue.__table__,
                                     backref='hdus')
    HeaderValue.keyword = relationship(HeaderKeyword, backref='values')
    DapAll.file = relationship(File, uselist=False, backref='dapall')

    # necessary manual foreign key relationship
    Structure.template_kin = relationship(Template,
                                          foreign_keys=[Structure.template_kin_pk],
                                          backref='structures_kin')
    Structure.template_pop = relationship(Template,
                                          foreign_keys=[Structure.template_pop_pk],
                                          backref='structures_pop')

    # add foreign key relationships on (Clean)SpaxelProp classses to File
    spaxel_tables = {k: v for k, v in locals().items()
                     if 'SpaxelProp' in k or 'CleanSpaxelProp' in k}
    for classname, class_model in spaxel_tables.items():
        fks = insp.get_foreign_keys(class_model.__table__.name, schema=SCHEMA)
        if fks:
            backname = classname.lower().replace('prop', 'props')
            class_model.file = relationship(File, backref=backname)

    fks = insp.get_foreign_keys(ModelCube.__table__.name, schema=SCHEMA)
    if fks:
        ModelCube.file = relationship(File, backref='modelcube', uselist=False)

    fks = insp.get_foreign_keys(ModelSpaxel.__table__.name, schema=SCHEMA)
    if fks:
        ModelSpaxel.modelcube = relationship(ModelCube, backref='modelspaxels')

    fks = insp.get_foreign_keys(RedCorr.__table__.name, schema=SCHEMA)
    if fks:
        RedCorr.modelcube = relationship(ModelCube, backref='redcorr')


# prepare the base
database.add_base(Base)
