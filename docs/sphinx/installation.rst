
.. _installation:

Installation
============

.. important:: sdssdb is Python 3-only. You need to have Python 3.6 or above to use it.

``sdssdb`` can be installed by simply doing ::

    pip install sdssdb

then you can check that it works by running a python terminal and doing

.. parsed-literal::

    >>> import sdssdb
    >>> sdssdb.__version__
    |sdssdb_version|

This should provide all the libraries that you'll need for basic use of ``sdssdb``. Some functions require libraries such as `astropy <https://www.astropy.org/>`__ or `pandas <https://pandas.pydata.org/>`__. To install all the necessary dependencies you can do ``pip install sdssdb[all]``. If you want to also install the development and documentation tools, do ``pip install sdssdb[all,dev,docs]``.

If you are working from Utah, ``sdssdb`` is installed as a module and you should be able to do ::

    module load sdssdb

and follow the instructions above to be sure it has been loaded. Remember that ``sdssdb`` is Python 3-only so you may need to load the Python 3 module (e.g., ``module switch python python/3.6.3`` or similar). Alternatively you can use `sdss_install <https://github.com/sdss/sdss_install>`__ to checkout a local copy in your unit or local machine ::

    sdss_install --github sdssdb <version>

or for a development version ::

    sdss_install --github sdssdb main

More instructions on how to install and use ``sdss_install`` are available `here <https://wiki.sdss.org/display/knowledge/sdss_install+bootstrap+installation+instructions>`__.
