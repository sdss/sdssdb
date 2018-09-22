# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:02:19
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-09-22 10:34:56

from __future__ import print_function, division, absolute_import

import os
import yaml
from pgpasslib import getpass
from sdssdb.sqlalchemy.DatabaseConnection import DatabaseConnection


def read_config_file(filename):
    ''' Read a config file '''

    try:
        with open(filename, 'r') as ff:
            rawfile = ff.read()

    except IOError as e:
        raise RuntimeError('IOError: Could not open dbconfigfile {0}:{1}'.format(dbconfigfile, e))
    dbdict = yaml.load(rawfile)
    return dbdict


def get_db_conn(config_name=None, config_file=None, host=None,
                user=None, password=None, port=None, database=None, dbinfo=None):
    ''' Get a database connection '''

    # load db info by config
    if config_name:
        if not config_file:
            # use default config file
            path = os.path.abspath(os.path.dirname(__file__))
            configpath = os.path.abspath(os.path.join(path, os.pardir))
            config_file = os.path.join(configpath, 'dbconfig.ini')

        dbdict = read_config_file(config_file)
        if config_name not in dbdict:
            raise KeyError(f'{config_name} not found in list of available configs')
        dbinfo = dbdict[config_name]

    # load db info by manual input
    if not config_file and not config_name:
        assert dbinfo or all([host, database]), 'Must specify manual db connection info'
        if host != 'localhost':
            assert all([user, port]), 'Must also specify a db user and port'

        if not dbinfo:
            dbinfo = dict(host=host, user=user, port=port, database=database)
            if password:
                dbinfo['password'] = password

    # check for the password
    if 'password' not in dbinfo:
        try:
            dbinfo['password'] = getpass(dbinfo['host'], dbinfo['port'], dbinfo['database'], dbinfo['user'])
        except KeyError as e:
            raise RuntimeError('ERROR: invalid server configuration')

    # build the database connection string
    if dbinfo["host"] == 'localhost':
        db_connection_string = f"postgresql+psycopg2:///{dbinfo['database']}"
    else:
        db_connection_string = 'postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}'.format(**dbinfo)

    # load a DatabaseConnection
    db = DatabaseConnection(database_connection_string=db_connection_string)

    return db










