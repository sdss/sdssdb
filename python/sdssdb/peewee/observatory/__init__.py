# flake8: noqa

from sdssdb.peewee.connection import BaseModel, DatabaseConnection


database = DatabaseConnection(autoconnect=False)


# Create a new base model class for the observatory and bind the database
class ObservatoryModel(BaseModel):
    class Meta:
        database = database
