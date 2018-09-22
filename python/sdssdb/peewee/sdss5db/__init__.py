# flake8: noqa

from sdssdb.peewee.connection import BaseModel, DatabaseConnection


class SDSS5DatabaseConnection(DatabaseConnection):
    DATABASE_NAME = 'sdss5db'


database = SDSS5DatabaseConnection(autoconnect=True)


# Create a new base model class for the observatory and bind the database
class SDSS5Model(BaseModel):
    class Meta:
        database = database
