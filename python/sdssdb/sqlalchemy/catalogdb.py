#!/usr/bin/env python
# encoding: utf-8
#
# @Author: Jennifer Sobeck
# @Date: August 2018
# @Filename: catalogdb.py
# @License: BSD 3-Clause
# @Copyright: 

# Initial attempt to create catalogdb model; JSG Method

#JSG
from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

from sqlalchemy.orm import configure_mappers, relation

from ..connections import DatabaseConnection

def __repr__(self):
    """A custom repr for catalogdb models.
    By default it always prints pk, name, and label, if found. Models can
    define they own ``__print_fields__`` as a list of field to be output in the
    repr.
    """

    fields = ['pk={0!r}'.format(self.pk)]

    for ff in self.__print_fields__:
        if hasattr(self, ff):
            fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

    return '<{0}: {1}>'.format(self.__class__.__name__, ', '.join(fields))


db = DatabaseConnection()
Base = db.Base

Base.__print_fields__ = ['label', 'name']
Base.__repr__ = __repr__

## Alternate Method from BC
class CatalogDB(object):
    ''' Class designed to handle the CatalogDB database  '''

    def __init__(self, *args, **kwargs):
        self.dbtype = kwargs.get('dbtype', None)
        self.db = None
        self.log = kwargs.get('log', None)
        self.error = []
        self.spaxelpropdict = None
        self.datadb = None
        self.dapdb = None
        self.sampledb = None
        self.__init_the_db()

    def __init_the_db(self):
        ''' Initialize the db '''
        if self.dbtype:
            self._setupDB()
        if self.db:
            self._importModels()
        self._setSession()
        self.testDbConnection()
        self._setModelGraph()
        self.cache_bits = []
        if self.db:
            self._addCache()

    def _setupDB(self):
        ''' Try to import the database '''
        try:
            from marvin.db.database import db
        except RuntimeError as e:
            log.debug('RuntimeError raised: Problem importing db: {0}'.format(e))
            self.db = None
        except ImportError as e:
            log.debug('ImportError raised: Problem importing db: {0}'.format(e))
            self.db = None
        else:
            self.db = db

    def _importModels(self):
        ''' Try to import the sql alchemy model classes '''

### ADD to the above specifically for CATALOGDB
