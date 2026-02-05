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

## Installation

To install `sdssdb` for regular usage, from PyPi,

```bash
pip install sdssdb
```

### Developer Install

```bash
git clone https://github.com/sdss/sdssdb
cd sdssdb
uv sync --python 3.12 --locked
```

This only installs the dependencies needed to run the code. For development, you can install extra dependencies needed for building docs or running tests with the `--all-groups` keyword.
```
uv sync --all-groups --python=3.12 --locked
```

If you don't have `uv` installed, you can install directly with pip:
```
git clone https://github.com/sdss/sdssdb
cd sdssdb
pip install -e .
```

### Building Sphinx Docs locally

Within the `sdssdb` directory, run
```
sdss docs.build
```
To have the docs autobuild and watch for changes, use `nox`.  To build and run the local docs server, run
```
nox
```
This will start a local docs server at http://localhost:53992/



## How to use

```python

    >>> from sdssdb.peewee.sdss5db import catalogdb
    >>> targets = catalogdb.GaiaDR2Source.select().where(catalogdb.GaiaDR2Source.phot_g_mean_mag < 15)
```
