################################################################################
#
# convert.py - A Python module that contains unit conversions and
#               coordinate conversions for astronomical data
#               processing and analysis
#
# Copyright (C) 2011 Adrian Price-Whelan
#
# Notes:
#   - Angles that are not labeled with units (like ra, vs. raRad) are in
#       Degrees.
################################################################################
"""
todo: any function that takes RA and Dec  should accept a string of the form HH:MM:SS.SS
todo: define __all__ so importing all from this script doesn't carry all of 'math'
"""

__author__ = 'Adrian Price-Whelan <adrn@nyu.edu>'

# Standard library dependencies
import datetime
import math
import re
from math import *

import numpy as np

from .geometry import *

# Assumed Constants:
epochOffsetT = 0.0
ee = 23.0 + 26.0 / 60.0 + 21.45 / 3600.0 - 46.815 / 3600.0 * epochOffsetT - 0.0006 / 3600.0 * epochOffsetT**2 + 0.00181 / 3600.0 * epochOffsetT**3
toRad = np.pi / 180.0

#
# Formatting:
dayNames = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday'
}


def parseRA(raString):
    """ Parse an RA string and return hours, minutes, seconds.

    Parameters
    ----------
    raString : string
        A string representing a Right Ascension (RA). The values can be delimited by
        white space, no space, or a colon:
        13:19:23.1 or
        13 19 23.1 or
        131923.1

    Returns
    -------

    """
    div = '(|:|\s|/)'
    pattr = '([+-]*\d?\d)' + div + '(\d?\d)' + div + '(\d?\d[\.0-9]*)'
    try:
        elems = re.search(pattr, raString).groups()
    except:
        print('Invalid input string!')
        raise

    hours = int(elems[0])
    minutes = int(elems[2])
    seconds = float(elems[4])

    # Check for nonsense values
    if hours > 24.0:
        raise ValueError('Hour value must be < 24.')
    if minutes >= 60.0:
        raise ValueError('Minute value must be < 60.')
    if seconds >= 60.0:
        raise ValueError('Second value must be < 60.')

    return (int(hours), int(minutes), seconds)


def parseDec(decString):
    """ Parse a Dec string and return degrees, minutes, seconds.

    Parameters
    ----------
    raString : string
        A string representing a Declination (dec). The values can be delimited by
        white space, no space, or a colon:
        +13:19:23.1 or
        -13 19 23.1 or
        +131923.1

    Returns
    -------

    """

    div = '(|:|\s|/)'
    pattr = '([+-]*\d?\d)' + div + '(\d?\d)' + div + '(\d?\d[\.0-9]*)'
    try:
        elems = re.search(pattr, decString).groups()
    except:
        print('Invalid input string!')
        raise

    degrees = int(elems[0])
    arcminutes = int(elems[2])
    arcseconds = float(elems[4])

    # Check for nonsense values
    if degrees > 90.0:
        raise ValueError('Degree value must be <= 90.')
    if arcminutes >= 60.0:
        raise ValueError('Arcminute value must be < 60.')
    if arcseconds >= 60.0:
        raise ValueError('Arcsecond value must be < 60.')

    return (int(degrees), int(arcminutes), arcseconds)


def string2hours(string):
    print('string2hours is deprecated! Use parseRA instead')
    return parseRA(string)


def string2deg(string):
    print('string2deg is deprecated! Use parseDec instead')
    return parseDec(string)


def hours2string(*args):
    if len(args) > 1:
        h = args[0]
        m = args[1]
        s = args[2]
    else:
        decHours = args[0]
        h, m, s = dec2sex(decHours)

    return '%02d:%02d:%08.5f' % (h, m, s)


def degrees2string(*args):
    if len(args) > 1:
        d = args[0]
        m = args[1]
        s = args[2]
    else:
        decHours = args[0]
        d, m, s = dec2sex(decHours)

    if m < 0 or s < 0:
        d, m, s = d, -m, -s
        decString = '%03d:%02d:%08.5f' % (d, m, s)
    else:
        decString = '%02d:%02d:%08.5f' % decTuple

    return decString


#
# Date / Time Conversions:


def datetime2decHour(datetimeObj):
    """ Converts a Python datetime.datetime object into a decimal hour """
    return sex2dec(*map(float, datetimeObj.strftime('%H:%M:%S').split(':')))


