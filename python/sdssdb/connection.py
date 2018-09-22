#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-21
# @Filename: database.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)
#
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last modified time: 2018-09-22 14:28:43


from __future__ import absolute_import, division, print_function

import abc
import socket

import six

from sdssdb import config, log


try:
    from peewee import OperationalError, PostgresqlDatabase
    _peewee = True
except ImportError:
    _peewee = False


__all__ = ['DatabaseConnection', 'PeeweeDatabaseConnection']


class DatabaseConnection(six.with_metaclass(abc.ABCMeta)):
    """A PostgreSQL database connection with profile and autoconnect features.

    Provides a base class for PostgreSQL connections for either peewee_ or
    SQLAlchemy_. The parameters for the connection can be
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

    .. _peewee: http://docs.peewee-orm.com/en/latest/
    .. _SQLAlchemy: http://www.sqlalchemy.org

    """

    #: The default database name.
    DATABASE_NAME = None

    def __init__(self, profile=None, dbname=None, autoconnect=True):

        #: Reports whether the connection is active.
        self.connected = False
        self.profile = None

        self.set_profile(profile=profile)

        if autoconnect:
            try:
                self.connect(profile=profile, dbname=dbname)
            except:
                pass

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

    @abc.abstractmethod
    def _conn(self, dbname, **params):
        """Actually initialises the database connection.

        This method should be overridden depending on the ORM library being
        used. At the end, `.connected` should be set to True if the connection
        was successful.

        """

        pass

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

        self.connect_from_parameters(dbname=dbname, **db_configuration)

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

        self._conn(dbname, **params)

    @staticmethod
    def list_profiles():
        """Returns a list of profiles."""

        return config.keys()

    @abc.abstractproperty
    def connection_params(self):
        """Returns a dictionary with the connection parameters."""

        pass

    def become(self, user):
        """Change the connection to a certain user."""

        if not self.connected:
            raise RuntimeError('DB has not been initialised.')

        dsn_params = self.connection_params
        if dsn_params is None:
            raise RuntimeError('cannot determine the DSN parameters. '
                               'The DB may be disconnected.')

        dsn_params['user'] = user
        dbname = self.database
        self.connect_from_parameters(dbname, **dsn_params)

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


if _peewee:

    class PeeweeDatabaseConnection(DatabaseConnection, PostgresqlDatabase):
        """Peewee database connection implementation."""

        def __init__(self, *args, **kwargs):

            PostgresqlDatabase.__init__(self, None)
            DatabaseConnection.__init__(self, *args, **kwargs)

        @property
        def connection_params(self):
            """Returns a dictionary with the connection parameters."""

            return self.connect_params

        def _conn(self, dbname, **params):
            """Connects to the DB and tests the connection."""

            PostgresqlDatabase.init(self, dbname, **params)

            try:
                self.connected = PostgresqlDatabase.connect(self)
            except OperationalError:
                log.warning('failed to connect to database {0}. '
                            'Setting database to None.'.format(self.database), UserWarning)
                PostgresqlDatabase.init(self, None)
                self.connected = False
