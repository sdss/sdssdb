# sdssdb

![Versions](https://img.shields.io/badge/python->=3.9-blue)
[![Documentation Status](https://readthedocs.org/projects/sdssdb/badge/?version=latest)](https://sdssdb.readthedocs.io/en/latest/?badge=latest)
[![Test](https://github.com/sdss/sdssdb/actions/workflows/test.yml/badge.svg)](https://github.com/sdss/sdssdb/actions/workflows/test.yml)

[SDSS](https://sdss.org>) product for database management.

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

```console
uv sync --all-groups --python=3.12 --locked
```

If you don't have `uv` installed, you can install directly with pip:

```console
git clone https://github.com/sdss/sdssdb
cd sdssdb
pip install -e .
```

### Building Sphinx Docs locally

Within the `sdssdb` directory, run

```console
sdss docs.build
```

To have the docs autobuild and watch for changes, use `nox`.  To build and run the local docs server, run

```console
nox
```

This will start a local docs server on a random port. You should see something like,

```console
[sphinx-autobuild] Serving on http://127.0.0.1:54429
[sphinx-autobuild] Waiting to detect changes...
```

It should open the site automatically in a new browser window.  If `127.0.0.1:[port]` fails to load, try `localhost:[port]`.


## How to use

```python

    >>> from sdssdb.peewee.sdss5db import catalogdb
    >>> targets = catalogdb.GaiaDR2Source.select().where(catalogdb.GaiaDR2Source.phot_g_mean_mag < 15)
```