def dec2sex(dec_hours, microsecond=False):
    """ Convert a time in decimal hours to sexagesimal.

    Parameters
    ----------
    dec_hours : float
        A time in decimal hours.

    microsecond : boolean
        If true, will output a 4-tuple (hour, minute, second, microsecond). If false,
        it will output a 3-tuple with a floating point 'second' term.

    Returns
    -------
        See 'microsecond' above.

    Notes
    -----
        This is accurate to 1 microsecond.

    """

    (hrRemainder, hours) = math.modf(dec_hours)
    (minRemainder, minutes) = math.modf(hrRemainder * 60.0)
    (secRemainder, seconds) = math.modf(minRemainder * 60.0)
    microseconds = int(secRemainder * 1E6)

    if microsecond:
        return (int(hours), int(minutes), int(seconds), microseconds)
    else:
        return (int(hours), int(minutes), seconds + secRemainder)


def sex2dec(hour, minute, second, microsecond=0.0):
    """ Convert a sexagesimal time to decimal hours.

    Parameters
    ----------
    hour, min, sec : int, float

    Returns
    -------
        Time in decimal hours

    """
    return float(hour) + minute / 60.0 + (second + microsecond / 1E6) / 3600.0


def hms2stringTime(h, m, s, precision=5):
    """ Convert a sexagesimal time to a formatted string.

    Parameters
    ----------
    hour, min, sec : int, float
    precision : int

    Returns
    -------
        String formatted HH:MM:SS.SSSSS

    """
    if h < 0 or m < 0 or s < 0:
        pm = '-'
    else:
        pm = '+'

    formString = '%s%02d:%02d:%0' + str(precision + 3) + '.' + str(precision) + 'f'
    return formString % (pm, abs(h), abs(m), abs(s))


def dec2stringTime(decim, precision=5):
    """ Convert a decimale time or coordinate to a formatted string.

    Parameters
    ----------
    decim : int, float
    precision : int

    Returns
    -------
        String formatted HH:MM:SS.SSSSS

    """
    return hms2stringTime(*dec2sex(decim), precision=precision)


def datetime2decimalTime(datetimeObj=None):
    """ Converts a Python datetime.datetime object into a decimal hour """
    if datetimeObj == None:
        datetimeObj = datetime.datetime.now()
    return sex2dec(datetimeObj.hour, datetimeObj.minute, datetimeObj.second,
                   datetimeObj.microsecond)


def time2decHours(time):
    # DEPRECATED!
    # Use datetime2decimalTime
    print('time2decHours is deprecated! Use datetime2decimalTime instead.')
    return datetime2decimalTime(time)


def ymd2jd(year, month, day):
    """
    Converts a year, month, and day to a Julian Date.
    This function uses an algorithm from the book "Practical Astronomy with your
    Calculator" by Peter Duffet-Smith (Page 7)

    Parameters
    ----------
    year : int
        A Gregorian year
    month : int
        A Gregorian month
    day : int
        A Gregorian day

    Returns
    -------
    jd : float
        A Julian Date computed from the input year, month, and day.

    """
    if month == 1 or month == 2:
        yprime = year - 1
        mprime = month + 12
    else:
        yprime = year
        mprime = month

    if year > 1582 or (year == 1582 and (month >= 10 and day >= 15)):
        A = int(yprime / 100)
        B = 2 - A + int(A / 4.0)
    else:
        B = 0

    if yprime < 0:
        C = int((365.25 * yprime) - 0.75)
    else:
        C = int(365.25 * yprime)

    D = int(30.6001 * (mprime + 1))

    return B + C + D + day + 1720994.5

    #def ymd2weekday(year, month, day):
    """ Returns the day of the week for the specified year, month, and day """
    jd = ymd2jd(year, month, day)
    A = (jd + 1.5) / 7.0
    return dayNames[round((A - int(A)) * 7.0)]


def utcDatetime2gmst(datetimeObj):
    """
    Converts a Python datetime object with UTC time to Greenwich Mean Sidereal Time.
    This function uses an algorithm from the book "Practical Astronomy with your
    Calculator" by Peter Duffet-Smith (Page 17)

    Parameters
    ----------
    datetimeObj : datetime.datetime
        A Python datetime.datetime object

    Returns
    -------
    < > : datetime.datetime
        A Python datetime.datetime object corresponding to the Greenwich Mean
        Sidereal Time of the input datetime.datetime object.

    """
    jd = ymd2jd(datetimeObj.year, datetimeObj.month, datetimeObj.day)

    S = jd - 2451545.0
    T = S / 36525.0
    T0 = 6.697374558 + (2400.051336 * T) + (0.000025862 * T**2)
    T0 = T0 % 24

    UT = datetime2decimalTime(datetimeObj.time()) * 1.002737909
    T0 += UT

    GST = T0 % 24

    h, m, s = dec2sex(GST)
    return datetime.datetime(
        year=datetimeObj.year,
        month=datetimeObj.month,
        day=datetimeObj.day,
        hour=h,
        minute=m,
        second=int(s),
        microsecond=int((s - int(s)) * 10**6))


