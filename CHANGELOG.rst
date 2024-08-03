.. _sdssdb-changelog:

Changelog
=========

This document records the main changes to the ``sdssdb`` code.

* :release:`0.12.3 <2024-08-02>`
* One more attempt at fixing the various issues with reflection. Reloading the fields each time a table was not found worked well for ``operations`` but not so much for ``pipelines`` because so many tables are missing. This time, we will only refresh the fields if the table is not found in the schema metadata *and* it exists in the database.
* Fixed column names in ``SDSS_ID_To_Catalog`` models (#260).
* Adds new column to ``vizdb.sdssid_to_pipes`` view (#259).

* :release:`0.12.2 <2024-07-29>`
* Use Markdown for the README file. The old README.rst was giving trouble when packaging the app.
* Fix issues with the caching of the schema during reflection. Added a ``force`` option to ``reflection_options`` to force the schema information to be refreshed. Additionally, if the table does not exist in the schema metadata, the metadata will be refreshed.

* :release:`0.12.1 <2024-07-19>`
* add cadence dark_flexible_3x1.csv
* fixing removed column from astra source table
* Fix table name in peewee model for catalog_from_sdss_speclite_dr19p
* Add method ``get_database_uri()`` to ``DatabaseConnection``.

* :release:`0.12.0 <2024-06-28>`
* Updated ``sdss_id_to_catalog`` view models to use double underscore separating table name from primary key.
* Very significantly speed up the reflection of the database by caching the schema metadata.
* Add ``targetdb`` ``targeting_generation`` and ``targeting_generation_to_target`` tables and models.
* Allow passing additional connection parameters to ``set_profile()`` which will override the profile defaults.

* :release:`0.11.4 <2024-04-30>`
* Add columns ``too_metadata.last_modified_date``, ``too_target.observe_from_mjd``, and ``too_target.added_date``.
* Rename column ``too_target.expiration_date`` to ``too_target.observe_until_mjd``.

* :release:`0.11.3 <2024-04-28>`
* Add columns ``fiber_type`` and ``assigned`` to ``opsdb.assignment_to_focal``.

* :release:`0.11.2 <2024-04-24>`
* Add column ``can_offset`` to ``too_metadata``.

* :release:`0.11.1 <2024-04-24>`
* Fix typo in `CatalogToToO_Target` model name.

* :release:`0.11.0 <2024-04-24>`
* Explicitly define ``CatalogToXXX`` models instead of loading them dynamically.

* :release:`0.10.0 <2024-04-23>`
* Add ``catalogdb.too_target`` and ``catalogdb.too_metadata`` tables and models.
* Add new cadences.
* Add ``disabled`` flag to tile.

* :release:`0.9.0 <2024-03-08>`
* Add new schema for ``astra`` to ``sdss5db``.
* Added new peewee and sqlalchemy ORMs for ``astra`` schema.
* Added legacy survey sql schema files

* :release:`0.8.3 <2023-12-11>`
* Add column ``macro_id`` to ``opsdb.overhead``.
* Fix hardcoded schema in SQLAlchemy ``opsdb.overhead`` model.

* :release:`0.8.2 <2023-12-05>`
* Change ``DATE`` to ``TIMESTAMPTZ`` for the datetime columns in ``opsdb.overhead`` and models. Fixed the SQLAlchemy ``Overhead`` model which was in ``targetdb`` by mistake.

* :release:`0.8.1 <2023-12-05>`
* Added ``opsdb.overhead`` table and models for Peewee and SQLAlchemy.
* Updated GitHub workflows.

* :release:`0.8.0 <2023-10-23>`
* Added new schema for ``vizdb`` schema in ``sdss5db``.
* Added new peewee and sqlalchemy ORMs for ``vizdb`` schema.

* :release:`0.7.0 <2023-09-28>`
* Added complete SQLAlchemy models for ``sdss5db``.
* Added files to create ``catalogdb.lvm_magnitude``.
* Added ``allStar-dr17-synspec_rev1`` table and models.

* :release:`0.6.6 <2023-08-17>`
* Added the option to disable database autoconnection by setting ``sdssdb.autoconnect = False`` or an environment variable ``SDSSDB_AUTOCONNECT=false``.

* :release:`0.6.5 <2023-08-09>`
* Hotfix for a bug introduced in 0.6.4 that would prevent a connection to fail without errors when a profile was not present on import.

* :release:`0.6.4 <2023-08-08>`
* Add ``catalogdb.rave_dr6_xgaiae3`` (Gaia DR3 cross-match for RAVE DR6).
* Add LVM schema and model classes
* Updates and fixes for cadences and obsmodes
* Add 'pipelines' profile
* Implement fine-grain field priorities

* :release:`0.6.2 <2023-02-12>`
* Rename ``SagittaEDR3`` to ``Sagitta_EDR3``.
* Update to allow for v1.0.6 of eROSITA superset catalogues.
* Speed up loading of reflected tables by caching results except if the table is not found in the schema.

* :release:`0.6.1 <2023-01-19>`
* Don't count observed designs in ``queue.rm``.
* Add ``assignmentStatus`` table to targetdb.
* Update auto schemas.

* :release:`0.6.0 <2022-12-29>`
* Many additions to ``sdss5db``, mainly related to target selection v1. See the `commit list <https://github.com/sdss/sdssdb/compare/0.5.5...0.6.0>`__ for details.

* :release:`0.5.5 <2022-09-11>`
* :feature:`127` Add ``Design.field`` attribute.
* Use full hostname for sdss5-db at APO.
* Fixes to opsdb, targetdb.
* Update default Cadences to v2.
* Fix issue with ``get_database_columns``.
* Multiple additions to ``catalogdb`` for v1.

* :release:`0.5.4 <2022-07-15>`
* Add ``targetdb.design_to_field`` table
* Improve offset support
* New catalogs: gaia DR3

* :release:`0.5.3 <2022-05-19>`
* Support opsdb_apo or opsdb_lco depending on OBSERVATORY environment variable
* New catalogs: gaia eDR3, skies_v2, legacy_survey_dr10a

* :release:`0.5.2 <2022-04-01>`
* Add assignment_hash to ``targetdb.design``
* Add more magnitudes to targetdb
* Add ``manual`` column to ``opsdb.design_to_status``

* :release:`0.5.0 <2021-11-16>`
* Add ``targetdb.field_reservation`` and associated peewee util
* Add ``targetdb.design_mode_value`` table
* Bug fixes found during commissioning

* :release:`0.4.13 <2021-11-16>`
* Add ``mugatu_version``, and ``run_on`` to ``targetdb.design``
* Minor bug fixes

* :release:`0.4.12 <2021-11-16>`
* Add ``skies_v2``, ``bailer_jones_dr3``, ``sagitta_edr3``, and APOGEE DR17 tables.
* Several major modifications to ``targetdb`` and ``opsdb`` schemas.

* :release:`0.4.11 <2021-10-12>`
* Add cadences and engineering design modes.
* Fix a bug with the documentation not building with Sphinx 4.
* Add cadence generator scripts, cfg files, and notebook for merging.
* Do not cache database field. This was causing issues when reflection was used multiple times in the same routine.
* Add targetdb ``data_table``.
* Add ``lco5`` profile for LCO.

* :release:`0.4.10 <2021-08-25>`
* Add priority to field table to ``opsdb``
* Add ``apo5`` profile.
* Add ``apql`` tables to ``opsdb``.
* Add ``default_lambda_eff`` to ``targetdb.instrument``.
* Add ``run_on`` field to ``targetdb.carton``.
* When calling `.DatabaseConnection.become`, ignore the password stored in the DSN parameters since the user/admin passwords will likely be different.

* :release:`0.4.9 <2021-04-19>`
* Add delta_ra, delta_dec and, inertial for ``CartonToTarget``.
* Add ``tycid`` column to ``Tycho2`` to prevent import errors.
* ``DatabaseConnection.become_admin`` and ``become_user`` now accept a user parameter. If not provided, defaults to the old behaviour (using the ``admin`` and ``user`` fields in the profile).

* :release:`0.4.8 <2021-03-05>`
* Fix name collision in previous version by changing the column_name of TIC_v8 foreign key.

* :release:`0.4.7 <2021-03-05>`
* Multiple new tables for ``sdss5db.catalogdb`` related to SDSS-V target selection v0.5.
* Modifications to ``apogeedb`` dump.
* :bug:`-` Use refection only if ``use_reflection=True``.
* :feature:`66` Update targetdb schema with changes to cadence, carton_to_target, and others.
* Change default FK in TIC_v8 for ``Tycho2``.

* :release:`0.4.6 <2020-11-12>`
* :feature:`43` Add a database registry
* Initial version of the ``sdss5db.opsdb`` schema.
* Added field ``value`` to ``carton_to_target``.
* Fix reflection for ``catalogdb.skies_v1``.
* Schema files for multiple ``catalogdb`` tables in preparation for SDSS-V target selection v0.5.
* Initial schema files for ``opsdb``.

* :release:`0.4.5 <2020-07-12>`
* Add ``ForeignKeyField`` from ``CatalogToSDSS_DR13_PhotoObj_Primary`` directly to ``SDSS_DR13_PhotoObj``.
* Add single precision float type to the list of Peewee arrays during reflection.

* :release:`0.4.4 <2020-07-07>`
* Add ``ForeignKeyField`` to ``TIC_v8`` where for all models in ``catalogdb`` connected to Gaia.
* Use ``autorollback=True`` by default in `.PeeweeDatabaseConnection`.
* Ensure reflection assigns double type arrays.
* Clear metadata on reconnect.
* Add ``lite`` materialized views to ``catalogdb``.
* Add ``catalogdb.gaia_assas_sn_cepheids`` table.
* Move deprecated tables to ``deprecated`` schema in ``sdss5db``.
* Add DR16 versions of APOGEE tables.

* :release:`0.4.3 <2020-06-05>`
* Add schema for ``gaia_dr2_ruwe``.
* Rename ``targetdb.program`` to ``carton``, and ``survey`` to ``mapper``. Add ``priority`` field in ``carton_to_target``.
* Add ``z`` column to ``targetdb.magnitude``.
* Add ``position_angle`` column to ``targetdb.field``.

* :release:`0.4.2 <2020-05-29>`
* Add ``targetdb.version.tag`` column.
* Use schema-qualified keys for ``database.models``.
* Modify ``targetdb`` schema so that ``magnitude`` references ``target`` instead of the other way around.
* Allow to use `.ReflectMeta.reflect` manually even if ``use_reflection`` has not been set in ``Meta``.

* :release:`0.4.1 <2020-05-18>`
* Rename ``targetdb.version.label`` and ``catalogdb.version.version`` to ``plan``.

* :release:`0.4.0 <2020-05-15>`
* Test suite only runs where existing local databases found.  Optionally run only ``peewee`` or ``sqlalchemy`` tests.
* Adds ability to generate fake data based on real database models for tests.
* Adds ability to test against real or fake databases.
* Write tests either for ``peewee`` or ``sqlalchemy`` databases.
* :feature:`-` New framework for writing tests against databases.
* Many changes to the ``catalogdb`` schema files and PeeWee implementation to match the contents to SDSS-V v0 target selection.
* :feature:`-` A new `.ReflectMeta` metaclass that provides :ref:`reflection for Peewee models <reflect-peewee>` (with some caveats).
* Reimplementation of most catalogdb PeeWee model classes for catalogdb using reflection.
* Changes to the schema display tools.
* New tools for table `ingestion <.ingest>`.
* New tools for database `maintenance/internals <.internals>`.
* Add `.PeeweeDatabaseConnection.get_model` to retrieve the model for a given table.
* :bug:`28` Temporarily remove SQLAlchemy implementation of ``sds5db`` since it's not maintained. We may reintroduce it later once the schema is stable.
* Use ``host=localhost`` when a profile is being used on its own domain.
* :support:`32` Assume that both SQLAlchemy and Peewee will be installed and simplify code.

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
* :feature:`7` Added `~sdssdb.utils.schemadisplay.create_schema_graph` function to generate schema graphs and use it to auto-generate graphs in the documentation for the supported databases.
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
