# flake8: noqa

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


database = PeeweeDatabaseConnection(autoconnect=False)


# Create a new base model class for the observatory and bind the database
class OperationsDBModel(BaseModel):
    class Meta:
        database = database