def gmst2utcDatetime(datetimeObj):
    """
    Converts a Python datetime object representing a Greenwich Mean Sidereal Time
    to UTC time. This function uses an algorithm from the book "Practical Astronomy
    with your Calculator" by Peter Duffet-Smith (Page 18)

    Parameters
    ----------
    datetimeObj : datetime.datetime
        A Python datetime.datetime object

    Returns
    -------
    < > : datetime.datetime
        A Python datetime.datetime object corresponding to UTC time of the input
        Greenwich Mean Sidereal Time datetime.datetime object.

    """
    jd = ymd2jd(datetimeObj.year, datetimeObj.month, datetimeObj.day)

    S = jd - 2451545.0
    T = S / 36525.0
    T0 = 6.697374558 + (2400.051336 * T) + (0.000025862 * T**2)
    T0 = T0 % 24

    GST = (datetime2decimalTime(datetimeObj.time()) - T0) % 24
    UT = GST * 0.9972695663

    h, m, s = dec2sex(UT)
    return datetime.datetime(
        year=datetimeObj.year,
        month=datetimeObj.month,
        day=datetimeObj.day,
        hour=h,
        minute=m,
        second=int(s),
        microsecond=int((s - int(s)) * 10**6))


def mjd2jd(mjd):
    """
    Converts a Modified Julian Date to Julian Date

    Parameters
    ----------
    mjd : float (any numeric type)
        A Modified Julian Date

    Returns
    -------
    jd : float
        The Julian Date calculated from the input Modified Julian Date

    Examples
    --------
    >>> mjd2jd(55580.90429)
    2455581.40429

    """
    return mjd + 2400000.5


def jd2mjd(jd):
    """
    Converts a Julian Date to a Modified Julian Date

    Parameters
    ----------
    jd : float (any numeric type)
        A julian date

    Returns
    -------
    mjd : float
        The Modified Julian Date (MJD) calculated from the input Julian Date

    Examples
    --------
    >>> jd2mjd(2455581.40429)
    55580.90429

    """
    return float(jd - 2400000.5)


def mjd2sdssjd(mjd):
    """
    Converts a Modified Julian Date to a SDSS Julian Date, which is
        used at Apache Point Observatory (APO).

    Parameters
    ----------
    mjd : float (any numeric type)
        A Modified Julian Date

    Returns
    -------
    mjd : float
        The SDSS Julian Date calculated from the input Modified Julian Date

    Notes
    -----
    - The SDSS Julian Date is a convenience used at APO to prevent MJD from rolling
        over during a night's observation.

    Examples
    --------
    >>> mjd2sdssjd(55580.90429)
    55581.20429

    """
    return mjd + 0.3


def jd2sdssjd(jd):
    """
    Converts a Julian Date to a SDSS Julian Date, which is
        used at Apache Point Observatory (APO).

    Parameters
    ----------
    jd : float (any numeric type)
        A Julian Date

    Returns
    -------
    mjd : float
        The SDSS Julian Date calculated from the input Modified Julian Date

    Notes
    -----
    - The SDSS Julian Date is a convenience used at APO to prevent MJD from rolling
        over during a night's observation.

    Examples
    --------
    >>> jd2sdssjd(2455581.40429)
    55581.20429

    """
    mjd = jd2mjd(jd)
    return mjd2sdssjd(mjd)


def sdssjd2mjd(sdssjd):
    """
    Converts a SDSS Julian Date to a Modified Julian Date

    Parameters
    ----------
    sdssjd : float (any numeric type)
        The SDSS Julian Date

    Returns
    -------
    mjd : float
        The Modified Julian Date calculated from the input SDSS Julian Date

    Notes
    -----
    - The SDSS Julian Date is a convenience used at APO to prevent MJD from rolling
        over during a night's observation.

    Examples
    --------
    >>> sdssjd2mjd(55581.20429)
    55580.90429

    """
    return sdssjd - 0.3


