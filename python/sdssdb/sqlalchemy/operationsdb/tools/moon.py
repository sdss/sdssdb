################################################################################
#
# Moon.py - A Python module that ...
#
# Copyright (C) 2011 Adrian Price-Whelan
#
################################################################################
"""
todo: something to do
"""

__author__ = 'Adrian Price-Whelan <adrn@nyu.edu>'

import datetime
import math
from math import acos, asin, cos, degrees, fabs, log, pi, radians, sin, sqrt

from . import convert, geometry
from .sun import Sun


APOLAT = 32.7797556
APOLONG = 105.8198305


class Moon(object):
    """
    """
    ra = None
    dec = None
    datetimeObj = None

    def __init__(self, datetimeObj=datetime.datetime.now()):
        self.datetimeObj = datetimeObj
        self._set_position()

    def _set_position(self):
        """ ~ a few arcminutes accuracy
        """
        l0 = 318.351648  # mean longitude
        P0 = 36.340410  # mean longitude of perigee
        N0 = 318.510107  # mean longitude of node
        ii = 5.145396  # inclination
        ee = 0.054900  # eccentricity
        aa = 384401  # km, semi-major axis or moon's orbit
        theta0 = 0.5181  # degrees, semiangular size at distance a
        pi0 = 0.9507  # parallax at distance a

        sun = Sun(self.datetimeObj)

        jdJan0 = convert.datetime2jd(
            datetime.datetime(self.datetimeObj.year, 1, 1, hour=0, minute=0, second=0))
        jd = convert.datetime2jd(self.datetimeObj)

        d = jd - jdJan0
        D = (self.datetimeObj.year - 1990) * 365.0 + (self.datetimeObj.year - 1992) / 4 + d + 2

        l = (13.1763966 * D + l0) % 360.0
        C = l - sun.longitude

        moonMeanAnomaly = (l - 0.1114041 * D - P0) % 360.0
        N = (N0 - 0.0529539 * D) % 360.0

        Ev = 1.2739 * math.sin(math.radians(2 * C - moonMeanAnomaly))
        Ae = 0.1858 * math.sin(math.radians(sun.meanAnomaly))
        A3 = 0.37 * math.sin(math.radians(sun.meanAnomaly))

        corrected_moonMeanAnomaly = moonMeanAnomaly + Ev - Ae - A3

        Ec = 6.2886 * math.sin(math.radians(corrected_moonMeanAnomaly))
        A4 = 0.214 * math.sin(math.radians(2.0 * corrected_moonMeanAnomaly))

        lprime = l + Ev + Ec - Ae + A4
        V = 0.6583 * math.sin(math.radians(2.0 * (lprime - sun.longitude)))
        lprimeprime = lprime + V

        Nprime = N - 0.16 * math.sin(math.radians(sun.meanAnomaly))
        y = math.sin(math.radians(lprimeprime - Nprime)) * math.cos(math.radians(ii))
        x = math.cos(math.radians(lprimeprime - Nprime))

        arcTan = math.degrees(math.atan(y / x))

        if y > 0 and x > 0:
            arcTan = arcTan % 90.0
        elif y > 0 and x < 0:
            arcTan = (arcTan % 90.0) + 90.0
        elif y < 0 and x < 0:
            arcTan = (arcTan % 90.0) + 180.0
        elif y < 0 and x > 0:
            arcTan = (arcTan % 90.0) + 270.0

        moonLongitude = arcTan + Nprime
        moonBeta = math.degrees(
            math.asin(math.sin(math.radians(lprimeprime - Nprime)) * math.sin(math.radians(ii))))

        ra, dec = convert.eclipticLatLon2RADec(moonLongitude, moonBeta)

        self.ra = ra
        self.dec = dec

    def illumination(self, datetimeObj=datetime.datetime.now()):
        """
        """
        fraction = 0.0
        return fraction

    def rise(self, datetimeObj=datetime.datetime.now()):
        """
        """
        return datetimeObj

    def set(self, datetimeObj=datetime.datetime.now()):
        """
        """
        return datetimeObj


