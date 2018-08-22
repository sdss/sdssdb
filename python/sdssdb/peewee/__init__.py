#!/usr/bin/env python
# encoding: utf-8
#
# @Authors: José Sánchez-Gallego, Jennifer Sobeck
# @Notes: Copy from Observesim/db; Modifications to come
# @Date: August 2018
# @Filename: __init__.py
# @License: BSD 3-Clause
# @Copyright: José Sánchez-Gallego


from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import socket
import warnings

from peewee import PostgresqlDatabase, OperationalError

from observesim import log, config


__all__ = ['database', 'DatabaseConnection']


class DatabaseConnection(PostgresqlDatabase):
    """Customised `PostgresqlDatabase` connection.

    If ``autoconnect=True``, tries to determine the correct connection
    parameters based on the hostname. If a valid connection cannot be
    established, a null connection will be created. Connections can be
    (re-)initiated using the `.connect_from_parameters` method.

    Alternatively, a ``profile`` name can be passed, that must mach and entry
    in the configuration file under the ``database`` section.

    """

    def __init__(self, autoconnect=True, profile=None):

        super(DatabaseConnection, self).__init__(None)
        self.connected = False

        if autoconnect:

            log.debug('autoconnecting to database ...')

            hostname = socket.getfqdn()
            if hostname.endswith('sdss.org') or hostname.endswith('utah.edu'):
                profile = 'utah'
                log.debug(f'found a Utah hostname. Trying {profile!r} profile')
                self.connect_from_config(profile)
            else:
                for profile in sorted(config['database'].keys()):
                    log.debug(f'trying profile {profile!r}')
                    self.connect_from_config(profile, warn_on_fail=False)
                    if self.connected is True:
                        log.info(f'connected to database {self.database!r} '
                                 f'using profile {profile!r}')
                        return
                    else:
                        log.debug(f'failed to connect with profile {profile!r}')

        if profile:
            self.connect_from_config(profile)

    def _test_connection(self, warn_on_fail=None):
        """Checks whether the connection is correct."""

        try:
            self.connect()
            self.connected = True
        except OperationalError:

            if warn_on_fail in (None, True):
                warnings.warn('failed to connect to database {0}. '
                              'Setting database to None.'.format(self.database),
                              UserWarning)
                self.init(None)
                self.connected = False

    def connect_from_config(self, profile, warn_on_fail=None):
        """Initialises the database from the config file."""

        db_configuration = config['database'][profile].copy()

        dbname = db_configuration.pop('dbname')
        self.init(dbname, **db_configuration)
        self._test_connection(warn_on_fail=warn_on_fail)

    def connect_from_parameters(self, dbname, **params):
        """Initialises the database from parameters. See `psycopg2.connect`."""

        self.init(dbname, **params)
        self._test_connection()

    def check_connection(self):
        """Checks whether the connection is open or can be connected."""

        if self.connected and self.get_conn().closed == 0:
            return True

        try:
            self.connect()
            self.connected = True
            return True
        except OperationalError:
            return False


database = DatabaseConnection()