def sdssjd2jd(sdssjd):
    """
    Converts a SDSS Julian Date to a Julian Date

    Parameters
    ----------
    sdssjd : float (any numeric type)
        The SDSS Julian Date

    Returns
    -------
    jd : float
        The Julian Date calculated from the input SDSS Julian Date

    Notes
    -----
    - The SDSS Julian Date is a convenience used at APO to prevent MJD from rolling
        over during a night's observation.

    Examples
    --------
    >>> sdssjd2jd(55581.20429)
    2455581.40429

    """
    mjd = sdssjd - 0.3
    return mjd2jd(mjd)


def jd2datetime(fracJD, timezone=0):
    """
    Converts a Julian Date to a Python datetime object. The resulting time is in UTC.

    Parameters
    ----------
    jd : float (any numeric type)
        A Julian Date
    timezone : int
        An integer representing the timezone to convert to -- defaults to 0.
        i.e. -5 for EST...

    Returns
    -------
    < > : datetime.datetime
        A Python datetime.datetime object calculated using an algorithm from the book
        "Practical Astronomy with your Calculator" by Peter Duffet-Smith (Page 8)

    Examples
    --------
    >>> jd2datetime(2455581.40429)
    2011-01-19 21:42:10.000010

    """
    jdTmp = fracJD + 0.5
    I = int(jdTmp)
    F = jdTmp - I
    if I > 2299160:
        A = int((I - 1867216.25) / 36524.25)
        B = I + 1 + A - int(A / 4)
    else:
        B = I

    C = B + 1524
    D = int((C - 122.1) / 365.25)
    E = int(365.25 * D)
    G = int((C - E) / 30.6001)

    d = C - E + F - int(30.6001 * G)

    if G < 13.5:
        m = G - 1
    else:
        m = G - 13

    if m > 2.5:
        y = D - 4716
    else:
        y = D - 4715

    year = int(y)
    month = int(m)
    day = int(d)
    hour, min, sec, ms = dec2sex((d - int(d)) * 24., True)
    return datetime.datetime(year, month, day, hour, min, sec, ms) + datetime.timedelta(
        0.0, seconds=timezone * 60 * 60)


def mjd2datetime(mjd):
    """
    Converts a Modified Julian Date to a Python datetime object. The resulting time is in UTC.

    Parameters
    ----------
    mjd : float (any numeric type)
        A Modified Julian Date

    Returns
    -------
    < > : datetime.datetime
        A Python datetime.datetime object calculated using an algorithm from the book
        "Practical Astronomy with your Calculator" by Peter Duffet-Smith (Page 8)

    Examples
    --------
    >>> mjd2datetime(55580.90429)
    2011-01-19 21:42:10.000010

    """
    jd = mjd2jd(mjd)
    return jd2datetime(jd)


def datetime2jd(datetimeObj):
    """
    Converts a Python datetime object to a Julian Date.

    Parameters
    ----------
    datetimeObj : datetime.datetime
        A Python datetime.datetime object calculated using an algorithm from the book
        "Practical Astronomy with your Calculator" by Peter Duffet-Smith (Page 7)

    Returns
    -------
    < > : float
        A Julian Date

    Examples
    --------
    >>> datetime2jd(datetimeObject)
    2455581.40429

    """
    A = ymd2jd(datetimeObj.year, datetimeObj.month, datetimeObj.day)
    B = datetime2decimalTime(datetimeObj.time()) / 24.0
    return A + B


def datetime2mjd(datetimeObj):
    """
    Converts a Python datetime object to a Modified Julian Date.

    Parameters
    ----------
    datetimeObj : datetime.datetime
        A Python datetime.datetime object calculated using an algorithm from the book
        "Practical Astronomy with your Calculator" by Peter Duffet-Smith (Page 7)

    Returns
    -------
    < > : float
        A Modified Julian Date

    Examples
    --------
    >>> datetime2mjd(datetimeObject)
    55580.90429

    """
    jd = datetime2jd(datetimeObj)
    return jd2mjd(jd)


