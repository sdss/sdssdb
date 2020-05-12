#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-12-11
# @Filename: mangadb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import math
from decimal import Decimal

from astropy.time import Time
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import backref, relationship

from sdssdb.sqlalchemy.operationsdb import OperationsBase, database, platedb

from .tools import dateObs2HA as ha


class MangaDBBase(AbstractConcreteBase, OperationsBase):
    __abstract__ = True
    _schema = 'mangadb'
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class Exposure(MangaDBBase):

    __tablename__ = 'exposure'

    def __repr__(self):
        return '<Exposure (pk={0})>'.format(self.pk)

    def taiToAirmass(self):
        """Convert airmass from Tai, for midpoint of observation."""

        # compute tai midpoint
        taibeg = self.platedbExposure.start_time
        exptime = self.platedbExposure.exposure_time
        taiend = taibeg + exptime
        taimid = (taibeg + taiend) / Decimal(2.0)

        # APO location
        # longitude = 360. - 105.820417
        latitude = 32.780361
        # altitude = 2788.

        # convert to radians
        jd = 2400000.5 + float(taimid) / (24. * 3600.)  # julian day
        lat = math.radians(latitude)
        dec = math.radians(self.platedbExposure.observation.plate_pointing.pointing.center_dec)
        ra = self.platedbExposure.observation.plate_pointing.pointing.center_ra

        # get hour angle
        t = Time(jd, scale='tai', format='jd')
        hourang = ha.dateObs2HA(t.iso.replace(' ', 'T'), float(ra))  # In hours
        hourang = math.radians(hourang)  # To radians

        # compute airmass
        cosz = math.sin(dec) * math.sin(lat) + math.cos(dec) * math.cos(hourang) * math.cos(lat)
        airmass = 1.0 / cosz

        return airmass

    def normalizeSN2(self, camera):
        """Normalize SN2."""

        if camera[0] == 'b':
            bosssn2 = 3.6
            scale = 1.0
        elif camera[0] == 'r':
            bosssn2 = 7.5
            scale = 1.25

        # simulated SN2 for a given camera, for a given exposure (via airmass)
        airmass = self.taiToAirmass()
        simSN2 = bosssn2 / math.pow(airmass, scale)

        if camera == 'b1':
            normSN2 = [sn2.b1_sn2 / simSN2 for sn2 in self.sn2values]
        elif camera == 'b2':
            normSN2 = [sn2.b2_sn2 / simSN2 for sn2 in self.sn2values]
        elif camera == 'r1':
            normSN2 = [sn2.r1_sn2 / simSN2 for sn2 in self.sn2values]
        elif camera == 'r2':
            normSN2 = [sn2.r2_sn2 / simSN2 for sn2 in self.sn2values]

        return normSN2


class ExposureStatus(MangaDBBase):

    __tablename__ = 'exposure_status'

    def __repr__(self):
        return '<Exposure_Status (pk={0}, label={1})>'.format(self.pk, self.label)


class ExposureToData_cube(MangaDBBase):

    __tablename__ = 'exposure_to_data_cube'

    def __repr__(self):
        return '<Exposure_to_Data_Cube (pk={0})'.format(self.pk)


class Set(MangaDBBase):

    __tablename__ = 'set'

    def __repr__(self):
        return '<Set (pk={0}, name={1})>'.format(self.pk, self.name)


class SetStatus(MangaDBBase):

    __tablename__ = 'set_status'

    def __repr__(self):
        return '<Set_Status (pk={0}, label={1})>'.format(self.pk, self.label)


class DataCube(MangaDBBase):

    __tablename__ = 'data_cube'

    def __repr__(self):
        return '<MangaDB Data_Cube (pk={0})>'.format(self.pk)


class Spectrum(MangaDBBase):

    __tablename__ = 'spectrum'

    def __repr__(self):
        return '<Spectrum (pk={0})>'.format(self.pk)


class SN2Values(MangaDBBase):

    __tablename__ = 'sn2_values'

    def __repr__(self):
        return '<SN2_Values (pk={0})>'.format(self.pk)

    def normalize(self, camera, kappa=1.0):
        """ Normalize the SN2 values to the simulated blue/red SN2 """

        if camera[0] == 'b':
            bosssn2 = 3.6
            scale = 1.0
            # kappa = dvals['gIncrease'].data[0]
        elif camera[0] == 'r':
            bosssn2 = 7.5
            scale = 1.25
            # kappa = dvals['iIncrease'].data[0]

        # simulated SN2 for a given camera, for a given exposure (via airmass)
        airmass = self.exposure.taiToAirmass()
        simSN2 = bosssn2 / (math.pow(airmass, scale) * kappa)

        if camera == 'b1':
            normSN2 = self.b1_sn2 / simSN2
        elif camera == 'b2':
            normSN2 = self.b2_sn2 / simSN2
        elif camera == 'r1':
            normSN2 = self.r1_sn2 / simSN2
        elif camera == 'r2':
            normSN2 = self.r2_sn2 / simSN2

        return normSN2


class CurrentStatus(MangaDBBase):

    __tablename__ = 'current_status'

    def __repr__(self):
        return '<Current_Status (pk={0}, exp={1}, mjd={2}, flavor={3}, unplugIFU={4})>'.format(
            self.pk, self.exposure_no, self.mjd, self.flavor, self.unpluggedifu)


class Filelist(MangaDBBase):

    __tablename__ = 'filelist'

    def __repr__(self):
        return '<Filelist (pk={0},name={1},path={2})'.format(self.pk, self.name, self.path)


class Plate(MangaDBBase):

    __tablename__ = 'plate'

    def __repr__(self):
        return '<Plate (pk={0}, plate_id={1})'.format(self.pk, self.platedbPlate.plate_id)


def define_relations():

    Exposure.set = relationship(Set, backref='exposures')
    Exposure.status = relationship(ExposureStatus, backref='exposures')
    Exposure.platedbExposure = relationship(platedb.Exposure, backref='mangadbExposure')
    Exposure.spectra = relationship(Spectrum, backref='exposures')
    Exposure.datacubes = relationship(DataCube, backref='exposures')

    ExposureToData_cube.exposure = relationship(Exposure, backref='exposuresToDatacubes')
    ExposureToData_cube.datacube = relationship(DataCube, backref='exposuresToDatacubes')

    DataCube.plate = relationship(platedb.Plate, backref='dataCube')

    Spectrum.datacube = relationship(DataCube, backref='spectrum')
    Set.status = relationship(SetStatus, backref='sets')

    SN2Values.exposure = relationship(Exposure, backref='sn2values')

    Plate.platedbPlate = relationship(platedb.Plate,
                                      backref=backref('mangadbPlate', uselist=False))


# Adds the MangaDBBase to the database connection.
database.add_base(MangaDBBase)
