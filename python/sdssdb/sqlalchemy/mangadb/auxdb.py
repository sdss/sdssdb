# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:57
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-10-08 19:19:39

from __future__ import absolute_import, division, print_function

from sdssdb.sqlalchemy.mangadb import MangaBase, db
from sdssdb.sqlalchemy.mangadb.datadb import Cube
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Column
from sqlalchemy.types import JSON

from sqlalchemy.ext.declarative import declarative_base, declared_attr

SCHEMA = 'mangaauxdb'


class Schema(object):
    _schema = SCHEMA

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


Base = declarative_base(cls=(Schema, MangaBase,))


class CubeHeader(Base):
    __tablename__ = 'cube_header'
    print_fields = ['cube']

    header = Column(JSON)
    cube = relationship(Cube, backref='hdr')


class MaskLabels(Base):
    __tablename__ = 'maskbit_labels'
    print_fields = ['maskbit']


class MaskBit(Base):
    __tablename__ = 'maskbit'
    print_fields = ['flag', 'bit', 'label']


Base.prepare(db.engine)
