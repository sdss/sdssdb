# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Joel Brownstein
# @Date:   2019-08-01 06:54:15
# @Last modified by: N Benjamin Murphy (n.benjamin.murphy@astro.utah.edu)
# @Date:   2019-09-04 16:31:00

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


class SymlinkFile(Base):
    __tablename__ = 'symlink_file'


class SymlinkDirectory(Base):
    __tablename__ = 'symlink_directory'


class ChecksumFile(Base):
    __tablename__ = 'checksumfile'


class Checksum(Base):
    __tablename__ = 'checksum'


def define_relations():
    """Setup relationships after preparation."""
    
    # model relationships
    Root.directories = relationship(Directory, backref='root')
    Tree.envs = relationship(Env, backref='tree')
    
    # class Checksum
    Checksum.tree = relationship(Tree, backref='checksums')
    Checksum.checksumfile = relationship(ChecksumFile, backref='checksums')
    Checksum.file = relationship(File, backref='checksums')
    Checksum.directory = relationship(Directory, backref='checksums')
    
    # class Checksumfile
    ChecksumFile.tree = relationship(Tree, backref='checksumfile')
    ChecksumFile.env = relationship(Env, backref='checksumfile')
    ChecksumFile.directory = relationship(Directory, backref='checksumfile')
    ChecksumFile.file = relationship(File, backref='checksumfile')

    # class Directory
    #Directory.root = relationship(Root, backref='directory')
    Directory.tree = relationship(Tree, backref='directories')
    Directory.env = relationship(Env, backref='directories')

    # class Env
    #Env.tree = relationship(Tree, backref='env')
    Env.real_env = relationship(Env, backref='env')

    # class File
    File.root = relationship(Root, backref='files')
    File.tree = relationship(Tree, backref='files')
    File.env = relationship(Env, backref='files')

    # class Symlink_directory
    SymlinkDirectory.root = relationship(Root, backref='symdirs', foreign_keys=['root_id'])
    SymlinkDirectory.tree = relationship(Tree, backref='symdirs', foreign_keys=['tree_id'])
    SymlinkDirectory.env = relationship(Env, backref='symdirs')

    # class Symlink_file
    SymlinkFile.root = relationship(Root, backref='symlinks', foreign_keys=['root_id'])
    SymlinkFile.tree = relationship(Tree, backref='symlinks', foreign_keys=['tree_id'])
    SymlinkFile.env = relationship(Env, backref='symlinks')


# prepare the base
database.add_base(Base)
