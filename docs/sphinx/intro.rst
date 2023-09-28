
.. _getting-started:

Getting started with sdssdb
===========================

``sdssdb`` provides general utilities and functionality for connecting to SDSS databases using `Object-relational Mapping <https://en.wikipedia.org/wiki/Object-relational_mapping>`__ (ORM).  ``sdssdb`` supports two Python ORM libraries for mapping between database tables and Python classes:  Peewee_ and SQLAlchemy_.


Making a simple query with ``sdssdb``
-------------------------------------

Imagine that you want to query ``catalogdb`` (the schema containing all the catalogues used for target selection in SDSS-V) and get all the Gaia targets within a range of magnitudes. In most cases this only requires a couple lines of code. This example assumes that you're running the code from a machine at Utah which has direct access to the ``operations.sdss.org`` machine. ::

    >>> from sdssdb.peewee.sdss5db.catalogdb import database
    >>> database.set_profile('operations')
    True
    >>> from sdssdb.peewee.sdss5db.catalogdb import Gaia_DR2
    >>> targets = Gaia_DR2.select().where((Gaia_DR2.phot_g_mean_mag > 15) & (Gaia_DR2.phot_g_mean_mag < 16)).limit(10)

This will returns the first 10 results from Gaia DR2 with g magnitude in the range :math:`(15, 16)`. Simple.

A subtlety is that the order of imports is important. Since the ``Gaia_DR2`` model is populated dynamically, it must be imported once a connection to the database has been accomplished. Alternatively, one can do ::

    >>> from sdssdb.peewee.sdss5db import catalogdb
    >>> catalogdb.database.set_profile('operations')
    True
    >>> targets = catalogdb.Gaia_DR2.select().where((catalogdb.Gaia_DR2.phot_g_mean_mag > 15) & (catalogdb.Gaia_DR2.phot_g_mean_mag < 16)).limit(10)


.. _available-databases:

Available databases
-------------------

Currently, we support the following databases and schemas:

* **operationsdb**: a global name for the APO (``apodb``) and LCO (``lcodb``) operations database.
    * *platedb*: schema for plate observations and metadata.
    * *mangadb*: schema for MaNGA observations and metadata.
    * *apogeeqldb*: schema for APOGEE observations and quick reductions.
* **mangadb**: the SDSS-IV MaNGA database.
    * *datadb*: schema for MaNGA DRP data products.
    * *dapdb*: schema for MaNGA DAP data products.
    * *sampledb*: schema for MaNGA target sample.
    * *auxdb*: schema for auxiliary information for MaNGA.
* **sdss5db**: the SDSS-V development database.
    * *catalogdb*: schema for source catalogues used for target selection.
    * *targetdb*: schema with the results of the target selection and positioner information.
    * *opsdb*: schema for the operations database
    * *apogee_drpdb*: schema with the results of the MWM DRP
    * *boss_drp*: schema with the results of the BHM DRP

* **archive**: the SDSS science archive database.
    * *sas*: schema for SAS.

Note that the level of readiness is not necessarily identical in both Peewee and SQLAlchemy. This table summarises what schemas are available for each library. Green indicates fully supported, yellow partial support, and red means that there are currently not model classes available for that schema. You can download the graph visualisation of the schema, showing the tables, columns, and relations between tables.

