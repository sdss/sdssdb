#!/usr/bin/env python
# encoding: utf-8

'''
Created by Brian Cherinka on 2016-04-26 09:20:35
Licensed under a 3-clause BSD license.

Revision History:
    Initial Version: 2016-04-26 09:20:35 by Brian Cherinka
    Last Modified On: 2016-04-26 09:20:35 by Brian
'''

from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.event import listen
from sqlalchemy.pool import Pool
import os


def clearSearchPathCallback(dbapi_con, connection_record):
    '''
    When creating relationships across schema, SQLAlchemy
    has problems when you explicitly declare the schema in
    ModelClasses and it is found in search_path.

    The solution is to set the search_path to "$user" for
    the life of any connection to the database. Since there
    is no (or shouldn't be!) schema with the same name
    as the user, this effectively makes it blank.

    This callback function is called for every database connection.

    For the full details of this issue, see:
    http://groups.google.com/group/sqlalchemy/browse_thread/thread/88b5cc5c12246220

    dbapi_con - type: psycopg2._psycopg.connection
    connection_record - type: sqlalchemy.pool._ConnectionRecord
    '''
    cursor = dbapi_con.cursor()
    cursor.execute('SET search_path TO "$user",functions,public')
    dbapi_con.commit()

listen(Pool, 'connect', clearSearchPathCallback)


CONNECTIONS = dict()


class DatabaseConnection(object):
    '''This class defines an object that makes a connection to a database.
       The "DatabaseConnection" object takes as its parameter the SQLAlchemy
       database connection string.

       This class is best called from another class that contains the
       actual connection information (so that it can be reused for different
       connections).

       This class implements the singleton design pattern. The first time the
       object is created, it *requires* a valid database connection string.
       Every time it is called via:

       db = DatabaseConnection()

       the same object is returned and contains the connection information.
    '''

    def __new__(cls, database_connection_string=None, expire_on_commit=True,
                echo=False, pool_size=10, pool_recycle=1800):
        """This overrides the object's usual creation mechanism."""

        assert database_connection_string is not None, "A database connection string must be specified!"
        if database_connection_string not in CONNECTIONS:
            me = object.__new__(cls)
            me.database_connection_string = database_connection_string
            me.engine = create_engine(me.database_connection_string, echo=echo,
                                      pool_size=pool_size, pool_recycle=pool_recycle)
            me.metadata = MetaData()
            me.metadata.bind = me.engine
            me.Base = declarative_base(bind=me.engine)
            me.Session = scoped_session(sessionmaker(bind=me.engine, autocommit=True,
                                                     expire_on_commit=expire_on_commit))
            CONNECTIONS[database_connection_string] = me

        return CONNECTIONS[database_connection_string]

    def __repr__(self):
        conn, info = self.database_connection_string.split('://', 1)
        info_split = info.rsplit('@', 1)
        host = info_split[0] if len(info_split) == 1 else info_split[1]
        return '<DatabaseConnection (conn={0}, host={1})>'.format(conn, host)



