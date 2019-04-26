from sdssdb.connection import SQLADatabaseConnection
from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
from sdssdb.sqlalchemy import BaseModel


# we need a shared common Base when joining across multiple schema
OperationsBase = declarative_base(cls=(DeferredReflection, BaseModel,))


class OperationsDBConnection(SQLADatabaseConnection):
    base = OperationsBase


database = OperationsDBConnection(autoconnect=False)

# Tries to connect to the correct database.
if database.profile == 'apo':
    database_name = 'apodb'
elif database.profile == 'lco':
    database_name = 'lcodb'
else:
    database_name = None

if database_name:
    database.connect(dbname=database_name, silent_on_fail=True)
