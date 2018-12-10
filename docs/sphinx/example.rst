
.. _target-selection-example:

How to use sdssdb for target selection
======================================

One of the tenets of SDSS-V is that target selection needs to be performed and documented in a way that is reproducible. That means that the product of target selection should not be a table of targets but instead an algorithm that, based on some standard inputs, produces the list of targets to observe.

To help with this endeavour we have ``catalogdb`` (part of the ``sdss5db`` database), which contains target catalogues from a variety of sources (SDSS, 2MASS, Gaia) as well as cross-match and helper tables. All target selection should happen *against* ``catalogdb``. Here we present an example of how to accomplish that using ``catalogdb`` and ``sdssdb``.


The Galactic Genesis Survey
---------------------------

The SDSS-V Galactic Genesis Survey aims to better understand Galactic formation by compiling data about the orbit, age, and abundances of stars across the Milky Way. In this case the target selection is quite simple:

    Observe all stars with :math:`H\lesssim 11` and :math:`(G-H)>3.5`

Here we need to use the 2MASS catalogue to get the H magnitudes and Gaia for the H-band magnitudes and astrometric information. Let's see how to accomplish that.

``catalogdb`` provides tables from Gaia DR2 (``GaiaDR2Source``) and 2MASS (``TwoMassPsc``), as well as an already computed best-neighbour relational table. To start with, let's join these tables ::

    >>> from sdssdb.peewee.sdss5db.catalogdb import database, GaiaDR2Source, TwoMassPsc, GaiaDR2TmassBestNeighbour
    >>> gaia_tmass = GaiaDR2Source.select().join(GaiaDR2TmassBestNeighbour).join(TwoMassPsc).limit(100)

The ``limit(100)`` allows us to test the expression without doing the full join, which may take hours. From each one of the Gaia sources we can access the Gaia information but also navigate to the best 2MASS match ::

    >>> g1 = gaia_tmass[0]
    >>> g1.phot_g_mean_mag  # G magnitude
    17.413
    >>> g1.tmass_best_sources[0]
    <TwoMassPsc: 337808783>
    >>> g1.tmass_best_sources[0].h_m  # H magnitude
    15.395

Here ``tmass_best_sources`` uses ``GaiaDR2TmassBestNeighbour`` to return a list of the 2MASS sources associted with the instance of ``GaiaDR2Source``. The list can be empty if there are no matches or even have more than one 2MASS target, depending on how the cross-match was done.

The next step is to add the target selection constraints ::

    >>> selection = GaiaDR2Source.select().join(GaiaDR2TmassBestNeighbour).join(TwoMassPsc).where(TwoMassPsc.h_m < 11).where((GaiaDR2Source.phot_g_mean_mag - TwoMassPsc.h_m) > 3.5).limit(100)

Quite simple! Let's improve things a bit. For both Gaia and 2MASS ``catalogdb`` provides "clean" tables, i.e., subsets of the original tables in which certain targets (e.g., those with bad astrometry, saturated, high proper motion) have been rejected. By joining to those tables we can make sure the resulting target selection also avoids them ::

    >>> selection_clean = GaiaDR2Source.select().join(GaiaDR2Clean).switch(GaiaDR2Source).join(GaiaDR2TmassBestNeighbour).join(TwoMassPsc).join(TwoMassClean).where(TwoMassPsc.h_m < 11).where((GaiaDR2Source.phot_g_mean_mag - TwoMassPsc.h_m) > 3.5)

Note the use of `switch <http://docs.peewee-orm.com/en/latest/peewee/api.html?highlight=switch#ModelSelect.switch>`__ to return the pointer to ``GaiaDR2Source`` before joining again with ``GaiaDR2TmassBestNeighbour``.

What is more, ``TwoMassClean`` has a ``twomassbrightneighbor`` boolean column that indicates if the target has a close, bright neighbour. Since we want to avoid those targets we add a new filter condition ::

    >>> selection_clean_no_bright = selection_clean.where(TwoMassClean.twomassbrightneighbor == False)

Note that we don't need to write the expression again. We can take the previous variable, ``selection_clean``, add the new filter, and store it in another variable.

The ``SELECT`` statement for this query is ``GaiaDR2Source``, which are returned as model class instances. From there we can navigate to all the relevant information, as we did to get ``h_m`` from the 2MASS table. To generate a list of targets to observe we are interested in only a few of the parameters (RA, declination, magnitude). We can select only those values and return the results as a list of tuples ::

    >>> galactic_genesis = GaiaDR2Source.select(
        GaiaDR2Source.source_id,
        TwoMassPsc.designation,
        GaiaDR2Source.ra,
        GaiaDR2Source.dec,
        GaiaDR2Source.phot_g_mean_mag,
        TwoMassPsc.h_m).join(GaiaDR2Clean).switch(GaiaDR2Source).join(GaiaDR2TmassBestNeighbour).join(TwoMassPsc).join(TwoMassClean).where(TwoMassPsc.h_m < 11, (GaiaDR2Source.phot_g_mean_mag - TwoMassPsc.h_m) > 3.5, TwoMassClean.twomassbrightneighbor == False)
    >>> list(galactic_genesis.limit(100).tuples())
    [(1866735487144411648,
      '21002432+3525317 ',
      315.101337448339,
      35.4254665619372,
      9.34731,
      5.224),
     (1866735688994546688,
      '21002769+3528065 ',
      315.115434580443,
      35.4684515624814,
      10.7767,
      7.232),
     (1869736363613931008,
      '20583835+3530225 ',
      314.660649460474,
      35.505858779861,
      14.0828,
      10.521),
     (1869764882197177984,
      '20575860+3551396 ',
      314.494113150012,
      35.8609520692133,
      12.0406,
      8.205),
      ... ]

From a list such as that one it's easy to create a new database table or FITS file with the target selection.


Using SQLAlchemy
----------------

The previous example used the Peewee submodule. The same query can be performed in SQLAlchemy with a very similar syntax. Here is the equivalent of the final query ::

    >>> from sdssdb.sqlalchemy.sdss5db.catalogdb import *
    >>> session = database.Session()
    >>> galactic_genesis = session.query(
            GaiaDR2Source.source_id,
            TwoMassPsc.designation,
            GaiaDR2Source.ra,
            GaiaDR2Source.dec,
            GaiaDR2Source.phot_g_mean_mag,
            TwoMassPsc.h_m).join(GaiaDR2Clean, GaiaDR2TmassBestNeighbour, TwoMassPsc, TwoMassClean).filter(TwoMassPsc.h_m < 11, (GaiaDR2Source.phot_g_mean_mag - TwoMassPsc.h_m) > 3.5, TwoMassClean.twomassbrightneighbor == False)

Note that in SQLAlchemy there is no need to use the ``switch`` method.


Cone searches
-------------

``sdssdb`` provides a simple way of performing elliptical cone searches using `q3c <https://github.com/segasai/q3c>`__. Using the ``galactic_genesis`` query defined above, let's now get the targets within 1.5 degrees of :math:`(200, 40)` degrees ::

    >>> cone = galactic_genesis.where(GaiaDR2Source.cone_search(200, 40, 1.5))
    >>> list(cone)
    [<GaiaDR2Source: 1524783316445526016>,
     <GaiaDR2Source: 1524577913928477568>,
     <GaiaDR2Source: 1524637493714681216>,
     <GaiaDR2Source: 1525140554643949568>]