.. raw:: html

    <table class="table" style="width: 80%">
        <thead>
        <tr>
            <th style="width: 30%">Database</th>
            <th style="width: 20%">Schema</th>
            <th style="width: 25%">Peewee</th>
            <th style="width: 25%">SQLAlchemy</th>
            <th style="width: 20%">Graph</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="active">operationsdb</td>
            <td class="active">platedb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="_static/schema_graphs/auto/operationsdb.platedb.pdf"></a></td>

        </tr>
        <tr>
            <td></td>
            <td class="active">mangadb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="_static/schema_graphs/auto/operationsdb.mangadb.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">apogeeqldb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="_static/schema_graphs/auto/operationsdb.apogeeqldb.pdf"></a></td>
        </tr>
        <tr>
            <td class="active">manga</td>
            <td class="active">auxdb</td>
            <td class="danger"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/marvin/blob/main/docs/dbschema/mangaauxdb_schema.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">dapdb</td>
            <td class="danger"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/marvin/blob/main/docs/dbschema/mangadapdb_schema.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">datadb</td>
            <td class="danger"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/marvin/blob/main/docs/dbschema/mangadatadb_schema.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">sampledb</td>
            <td class="danger"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/marvin/blob/main/docs/dbschema/mangasampledb_schema.pdf"></a></td>
        </tr>
        <tr>
            <td class="active">sdss5db</td>
            <td class="active">catalogdb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/catalogdb/sdss5db.catalogdb.pdf" alt="catalogdb full version"></a> <a class="glyphicon glyphicon-download-alt" style="color:green" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/catalogdb/sdss5db.catalogdb_lite.pdf" alt="catalogdb reduced version"></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">targetdb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/targetdb/sdss5db.targetdb.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">opsdb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/opsdb/sdss5db.opsdb.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">apogee_drpdb</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/apogee_drpdb/sdss5db.apogee_drpdb.pdf"></a></td>
        </tr>
        <tr>
            <td></td>
            <td class="active">boss_drp</td>
            <td class="success"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/sdss5db/boss_drp/sdss5db.boss_drp.pdf"></a></td>
        </tr>
        <tr>
            <td class="active">archive</td>
            <td class="active">sas</td>
            <td class="danger"></td>
            <td class="success"></td>
            <td align="center"><a class="glyphicon glyphicon-download-alt" href="https://github.com/sdss/sdssdb/raw/main/schema/archive/archive_sas.pdf"></a></td>
        </tr>
        </tbody>
    </table>


.. _conn-db:

Connecting to a Database
------------------------

The `~sdssdb.connection.DatabaseConnection` abstract class allows to connect to a PostgreSQL database using a profile (see the :ref:`profile`) or a custom set of connection parameters. In most cases, the user will need to use either `~sdssdb.connection.PeeweeDatabaseConnection` or `~sdssdb.connection.SQLADatabaseConnection` depending on the backend library used. Regarding the implementation details, their behaviour is identical. To open a connection to the database ``manga`` we can do ::

    >>> from sdssdb.connection import SQLADatabaseConnection
    >>> db = SQLADatabaseConnection('manga')
    >>> db
    <SQLADatabaseConnection (dbname='manga', profile='local', connected=True)>

(note that this example will only work if you have a local database called ``manga``)

What happened here? `~sdssdb.connection.SQLADatabaseConnection` connected to the ``manga`` database using the ``local`` profile. A profile is simply a set of username, hostname, and port on which to look for a PostgreSQL server. ``sdssdb`` tries to be smart and select a profile that matches the machine on which you are working. That may not always work. For example, imagine that you are working on ``manga.wasatch.peaks`` but trying to connect to ``sdss5db`` which is running on ``operations-test.sdss.utah.edu`` ::

    >>> from sdssdb.connection import PeeweeDatabaseConnection
    >>> db = PeeweeDatabaseConnection('sdss5db')
    <PeeweeDatabaseConnection (dbname='sdss5db', profile='manga', connected=False)>

In this case the profile is not the appropriate for connecting to ``sdss5db`` and the connection fails. We can fix that by connecting with the correct profile ::

    >>> db.set_profile('operations')
    True
    >>> db
    <PeeweeDatabaseConnection (dbname='sdss5db', profile='operations', connected=True)>

Or we could have connected to the database passing it a full set of parameters ::

    >>> db.connect_from_parameters(user='sdss', host='operations.sdss.org', port=5432)
    True

In other cases you may have several databases running on the same server. You can prepare a connection using the appropriate profile and then connect to a specific database ::

    >>> local_db = PeeWeeDatabaseConnection(profile='local')
    >>> local_db.connect('apodb')

`~sdssdb.connection.DatabaseConnection.connect` will try to use the current profile to connect to the given database.