def lunskybright(alpha, rho, altmoon, alt):
    """ From Skycalc: Evaluates predicted LUNAR part of sky brightness, in
        V magnitudes per square arcsecond, following K. Krisciunas
        and B. E. Schaeffer (1991) PASP 103, 1033.

        alpha = separation of sun and moon as seen from earth, in Degrees
        rho = separation of moon and object, in Degrees
        altmoon = altitude of moon above horizon, in Degrees
        alt = altitude of object above horizon, in Degrees


        The original C code has the following extra parameters, taken here to be constants:
        kzen = zenith extinction coefficient
        moondist = distance to moon, in earth radii

        all are in decimal degrees. """

    if altmoon < 0.0:
        return 0.0

    kzen = 0.19  # Zenith extinction
    moondist = 60.27  # Earth radii

    rho_rad = radians(rho)
    alpha = 180. - alpha
    Zmoon = pi / 2. - radians(altmoon)
    Z = pi / 2. - radians(alt)
    moondist = moondist / (60.27)  # divide by mean distance

    istar = -0.4 * (3.84 + 0.026 * fabs(alpha) + 4.0e-9 * alpha**4.)  # eqn 20
    istar = (10.**istar) / moondist**2

    if fabs(alpha) < 7.:  # crude accounting for opposition effect
        istar = istar * (1.35 - 0.05 * fabs(istar))

    # 35 per cent brighter at full, effect tapering linearly to
    #   zero at 7 degrees away from full. mentioned peripherally in
    #   Krisciunas and Scheafer, p. 1035.
    fofrho = 229087. * (1.06 + cos(rho_rad)**2.)

    if fabs(rho) > 10.:
        fofrho = fofrho + 10.**(6.15 - rho / 40.)  # eqn 21
    elif (fabs(rho) > 0.25):
        fofrho = fofrho + 6.2e7 / rho**2  # eqn 19
    else:
        fofrho = fofrho + 9.9e8  # for 1/4 degree -- radius of moon!

    Xzm = sqrt(1.0 - 0.96 * sin(Zmoon)**2)

    if (Xzm != 0.):
        Xzm = 1. / Xzm
    else:
        Xzm = 10000.

    Xo = sqrt(1.0 - 0.96 * sin(Z)**2)

    if (Xo != 0.):
        Xo = 1. / Xo
    else:
        Xo = 10000.

    Bmoon = fofrho * istar * (10.**(-0.4 * kzen * Xzm)) * (1. - 10.**
                                                           (-0.4 * kzen * Xo))  # nanoLamberts

    if (Bmoon > 0.001):
        return 22.50 - 1.08574 * log(Bmoon / 34.08)  # V mag per sq arcs-eqn 1
    else:
        return 99.


def mjdRADec2skyBright(mjd, ra, dec):
    dtObj = convert.mjd2datetime(mjd)

    moon = Moon(dtObj)
    moonRA, moonDec = moon.ra, moon.dec

    sun = Sun(dtObj)
    sunRA, sunDec = sun.ra, sun.dec

    # alpha
    moonSunAngle = geometry.subtends(sunRA, sunDec, moonRA, moonDec, units='DEGREES')

    # rho
    moonObjectAngle = geometry.subtends(moonRA, moonDec, ra, dec, units='DEGREES')

    moonAlt, moonAz = convert.raDec2AltAz(moonRA, moonDec, APOLAT, APOLONG, dtObj)
    objAlt, objAz = convert.raDec2AltAz(ra, dec, APOLAT, APOLONG, dtObj)

    if moonAlt > 0 and objAlt > 0:
        bright = lunskybright(moonSunAngle.degrees, moonObjectAngle.degrees, moonAlt, objAlt)
    else:
        bright = 0

    return bright


def main():
    moon = Moon(datetime.datetime.now())
    print(moon.ra, moon.dec)


if __name__ == '__main__':
    main()
