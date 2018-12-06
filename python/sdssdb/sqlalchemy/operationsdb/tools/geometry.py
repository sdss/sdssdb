################################################################################
#
# Geometry.py - A Python module with convenience classes for dealing with
#               geometric objects
#
# Copyright (C) 2011 Adrian Price-Whelan
#
################################################################################

"""
todo:
"""

__author__ = 'Adrian Price-Whelan <adrn@nyu.edu>'
__all__ = ['Angle', 'subtends']

import copy
import math
from math import acos, cos, degrees, radians, sin

from . import astrodatetime, convert


VALIDUNITS = ['radians', 'degrees', 'hours']


class Angle(object):
    """ This class represents an Angle. Set the bounds by specifying angleObject.bounds = (lower, upper) """

    _customBounds = False

    @staticmethod
    def fromDegrees(val): return Angle(degrees=val)

    @staticmethod
    def fromHours(val): return Angle(hours=val)

    @staticmethod
    def fromRadians(val): return Angle(radians=val)

    @staticmethod
    def fromDatetime(dt): return Angle(hours=convert.datetime2decimalTime(dt))

    @staticmethod
    def fromUnits(val, units):
        if units.lower() == 'degrees':
            return Angle(degrees=val)
        elif units.lower() == 'hours':
            return Angle(hours=val)
        elif units.lower() == 'radians':
            return Angle(radians=val)
        else:
            raise ValueError('Invalid units!')

    def __init__(self, degrees=None, hours=None, radians=None):
        """ Accepts an angle value in degrees. The input parameters degrees
            and hours both accept either a string like '15:23:14.231,' or a
            decimal representation of the value, e.g. 15.387.

        Parameters
        ----------
        degrees : float, string, int
        hours : float, string, int
        radians : float, int

        """

        if degrees is not None:
            self._degrees(degrees)
            self.units = 'degrees'
        elif hours is not None:
            self._hours(hours)
            self.units = 'hours'
        elif radians is not None:
            self._radians(radians)
            self.units = 'radians'
        else:
            raise TypeError(
                "When creating an Angle object, you must specify 'degrees', 'hours', or 'radians' as an input parameter.")

    # These are hacks so I can set the __repr__ and __str__ of the object depending
    #   on the primary units of the Angle
    def __str__(self):
        return self._str()

    def __repr__(self):
        return self._repr()

    def _str(self):
        if self.units == 'degrees':
            return self.degrees__str__()
        elif self.units == 'radians':
            return self.radians__str__()
        else:
            return self.hours__str__()

    def _repr(self):
        if self.units == 'degrees':
            return self.degrees__repr__()
        elif self.units == 'radians':
            return self.radians__repr__()
        else:
            return self.hours__repr__()

    def _degrees(self, deg):
        """
        """
        if isinstance(deg, ''.__class__):
            self.degrees = convert.sex2dec(*convert.parseDec(deg))
        else:
            self.degrees = deg

        self.hours = self.degrees / 15.
        self.radians = math.radians(self.degrees)

    def _hours(self, hr):
        """
        """
        if isinstance(hr, ''.__class__):
            self.hours = convert.sex2dec(*convert.parseRA(hr))
        else:
            self.hours = hr

        self.degrees = self.hours * 15.
        self.radians = math.radians(self.degrees)

    def _radians(self, rad):
        self.radians = rad
        self.degrees = math.degrees(self.radians)
        self.hours = self.degrees / 15.

    def degrees__str__(self):
        return convert.dec2stringTime(self.degrees) + ' degrees'

    def hours__str__(self):
        return convert.dec2stringTime(self.hours) + ' hours'

    def radians__str__(self):
        return str(self.radians) + ' radians'

    def degrees__repr__(self): return '< Angle: %f degrees -- %s >' % (self.degrees, str(self))

    def hours__repr__(self): return '< Angle: %f hours -- %s >' % (self.hours, str(self))

    def radians__repr__(self): return '< Angle: %f radians >' % self.radians

    def _setUnits(self, units):
        if units == 'degrees':
            if not self._customBounds:
                self._bounds = (-180., 180.)
            else:
                print('You specified custom bounds for this object. If you are changing units, you may need to respecify those bounds in the new units.')
            self._str = self.degrees__str__
            self._repr = self.degrees__repr__
            self._value = self.degrees
        elif units == 'hours':
            if not self._customBounds:
                self._bounds = (0., 24.)
            else:
                print('You specified custom bounds for this object. If you are changing units, you may need to respecify those bounds in the new units.')
            self._str = self.hours__str__
            self._repr = self.hours__repr__
            self._value = self.hours
        elif units == 'radians':
            if not self._customBounds:
                self._bounds = (0., 2 * math.pi)
            else:
                print('You specified custom bounds for this object. If you are changing units, you may need to respecify those bounds in the new units.')
            self._str = self.radians__str__
            self._repr = self.radians__repr__
            self._value = self.radians
        else:
            raise ValueError('Invalid units!')

    @property
    def units(self): return self._units

    @units.setter
    def units(self, val):
        lowVal = val.lower()
        if lowVal not in VALIDUNITS:
            raise ValueError('Specified units (%s) are not supported by this class!' % val)

        self._units = lowVal
        self._setUnits(self._units)

    @property
    def bounds(self):
        return self._bounds

    @bounds.setter
    def bounds(self, val):
        try:
            tupVal = tuple(val)
        except ValueError:
            print('Invalid bounds.')
            raise

        if len(tupVal) != 2:
            raise ValueError(
                'Invalid tuple. You have to the lower and upper bounds -- you specified %d numbers!' %
                len(tupVal))
        self._customBounds = True
        self._bounds = tupVal

    @property
    def normalized(self):
        """ Normalize the angle to be within the set bounds (self.bounds), and
            return a new object with the normalized angle.
        """
        if self._value < self.bounds[0]:
            return Angle.fromUnits(self._value % self.bounds[1], self.units)
        elif self._value >= self.bounds[1]:
            if self.bounds[0] == 0:
                return Angle.fromUnits(self._value % self.bounds[1], self.units)
            else:
                return Angle.fromUnits(self._value % self.bounds[1], self.units)
        else:
            return copy.copy(self)

    def normalize(self):
        """ Normalize the angle to be within the set bounds (self.bounds), and
            replace the internal values.
        """
        if self._value < self.bounds[0]:
            self._value = self._value % self.bounds[1]
            if self.units == 'degrees':
                self._degrees(self._value)
            elif self.units == 'radians':
                self._radians(self._value)
            elif self.units == 'hours':
                self._hours(self._value)

        elif self._value >= self.bounds[1]:
            if self.bounds[0] == 0:
                self._value = self._value % self.bounds[1]
            else:
                self._value = self._value % self.bounds[0]

            if self.units == 'degrees':
                self._degrees(self._value)
            elif self.units == 'radians':
                self._radians(self._value)
            elif self.units == 'hours':
                self._hours(self._value)
        else:
            pass

    # self._value is defined by setting the 'units' attribute. By default, it is
    #   set to whatever units you specified when you created the object.
    def __float__(self): return self._value

    def __int__(self): return int(self._value)

    def __radians__(self): return self.radians

    def __degrees__(self): return self.degrees

    # Addition
    def __add__(self, other, option='left'):
        selfCopy = copy.copy(self)
        otherCopy = copy.copy(other)

        if not isinstance(otherCopy, Angle):
            raise TypeError("Can't add an Angle object and a %s!" % otherCopy.__class__)
        if option == 'left':
            selfCopy.units = otherCopy.units
            return Angle.fromUnits(selfCopy._value + otherCopy._value, selfCopy.units)
        elif option == 'right':
            otherCopy.units = selfCopy.units
            return Angle.fromUnits(otherCopy._value + selfCopy._value, otherCopy.units)

    def __radd__(self, other): return self.__add__(other, 'right')

    # Subtraction
    def __sub__(self, other, option='left'):
        if not isinstance(other, Angle):
            raise TypeError("Can't subtract an Angle object and a %s!" % other.__class__)

        selfCopy = copy.copy(self)
        otherCopy = copy.copy(other)

        if option == 'left':
            selfCopy.units = otherCopy.units
            return Angle.fromUnits(selfCopy._value - otherCopy._value, selfCopy.units)
        elif option == 'right':
            otherCopy.units = selfCopy.units
            return Angle.fromUnits(otherCopy._value - selfCopy._value, otherCopy.units)

    def __rsub__(self, other): return self.__sub__(other, 'right')

    # Multiplication
    def __mul__(self, other, option='left'):
        if isinstance(other, Angle):
            raise TypeError('Multiplication is not supported between two Angle objects!')
        else:
            return Angle.fromUnits(self.degrees * other, 'degrees')

    def __rmul__(self, other): return self.__mul__(other, option='right')

    # Division
    def __div__(self, other):
        if isinstance(other, Angle):
            raise TypeError('Division is not supported between two Angle objects!')
        else:
            return Angle.fromUnits(self.degrees / other, 'degrees')

    def __rdiv__(self, other):
        if isinstance(other, Angle):
            raise TypeError('Division is not supported between two Angle objects!')
        else:
            return Angle.fromUnits(other / self.degrees, 'degrees')

    def __truediv__(self, other):
        if isinstance(other, Angle):
            raise TypeError('Division is not supported between two Angle objects!')
        else:
            return Angle.fromUnits(self.degrees / other, 'degrees')

    def __rtruediv__(self, other):
        if isinstance(other, Angle):
            raise TypeError('Division is not supported between two Angle objects!')
        else:
            return Angle.fromUnits(other / self.degrees, 'degrees')

    def __neg__(self):
        return Angle.fromUnits(-self.degrees, 'degrees')