def gmst2lst(longitude,
             hour,
             minute=None,
             second=None,
             longitudeDirection='W',
             longitudeUnits='DEGREES'):
    """
    Converts Greenwich Mean Sidereal Time to Local Sidereal Time.

    Parameters
    ----------
    longitude : float (any numeric type)
        The longitude of the site to calculate the Local Sidereal Time. Defaults are
        Longitude WEST and units DEGREES, but these can be changed with the optional
        parameters lonDirection and lonUnits.
    hour : int (or float)
        If an integer, the function will expect a minute and second. If a float, it
        will ignore minute and second and convert from decimal hours to hh:mm:ss.
    minute : int
        Ignored if hour is a float.
    second : int (any numeric type, to include microseconds)
        Ignored if hour is a float.
    lonDirection : string
        Default is longitude WEST, 'W', but you can specify EAST by passing 'E'.
    lonUnits : string
        Default units are 'DEGREES', but this can be switched to radians by passing
        'RADIANS' in this parameter.

    Returns
    -------
    hour : int
        The hour of the calculated LST
    minute : int
        The minutes of the calculated LST
    second: float
        The seconds of the calculated LST

    Examples
    --------
    >>> gmst2lst(70.3425, hour=14, minute=26, second=18)
    (9, 44, 55.80000000000126)
    >>> gmst2lst(5.055477, hour=14.4383333333333333, longitudeDirection='E', longitudeUnits='RADIANS')
    (9, 44, 55.79892611013463)

    """
    if minute != None and second != None:
        hours = sex2dec(hour, minute, second)
    elif minute == None and second == None:
        hours = hour
    else:
        raise AssertionError('minute and second must either be both set, or both unset.')

    if longitudeUnits.upper() == 'DEGREES':
        longitudeTime = longitude / 15.0
    elif longitudeUnits.upper() == 'RADIANS':
        longitudeTime = longitude * 180.0 / math.pi / 15.0

    if longitudeDirection.upper() == 'W':
        lst = hours - longitudeTime
    elif longitudeDirection.upper() == 'E':
        lst = hours + longitudeTime
    else:
        raise AssertionError('longitudeDirection must be W or E')

    lst = lst % 24.0

    return dec2sex(lst)


def gmstDatetime2lstDatetime(longitude, gmst, longitudeDirection='W', longitudeUnits='DEGREES'):
    """
    Converts Greenwich Mean Sidereal Time to Local Sidereal Time.

    Parameters
    ----------
    longitude : float (any numeric type)
        The longitude of the site to calculate the Local Sidereal Time. Defaults are
        Longitude WEST and units DEGREES, but these can be changed with the optional
        parameters lonDirection and lonUnits.
    gmst : datetime.datetime
        A Python datetime.datetime object representing the Greenwich Mean Sidereal Time
    lonDirection : string
        Default is longitude WEST, 'W', but you can specify EAST by passing 'E'.
    lonUnits : string
        Default units are 'DEGREES', but this can be switched to radians by passing
        'RADIANS' in this parameter.

    Returns
    -------
    lst : datetime.datetime

    """
    hours = datetime2decimalTime(gmst)

    if longitudeUnits.upper() == 'DEGREES':
        longitudeTime = longitude / 15.0
    elif longitudeUnits.upper() == 'RADIANS':
        longitudeTime = longitude * 180.0 / math.pi / 15.0

    if longitudeDirection.upper() == 'W':
        lst = hours - longitudeTime
    elif longitudeDirection.upper() == 'E':
        lst = hours + longitudeTime
    else:
        raise AssertionError('longitudeDirection must be W or E')

    lst = lst % 24.0
    h, m, s = dec2sex(lst)

    return datetime.datetime.combine(gmst.date(), datetime.time(h, m, int(s)))


def lst2gmst(longitude,
             hour,
             minute=None,
             second=None,
             longitudeDirection='W',
             longitudeUnits='DEGREES'):
    """
    Converts Local Sidereal Time to Greenwich Mean Sidereal Time.

    Parameters
    ----------
    longitude : float (any numeric type)
        The longitude of the site to calculate the Local Sidereal Time. Defaults are
        Longitude WEST and units DEGREES, but these can be changed with the optional
        parameters lonDirection and lonUnits.
    hour : int (or float)
        If an integer, the function will expect a minute and second. If a float, it
        will ignore minute and second and convert from decimal hours to hh:mm:ss.
    minute : int
        Ignored if hour is a float.
    second : int (any numeric type, to include microseconds)
        Ignored if hour is a float.
    longitudeDirection : string
        Default is longitude WEST, 'W', but you can specify EAST by passing 'E'.
    longitudeUnits : string
        Default units are 'DEGREES', but this can be switched to radians by passing
        'RADIANS' in this parameter.

    Returns
    -------
    hour : int
        The hour of the calculated GMST
    minute : int
        The minutes of the calculated GMST
    second: float
        The seconds of the calculated GMST

    Examples
    --------
    >>> lst2gmst(70.3425, hour=14, minute=26, second=18)
    (19, 7, 40.20000000000607)
    >>> lst2gmst(5.055477, hour=14.4383333333333333, longitudeDirection='E', longitudeUnits='RADIANS')
    (19, 7, 40.20107388985991)

    """
    if minute != None and second != None:
        hours = sex2dec(hour, minute, second)
    elif minute == None and second == None:
        hours = hour
    else:
        raise AssertionError('minute and second must either be both set, or both unset.')

    if longitudeUnits.upper() == 'DEGREES':
        longitudeTime = longitude / 15.0
    elif longitudeUnits.upper() == 'RADIANS':
        longitudeTime = longitude * 180.0 / math.pi / 15.0

    if longitudeDirection.upper() == 'W':
        gmst = hours + longitudeTime
    elif longitudeDirection.upper() == 'E':
        gmst = hours - longitudeTime
    else:
        raise AssertionError('longitudeDirection must be W or E')

    gmst = gmst % 24.0

    return dec2sex(gmst)


