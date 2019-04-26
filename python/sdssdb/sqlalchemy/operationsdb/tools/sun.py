################################################################################
#
# Sun.py - A Python module that ...
#
# Copyright (C) 2011 Adrian Price-Whelan
#
################################################################################

"""
todo: something to do
"""

__author__ = 'Adrian Price-Whelan <adrn@nyu.edu>'

import datetime
# Standard library dependencies (e.g. sys, os)
import math

# Internal imports
from . import convert


class Sun(object):
    """
    """

    ra = None
    dec = None
    meanAnomaly = None
    longitude = None

    def __init__(self, datetimeObj=datetime.datetime.now()):
        self._set_position(datetimeObj)

    def _set_position(self, datetimeObj=datetime.datetime.now()):
        """
        """

        jd = convert.datetime2jd(datetimeObj)

        # T is different than epochOffsetT, it is the offset in centuries from 1900 Jan. 0.5
        #	to the epoch we use, 2000 Jan. 1.5 (JD = 2451545.0)
        epoch = 2451545.0
        T = (epoch - 2415020.0) / 36525.0
        epsilon_g = 279.6966778 + 36000.76892*T + 0.0003025*T**2
        pomega_g = 281.2208444 + 1.719175*T + 0.000452778*T**2
        ecc = 0.01675104 - 0.0000418*T - 0.000000126*T**2

        D = jd - epoch
        N = (360.0/365.242191 * D) % 360.0
        Msun = N + epsilon_g - pomega_g
        nu = Msun + 360.0/math.pi * ecc*math.sin(Msun*math.pi/180.0)

        self.meanAnomaly = Msun

        lonSun = nu + pomega_g
        self.longitude = lonSun % 360.0
        latSun = 0.0 # ecliptic!

        ra, dec = convert.eclipticLatLon2RADec(lonSun % 360.0, latSun)
        self.ra = ra
        self.dec = dec

def main():
    theSun = Sun(datetime.datetime(1980, 7, 27))
    print(convert.dec2sex(theSun.ra / 15.0))
    print(convert.dec2sex(theSun.dec))

if __name__ == '__main__':
    main()
