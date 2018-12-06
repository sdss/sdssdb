# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:57
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 11:20:57

from __future__ import absolute_import, division, print_function

from sdssdb.sqlalchemy.mangadb import MangaBase, database
from sdssdb.sqlalchemy.mangadb.datadb import Cube
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship
from sqlalchemy.schema import Column
from sqlalchemy.types import JSON


class Base(AbstractConcreteBase, MangaBase):
    __abstract__ = True
    _schema = 'mangaauxdb'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


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


database.add_base(Base)