#
# Coordinate Transformations:
def raLST2ha(ra, hour, minute=None, second=None, raUnits='HOURS'):
    """
    Converts a Right Ascension to an Hour Angle, given the Local Sidereal Time.

    Parameters
    ----------
    ra : float (any numeric type)
        A right ascension. Default units are HOURS, but can be changed to DEGREES
    hour : int (or float)
        If an integer, the function will expect a minute and second. If a float, it
        will ignore minute and second and convert from decimal hours to hh:mm:ss.
    minute : int
        Ignored if hour is a float.
    second : int (any numeric type, to include microseconds)
        Ignored if hour is a float.
    raUnits : string
        Can be either HOURS or DEGREES, defaults to HOURS.

    Returns
    -------
    hour : int
        The hour of the calculated HA
    minute : int
        The minutes of the calculated HA
    second: float
        The seconds of the calculated HA

    Examples
    --------
    >>> raLST2ha(70.3425, hour=14, minute=26, second=18, raUnits='DEGREES')
    9.74883333333
    >>> raLST2ha(5.055477, hour=14.4383333333333333)
    9.74883333333

    """
    if minute != None and second != None:
        hours = sex2dec(hour, minute, second)
    elif minute == None and second == None:
        hours = hour
    else:
        raise AssertionError('minute and second must either be both set, or both unset.')

    if raUnits.upper() == 'HOURS':
        HA = hours - ra
    elif raUnits.upper() == 'DEGREES':
        HA = hours - ra / 15.0
    else:
        raise AssertionError('raUnits must be either HOURS or DEGREES')

    return HA


def haLST2ra():
    pass


def raUTC2ha():
    pass


def haUTC2ra():
    pass


def ra2transitTime():
    pass


def raDec2AltAz(ra, dec, latitude, longitude, datetimeObj, longitudeDirection='W'):
    """
    Converts an RA and Dec to Alt Az for a given datetime object.

    Parameters
    ----------
    ra : float (any numeric type)
        A Right Ascension, default units DEGREES
    dec : float (any numeric type)
        A Declination, default units DEGREES
    latitude : float (any numeric type)
        A latitude in DEGREES
    longitide : float (any numeric type)
        A longitude in DEGREES
    datetimeObj : datetime.datetime
        A Python datetime.datetime object
    longitudeDirection : string
        Default is longitude WEST, 'W', but you can specify EAST by passing 'E'.

    Returns
    -------
    alt : float
        Altitude, default units DEGREES
    az : float
        Azimuth, default units DEGREES

    """
    gmst = utcDatetime2gmst(datetimeObj)
    h, m, s = gmst2lst(longitude, gmst.hour, gmst.minute, gmst.second)
    lst = (h + m / 60.0 + s / 3600.0) * 15.0
    ha = lst - ra

    alt_rads = asin(sin(radians(dec))*sin(radians(latitude)) + \
        cos(radians(dec))*cos(radians(latitude))*cos(radians(ha)))

    cos_az = (sin(radians(dec)) - sin(alt_rads)*sin(radians(latitude))) / \
        (cos(alt_rads) * cos(radians(latitude)))

    #- Add bounds check on rounding
    if cos_az < -1.0:
        cos_az = -1.0
    if cos_az > 1.0:
        cos_az = 1.0

    alt = degrees(alt_rads)
    az = degrees(acos(cos_az))

    if sin(radians(ha)) < 0:
        return alt, az
    else:
        return alt, (360.0 - az)


