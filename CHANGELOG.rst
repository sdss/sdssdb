.. _sdssdb-changelog:

Changelog
=========

This document records the main changes to the ``sdssdb`` code.

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
