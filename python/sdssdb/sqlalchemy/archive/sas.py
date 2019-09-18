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
    print_fields = ['identifier']


class Tree(Base):
    __tablename__ = 'tree'
    print_fields = ['version']


class Env(Base):
    __tablename__ = 'env'


class Directory(Base):
    __tablename__ = 'directory'
    print_fields = ['location']


class File(Base):
    __tablename__ = 'file'
    print_fields = ['location']


class SymlinkFile(Base):
    __tablename__ = 'symlink_file'
    print_fields = ['location']


class SymlinkDirectory(Base):
    __tablename__ = 'symlink_directory'
    print_fields = ['location']


class ChecksumFile(Base):
    __tablename__ = 'checksumfile'
    print_fields = ['filename']


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
    ChecksumFile.tree = relationship(Tree, backref='checksumfiles')
    ChecksumFile.env = relationship(Env, backref='checksumfile')
    ChecksumFile.directory = relationship(Directory, backref='checksumfile')
    ChecksumFile.file = relationship(File, backref='checksumfile')

    # class Directory
    Directory.tree = relationship(Tree, backref='directories')
    Directory.env = relationship(Env, backref='directories')

    # class Env
    # need to specify remote_side when foreign key points to itself
    Env.real_env = relationship(Env, remote_side='Env.id', backref='env')

    # class File
    File.root = relationship(Root, backref='files')
    File.tree = relationship(Tree, backref='files')
    File.env = relationship(Env, backref='files')

    # class Symlink_directory
    SymlinkDirectory.env = relationship(Env, backref='symdirs')
    SymlinkDirectory.root = relationship(Root, backref='symdirs')
    # need to specify foreign_keys when multiple columns points to same key
    # need to specify primaryjoin when there are multiple ways to join the tables
    SymlinkDirectory.directory = relationship(
        Directory, backref='symdir', foreign_keys='SymlinkDirectory.directory_id')
    SymlinkDirectory.real_dir = relationship(Directory, backref='realsymdir',
                                             primaryjoin='and_(SymlinkDirectory.real_directory_id==Directory.id)')
    SymlinkDirectory.tree = relationship(Tree, backref='symdirs', foreign_keys='SymlinkDirectory.tree_id',
                                         primaryjoin='and_(SymlinkDirectory.tree_id==Tree.id)')
    SymlinkDirectory.real_tree = relationship(
        Tree, backref='realsymdir', primaryjoin='and_(SymlinkDirectory.real_tree_id==Tree.id)')

    # class Symlink_file
    SymlinkFile.directory = relationship(Directory, backref='symlinks')
    SymlinkFile.env = relationship(Env, backref='symlinks')
    SymlinkFile.real_file = relationship(File, backref='symlinks')
    SymlinkFile.root = relationship(Root, backref='symlinks', foreign_keys='SymlinkFile.root_id')
    SymlinkFile.tree = relationship(Tree, backref='symlinks', foreign_keys='SymlinkFile.tree_id',
                                    primaryjoin='and_(SymlinkFile.tree_id==Tree.id)')
    SymlinkFile.real_tree = relationship(
        Tree, backref='realsymlinks', primaryjoin='and_(SymlinkFile.real_tree_id==Tree.id)')


# prepare the base
database.add_base(Base)
