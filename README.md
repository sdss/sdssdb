# sdssdb

![Versions](https://img.shields.io/badge/python->=3.6-blue)
[![Documentation Status](https://readthedocs.org/projects/sdssdb/badge/?version=latest)](https://sdssdb.readthedocs.io/en/latest/?badge=latest)
[![Test](https://github.com/sdss/sdssdb/actions/workflows/test.yml/badge.svg)](https://github.com/sdss/sdssdb/actions/workflows/test.yml)

[SDSS](https://sdss.org>) product for database management.

**sdssdb is in active development. Although the code is stable and can be used for production, the implementation of existing features may be changed without previous notice. This will change when we reach version 1.0.0.**

## Useful links

- GitHub: [https://github.com/sdss/sdssdb](https://github.com/sdss/sdssdb)
- Documentation: [https://sdssdb.readthedocs.org](https://sdssdb.readthedocs.org)
- Issues: [https://github.com/sdss/sdssdb/issues](https://github.com/sdss/sdssdb/issues)

## How to use

```python

    >>> from sdssdb.peewee.sdss5db import catalogdb
    >>> targets = catalogdb.GaiaDR2Source.select().where(catalogdb.GaiaDR2Source.phot_g_mean_mag < 15)
```