def eclipticLatLon2RADec(lat, lon, latLonUnits='DEGREES', raDecUnits='DEGREES'):
    """
    Converts an Ecliptic Latitude and Ecliptic Longitude to a Right Ascension and
    Declination.

    Parameters
    ----------
    lat : float (any numeric type)
        An ecliptic latitude, default units DEGREES
    long : float (any numeric type)
        An ecliptic longitude, default units DEGREES
    latLonUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.
    raDecUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.

    Returns
    -------
    ra : float
        A right ascension, default units DEGREES
    dec : float
        A declination, default units DEGREES

    Examples
    --------
    >>> eclipticLatLon2RADec(70.3425, -11.4552)
    (143.72252629028003, 19.535734683739964)

    """
    if latLonUnits.upper() == 'HOURS':
        lambdaa = lat * 15.0
        beta = lon * 15.0
    elif latLonUnits.upper() == 'DEGREES':
        lambdaa = lat
        beta = lon
    else:
        raise AssertionError('latLonUnits must be either HOURS or DEGREES')

    # Python works in Radians...
    lambdaaRad = lambdaa * math.pi / 180.0
    betaRad = beta * math.pi / 180.0
    eeRad = ee * math.pi / 180.0

    deltaRad = math.asin(
        math.sin(betaRad) * math.cos(eeRad) +
        math.cos(betaRad) * math.sin(eeRad) * math.sin(lambdaaRad))

    y = math.sin(lambdaaRad) * math.cos(eeRad) - math.tan(betaRad) * math.sin(eeRad)
    x = math.cos(lambdaaRad)

    alphaPrime = math.atan(y / x) * 180.0 / math.pi

    if y > 0 and x > 0:
        alpha = alphaPrime % 90.0
    elif y > 0 and x < 0:
        alpha = (alphaPrime % 90.0) + 90.0
    elif y < 0 and x < 0:
        alpha = (alphaPrime % 90.0) + 180.0
    elif y < 0 and x > 0:
        alpha = (alphaPrime % 90.0) + 270.0
    else:
        alpha = alphaPrime

    if raDecUnits.upper() == 'HOURS':
        ra = alpha / 15.0
        dec = deltaRad * 180.0 / math.pi / 15.0
    elif raDecUnits.upper() == 'DEGREES':
        ra = alpha
        dec = deltaRad * 180.0 / math.pi
    else:
        raise AssertionError('raDecUnits must be either HOURS or DEGREES')

    return ra, dec


def raDec2Galactic(ra, dec, latLonUnits='DEGREES', raDecUnits='DEGREES'):
    """
    Converts a Right Ascension and Declination to an Galactic Latitude
    and Longitude

    Parameters
    ----------
    ra : float (any numeric type)
        A right ascension, default units DEGREES
    dec : float (any numeric type)
        A declination, default units DEGREES
    latLonUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.
    raDecUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.

    Returns
    -------
    b : float
        A Galactic latitude, default units DEGREES
    l : float
        An Galactic longitude, default units DEGREES

    """
    if isinstance(ra, [].__class__) or isinstance(dec, [].__class__):
        ra = np.array(float(ra))
        dec = np.array(float(dec))
    elif isinstance(ra, np.array([]).__class__):
        ra = ra.astype(float)
        dec = dec.astype(float)
    else:
        ra = np.array([float(ra)])
        dec = np.array([float(dec)])

    if raDecUnits.lower() == 'degrees':
        ra *= toRad
        dec *= toRad

    raNGP = 192.85948 * toRad
    decNGP = 27.12825 * toRad
    lASCEND = 32.93192 * toRad

    gb = np.arcsin(
        np.cos(dec) * np.cos(decNGP) * np.cos(ra - raNGP) + np.sin(dec) * np.sin(decNGP))
    gl = np.arctan2( np.sin(dec)*np.cos(decNGP) - np.cos(dec)*np.cos(ra - raNGP)*np.sin(decNGP),\
                     np.cos(dec)*np.sin(ra - raNGP) ) + lASCEND

    gl /= toRad
    gb /= toRad

    gl[gl < 0.] += 360.

    if len(gl) == 1:
        return gl[0], gb[0]

    return gl, gb


