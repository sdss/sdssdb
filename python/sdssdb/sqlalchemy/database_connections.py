#!/usr/bin/env python
# encoding: utf-8
#
# @Author: Jennifer Sobeck
# @Date: August 2018
# @Filename: database_connection.py
# @License: BSD 3-Clause
# @Copyright: 

#Source JSG; MODIFY

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base


class DatabaseConnection(object):
    """This class defines an object that makes a connection to a database.
    The `DatabaseConnection` object takes as its parameter the SQLAlchemy
    database connection string.
    This class is best called from another class that contains the
    actual connection information (so that it can be reused for different
    connections).
    This class implements the singleton design pattern. The first time the
    object is created, it *requires* a valid database connection string.
    Every time it is called via ::
        db = DatabaseConnection()
    the same object is returned and contains the connection information.
    """

    _singletons = dict()

    def __new__(cls, database_connection_string=None, expire_on_commit=True):
        """This overrides the object's usual creation mechanism."""

        if cls not in cls._singletons:

            assert database_connection_string is not None, \
                'A database connection string must be specified!'

            cls._singletons[cls] = object.__new__(cls)

            # ------------------------------------------------
            # This is the custom initialization
            # ------------------------------------------------

            me = cls._singletons[cls]  # just for convenience (think "self")

            me.database_connection_string = database_connection_string

            # change 'echo' to print each SQL query (for debugging/optimizing/the curious)
            me.engine = create_engine(me.database_connection_string, echo=False)

            me.metadata = MetaData()
            me.metadata.bind = me.engine
            me.Base = declarative_base(bind=me.engine)
            me.Session = scoped_session(sessionmaker(bind=me.engine, autocommit=True,
                                                     expire_on_commit=expire_on_commit))

            # ------------------------------------------------

        return cls._singletons[cls]
