
.. _contributing:

Contributing to sdssdb
======================

Contributions to ``sdssdb`` are most welcome. Product development happens on its `GitHub repository <https://www.github.com/sdss/sdssdb>`__. For details on how to develop for an SDSS product refer to the `coding style guide <https://sdss-python-template.readthedocs.io/en/latest/standards.html>`__. All contributions to ``sdssdb`` need to be done as pull requests against the master branch.


Contributing a new database or schema
-------------------------------------

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

Let's imagine you want to create files for a database called ``awesomedb`` which has two schemas: ``amazing`` 
and ``stupendous``. Depending on whether you are creating model classes for peewee or sqlalchemy (or both), 
you will need to create a directory called ``awesomedb`` under the correct library directory with a 
``__init__.py`` file and two ``amazing.py`` and ``stupendous.py`` files. The following sections will show you 
how to fill out those files depending on the library used.


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

Next we need to creates the model classes themselves. At its simplest, a model class represents a table in a given schema and contains a list of the columns in the table, each one as a class attribute. Model classes must subclass from a base class (``AwesomedbModel`` in our example) that has been linked to the database connection. The default mode in Peewee is to explicitely define all columns, as opposed to autoloaded. To help with this task you can use the `pwiz <http://docs.peewee-orm.com/en/latest/peewee/playhouse.html#pwiz-a-model-generator>`__ model generator. For example, to create a file with the list of model classes for ``stupendous`` you would run, from a terminal ::

    python -m pwiz -e postgresql -s stupendous awesomedb > stupendous.py

Note that you may need to pass additional flags with the username, host, or port. Refer to the documentation for those.

Once the file has been generated you will need to do some changes. On the top of the file import ::

    from . import database
    from . import AwesomedbModel as BaseModel

The first line conveniently allows for access to the database connection from the schema submodule. The second one renames ``AwesomedbModel`` to ``BaseModel`` so that all the model classes in the file inherit from it. You'll probably need to make some other changes to the file, especially to the foreign keys to make sure they match your naming requirements.

