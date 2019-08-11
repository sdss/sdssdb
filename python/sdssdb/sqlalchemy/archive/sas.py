# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Joel Brownstein
# @Date:   2019-08-01 06:54:15
# @Last modified by: Joel Brownstein (joelbrownstein@astro.utah.edu)

from __future__ import absolute_import, division, print_function

from sdssdb.sqlalchemy.archive import database, ArchiveBase, sas
from sqlalchemy import Column, Float, and_, case, cast, select
from sqlalchemy.engine import reflection
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import relationship
from sqlalchemy.types import Integer

SCHEMA = 'sas'

class Base(AbstractConcreteBase, ArchiveBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}

class Root(Base):
    __tablename__ = 'root'

class Tree(Base):
    __tablename__ = 'tree'

class Env(Base):
    __tablename__ = 'env'

class Directory(Base):
    __tablename__ = 'directory'

class File(Base):
    __tablename__ = 'file'

class Symlink_file(Base):
    __tablename__ = 'symlink_file'

class Symlink_directory(Base):
    __tablename__ = 'symlink_directory'

class Checksumfile(Base):
    __tablename__ = 'checksumfile'

class Checksum(Base):
    __tablename__ = 'checksum'

def define_relations():
    """Setup relationships after preparation."""
    pass

# prepare the base
database.add_base(Base)
