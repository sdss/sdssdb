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
    
    # model relationships
    #directories = relationship("Directory", backref='root')
    #envs = relationship("Env", backref='tree')
    Root.directories = relationship(Directory, backref='root')
    Tree.envs = relationship(Env, backref='tree')
    
    #class Checksum
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #checksumfile_id = db.Column(db.Integer, db.ForeignKey('%s.checksumfile.id' % schema), nullable=False)
    #file_id = db.Column(db.Integer, db.ForeignKey('%s.file.id' % schema))
    #directory_id = db.Column(db.Integer, db.ForeignKey('%s.directory.id' % schema), nullable=False)
    Checksum.tree = relationship(Tree, backref='checksum')
    Checksum.checksumfile = relationship(Checksumfile, backref='checksum')
    Checksum.file = relationship(File, backref='checksum')
    Checksum.directory = relationship(Directory, backref='checksum')
    
    #class Checksumfile
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    #directory_id = db.Column(db.Integer, db.ForeignKey('%s.directory.id' % schema), nullable=False)
    #file_id = db.Column(db.Integer, db.ForeignKey('%s.file.id' % schema), nullable=False)
    Checksumfile.tree = relationship(Tree, backref='checksumfile')
    Checksumfile.env = relationship(Env, backref='checksumfile')
    Checksumfile.directory = relationship(Directory, backref='checksumfile')
    Checksumfile.file = relationship(File, backref='checksumfile')

    #class Directory
    #root_id = db.Column(db.Integer, db.ForeignKey('%s.root.id' % schema), nullable = False)
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    Directory.root = relationship(Root, backref='directory')
    Directory.tree = relationship(Tree, backref='directory')
    Directory.env = relationship(Env, backref='directory')

    #class Env
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #real_env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    Env.tree = relationship(Tree, backref='env')
    Env.real_env = relationship(Env)

    #class File
    #root_id = db.Column(db.Integer, db.ForeignKey('%s.root.id' % schema), nullable = False)
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    File.root = relationship(Root, backref='file')
    File.tree = relationship(Tree, backref='file')
    File.env = relationship(Env, backref='file')

    #class Symlink_directory
    #root_id = db.Column(db.Integer, db.ForeignKey('%s.root.id' % schema), nullable = False)
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    Symlink_directory.root = relationship(Root, backref='symlink_directory')
    Symlink_directory.tree = relationship(Tree, backref='symlink_directory')
    Symlink_directory.env = relationship(Env, backref='symlink_directory')

    #class Symlink_file
    #root_id = db.Column(db.Integer, db.ForeignKey('%s.root.id' % schema), nullable = False)
    #tree_id = db.Column(db.Integer, db.ForeignKey('%s.tree.id' % schema))
    #env_id = db.Column(db.Integer, db.ForeignKey('%s.env.id' % schema))
    Symlink_file.root = relationship(Root, backref='symlink_file')
    Symlink_file.tree = relationship(Tree, backref='symlink_file')
    Symlink_file.env = relationship(Env, backref='symlink_file')


# prepare the base
database.add_base(Base)