In general you will not usually create database connections directly. Each database schema is bound to a database connection which will try to connect to the correct database. For example ::

    >>> from sdssdb.peewee.operationsdb import database
    >>> database
    <PeeweeDatabaseConnection (dbname='apodb', profile='apo', connected=True)>

Now imagine the case in which you are running ``sdssdb`` from your local computer and are trying to connect to ``apodb`` at APO. You do not have the database locally but have created a tunnel connection to ``sdss4-db.apo.nmsu.edu`` and redirected it to your localhost port 6666. To connect to that tunnel you do ::

    >>> from sdssdb.peewee.operationsdb import database
    >>> database
    <PeeweeDatabaseConnection (dbname=None, profile='local', connected=False)>
    >>> database.connect_from_parameters(dbname='apodb', host='localhost', port=6666, user='sdssdb')
    True
    >>> database
    <PeeweeDatabaseConnection (dbname='apodb', profile='local', connected=True)>

There are two database connections, ``SQLADatabaseConnection`` and ``PeeWeeDatabaseConnection``, one for each mapping library. Each database connection has two keyword arguments: a user/machine profile, a database name.  The connection will automatically attempt to connect to the specified database with the profile unless the ``autoconnect`` keyword is set to `False`. ::

    # load a database connection with the Utah manga machine profile and connect to the manga database. To create a Peewee conenction replace with PeeweeDatabaseConnection.
    from sdssdb.connection import SQLADatabaseConnection
    db = SQLADatabaseConnection(profile='manga', dbname='manga')


A note about passwords
----------------------

``sdssdb`` does not allow you to pass plaintext passwords when creating a connection, or to store them in the profiles. Instead, you should use `pgpass <https://www.postgresql.org/docs/9.3/libpq-pgpass.html>`__ to set your passwords. A typical ``~/.pgpass`` file looks something like ::

    *:*:apodb:sdssdb:XXXX
    localhost:5432:sdss5db:sdss:YYYY
    operations-test.sdss.utah.edu:5432:sdss5db:sdss:ZZZZ

where ``XXXX``, ``YYYY``, etc are the associated passwords for each set of parameters.


.. _profile:

Supported Profiles
------------------

The following `profiles <https://github.com/sdss/sdssdb/blob/main/python/sdssdb/etc/sdssdb.yml>`__ are included with sdssdb. When a :ref:`database connection <conn-db>` is created without an explicit profile, the hostname of the current machine is used to find the best possible profile. Profiles can be added or modified by creating a YAML file in ``~/.config/sdss/sdssdb.yaml`` with the same structure.

* **local**: a generic localhost profile. Used if the hostname does not match any other profile.
* **apo**: a user on the APO machines.
* **lco**: a user on the LCO machines.
* **manga**: a user on the Utah manga machine.
* **operations**: a user on the Utah operations machine.
* **sdssadmin**: a user on the Utah sdssadmin machine.
* **lore**: a user on the Utah lore machine.

A list of available profiles (including custom ones) can also be accessed via de `~sdssdb.connection.DatabaseConnection.list_profiles` classmethod ::

    >>> import sdssdb
    >>> profiles = sdssdb.DatabaseConnection.list_profiles()
    >>> profiles
    dict_keys(['apo', 'lco', 'operations-test', 'local', 'lore', 'jhu', 'sdssadmin', 'manga'])
    >>> sdssdb.DatabaseConnection.list_profiles('apo')
    {'user': 'sdssdb',
     'admin': 'sdssdb_admin',
     'host': 'sdss4-db',
     'port': 5432,
     'domain': 'apo.nmsu.edu'}


Accessing the model classes
---------------------------

A model class is a Python class that abstracts a database table so that it can be accessed by the ORM libraries. In ``sdssdb`` the model class for a given table can always be found under ``sdssdb.XXX.YYY.ZZZ`` where ``XXX`` is either ``peewee`` or ``sqlalchemy`` depending on the library you want to use, ``YYY`` is the database name, and ``ZZZ`` is the schema name. For instance, if you want to use peewee to query the ``target`` table in the ``targetdb`` schema in ``sdss5db``, you need to import ::

    from sdssdb.peewee.sdss5db.targetdb import Target

