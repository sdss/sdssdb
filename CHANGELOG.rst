.. _sdssdb-changelog:

Changelog
=========

This document records the main changes to the ``sdssdb`` code.

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
