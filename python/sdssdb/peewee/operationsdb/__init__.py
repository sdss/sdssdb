# flake8: noqa

from sdssdb.connection import PeeweeDatabaseConnection, _should_autoconnect
from sdssdb.peewee import BaseModel


database = PeeweeDatabaseConnection(autoconnect=False)

# Tries to connect to the correct database.
if database.profile == 'apo':
    database_name = 'apodb'
elif database.profile == 'lco':
    database_name = 'lcodb'
else:
    database_name = None

if database_name and _should_autoconnect():
    database.connect(dbname=database_name, silent_on_fail=True)


# Create a new base model class for the observatory and bind the database
class OperationsDBModel(BaseModel):
    class Meta:
        database = database


from . import apogeeqldb, mangadb, platedb
