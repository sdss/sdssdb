#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-21
# @Filename: database.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)
#
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last modified time: 2018-09-22 10:06:13


from __future__ import absolute_import, division, print_function

import socket
import warnings

from peewee import Model, OperationalError, PostgresqlDatabase

from sdssdb import config


__all__ = ['DatabaseConnection', 'BaseModel']


class DatabaseConnection(PostgresqlDatabase):

    DATABASE_NAME = None

    def __init__(self, profile=None, autoconnect=True):

        super(DatabaseConnection, self).__init__(None)
        self.connected = False
        self.profile = None

        self.set_profile(profile=profile)

        if self.DATABASE_NAME is not None and autoconnect:
            try:
                self.autoconnect()
            except:
                pass

    def _test_connection(self):
        """Checks whether the connection is correct."""

        try:
            super(DatabaseConnection, self).connect()
            self.connected = True
        except OperationalError:

            warnings.warn('failed to connect to database {0}. '
                          'Setting database to None.'.format(self.database),
                          UserWarning)
            self.init(None)
            self.connected = False

    def set_profile(self, profile=None):
        """Determines observatory profile."""

        if profile is not None:
            self.profile = profile
            return

        # Get hostname
        hostname = socket.getfqdn()

        # Initially set location to local.
        self.profile = 'local'

        # Tries to find a profile whose domain matches the hostname
        for profile in config:
            if 'domain' in profile and profile['domain'] is not None:
                if hostname.endswith(profile['domain']):
                    self.profile = profile
                    break

    def autoconnect(self, dbname=None):
        """Tries to select the best possible connection to the db."""

        dbname = dbname or self.DATABASE_NAME
        assert dbname is not None, 'database name not defined or passed.'

        self.connect(profile=self.profile, dbname=dbname)

    def connect(self, dbname=None, profile=None):
        """Initialises the database from a profile in the config file."""

        profile = profile or self.profile
        assert profile is not None, 'profile not set.'

        # Gets the necessary configuration values from the profile
        db_configuration = {item: config[profile][item] for item in ['user', 'host', 'port']}

        dbname = dbname or self.DATABASE_NAME
        assert dbname is not None, 'database name not defined or passed.'

        self.init(dbname, **db_configuration)
        self._test_connection()

    def connect_from_parameters(self, dbname=None, **params):
        """Initialises the database from a dictionary of parameters."""

        dbname = dbname or self.DATABASE_NAME
        assert dbname is not None, 'database name not defined or passed.'

        self.init(dbname, **params)
        self._test_connection()

    def check_connection(self):
        """Checks whether the connection is open or can be connected."""

        if self.connected and self.connection().closed == 0:
            return True

        try:
            self.connect()
            self.connected = True
            return True
        except OperationalError:
            return False

    @staticmethod
    def list_profiles():
        """Returns a list of profiles."""

        return config.keys()

    def become(self, user):
        """Change the connection to a certain user."""

        if not self.connected:
            raise RuntimeError('DB has not been initialised.')

        dsn_params = self.connect_params
        if dsn_params is None:
            raise RuntimeError('cannot determine the DSN parameters. '
                               'The DB may be disconnected.')

        try:
            dsn_params['user'] = user
            dbname = self.database
            self.init(dbname, **dsn_params)
            super(DatabaseConnection, self).connect()
        except OperationalError:
            raise RuntimeError('cannot connect to database with '
                               'user {0}'.format(user))

    def become_admin(self):
        """Becomes the admin user."""

        assert self.profile is not None, \
            'this connection was not initialised from a profile. Try using become().'

        self.become(config[self.profile]['admin'])

    def become_user(self):
        """Becomes the read-only user."""

        assert self.profile is not None, \
            'this connection was not initialised from a profile. Try using become().'

        self.become(config[self.profile]['user'])


class BaseModel(Model):

    print_fields = []

    def __str__(self):
        """A custom repr for observatory models.

        By default it always prints pk, name, and label, if found. Models can
        define they own ``print_fields`` as a list of field to be output in the
        repr.

        """

        fields = ['pk={0!r}'.format(self.get_id())]

        for extra_field in ['label']:
            if extra_field not in self.print_fields:
                self.print_fields.append(extra_field)

        for ff in self.print_fields:
            if hasattr(self, ff):
                fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

        return '{0}'.format(', '.join(fields))