class RA(Angle):
    """ Represents a J2000 Right Ascension """

    @staticmethod
    def fromDegrees(val): return RA(degrees=val)

    @staticmethod
    def fromHours(val): return RA(hours=val)

    @staticmethod
    def fromRadians(val): return RA(radians=val)

    @staticmethod
    def fromDatetime(dt): return RA(hours=convert.datetime2decimalTime(dt))

    @staticmethod
    def fromUnits(val, units):
        if units.lower() == 'degrees':
            return RA(degrees=val)
        elif units.lower() == 'hours':
            return RA(hours=val)
        elif units.lower() == 'radians':
            return RA(radians=val)
        else:
            raise ValueError('Invalid units!')

    def __init__(self, **kwargs):
        Angle.__init__(self, **kwargs)
        if 'degrees' in kwargs:
            self.bounds = (0, 360.)
        elif 'radians' in kwargs:
            self.bounds = (0, 2. * math.pi)
        elif 'hours' in kwargs:
            self.bounds = (0, 24.)

    def ha(self, lst, units='hours'):
        """ Given a Local Sidereal Time (LST), calculate the hour angle for this RA

        Parameters
        ----------
        lst : float, string, Angle
        units : string

        Returns
        -------
            Angle

        Notes
        -----
            - if lst is *not* an Angle object, you can specify the units by passing a 'units'
                parameter into the call
            - 'units' can be radians, degrees, or hours
            - this function always returns an Angle object
        """

        if not isinstance(lst, Angle):
            lst = Angle.fromUnits(lst, units)

        return lst - self

    def lst(self, ha, units='degrees'):
        """ Given an Hour Angle, calculate the Local Sidereal Time (LST) for this RA

        Parameters
        ----------
        ha : float, string, Angle
        units : string

        Returns
        -------
            Angle

        Notes
        -----
            - if ha is *not* an Angle object, you can specify the units by passing a 'units'
                parameter into the call
            - 'units' can be radians, degrees, or hours
            - this function always returns an Angle object
        """
        if not isinstance(ha, Angle):
            ha = Angle.fromUnits(ha, units)

        return ha + self


