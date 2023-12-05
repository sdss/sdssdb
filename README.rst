sdssdb
======

|python| |docs|

`SDSS <https://sdss.org>`__ product for database management.

**sdssdb is in active development. Although the code is stable and can be used for production, the implementation of existing features may be changed without previous notice. This will change when we reach version 1.0.0.**

Useful links
------------

- GitHub: https://github.com/sdss/sdssdb
- Documentation: https://sdssdb.readthedocs.org
- Issues: https://github.com/sdss/sdssdb/issues

How to use
----------
::

    >>> from sdssdb.peewee.sdss5db import catalogdb
    >>> targets = catalogdb.GaiaDR2Source.select().where(catalogdb.GaiaDR2Source.phot_g_mean_mag < 15)


.. |python| image:: https://img.shields.io/badge/python-3.6%2B-green.svg
    :alt: Requires Python 3.6+
    :scale: 100%

.. |docs| image:: https://readthedocs.org/projects/sdssdb/badge/?version=latest
    :alt: Documentation Status
    :scale: 100%
    :target: https://sdssdb.readthedocs.io/en/latest/?badge=latest

.. |Python application| image:: https://github.com/sdss/sdssdb/workflows/Python%20application/badge.svg
