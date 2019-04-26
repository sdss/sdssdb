
.. _contributing:

Contributing to sdssdb
======================

Contributions to ``sdssdb`` are most welcome. Product development happens on its `GitHub repository <https://www.github.com/sdss/sdssdb>`__. For details on how to develop for an SDSS product refer to the `coding style guide <https://sdss-python-template.readthedocs.io/en/latest/standards.html>`__. All contributions to ``sdssdb`` need to be done as pull requests against the master branch.


Contributing a new database
---------------------------

In addition to improvements to the code, you can contribute database connections and model classes for your databases. To do so, first remember the directory structure of ``sdssdb``

.. code-block:: none

    sdssdb
    |
    |__ peewee
    |   |
    |   |__ database_name
    |       |
    |       |__ __init__.py
    |       |__ schema1.py
    |       |__ schema2.py
    |
    |__ sqlalchemy
    |   |
    |   |__ database_name
    |       |
    |       |__ __init__.py
    |       |__ schema1.py
    |       |__ schema2.py

Let's imagine you want to create files for a database called ``awesomedb`` which has two schemas: ``amazing`` and ``stupendous``. Depending on whether you are creating model classes for peewee or sqlalchemy (or both), you will need to create a directory called ``awesomedb`` under the correct library directory with a ``__init__.py`` file and two ``amazing.py`` and ``stupendous.py`` files. The following sections will show you how to fill out those files depending on the library used.


Peewee
^^^^^^

For an example of how to implement a database with Peewee you can look at the `sdss5db <https://github.com/sdss/sdssdb/tree/master/python/sdssdb/peewee/sdss5db>`__ implementation. Let's start with the database connection in the ``__init__.py`` file. The basic structure is quite simple and would look something like ::

    from sdssdb.connection import PeeweeDatabaseConnection
    from sdssdb.peewee import BaseModel


    class AwesomedbDatabaseConnection(PeeweeDatabaseConnection):
        dbname = 'awesomedb'


    database = AwesomedbDatabaseConnection(autoconnect=True)


    # Create a new base model class for the observatory and bind the database
    class AwesomedbModel(BaseModel):

        class Meta:
            database = database

The first two lines simply import the base classes for the database connection and base model class. We then subclass `~sdssdb.connection.PeeweeDatabaseConnection` to create the connection for ``awesomedb``, overriding the `~sdssdb.connection.PeeweeDatabaseConnection.dbname` attribute. We then instantiate the database connection as ``database``. Note the ``autoconnect=True`` parameter which tells the database connection to try to use the best available profile to connect when the class gets instantiated. Finally, we subclass `~sdssdb.peewee.BaseModel` and we bind the database connection to it.

Next we need to creates the model classes themselves. At its simplest, a model class represents a table in a given schema and contains a list of the columns in the table, each one as a class attribute. Model classes must subclass from a base class (``AwesomedbModel`` in our example) that has been linked to the database connection. Differently from SQLAlchemy, Peewee requires that all the columns be explicitly described, as opposed to autoloaded. To help with this task you can use the `pwiz <http://docs.peewee-orm.com/en/latest/peewee/playhouse.html#pwiz-a-model-generator>`__ model generator. For example, to create a file with the list of model classes for ``stupendous`` you would run, from a terminal ::

    python -m pwiz -e postgresql -s stupendous awesomedb > stupendous.py

Note that you may need to pass additional flags with the username, host, or port. Refer to the documentation for those.

Once the file has been generated you will need to do some changes. On the top of the file import ::

    from . import database
    from . import AwesomedbModel as BaseModel

The first line conveniently allows for access to the database connection from the schema submodule. The second one renames ``AwesomedbModel`` to ``BaseModel`` so that all the model classes in the file inherit from it. You'll probably need to make some other changes to the file, especially to the foreign keys to make sure they match your naming requirements.


SQLAlchemy
^^^^^^^^^^

Creating a database connection and model classes for SQLALchemy is quite similar to Peewee. As before, refer to the implementation of `sdss5db <https://github.com/sdss/sdssdb/tree/master/python/sdssdb/sqlalchemy/sdss5db>`__ for a good example. In this case the ``__init__.py`` file would look like ::

    from sdssdb.connection import SQLADatabaseConnection
    from sqlalchemy.ext.declarative import declarative_base, DeferredReflection
    from sdssdb.sqlalchemy import BaseModel

    # we need a shared common Base when joining across multiple schema
    AwesomedbBase = declarative_base(cls=(DeferredReflection, BaseModel,))


    class AwesomedbDatabaseConnection(SQLADatabaseConnection):
        dbname = 'sdss5db'
        base = AwesomedbBase


    database = AwesomedbDatabaseConnection(autoconnect=True)

Note that we define ``AwesomedbBase`` as a `~sqlalchemy.ext.declarative.declarative_base` using the SQLAlchemy ``sdssdb`` base class and a `~sqlalchemy.ext.declarative.DeferredReflection` base class. The latter allows for the autoloading of table columns but only at the time at which the model classes are prepared.

For the model classes you will need to write the files manually but there is no need to fill out all the column names. The deferred reflection will take care of that. An example of how the ``stupendous.py`` file would look is ::

    from sqlalchemy import Column, ForeignKey, Integer, String
    from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
    from sqlalchemy.orm import relationship

    from sdssdb.sqlalchemy.awesome import AwesomedbBase, database


    class Base(AbstractConcreteBase, AwesomedbBase):
        __abstract__ = True
        _schema = 'stupendous'
        _relations = 'define_relations'

        @declared_attr
        def __table_args__(cls):
            return {'schema': cls._schema}


    class User(Base):
        __tablename__ = 'user'


    class Address(Base):
        __tablename__ = 'address'
        print_fields = ['zipcode']


    def define_relations():

        User.address = relationship(Address, backref='user')


    database.add_base(Base)


In this example we have two tables, ``user`` and ``address`` that we model as ``User`` and ``Address`` respectively. Note that we don't need to specify any column at this point, just the ``__tablename__`` metadata property. All model classes need to subclass from ``Base``, which in turn subclasses from `~sqlalchemy.ext.declarative.AbstractConcreteBase` and ``AwesomedbBase``. We can use the special attribute ``print_fields`` to define a list of fields that will be output in the standard representation of the model instances (primary keys and ``label`` fields are always output).

The ``define_relations`` function must contain all the foreign key relationships for this model. In this case there only one relationship that allows to retrieve the address for a given ``User`` (and its back reference). We need to encapsulate the relationships in a function so that they can be recreated if we change the database connection to point to a different database. Finally, we add the ``database.add_base(Base)`` statement to bind the base to the database connection.


Should I use Peewee or SQLAlchemy?
----------------------------------

Use the one that you prefer! Both Peewee and SQLAlchemy have their pros and cons and their own funclubs. Ideally you'll want to provide at least basic support for both library (and, indeed, it's not difficult if you follow the instructions above) to reach a wider audience. But if you only provide support for one library choose the one that you are more familiar with or the one that feels right.