class Dec(Angle):
    """ Represents a J2000 Declination """

    @staticmethod
    def fromDegrees(val): return Dec(degrees=val)

    @staticmethod
    def fromHours(val): return Dec(hours=val)

    @staticmethod
    def fromRadians(val): return Dec(radians=val)

    @staticmethod
    def fromDatetime(dt): return Dec(hours=convert.datetime2decimalTime(dt))

    @staticmethod
    def fromUnits(val, units):
        if units.lower() == 'degrees':
            return Dec(degrees=val)
        elif units.lower() == 'hours':
            return Dec(hours=val)
        elif units.lower() == 'radians':
            return Dec(radians=val)
        else:
            raise ValueError('Invalid units!')

    def __init__(self, **kwargs):
        Angle.__init__(self, **kwargs)
        if 'degrees' in kwargs:
            self.bounds = (-90, 90.)
        elif 'radians' in kwargs:
            self.bounds = (-math.pi / 2., math.pi / 2.)
        elif 'hours' in kwargs:
            self.bounds = (-6, 6)


class CoordinateSystem(object):
    """ A generic coordinate system class. Support n > 0 dimensions. This class is an 'abtract' class,
        and should really only be used in the below subclasses.
    """

    def __init__(self, *args):
        if len(args) == 0:
            raise ValueError('You must specify at least one coordinate!')

        self.coordinates = []
        for angle in args:
            if not isinstance(angle, Angle):
                raise ValueError('Input not a geometry.Angle() object!')
            self.coordinates.append(angle)


