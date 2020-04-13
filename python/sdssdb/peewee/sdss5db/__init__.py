# flake8: noqa

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


class SDSS5dbDatabaseConnection(PeeweeDatabaseConnection):
    dbname = 'sdss5db'


database = SDSS5dbDatabaseConnection(autoconnect=True)
