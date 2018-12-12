#!/usr/bin/env python
# encoding: utf-8
"""
dateObs2HA.py

Created by José Sánchez-Gallego on 23 Mar 2014.
Licensed under a 3-clause BSD license.

Revision history:
    23 Mar 2014 J. Sánchez-Gallego
      Initial version

"""

from __future__ import division, print_function

from astropy import coordinates as coo
from astropy import time
from astropy import units as uu
from astropy.units import cds


def convertTai(tai):
    """Convert tai in seconds to an appropriate date time isot format."""

    dateobs = time.Time((tai * cds.s).to(cds.MJD), format='mjd').isot
    return dateobs


def jd2lst(jd, longitude=0.0):

    jd0 = int(jd) + 0.5
    dd0 = jd0 - 2451545.
    dd = jd - 2451545.
    tt = dd / 36525
    hh = (jd - jd0) * 24.

    gmst = 6.697374558 + 0.06570982441908 * dd0 + 1.00273790935 * hh + \
        0.000026 * tt**2
    gmstL = coo.Longitude(gmst * uu.hour)
    lon = coo.Longitude(longitude * uu.degree)
    return coo.Longitude(gmstL + lon)


def dateObs2HA(dateObs, ra, longitude=254.179722):
    """Returns the HA of an observation.

    Parameters
    ----------
    dateObs : str
        An string with the TAI date at start of integration.
    ra : float
        The right ascension, in degrees, of the target.
    longitude : float, optional
        The longitude of the observatory in East degrees from 0. to 360.

    Returns
    -------
    result : float
        The HA, in degrees, of the object at the time of the observation, rescaled
        between -180 to 180 degrees around the meridian.

    Example
    -------
      >> dateObs = '2014-03-23T07:57:28'
      >> ra = 187.654
      >> print(dateObs2HA(dateObs, ra))
      >> 6.62507

    """

    if not isinstance(dateObs, str):
        raise TypeError('dateObs is not a string.')

    dateObs = dateObs.replace('T', ' ')

    dd = time.Time(dateObs, scale='tai', format='iso')

    lst = jd2lst(dd.jd, longitude=longitude)

    ha = coo.Longitude(lst.hour - ra / 15., unit=uu.hour)

    haDeg = ha.degree % 360

    if haDeg > 180.:
        haDeg -= 360

    return(haDeg)