class EquatorialCoordinates(CoordinateSystem):
    """ Represents an RA, Dec[, z | physical distance] coordinate system. """

    def __init__(self, ra, dec, **kwargs):
        """ A few notes:
            - if the ra/dec specified are not geometry.Angle() objects, they are
                assumed to be in units degrees, and converted to Angle() objects.
            - if you specify distance=blah, corresponding to a physical distance
                to the object, you must also specify 'distanceUnits' to be pc, kpc,
                mpc, ly, m, or km.

        """

        if 'z' in kwargs:
            self.z = float(kwargs['z'])
            self.distance = None
        elif 'redshift' in kwargs:
            self.z = float(kwargs['redshift'])
            self.distance = None
        elif 'distance' in kwargs:
            if 'distanceUnits' not in kwargs:
                raise ValueError(
                    "If you specify 'distance', you must also specify 'distanceUnits' to be one of:\npc, kpc, mpc, ly, m, or km.")

        if not isinstance(ra, RA):
            self.ra = Angle.fromDegrees(ra)
        else:
            self.ra = ra

        if not isinstance(ra, RA):
            # If dec is not an RA object
            if isinstance(ra, Angle):
                # If it is an Angle object, preserve units
                self.ra = RA.fromDegrees(ra.degrees)
            else:
                # Otherwise, assume units = degrees
                self.ra = RA.fromDegrees(ra)
        else:
            self.ra = ra

        if not isinstance(dec, Dec):
            # If dec is not a Dec object
            if isinstance(dec, Angle):
                # If it is an Angle object, preserve units
                self.dec = Dec.fromDegrees(dec.degrees)
            else:
                # Otherwise, assume units = degrees
                self.dec = Dec.fromDegrees(dec)
        else:
            self.dec = dec

    def subtends(self, other):
        """ Calculate the angle subtended by 2 coordinates on a sphere

        Parameters
        ----------
        other : EquatorialCoordinates

        Returns
        -------
            Angle

        """
        if not isinstance(other, EquatorialCoordinates):
            raise ValueError(
                "You must pass another 'EquatorialCoordinates' into this function to calculate the angle subtended.")

        x1 = cos(self.ra.radians) * cos(self.dec.radians)
        y1 = sin(self.ra.radians) * cos(self.dec.radians)
        z1 = sin(self.dec.radians)

        x2 = cos(other.ra.radians) * cos(other.dec.radians)
        y2 = sin(other.ra.radians) * cos(other.dec.radians)
        z2 = sin(other.dec.radians)

        angle = Angle.fromRadians(acos(x1 * x2 + y1 * y2 + z1 * z2))
        angle.units = 'degrees'
        return angle