Using reflection with Peewee
''''''''''''''''''''''''''''

Peewee provides a :ref:`reflection <peewee:reflection>` utility (internally used by ``pwiz``). Based on this tool we developed a `reflection metaclass <.ReflectMeta>` that can be used to expedite the creating of models by only requiring to define foreign keys. Note that this is not an official component of Peewee and it comes with certain caveats. Before using the reflection metaclass, make sure to read the `API documentation <.ReflectMeta>`.

To define a base class with reflection with do ::

    import peewee
    from sdssdb.peewee import ReflectMeta

    class ReflectBaseModel(peewee.Model, metaclass=ReflectMeta):
        class Meta:
            primary_key = False     # To make sure Peewee doesn't add its own PK.
            use_reflection = False  # We'll enable reflection manually for certain models.
            database = database

    class AwesomedbModel(ReflectBaseModel):
        class Meta:
            use_reflection = True
            schema = 'stupendous'
            table_name = 'stupendous_table'

When the connection is created this model will be reflected and autocompleted with all the columns that exist in the table. The reflection does not include `foreign keys <peewee:ForeignKeyField>`, which must be created manually (along with their referenced columns). You can check the `catalogdb <https://github.com/sdss/sdssdb/blob/master/python/sdssdb/peewee/sdss5db/catalogdb.py>`__ models for an implementation of this type.


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


In this example we have two tables, ``user`` and ``address`` that we model as ``User`` and ``Address`` 
respectively. Note that we don't need to specify any column at this point, just the ``__tablename__`` 
metadata property. All model classes need to subclass from ``Base``, which in turn subclasses from 
`~sqlalchemy.ext.declarative.AbstractConcreteBase` and ``AwesomedbBase``. We can use the special attribute 
``print_fields`` to define a list of fields that will be output in the standard representation of the model 
instances (primary keys and ``label`` fields are always output).

The ``define_relations`` function must contain all the foreign key relationships for this model. In this 
case there only one relationship that allows to retrieve the address for a given ``User`` (and its 
back reference). We need to encapsulate the relationships in a function so that they can be recreated if 
we change the database connection to point to a different database. Finally, we add the 
``database.add_base(Base)`` statement to bind the base to the database connection.

Testing Your New Database
-------------------------

After creating your database, you will want to ensure its stability and robustness as you expand its 
capabilities over time.  This can be done by writing tests against your database.  The testing directory system 
is very similar to the `sdssdb` database directory, with test database files located within separate library 
folders for ``peewee`` databases (``pwdbs``) or  ``sqlalchemy`` databases (``sqladbs``).   

.. code-block:: none

    tests
    |
    |__ pwdbs
    |   |
    |   |__ __init__.py
    |   |__ conftest.py
    |   |__ models.py
    |   |__ factories.py
    |   |
    |   |__ test_database1.py
    |   |__ test_database2.py
    |
    |__ sqladbs
    |   |
    |   |__ __init__.py
    |   |__ conftest.py
    |   |__ models.py
    |   |__ factories.py
    |   |
    |   |__ test_database1.py
    |   |__ test_database2.py
    |
    |__ conftest.py
    |__ test_generic_items.py

Most Python testing frameworks look for tests in files named ``test_xxxx.py``.  Under each library we create a 
``test_xxxx`` file for each new database we want to test. Since we've created a new ``awesomedb`` database, our
testing file will be ``test_awesomedb.py``.  This file gets placed under either the ``pwdbs`` or ``sqladbs`` (or both)
depending on if your database is using ``peeewee`` or ``sqlalchemy``.  

``sdssdb`` uses `pytest <https://docs.pytest.org/en/latest/>`_ as its testing framework, and assumes user 
familiarity with pytest.  The test directories contain ``conftest.py`` files which are files used for sharing
fixture functions between tests. See `here <https://docs.pytest.org/en/latest/fixture.html#conftest-py-sharing-fixture-functions>`_
for more details.  You will also see files called ``models`` and ``factories``.  We will come back to these later. 

Peewee
^^^^^^

Let's see what an example ``test_awesomedb.py`` might look like
::

    import pytest
    from sdssdb.peewee.awesomedb import database, stupendous


    @pytest.mark.parametrize('database', [database], indirect=True)
    class TestStupdendous(object):

        def test_user_count(self):
            ''' test that count of user table returns results '''
            user_ct = stupendous.User.select().count()
            assert user_ct > 0

We follow pytest's `test naming convention <https://docs.pytest.org/en/latest/goodpractices.html#test-discovery>`_
for naming test files as well as tests within files.  In our ``test_awesomedb`` file, we group similar tests
by schema together into ``Test`` classes, i.e. for the ``stupendous`` schema, we create a ``TestStupendous`` class.
All tests related to the ``stupendous`` schema will be defined in this class.  Individual tests within each class
are defined as methods on the class, named with ``test_xxxx``.  

In order for our test class to understand that we wish to use the ``awesomedb`` database for all defined tests, we
use the provided ``database`` fixture function and parametrize it with the ``awesomedb`` database.  See 
`fixture parametrization <https://docs.pytest.org/en/latest/fixture.html#parametrizing-fixtures>`_ to learn more 
about how to parametrize tests or fixtures.

We've defined a simple test, ``test_user_count``, that checks that our ``user`` table returns 
some number of results > 0.  In this case, we are a performing a simple select statement that does not modify the
database.  If we are writing tests that perform write operations on the database, we could use the provided
``transaction`` fixture to ensure all changes are rolled back. 

SQLAlchemy
^^^^^^^^^^

The example ``test_awesomedb.py`` file for a ``sqlalchemy`` database will look very similar to the 
``peewee`` version.
::

    import pytest
    from sdssdb.sqlalchemy.awesomedb import database
    if database.connected:
        from sdssdb.sqlalchemy.awesomedb import stupendous


    @pytest.mark.parametrize('database', [database], indirect=True)
    class TestStupdendous(object):

        def test_user_count(self, session):
            ''' test that count of user table returns results '''
            user_ct = session.query(stupendous.User).count()
            assert user_ct > 0

There are two main differences in this file from the ``peewee`` version.  The first is that we must wrap the 
import of the ``stupendous`` models inside a conditional that checks if the database has been successfully 
connected to.  This is needed because importing ``sqlalchemy`` models when no database exists, or
cannot connect, breaks other succcessful database imports.  The second change is the use of the ``session`` 
fixture inside the test.  Since ``sqlalchemy`` needs a db session to perform queries, we use the 
provided ``session`` pytest fixture.  This fixture will ensure that all changes made to the database 
are rolled back and not permanent.    

Generating and Inserting Fake Data into Your Database Tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you are only interested in writing simple tests that test real data in your database 
tables, then you can stop here and start writing your tests.  Sometimes, however, you may want to write 
tests for special database queries or model functions where you don't quite have the right data, or enough 
of it, loaded.  In these cases, we can generate fake data and insert it dynamically into our database tables.  
To do so, we have to create a "model factory".  This factory creates fake data based on a database Model. 

The following examples use the following resources to generate fake data:

- `factory_boy <https://factoryboy.readthedocs.io/en/latest/>`_ - creates db model factories to generate fake entries
- `faker <https://faker.readthedocs.io/en/master/index.html>`_ - creates fake data as needed by models
- `pytest-factoryboy <https://pytest-factoryboy.readthedocs.io/en/latest/>`_ - turns model factories into pytest fixtures

Let's see how to create factories to generate fake Users and Addressess, inside the ``factories.py`` file, 
using the ``peewee`` library implementation as an example.
::

    from sdssdb.peewee.awesomedb import database as awesomedb, stupendous
    from .factoryboy import PeeweeModelFactory

    class AddressFactory(PeeweeModelFactory):
        # define a Meta class with the associated model and database
        class Meta:
            model = stupendous.Address
            database = awesomedb

        # define fake data generators for all columns in the table
        pk = factory.Sequence(lambda n: n)
        street = factory.Faker('street_address')
        city = factory.Faker('city')
        state = factory.Faker('state_abbr')
        zipcode = factory.Faker('zipcode')
        full = factory.LazyAttribute(lambda a: f'{a.street}\n{a.city}, {a.state} {a.zipcode}')

    class UserFactory(PeeweeModelFactory):
        class Meta:
            model = stupendous.User
            database = awesomedb

        pk = factory.Sequence(lambda n: n)
        first = factory.Faker('first_name')
        last = factory.Faker('last_name')
        name = factory.LazyAttribute(lambda u: f'{u.first} {u.last}')

        # establishes the one-to-one relationship
        address = factory.SubFactory(AddressFactory)

If the ``User`` and ``Address`` models created previously have the following columns on each table, we use 
the `factorboy declarations <https://factoryboy.readthedocs.io/en/latest/reference.html#declarations>`_ 
and `factory.Faker providers <https://faker.readthedocs.io/en/master/providers.html>`_ to assign each column
a fake data generator.  For each factory we need to define a ``Meta`` class in it that defines the database 
model associated with it, as well as the database it belongs to.

These factories allow us to create fake instances of data that automatically inserts into the 
designated database table.  To create an instance locally without database insertion, you can use 
``UserFactory.build`` or to create in bulk, use ``UserFactory.create_batch``.  
::

    >>> user = UserFactory()
    >>> user
    >>> <User: pk=1, name='Walter Brown'>
    >>> user.address
    >>> <Address: pk=1>

The more common use however will be in tests.  These factories automatically get converted into pytest 
fixture functions using ``pytest-factoryboy``.  Let's see how we would use this in ``test_awesomedb.py``.
::

    @pytest.mark.parametrize('database', [database], indirect=True)
    class TestStupdendous(object):

        def test_new_user(self, user_factory):
            ''' test that we add a new user '''
            user_factory.create(first='New Bob')
            user = stupendous.User.get(stupendous.User.first=='New Bob')
            assert user.first == 'New Bob'

Notice the lowercase-underscore syntax.  This is the fixture name of the ``UserFactory``.  The above examples 
were written using the ``peeweee`` implementation.  For real examples, see the sdss5db tests in 
``tests/pwdbs/test_sdss5db.py`` and associated factories in ``test/pwdbs/factories.py``. The ``sqlalchemy`` 
version of defining a factory is very similar.
::

    import factory
    from sdssdb.tests.sqladbs import get_model_from_database
    from sdssdb.sqlalchemy.awesomedb import database as awesomedb
    stupendous = get_model_from_database(awesomedb, 'stupendous')

    if stupendous:
        class UserFactory(factory.alchemy.SQLAlchemyModelFactory):
            ''' factory for stupendous user table '''
            class Meta:
                model = stupendous.User
                sqlalchemy_session = aweseomdb.Session   # the SQLAlchemy session object

            # column definitions as before
            pk = factory.Sequence(lambda n: n)
            ...

Because ``sqlalchemy`` models cannot be imported when no database exists locally, we must use
``get_model_from_database`` to conditionally import the models we need, and place the factory class inside
a conditional.  Additionally, the factory Meta class needs the ``sqlalchemy`` Session rather the database itself.
All other behaviours and defintions are the same.  For examples of ``sqlalchemy`` factories and their uses, see 
``tests/sqladbs/factories.py`` and the mangadb tests in ``tests/sqladbs/test_mangadb.py``.

Using a Generic Test Database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes you may want to test a function common to many databases, or a generic database connection, or simply
not want to mess with real databases.  In these cases, a temporary test postgres database is available to use.
By default, when no real database is passed into the ``database`` fixture function, the test database is generated.
For example, the ``peewee`` test example case from earlier would now be the following, with the pytest 
parametrization line removed.
::

    class TestStupdendous(object):

        def test_user_count(self):
            ''' test that count of user table returns results '''
            user_ct = stupendous.User.select().count()
            assert user_ct > 0

This test would now use the temporary database, which is setup and destroyed for each test module.  Because
the test database is created as a blank slate, all database models must be created as well, in addition to any 
model factories.  These models can be stored in the ``models.py`` file under the respective library directories.  
See any of the ``models.py`` files for examples of creating test database models, and ``factories.py`` for their
associated factories.  See any of the tests defined in ``test_factory.py`` for examples of how to write tests 
against temporary database models defined in ``models.py``. 

Should I use Peewee or SQLAlchemy?
----------------------------------

Use the one that you prefer! Both Peewee and SQLAlchemy have their pros and cons and their own funclubs. Ideally you'll want to provide at least basic support for both library (and, indeed, it's not difficult if you follow the instructions above) to reach a wider audience. But if you only provide support for one library choose the one that you are more familiar with or the one that feels right.
