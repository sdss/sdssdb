
API
===

Database connections
--------------------

.. automodule:: sdssdb.connection
   :members: DatabaseConnection, PeeweeDatabaseConnection, SQLADatabaseConnection
   :show-inheritance:


Peewee
------

.. autoclass:: sdssdb.peewee.ReflectMeta
   :members:
   :show-inheritance:

.. autoclass:: sdssdb.peewee.BaseModel
   :members:
   :show-inheritance:


SQLAlchemy
----------

.. autoclass:: sdssdb.sqlalchemy.BaseModel
   :members:
   :show-inheritance:


.. _api-utils:

Utils
-----

.. automodule:: sdssdb.utils.ingest
    :members:
    :show-inheritance:

.. automodule:: sdssdb.utils.internals
    :members:
    :show-inheritance:

.. autofunction:: sdssdb.utils.schemadisplay.create_schema_graph