def subtends(a1, b1, a2, b2, units='radians'):
    """ Calculate the angle subtended by 2 positions on a sphere """

    if units.lower() == 'degrees':
        a1 = radians(a1)
        b1 = radians(b1)
        a2 = radians(a2)
        b2 = radians(b2)

    x1 = cos(a1) * cos(b1)
    y1 = sin(a1) * cos(b1)
    z1 = sin(b1)

    x2 = cos(a2) * cos(b2)
    y2 = sin(a2) * cos(b2)
    z2 = sin(b2)

    theta = Angle.fromDegrees(degrees(acos(x1 * x2 + y1 * y2 + z1 * z2)))
    return theta  # Returns an angle object


if __name__ == '__main__':
    # do tests..

    # Angle
    a = Angle.fromDegrees()
    b = Angle.fromRadians()
    c = Angle.fromHours()

    # RA
    ra = RA.fromHours(14.54321)
    lst = Angle.fromHours('11:41:23.1341')
    ha = ra.ha(lst)
    lst2 = ra.lst(ha)

    assert lst.degrees == lst2.degrees


"""
# Standard library dependencies (e.g. sys, os)
from math import radians, degrees, pi, fabs, cos, acos, sin

import convert

class Angle(object):
    @property
    def deg(self):
        return self._deg

    @deg.setter
    def deg(self, angle):
        if isinstance(angle, Angle):
            angle = angle.deg
        self._deg = float(angle)
        self._rad = float(radians(self._deg))
        self._hours = float(self._deg / 15.0)
        self.hour, self.minute, self.second = convert.dec2sex(self._hours)
        self._hms = "%02d:%02d:%02.2f" % (self.hour, self.minute, self.second)

    @property
    def rad(self):
        return self._rad

    @rad.setter
    def rad(self, angle):
        if isinstance(angle, Angle):
            angle = angle.rad
        self._rad = float(angle)
        self._deg = float(degrees(self._rad))
        self._hours = float(self._deg / 15.0)
        self.hour, self.minute, self.second = convert.dec2sex(self._hours)
        self._hms = "%02d:%02d:%02.2f" % (self.hour, self.minute, self.second)

    @property
    def hours(self):
        return self._hours

    @hours.setter
    def hours(self, angle):
        if isinstance(angle, Angle):
            angle = angle.hours
        self._hours = float(angle)
        self._deg = float(self._hours * 15.0)
        self._rad = float(radians(self._deg))
        self.hour, self.minute, self.second = convert.dec2sex(self._hours)
        self._hms = "%02d:%02d:%02.2f" % (self.hour, self.minute, self.second)

    @property
    def hms(self):
        return self._hms

    @hms.setter
    def hms(self, angle):
        if isinstance(angle, Angle):
            angle = angle.hms
        self._hms = angle
        self._hours = convert.string2hours(angle)
        self._deg = float(self._hours * 15.0)
        self._rad = float(radians(self._deg))
        self.hour, self.minute, self.second = convert.dec2sex(self._hours)

    def __float__(self):
        return self._deg

    def __int__(self):
        return int(self._deg)

    def __str__(self):
        return "%f degrees" % self._deg

    def __add__(self, other):
        return self._deg + other

    def __sub__(self, other):
        return self._deg - other

    def __rsub__(self, other):
        return other - self._deg

    def __mul__(self, other):
        return self._deg * other

    def __div__(self, other):
        return self._deg / other

    def __rdiv__(self, other):
        return other / self._deg

    def __radians__(self):
        return self._rad

if __name__ == '__main__':
    ra = Angle()
    ra.hours = 9.16123344
    print ra.deg
    print ra.hms
    ra.hms = "04:15:23.45"
    print ra.deg
    print ra.hours
    ra.rad = 1.782
    print ra.deg
    print float(ra)
    print int(ra)
    print str(ra)
"""
