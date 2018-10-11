
.. _intro:

Introduction to sdssdb
===============================

``sdssdb`` provides general utilities and functionality for connecting to all SDSS databases.  For now, ``sdssdb`` supports two Python ORM libraries for mapping between database tables and Python classess:  `Peewee <http://docs.peewee-orm.com/en/latest/>`_ and `SQLAlchemy <https://www.sqlalchemy.org/>`_.  The package hiearchc

is organized from the top level into directories **mapping library/database_name**.  Each ORM library directory contains individual directories for each database, with individual schema model files contained in

Connecting to a Database
------------------------

By default, databases will always attempt to automatically connect

With Parameters
^^^^^^^^^^^^^^^


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




SQLAlchemy
----------

Using ``sdssdb`` with SQLAlchemy has one.

::

    # connecting to the manga database
    from sdssdb.sqlalchemy.mangadb import db, datadb

    session = db.Session()

    cube = session.query(datadb.Cube).first()

Accessing catalogdb from the sdss5 database on the Utah sdssadmin machine.

::

    # connecting to sdss5db on the sdssadmin machine
    from sdssdb.sqlalchemy.sdss5db import db, catalogdb

    db.set_profile('sdssadmin')
    db.connect('sdss5db')

    session = db.Session()

    # get the first entry in the Gaia Clean source catalog
    gaiaclean = session.query(catalogdb.GaiaClean).first()




