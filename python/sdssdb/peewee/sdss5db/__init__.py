# flake8: noqa

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


class SDSS5DatabaseConnection(PeeweeDatabaseConnection):
    DATABASE_NAME = 'sdss5db'


database = SDSS5DatabaseConnection(autoconnect=True)


# Create a new base model class for the observatory and bind the database
class SDSS5Model(BaseModel):
    class Meta:
        database = database
