#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-21
# @Filename: database.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)
#
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last modified time: 2018-09-22 11:02:01


from __future__ import absolute_import, division, print_function

import socket
import warnings

from peewee import Model, OperationalError, PostgresqlDatabase

from sdssdb import config


__all__ = ['DatabaseConnection', 'BaseModel']


class DatabaseConnection(PostgresqlDatabase):
    """A PostgreSQL database connection with profile and autoconnect features.

    Provides a base class for PostgreSQL connections based on peewee's
    `.PostgresqlDatabase`. The parameters for the connection can be
    passed directly (see `.connect_from_parameters`) or, more conveniently, a
    profile can be used. By default `.DATABASE_NAME` is left undefined and
    needs to be passed when initiating the connection. This is useful for
    databases such as ``apodb/lcodb`` for which the model classes are identical
    but the database name is not. For databases for which the database name is
    fixed (e.g., ``sdss5db``), this class can be subclassed and
    `.DATABASE_NAME` overridden.

    Parameters
    ----------
    profile : str
        The configuration profile to use. The profile defines the default
        user, database server hostname, and port for a given location. If
        not provided, the profile is automatically determined based on the
        current domain, or defaults to ``local``.
    autoconnect : bool
        Whether to autoconnect to the database using the profile parameters.
        Requites `.DATABASE_NAME` to be set.

    """

    #: The default database name.
    DATABASE_NAME = None

    def __init__(self, profile=None, autoconnect=True):

        super(DatabaseConnection, self).__init__(None)
        self.connected = False
        self.profile = None

        self.set_profile(profile=profile)

        if self.DATABASE_NAME is not None and autoconnect:
            try:
                self.connect()
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

    def connect(self, dbname=None, profile=None):
        """Initialises the database from a profile in the config file.
        Parameters
        ----------
        dbname : `str` or `None`
            The database name. If `None`, defaults to `.DATABASE_NAME`.
        profile : `str` or `None`
            The connection profile to use. If `None`, uses the default profile.

        """

        profile = profile or self.profile
        assert profile is not None, 'profile not set.'

        # Gets the necessary configuration values from the profile
        db_configuration = {item: config[profile][item] for item in ['user', 'host', 'port']}

        dbname = dbname or self.DATABASE_NAME
        assert dbname is not None, 'database name not defined or passed.'

        self.init(dbname, **db_configuration)
        self._test_connection()

    def connect_from_parameters(self, dbname=None, **params):
        """Initialises the database from a dictionary of parameters.

        Parameters
        ----------
        dbname : `str` or `None`
            The database name. If `None`, defaults to `.DATABASE_NAME`.
        params : dict
            A dictionary of parameters, which should include ``user``,
            ``host``, and ``port``.

        """

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