Note that we use the standard of capitalising class names. Frequently, you'll want to import the whole schema as ::

    from sdssdb.peewee.sdss5db import targetdb

which gives you access to all the model classes for that schema. The database bound to those model classes can be accessed from the submodule containing the database or from the schema ::

    >>> from sdssdb.peewee.sdss5db import database
    >>> from sdssdb.peewee.sdss5db import targetdb
    >>> database
    <SDSS5dbDatabaseConnection (dbname='sdss5db', profile='local', connected=True)>
    >>> targetdb.database
    <SDSS5dbDatabaseConnection (dbname='sdss5db', profile='local', connected=True)>
    >>> targetdb.database == database
    True


SQLAlchemy specifics
--------------------

The database handling with SQLAlchemy is mostly the same as with Peewee. The main difference is the need to create a database session before connecting and querying ::

    # connecting to the manga database
    from sdssdb.sqlalchemy.mangadb import database, datadb

    # start a session
    session = database.Session()

    # write a query
    cube = session.query(datadb.Cube).first()

If you connect to a different database, you must recreate the database session ::

    # connect to a separate database
    database.connect('other-mangadb')
    session = database.Session()


The case of ``operationsdb``
----------------------------

If you are familiar with the SDSS databases you will know that there is no ``operationsdb``. Instead, there is ``apodb`` and ``lcodb``, two databases that share the same schemas but are located on computers are APO and LCO respectively. Instead of creating different sets of identical model classes for both databases, the models and database connections can be found under the ``operationsdb`` submodule (``sdssdb.peewee.operationsdb`` or ``sdssdb.sqlalchemy.operationsdb``).

When you import the database connection ``sdssdb`` will try use the profile name to decide to which database to connect. For example, if you are at APO the ``apo`` profile will be used by default and the database connection will try to connect to ``apodb`` ::

    >>> from sdssdb.peewee.operationsdb import database
    >>> database
    <PeeweeDatabaseConnection (dbname='apodb', profile='apo', connected=True)>

If that fails, you will need to define the database name and profile. In the following example the user has ``apodb`` available locally ::

    >>> from sdssdb.peewee.operationsdb import database
    >>> database
    <PeeweeDatabaseConnection (dbname=None, profile='local', connected=False)>
    >>> database.connect('apodb')
    True
    >>> database
    <PeeweeDatabaseConnection (dbname='apodb', profile='local', connected=True)>

If both ``apodb`` and ``lcodb`` are available the ``local`` profile will **not** connect to either of them automatically ::

    >>> from sdssdb.peewee.operationsdb import database
    >>> database
    <OperationsDBConnection (dbname=None, profile='local', connected=False)>
    >>> database.connect('lcodb')
    True
    >>> database
    <OperationsDBConnection (dbname='lcodb', profile='local', connected=True)>

We can switch from one to the other in runtime ::

    >>> database
    <PeeweeDatabaseConnection (dbname='lcodb', profile='local', connected=True)>
    >>> from sdssdb.peewee.operationsdb import platedb
    >>> plate_9781 = platedb.Plate.get(plate_id=9781)
    >>> plate_9781.plate_run.label
    '2017.03.b.apogee2s.south'
    >>> database.connect('apodb')
    True
    >>> database
    <PeeweeDatabaseConnection (dbname='apodb', profile='local', connected=True)>
    >>> plate_10k = platedb.Plate.get(plate_id=10000)
    >>> plate_10k.plate_run.label
    '2015.08.z.eboss'


Where to go from here?
----------------------

Once the connection has been created and the model classes imported you can use them as you would with any Peewee or SQLALchemy model. It is beyond the purpose of this documentation to explain how to use those libraries. Instead, refer to the Peewee_ or SQLAlchemy_ documentation.

The :ref:`target-selection-example` section provides a detailed example of how to use ``sdssdb`` that highlights the advantages of the ORM approach.


.. _Peewee: http://docs.peewee-orm.com/en/latest/
.. _SQLAlchemy: http://www.sqlalchemy.org/