def galactic2RaDec(gl, gb, latLonUnits='DEGREES', raDecUnits='DEGREES'):
    """
    Converts a Galactic Latitude and Longitude to Right Ascension and Declination

    Parameters
    ----------
    gl : float (any numeric type)
        An Galactic longitude, default units DEGREES
    gb : float (any numeric type)
        A Galactic latitude, default units DEGREES
    latLonUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.
    raDecUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.

    Returns
    -------
    ra : float
        A right ascension, default units DEGREES
    dec : float
        A declination, default units DEGREES

    """

    if isinstance(gl, [].__class__) or isinstance(gb, [].__class__):
        gl = np.array(float(gl))
        gb = np.array(float(gb))
    elif isinstance(gl, np.array([]).__class__):
        gl = gl.astype(float)
        gb = gb.astype(float)
    else:
        gl = np.array([float(gl)])
        gb = np.array([float(gb)])

    if latLonUnits.lower() == 'degrees':
        gl *= toRad
        gb *= toRad

    raNGP = 192.85948 * toRad
    decNGP = 27.12825 * toRad
    lASCEND = 32.93192 * toRad

    dec = np.arcsin(
        np.cos(gb) * np.cos(decNGP) * np.sin(gl - lASCEND) + np.sin(gb) * np.sin(decNGP))
    ra = np.arctan2( np.cos(gb)*np.cos(gl - lASCEND), \
                     np.sin(gb)*np.cos(decNGP) - np.cos(gb)*np.sin(gl - lASCEND)*np.sin(decNGP) ) + raNGP

    ra /= toRad
    dec /= toRad

    ra[ra > 360.] -= 360.

    if len(ra) == 1:
        return ra[0], dec[0]

    return ra, dec


def raDec2EclipticLatLon(ra, dec, latLonUnits='DEGREES', raDecUnits='DEGREES'):
    """
    Converts a Right Ascension and Declination to an Ecliptic Latitude and
    Ecliptic Longitude.

    Parameters
    ----------
    ra : float (any numeric type)
        A right ascension, default units DEGREES
    dec : float (any numeric type)
        A declination, default units DEGREES
    latLonUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.
    raDecUnits : string
        Can be either HOURS or DEGREES, defaults to DEGREES.

    Returns
    -------
    lat : float
        An ecliptic latitude, default units DEGREES
    lon : float
        An ecliptic longitude, default units DEGREES


    """
    if raDecUnits.upper() == 'HOURS':
        ra = ra * 15.0
        dec = dec * 15.0
    elif raDecUnits.upper() == 'DEGREES':
        ra = ra
        dec = dec
    else:
        raise AssertionError('raDecUnits must be either HOURS or DEGREES')

    # Python works in Radians...
    raRad = ra * math.pi / 180.0
    decRad = dec * math.pi / 180.0
    eeRad = ee * math.pi / 180.0

    betaRad = math.asin(
        math.sin(decRad) * math.cos(eeRad) - math.cos(decRad) * math.sin(eeRad) * math.sin(raRad))

    y = math.sin(raRad) * math.cos(eeRad) + math.tan(decRad) * math.sin(eeRad)
    x = math.cos(raRad)

    lambdaPrime = math.atan(y / x) * 180.0 / math.pi

    if y > 0 and x > 0:
        lambdaa = lambdaPrime % 90.0
    elif y > 0 and x < 0:
        lambdaa = (lambdaPrime % 90.0) + 90.0
    elif y < 0 and x < 0:
        lambdaa = (lambdaPrime % 90.0) + 180.0
    elif y < 0 and x > 0:
        lambdaa = (lambdaPrime % 90.0) + 270.0
    else:
        lambdaa = lambdaPrime

    if latLonUnits.upper() == 'HOURS':
        lat = lambdaa / 15.0
        lon = betaRad * 180.0 / math.pi * 15.0
    elif latLonUnits.upper() == 'DEGREES':
        lat = lambdaa
        lon = betaRad * 180.0 / math.pi
    else:
        raise AssertionError('latLonUnits must be either HOURS or DEGREES')

    return lat, lon


def decHours2hms(dec_hours):
    ''' Convert decimal hours into hour, min, sec
          returned as a tuple, e.g.
          (12, 45, 6.6)
    '''
    (hours_frac, h) = math.modf(dec_hours)
    (min_frac, m) = math.modf(hours_frac * 60)
    s = min_frac * 60.
    return (int(h), int(m), s)


def mjd2ut(mjd):
    '''Convert a modified julian day to universal time.
            Julian day = mjd + 2400000.5
    '''
    return jd2datetime(float(mjd) + 2400000.5)
