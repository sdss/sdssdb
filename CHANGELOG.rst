.. _sdssdb-changelog:

Changelog
=========

This document records the main changes to the ``sdssdb`` code.

* :release:`0.3.2 <2020-03-10>`
* Change ``operations-test`` profile to ``operations`` using the new machine hostname.
* New schema and models for ``sdss5db.targetdb``.

* :release:`0.3.1 <2020-02-24>`
* Added ``archive`` database with ``sas`` schema.
* :bug:`18` Fixed Travis built after migration to using ``setup.cfg``.
* Fix import of ``mangadb`` schema in ``Plate.mangadb_plate``.

* :release:`0.3.0 <2019-09-23>`
* Removed ``TIC v6``.
* Added ``TIC v8``.
* Updated schema for ``mangadb.Plate``.
* `~.DatabaseConnection.connect` now accepts ``user``, ``host``, and ``port`` to override the default profile parameters.
* :feature:`13` Add support for schema ``apogeeqldb`` in ``operationsdb``.
* :feature:`16` Changed the package internals to use ``setup.cfg``.
* :feature:`14` Add support for table ``DR14Q_v4_4`` in ``catalogdb``.
* :feature:`15` New CLI ``file2db`` and associated :ref:`tools <api-utils>` to create and load a table from a file. Also added Numpy adaptors.

* :release:`0.2.2 <2019-07-24>`
* Fixed import of database connections when Peewee or SQLAlchemy are not available.
* Added ``operationsdb`` SQL schemas.
* Improved descriptions in ``setup.py`` and ``README.rst``.
* Update ``PyYAML`` requirement to 5.1 and use explicit loader.
* :release:`0.2.1 <2018-12-14>`
* :bug:`-` Remove ``bin/sdssdb`` from the list of scripts to install. This was making the build process fail.

* :release:`0.2.0 <2018-12-14>`
* Removed some unused files from the template.
* :feature:`7` Added `~sdssdb.utils.create_schema_graph` function to generate schema graphs and use it to auto-generate graphs in the documentation for the supported databases.
* Fixed command line example about how to install with ``sdss_install``.
* Added ``mangadb`` schema for SQLA.
* Use ``tmass_pts_key`` for fk relationship between ``GaiaDR2TmassBestNeighbour`` and ``TwoMassPsc``.
* Use ``pts_key`` for fk relationship between ``TwoMassClean`` and ``TwoMassPsc``.
* Improve model ``__repr__``.

* :release:`0.1.1 <2018-12-10>`
* Set ``python_requires='>=3.6'``.

* :release:`0.1.0 <2018-12-10>`
* Initial version.
* ``DatabaseConnection`` class with Peewee and SQLA subclasses.
* Support for sdss5db, operationsdb (apodb/lcodb), and manga (only in SQLAlchemy).
* Implemented database connection switching in SQLAlchemy.
* Basic documentation.
