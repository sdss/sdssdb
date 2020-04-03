# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Joel Brownstein
# @Date:   2019-08-01 06:54:15
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date:   2019-09-04 16:31:00

from __future__ import absolute_import, division, print_function

import pathlib
from sdssdb.sqlalchemy.archive import database, ArchiveBase
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relationship, Session
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy import func

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

    @property
    def parents(self):
        ''' return a list of all parent directories '''
        parentdirs = []
        path = pathlib.Path(self.location)
        session = Session.object_session(self)
        parentlocs = [str(p) for p in path.parents]
        parentdirs = session.query(Directory).\
            filter(Directory.tree == self.tree, Directory.location.in_(parentlocs)).\
            order_by(Directory.id.desc()).all()
        return parentdirs

    @property
    def children(self):
        ''' return a complete list of child sub-directories '''
        session = Session.object_session(self)
        realc = session.query(Directory).\
            filter(Directory.tree == self.tree, Directory.location.ilike(
            self.location + '%'), Directory.nested == self.nested + 1).all()
        symc = self.symlink_directories
        return realc + symc 


class File(Base):
    __tablename__ = 'file'
    print_fields = ['name']

    @hybrid_property
    def name(self):
        return self.location.rsplit('/', 1)[-1]

    @name.expression
    def name(cls):
        return func.reverse(func.split_part(func.reverse(cls.location), '/', 1))

    @property
    def parents(self):
        ''' returns a list of all parent directories '''
        parent = self.directory
        parents = parent.parents
        parents.insert(0, parent)
        return parents
    
    @property
    def has_symlinks(self):
        ''' returns True if this file is being symlinked or not '''
        return any(self.symlink_files)

    @property
    def symlink_tree(self):
        ''' returns a list of files/directories symlinking to this file '''
        symfiles = self.symlink_files
        symdirs = []
        for path in self.parents:
            if any(path.linked_symlink_directories):
                symdirs.extend(path.linked_symlink_directories)
        return symfiles + symdirs


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
    File.directory = relationship(Directory, backref='files')

    # class Symlink_directory
    SymlinkDirectory.env = relationship(Env, backref='symlink_directories')
    SymlinkDirectory.root = relationship(Root, backref='symlink_directories')
    # need to specify foreign_keys when multiple columns points to same key
    # need to specify primaryjoin when there are multiple ways to join the tables
    SymlinkDirectory.directory = relationship(
        Directory, backref='symlink_directories', foreign_keys='SymlinkDirectory.directory_id')
    SymlinkDirectory.real_directory = relationship(
        Directory, backref='linked_symlink_directories',
        primaryjoin=('and_(SymlinkDirectory.real_directory_id==Directory.id)'))

    SymlinkDirectory.tree = relationship(Tree, backref='symlink_directories',
                                         foreign_keys='SymlinkDirectory.tree_id',
                                         primaryjoin='and_(SymlinkDirectory.tree_id==Tree.id)')
    SymlinkDirectory.real_tree = relationship(
        Tree, backref='linked_symlink_directories',
        primaryjoin='and_(SymlinkDirectory.real_tree_id==Tree.id)')

    # class Symlink_file
    SymlinkFile.directory = relationship(Directory, backref='symlink_files')
    SymlinkFile.env = relationship(Env, backref='symlink_files')
    SymlinkFile.real_file = relationship(File, backref='symlink_files')
    SymlinkFile.root = relationship(Root, backref='symlink_files',
                                    foreign_keys='SymlinkFile.root_id')

    SymlinkFile.tree = relationship(Tree, backref='symlink_files',
                                    foreign_keys='SymlinkFile.tree_id',
                                    primaryjoin='and_(SymlinkFile.tree_id==Tree.id)')
    SymlinkFile.real_tree = relationship(
        Tree, backref='linked_symlink_files',
        primaryjoin='and_(SymlinkFile.real_tree_id==Tree.id)')


# prepare the base
database.add_base(Base)
