
.. _intro:

Introduction to sdssdb
===============================

``sdssdb`` provides general utilities and functionality for connecting to all SDSS databases.  For now, ``sdssdb`` supports two Python ORM libraries for mapping between database tables and Python classess:  `Peewee <http://docs.peewee-orm.com/en/latest/>`_ and `SQLAlchemy <https://www.sqlalchemy.org/>`_.


Supported Databases and Schema/Models
-------------------------------------

* **observatory** -  The APO (apodb) and LCO (lcodb) operations database
    * **mangadb** - Models associated with the MaNGA observations and metadata
    * **platedb** - Models associated with the plate observations and metadata

* **mangadb** - The SDSS-IV MaNGA database
    * **datadb** - Models associated with the MaNGA DRP data products
    * **dapdb** - Models associated with the MaNGA DAP data products
    * **sampledb** - Models associated with the MaNGA target sample
    * **auxdb** - Models associated with auxillary information for MaNGA

* **sdss5db** - The SDSS-V development database
    * **catalogdb** - Models associated with the source catalogs used for target selection


Supported Profiles
------------------

* **localhost** - a generic localhost profile
* **apo** - a user on the APO machines
* **lco** - a user on the LCO machines
* **manga** - a user on the Utah manga machine
* **sdssadmin** - a user on the Utah sdssadmin machine
* **lore** - a user on the Utah lore machine


Connecting to a Database
------------------------

There are two database connections, ``SQLADatabaseConnection`` and ``PeeWeeDatabaseConnection``, one for each mapping library. Each database connection has two keyword arguments: a user/machine profile, a database name.  The connection will automatically attempt to connect to the specified database with the profile unless the ``autoconnect`` keyword is set to `False`.
::

    # load a database connection with the Utah manga machine profile and connect to the manga database
    from sdssdb.connection import SQLADatabaseConnection
    db = SQLADatabaseConnection('manga', dbname='manga')

You can switch to other databases on using the same profile.
::

    # switch/connect to separate database
    db.connect('other-mangadb')

You can change the profile of the user or machine you are connecting to
::

    # switch to the sdssadmin machine profile and connect to the sdss5 database
    db.set_profile('sdssadmin')
    db.connect('sdss5db')

You can connect to a database by manually specifying parameters as well.
::

    # manually connect via parameters
    db.connect_from_parameters('sdss5db', user='sdss', host='sdssadmin', port=5432)



SQLAlchemy Specifics
^^^^^^^^^^^^^^^^^^^^

The database handling with SQLAlchemy is mostly the same as with PeeWee.  The main difference is the need to create a database session before connecting and querying
::

    # connecting to the manga database
    from sdssdb.sqlalchemy.mangadb import db, datadb

    # start a session
    session = db.Session()

    # write a query
    cube = session.query(datadb.Cube).first()

If you connect to a different database, you must recreate the database session.
::

    # connect to a separate database
    db.connect('other-mangadb')
    session = db.Session()


Prepared Database Connections
-----------------------------

Some databases have been prepared ahead of time to facilitiate immediate querying.  We can access both the models and a connection for a database by importing them both together.   Let's access and query from catalogdb on the sdss5 database on the Utah sdssadmin machine.
::

    # import the db and models for catalogdb
    from sdssdb.sqlalchemy.sdss5db import db, catalogdb

    # set the profile to the sdssadmin machine and reconnect to the database
    db.set_profile('sdssadmin')
    db.connect('sdss5db')

    # create a session
    session = db.Session()

    # get the first entry in the Gaia source catalog
    gaia = session.query(catalogdb.GaiaSource).first()


Adding your own database connection
-----------------------------------

The package hiearchy is organized as:

* mapping library
    * database name
        * schema modelclass .py file


