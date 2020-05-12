#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: Demitri Muna
# @Filename: platedb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime
import math
import warnings
from decimal import Decimal
from textwrap import TextWrapper

import sqlalchemy
from sqlalchemy import func
from sqlalchemy.ext.declarative import AbstractConcreteBase, declared_attr
from sqlalchemy.orm import relation
from sqlalchemy.orm.exc import MultipleResultsFound, NoResultFound
from sqlalchemy.orm.session import Session

from sdssdb.sqlalchemy.operationsdb import OperationsBase, database

from .tools import convert
from .tools.moon import Moon


apo_lat = 32.7802778  # Latitude at APO
apo_lon = 105.820278  # Longitude at APO


warnings.filterwarnings('ignore', '.*Skipped unsupported reflection.*')
warnings.filterwarnings('ignore', '.*Did not recognize type*')


class Base(AbstractConcreteBase, OperationsBase):
    __abstract__ = True
    _schema = 'platedb'
    _relations = 'define_relations'

    @declared_attr
    def __table_args__(cls):
        return {'schema': cls._schema}


class PluggingException(Exception):
    """Custom class for plugging exceptions. Adds contact information."""

    def __init__(self, message, *args):

        tw = TextWrapper()
        tw.width = 79
        tw.subsequent_indent = ''
        tw.break_on_hyphens = False

        # Adds custom error
        message += '\n\n'
        message += '*' * 79 + '\n'

        addenda = ('If you are not sure of how to solve this problem '
                   'please copy this error message and email to Jose '
                   'Sanchez-Gallego <j.sanchezgallego@uky.edu> and Drew '
                   'Chojnowski <drewski@nmsu.edu> and CC Demitri Muna '
                   '<muna@astronomy.ohio-state.edu> and John Parejko '
                   '<john.parejko@yale.edu>.\n')
        addenda = '\n'.join(tw.wrap(addenda))
        message += addenda + '\n'

        message += '*' * 79 + '\n'

        super(PluggingException, self).__init__(message)


class ActivePluggingException(PluggingException):
    """Custom class for problems with Active Pluggings."""

    pass


class Cartridge(Base):

    __tablename__ = 'cartridge'

    def __repr__(self):
        return '<Cartridge: cartridge_id=%s>' % self.number


class Constants(Base):

    __tablename__ = 'constants'

    def __repr__(self):
        return '<Constants>'


class Gprobe(Base):

    __tablename__ = 'gprobe'

    def __repr__(self):
        return f'<Gprobe: gprobe={self.gprobe_id} cartridge={self.cartridge.number}>'


class Plugging(Base):

    __tablename__ = 'plugging'

    def __repr__(self):
        return f'<Plugging: plate={self.plate.plate_id} cartridge={self.cartridge.number}>'

    @property
    def fscan_datetime(self):
        return convert.mjd2datetime(self.fscan_mjd)

    def scienceExposures(self):
        session = Session.object_session(self)
        return session.query(Exposure).join(Observation, ExposureFlavor).filter(
            Observation.plugging_pk == self.pk).filter(
                ExposureFlavor.label == 'Science').all()

    def getSumSn2(self, cameras=None):
        session = Session.object_session(self)
        if cameras is None:
            cameras = ['r1', 'r2', 'b1', 'b2']
        exposures = session.query(Exposure).join(Observation).filter(
            Observation.plugging == self).all()
        SumSn2 = [0, 0, 0, 0]
        for i, camName in enumerate(cameras):
            camera = session.query(Camera).filter_by(label=camName).one()
            for exposure in exposures:
                cframe = session.query(CameraFrame).filter_by(
                    exposure=exposure).filter_by(
                        camera=camera).one()
                if cframe.sn2 > 0.2:
                    SumSn2[i] = SumSn2[i] + cframe.sn2
        return SumSn2

    def percentDone(self):
        if len(self.activePlugging) > 0:
            session = Session.object_session(self)

            # Refresh observations to ensure they are in sync with DB
            r1_sum = float(sum([obs.sumOfCamera('r1') for obs in self.observations]))
            r2_sum = float(sum([obs.sumOfCamera('r2') for obs in self.observations]))
            b1_sum = float(sum([obs.sumOfCamera('b1') for obs in self.observations]))
            b2_sum = float(sum([obs.sumOfCamera('b2') for obs in self.observations]))

            min_r_percent = min([r1_sum, r2_sum]) / float(
                session.query(BossSN2Threshold).join(Camera).filter(
                    Camera.label == 'r1').one().sn2_threshold) * 100.0
            min_b_percent = min([b1_sum, b2_sum]) / float(
                session.query(BossSN2Threshold).join(Camera).filter(
                    Camera.label == 'b1').one().sn2_threshold) * 100.0

            percent_done = min([min_r_percent, min_b_percent])

            if percent_done > 100.0:
                percent_done = 100.0

            return percent_done
        else:
            return 0

    def updateStatus(self):
        session = Session.object_session(self)

        cameras = ['r1', 'r2', 'b1', 'b2']

        exposureExcellent = 1
        # exposureBad = 2
        # exposureTest = 3
        # exposureText = ['', 'Excellent', 'Bad', 'Test']

        # flagAuto = session.query(PluggingStatus).filter_by(pk=0).one()
        flagGood = session.query(PluggingStatus).filter_by(pk=1).one()
        flagIncomplete = session.query(PluggingStatus).filter_by(pk=2).one()
        flagOverGood = session.query(PluggingStatus).filter_by(pk=3).one()
        flagOverIncomplete = session.query(PluggingStatus).filter_by(pk=4).one()

        # If plugging status is overwritten, nothing for us to calculate
        if self.status == flagOverGood or self.status == flagOverIncomplete:
            return 0

        exposures = session.query(Exposure).join(Observation).filter(
            Observation.plugging == self).all()

        for camName in cameras:
            try:
                camera = session.query(Camera).filter_by(label=camName).one()
                sn2Thresh = session.query(BossSN2Threshold).filter_by(camera=camera).one()

                sumsn2 = 0.0
                goodExposures = 0
                for exposure in exposures:
                    if exposure.status.pk != exposureExcellent:
                        continue
                    else:
                        goodExposures += 1

                    try:
                        cframe = session.query(CameraFrame).filter_by(
                            exposure=exposure).filter_by(camera=camera).one()

                        sn2 = cframe.sn2
                        if sn2 > sn2Thresh.sn2_min:
                            sumsn2 += float(sn2)
                    except sqlalchemy.orm.exc.MultipleResultsFound:
                        print('More than one CameraFrame found. '
                              'Expecting only one! \n\n')
                        raise
                    except (sqlalchemy.orm.exc.NoResultFound, KeyError):
                        print('!WARNING: Could not get sn2 from platedb')
                        pass
                    except:
                        print('Problem loading CameraFrame \n\n')
                        raise

                # Not enough sn2, plugging is incomplete
                if sumsn2 < float(sn2Thresh.sn2_threshold):
                    # Set the plugging status to incomplete
                    self.status = flagIncomplete
                    session.flush()
                    return

                # Not enough exposures, plugging is incomplete
                if goodExposures < float(sn2Thresh.min_exposures):
                    # Set the plugging status to incomplete
                    self.status = flagIncomplete
                    session.flush()
                    return

            except:
                print('Problem calculating sumsn2')
                raise

        # Set the plugging status to complete
        self.status = flagGood
        session.flush()

        return

    def mangaUpdateStatus(self, status):
        """Update the plugging status of manga exposures, based on Totoro."""

        session = Session.object_session(self)

        flagGood = session.query(PluggingStatus).filter_by(pk=1).one()
        flagIncomplete = session.query(PluggingStatus).filter_by(pk=2).one()

        if status:
            self.status = flagGood
        else:
            self.status = flagIncomplete

    def makeActive(self):
        """Makes the plugging active."""

        session = Session.object_session(self)

        cartNo = self.cartridge.number

        # Checks if the plate has already an active plugging
        platePK = self.plate.pk
        activePluggings = session.query(ActivePlugging).all()

        for aP in activePluggings:
            if aP.plugging.plate.pk == platePK and aP.plugging_pk != self.pk:
                warnings.warn(
                    'plate {0} is already loaded in cart {1} with a '
                    'different plugging. Removing previous active '
                    'plugging'.format(self.plate.plate_id,
                                      aP.plugging.cartridge.number), UserWarning)
                session.delete(aP)

        # Checks if the plugging is already active
        try:
            activePlugging = session.query(ActivePlugging).filter(
                ActivePlugging.plugging_pk == self.pk).one()
        except MultipleResultsFound:
            raise ActivePluggingException(
                'more than one active plugging for plugging pk={0}. '
                'This should never happen!'.format(self.pk))
        except NoResultFound:
            activePlugging = None

        # If plugging is already active, checks the cart number
        if activePlugging is not None:
            if activePlugging.pk != cartNo:
                raise ActivePluggingException(
                    'plugging pk={0} is already active but its cart number '
                    'does not match the one in the plugging ({1}!={2}). This '
                    'should never happen.'.format(self.pk, activePlugging.pk, cartNo))

            warnings.warn('plugging pk={0} is already active. '
                          'Not doing anything.'.format(self.pk), UserWarning)
            return activePlugging

        # Makes the plugging active
        activePlugging = session.query(ActivePlugging).get(cartNo)
        if activePlugging is not None:
            activePlugging.plugging_pk = self.pk
            session.flush()
        else:
            session.add(ActivePlugging(pk=cartNo, plugging_pk=self.pk))
            session.flush()

        # Check that it worked
        # Checks if the plugging is already active
        try:
            activePlugging = session.query(ActivePlugging).filter(
                ActivePlugging.plugging_pk == self.pk).one()
        except NoResultFound:
            raise ActivePluggingException(
                'something went wrong when trying to make plugging pk={0} '
                'active'.format(self.pk))

        return activePlugging


class ActivePlugging(Base):

    __tablename__ = 'active_plugging'

    def __repr__(self):
        return (f'<Active Plugging: plate={self.plugging.plate.plate_id}, '
                f'cartridge={self.plugging.cartridge.number}>')


class PlPlugMapM(Base):

    __tablename__ = 'pl_plugmap_m'

    def platePointing(self):
        # Class method that returns the session this object is in.
        session = Session.object_session(self)
        try:
            pp = session.query(PlatePointing).join(Plate, Plugging).filter(
                Plate.pk == self.plugging.plate.pk).filter(
                    PlatePointing.pointing_name == self.pointing_name).one()
        except sqlalchemy.orm.exc.NoResultFound:
            print(f'A plate pointing for a plugmap (pk={self.pk}) '
                  f'could not be found (plate id={self.plugging.plate.plate_id}, '
                  f'pk={self.plugging.plate.pk})')
            pp = None
        return pp

    def visibility(self):
        """Retrieves the visiblity range for this plate
        as a map with keys "ha_observable_min" and "ha_observable_max".
        Each value is an array of values corresponding to each pointing.
        """

        max_found = False
        min_found = False

        visibilities = dict()

        # Just loop over every line in the "file" until the two keys are found.
        # They're near the top, so it won't take long.
        for line in self.file.split('\n'):
            if line[0:17] == 'ha_observable_min':
                min_found = True
                visibilities['ha_observable_min'] = [float(x) for x in line[17:].split()]
            elif line[0:17] == 'ha_observable_max':
                visibilities['ha_observable_max'] = [float(x) for x in line[17:].split()]
                max_found = True

            if min_found and max_found:
                break

        return visibilities

    def __repr__(self):
        return f'<PlPlugMapM file: {self.filename} (id={self.pk})>'


class Plate(Base):
    __tablename__ = 'plate'

    def __repr__(self):
        return f'<Plate: plate_id={self.plate_id}>'

    def calculatedCompletionStatus(self):
        """Determine whether the plate is done from the pluggings on that plate."""

        if True not in ['boss' in survey.label.lower() for survey in self.surveys]:
            return 'n/a'

        if self.completionStatus.pk == 0:  # pk = 0 -> "Automatic"
            return self._automaticCompletionStatus()
        else:
            # If the status is "Force Complete" or "Force Incomplete",
            #   return that status
            return self.completionStatus.label

    def _automaticCompletionStatus(self):
        """If the plate completion status were automatic, is it complete or incomplete."""

        if True not in ['boss' in survey.label.lower() for survey in self.surveys]:
            return 'n/a'

        session = Session.object_session(self)
        plug_statuses = session.query(PluggingStatus.label).join(
            Plugging, Plate).filter(Plate.plate_id == self.plate_id).all()

        for status in [a[0] for a in plug_statuses]:
            if 'Good' in status:
                return 'Complete'

        return 'Incomplete'

    @property
    def firstPointing(self):
        return self.design.pointings[0]

    """
    # LEFT OFF HERE!
    def tilePlatesRecalculate(self, old_completion_status_pk, new_completion_status_pk):
        session = Session.object_session(self)
        if (old_completion_status_pk == 0 and new_completion_status_pk == 3 and
                self._automaticCompletionStatus() == 'Complete'):

            # Changing from Automatic (complete) to Force Incomplete

            # If the most recent entry in completion_status_history is by 'platedb'
            # and is 'Do Not Observe,' change the completion_status back to whatever
            # the entry before that one is.

            if len(self.completionStatusHistory) > 0:
                try:
                    mostRecentChange = self.completionStatusHistory[-1]
                    if mostRecentChange.first_name == 'platedb':
                        prevStatus_pk = self.completionStatusHistory[-2].plate_completion_status_pk
                        previousStatus = session.query(PlateCompletionStatus).filter(
                            PlateCompletionStatus.pk == prevStatus_pk).one()
                except IndexError:
                    # This could happen if the plate's completion status was only changed once from
                    # automatic -> do not observe by the script. In that case, the completion
                    # status should go back to automatic
                    previousStatus = session.query(PlateCompletionStatus).filter(
                        PlateCompletionStatus.pk == 0).one() # Automatic
                self.completionStatus = previousStatus
                session.flush()
    """


class Survey(Base):

    __tablename__ = 'survey'

    def display_string(self):
        if self.label is None:
            return self.plateplan_name
        else:
            return self.label

    def __repr__(self):
        return f'<Survey: {self.label} / {self.plateplan_name} (pk={self.pk})>'


class PlateRun(Base):

    __tablename__ = 'plate_run'

    def __repr__(self):
        return f'<PlateRun: {self.label!r} (pk={self.pk})>'


class PlateLocation(Base):

    __tablename__ = 'plate_location'


class PlateStatus(Base):

    __tablename__ = 'plate_status'

    def __repr__(self):
        return f'<PlateStatus: {self.label!r} (pk={self.pk})>'


class PlateToPlateStatus(Base):

    __tablename__ = 'plate_to_plate_status'


class PlateCompletionStatus(Base):

    __tablename__ = 'plate_completion_status'


class PlateCompletionStatusHistory(Base):

    __tablename__ = 'plate_completion_status_history'


class Tile(Base):

    __tablename__ = 'tile'

    def __repr__(self):
        return f'<Tile: id={self.id} (pk={self.pk})>'

    def calculatedCompletionStatus(self):
        """Determine whether the tile is done."""

        if self.status.pk == 0:
            plates = self.plates

            for plate in plates:
                if 'Complete' in plate.calculatedCompletionStatus():
                    return 'Complete'
                else:
                    pass

            return 'Incomplete'
        else:
            return self.status.label


class TileStatus(Base):

    __tablename__ = 'tile_status'


class TileStatusHistory(Base):

    __tablename__ = 'tile_status_history'


class PlateToSurvey(Base):

    __tablename__ = 'plate_to_survey'


class DesignValue(Base):

    __tablename__ = 'design_value'


class DesignField(Base):

    __tablename__ = 'design_field'


class Design(Base):

    __tablename__ = 'design'

    def __repr__(self):
        return f'<Design (pk={self.pk})>'

    @property
    def designDictionary(self):
        """Returns dictionary of key value pairs, as strings."""

        dv = {}
        for v in self.values:
            dv[v.field.label.lower()] = v.value

        return dv

    def no_science_targets(self):
        """Returns the number of science targets as a list for each pointing."""

        session = Session.object_session(
            self)  # class method that returns the session this object is in

        try:
            design_values = session.query(DesignValue).join(
                Design, DesignField).filter(DesignValue.design == self).filter(
                    DesignField.label.ilike('n%_science')).all()

            # create a list, initialized to 0, with the number of pointings
            science_targets = [0] * len(design_values[0].value.split())

            for design_value in design_values:
                for idx, value in enumerate(design_value.value.split()):
                    science_targets[idx] = science_targets[idx] + int(value)
            return science_targets
        except:
            return [0]

    def getDesignId(self):
        """Returns the designID of the plate, given the plate object."""

        session = Session.object_session(self)
        try:
            designId = session.query(DesignValue).join(
                Design, DesignField).filter(
                    DesignValue.design == self).filter(
                        DesignField.label.ilike('designid')).one()
            designId = designId.value
            return designId
        except:
            return -1

    def numPlates(self):
        """Returns the number of plates in a design, given the design object."""

        session = Session.object_session(self)
        try:
            numPlate = session.query(Plate).join(Design).filter(Plate.design == self).count()
            return numPlate
        except:
            return -1

    def numObservations(self):
        """Returns the number of observations for a design, given the design object."""

        session = Session.object_session(self)
        try:
            numObs = session.query(Observation).join(
                Plugging, Plate, Design).filter(Design.pk == self.pk).count()
            return numObs
        except:
            return -1

    def getRa(self):
        """Returns the ra and dec for a design, given the design object."""

        session = Session.object_session(self)
        try:
            ra = session.query(DesignValue).join(Design, DesignField).filter(
                DesignValue.design == self).filter(
                    DesignField.label.ilike('racen')).one()
            ra = ra.value
            return ra
        except:
            return -1

    def getDec(self):
        """Returns the ra and dec for a design, given the design object."""

        session = Session.object_session(self)
        try:
            dec = session.query(DesignValue).join(Design, DesignField).filter(
                DesignValue.design == self).filter(
                    DesignField.label.ilike('deccen')).one()
            dec = dec.value
            return dec
        except:
            return -1


class PluggingToInstrument(Base):

    __tablename__ = 'plugging_to_instrument'


class Exposure(Base):

    __tablename__ = 'exposure'

    def mjd(self):
        """Returns the *SDSS* MJD.

        See line ~140 (the mjd4Gang function) here for notes on this value.
        https://svn.sdss.org/deprecated/operations/iop/trunk/etc/iopUtils.tcl
        """

        return int(float(self.start_time) / 86400.0 + 0.3)

    def startTimeUT(self):

        return convert.mjd2ut(Decimal(self.start_time) / Decimal('86400'))

    def getHeaderValue(self, headerLabel):

        session = Session.object_session(self)
        try:
            keyValue = session.query(ExposureHeaderValue.value).join(
                Exposure, ExposureHeaderKeyword).filter(
                    Exposure.pk == self.pk).filter(
                        ExposureHeaderKeyword.label == headerLabel).first()

            return keyValue
        except:
            return '--'

    def whichLamp(self):
        session = Session.object_session(self)

        returnValue = '--'
        try:
            keyValue = session.query(ExposureHeaderValue).join(
                Exposure, ExposureHeaderKeyword).filter(Exposure.pk == self.pk).filter(
                    ExposureHeaderKeyword.label == 'LAMPTHAR').first()
            if keyValue.value.strip() == '1':
                returnValue = 'ThAr'

        except:
            pass

        try:
            keyValue = session.query(ExposureHeaderValue).join(
                Exposure, ExposureHeaderKeyword).filter(Exposure.pk == self.pk).filter(
                    ExposureHeaderKeyword.label == 'LAMPUNE').first()
            if keyValue.value.strip() == '1':
                returnValue = 'UNe'

        except:
            pass
        try:
            keyValue = session.query(ExposureHeaderValue).join(
                Exposure, ExposureHeaderKeyword).filter(Exposure.pk == self.pk).filter(
                    ExposureHeaderKeyword.label == 'LAMPQRTZ').first()
            if keyValue.value.strip() == '1':
                returnValue = 'QRTZ'
        except:
            pass

        return returnValue

    def calcSecZ(self):

        session = Session.object_session(self)

        try:
            keyValue = session.query(ExposureHeaderValue).join(
                Exposure, ExposureHeaderKeyword).filter(
                    Exposure.pk == self.pk).filter(
                        ExposureHeaderKeyword.label == 'ALT').first()
            secZ = 1 / math.cos(90.0 - float(keyValue.value))
            return round(secZ, 3)
        except:
            return '--'


class ExposureFlavor(Base):

    __tablename__ = 'exposure_flavor'

    def __repr__(self):
        return f'<ExposureFlavor: {self.label} (pk={self.pk})>'


class ExposureStatus(Base):

    __tablename__ = 'exposure_status'

    def __repr__(self):
        return f'<ExposureStatus: {self.label} (pk={self.pk})>'


class CameraFrame(Base):

    __tablename__ = 'camera_frame'


class Observation(Base):

    __tablename__ = 'observation'

    def startTime(self):

        session = Session.object_session(self)

        try:
            start_time = session.query(func.min(Exposure.start_time)).join(
                Observation).filter(Exposure.observation == self).one()
        except BaseException:
            return None

        return start_time[0]

    def endTime(self):
        session = Session.object_session(self)

        try:
            end_time = session.query(func.max(func.sum(Exposure.start_time,
                                                       Exposure.exposure_time))).join(
                Observation).filter(Exposure.observation == self).one()
        except:
            return None

        return end_time[0]

    def sumOfCamera(self, cameraLabel, mjd=None):

        if mjd is not None:
            totsn2 = sum([
                sum([cf.sn2 for cf in x.cameraFrames
                     if (cf.camera.label == cameraLabel and
                         cf.exposure.flavor.label == 'Science' and
                         cf.exposure.status.label == 'Good' and
                         cf.sn2 > 0.2)])
                for x in self.exposures if mjd == int(x.start_time / (24 * 60 * 60))])
        else:
            totsn2 = sum([sum([cf.sn2 for cf in x.cameraFrames
                               if (cf.camera.label == cameraLabel and
                                   cf.exposure.flavor.label == 'Science' and
                                   cf.exposure.status.label == 'Good' and
                                   cf.sn2 > 0.2)]) for x in self.exposures])

        return totsn2

    def numOfScienceExposures(self):

        session = Session.object_session(self)

        try:
            value = session.query(Exposure).join(ExposureFlavor).filter(
                Exposure.observation_pk == self.pk).filter(
                    ExposureFlavor.label == 'Science').count()
            return value
        except:
            return -1

    def numOfObjectExposures(self):
        session = Session.object_session(self)

        try:
            value = session.query(Exposure).join(ExposureFlavor).filter(
                Exposure.observation_pk == self.pk).filter(
                    ExposureFlavor.label == 'Object').count()
            return value
        except:
            return -1

    def numOfApogeePlates(self):
        session = Session.object_session(self)

        try:
            value = session.query(Plate).join(
                Plugging, Observation, PlateToSurvey, Survey).filter(
                    Observation.mjd == self.mjd).filter(Survey.label == 'APOGEE').count()
            return value
        except:
            return -1

    def __repr__(self):
        return f'<Observation: mjd = {self.mjd} (pk={self.pk})>'


class ObservationStatus(Base):

    __tablename__ = 'observation_status'

    def __repr__(self):
        return f'<ObservationStatus: {self.label} (pk={self.pk})>'


class Pointing(Base):

    __tablename__ = 'pointing'

    def platePointing(self, plateid):
        session = Session.object_session(self)
        try:
            pp = session.query(PlatePointing).join(Plate, Pointing).filter(
                Pointing.pk == self.pk).filter(Plate.plate_id == plateid).one()
        except sqlalchemy.orm.exc.NoResultFound:
            print(f'A PlatePointing record for this pointing (pk={self.pk}) '
                  f'was not be found (plate id={self.plate_id}).')
            print('It looks like that plate needs to be loaded into the database '
                  '(see $PLATEDB_DIR/bin/platePlans2db.py)')
            pp = None
        return pp


class PlateInput(Base):

    __tablename__ = 'plate_input'


class PlatePointing(Base):

    __tablename__ = 'plate_pointing'

    def __repr__(self):
        return (f'<PlatePointing: plate={self.plate.plate_id}, '
                f'pointing={self.pointing_name} (id={self.pk}])>')

    def times(self, datetimeObj):
        times_for_pp = dict()

        # All in degrees
        ra = float(self.pointing.center_ra)
        ha = float(self.hour_angle)
        LST = (ra + ha) / 15.0  # convert to hours

        gmst_h, gmst_m, gmst_s = convert.lst2gmst(apo_lon, LST)
        utc = convert.gmst2utcDatetime(
            datetime.datetime(datetimeObj.year, datetimeObj.month,
                              datetimeObj.day, gmst_h, gmst_m, int(gmst_s)))

        times_for_pp['nominal'] = utc

        try:
            # Error is thrown when ha_min or ha_max == None (i.e. not available)
            ha_min = float(self.ha_observable_min)
            ha_max = float(self.ha_observable_max)

            LST_min = (ra + ha_min) / 15.0  # convert to hours
            gmst_min_h, gmst_min_m, gmst_min_s = convert.lst2gmst(apo_lon, LST_min)
            utc_min = convert.gmst2utcDatetime(
                datetime.datetime(datetimeObj.year, datetimeObj.month,
                                  datetimeObj.day, gmst_min_h, gmst_min_m,
                                  int(gmst_min_s)))

            LST_max = (ra + ha_max) / 15.0  # convert to hours
            gmst_max_h, gmst_max_m, gmst_max_s = convert.lst2gmst(apo_lon, LST_max)
            utc_max = convert.gmst2utcDatetime(
                datetime.datetime(datetimeObj.year,
                                  datetimeObj.month,
                                  datetimeObj.day,
                                  gmst_max_h,
                                  gmst_max_m,
                                  int(gmst_max_s)))

            times_for_pp['min'] = utc_min
            times_for_pp['max'] = utc_max

        except TypeError:
            # default to +- 1hr if values not found in database
            times_for_pp['min'] = utc + datetime.timedelta(hours=-1)
            times_for_pp['max'] = utc + datetime.timedelta(hours=+1)

        # correct for dates crossing the day line
        if times_for_pp['min'] > times_for_pp['nominal']:
            times_for_pp['min'] = times_for_pp['min'] + datetime.timedelta(days=-1)

        if times_for_pp['max'] < times_for_pp['nominal']:
            times_for_pp['max'] = times_for_pp['max'] + datetime.timedelta(days=+1)

        return times_for_pp

    def skyBrightness(self, datetimeObj=None, mjd=None):
        if datetimeObj is None and mjd is None:
            return None
        elif mjd is None and datetimeObj is not None:
            mjd = convert.datetime2mjd(datetimeObj)
        elif datetimeObj is None and mjd is not None:
            mjd = float(mjd)
        else:
            return None

        # Create an RADec object for the current pointing
        ra = float(self.pointing.center_ra)
        dec = float(self.pointing.center_dec)

        skyMag = Moon.mjdRADec2skyBright(mjd, ra, dec)

        if skyMag == 0.0:
            skyMag = '--'
        else:
            skyMag = '%.1f' % skyMag

        return skyMag

    def HA(self, datetimeObj=datetime.datetime.now()):
        # Compute the hour angle of the platePointing for the given datetime object
        gmstDatetime = convert.utcDatetime2gmst(datetimeObj)
        lst = convert.gmstDatetime2lstDatetime(apo_lon, gmstDatetime)

        lstDegrees = convert.datetime2decimalTime(lst) * 15.0
        ha = lstDegrees - float(self.pointing.center_ra)

        if ha < -180.0:
            ha += 360.0
        elif ha > 180.0:
            ha -= 360.0

        return ha

    def altitude(self, datetimeObj=datetime.datetime.now()):
        ra = float(self.pointing.center_ra)
        dec = float(self.pointing.center_dec)
        alt, az = convert.raDec2AltAz(ra, dec, apo_lat, apo_lon, datetimeObj)

        return alt

    def azimuth(self, datetimeObj=datetime.datetime.now()):
        ra = float(self.pointing.center_ra)
        dec = float(self.pointing.center_dec)
        alt, az = convert.raDec2AltAz(ra, dec, apo_lat, apo_lon, datetimeObj)

        return az


class PlatePointingToPointingStatus(Base):

    __tablename__ = 'plate_pointing_to_pointing_status'


class PointingStatus(Base):

    __tablename__ = 'pointing_status'


class Instrument(Base):

    __tablename__ = 'instrument'


class Profilometry(Base):

    __tablename__ = 'profilometry'


class ProfilometryMeasurement(Base):

    __tablename__ = 'prof_measurement'

    def __repr__(self):
        return (f'<ProfilometryMeasurement: '
                f'Num: {self.number}, '
                f'({self.r1}, {self.r2}, {self.r3}, {self.r4}, {self.r5})>')


class ProfilometryTolerances(Base):

    __tablename__ = 'prof_tolerances'


class Camera(Base):

    __tablename__ = 'camera'


class BossSN2Threshold(Base):

    __tablename__ = 'boss_sn2_threshold'


class BossPluggingInfo(Base):

    __tablename__ = 'boss_plugging_info'


class PluggingStatus(Base):

    __tablename__ = 'plugging_status'


class PlateHolesFile(Base):

    __tablename__ = 'plate_holes_file'

    def __repr__(self):
        return f'<PlateHolesFile: pk={self.pk}>'


class Fiber(Base):

    __tablename__ = 'fiber'

    def __repr__(self):
        return f'<Fiber: number:{self.fiber_id} pk={self.pk}>'


class ExposureHeaderValue(Base):

    __tablename__ = 'exposure_header_value'

    def keyword(self):
        if self.keyword is None:
            return None
        else:
            return self.keyword.label

    def __repr__(self):
        return f'<ExposureHeaderValue: {self.value} (keyword={self.keyword.label}) pk={self.pk}>'


class ExposureHeaderKeyword(Base):

    __tablename__ = 'exposure_header_keyword'

    def __repr__(self):
        return f'<ExposureHeaderKeyword: {self.label} (pk={self.pk})>'


class PlateHole(Base):

    __tablename__ = 'plate_hole'

    def __repr__(self):
        return f'<PlateHole: ({self.xfocal}, {self.yfocal}) pk={self.pl}>'


class CmmMeas(Base):

    __tablename__ = 'cmm_meas'

    def getHoles(self, label):
        """Returns a list of holes with plateHoleType.label == label."""

        session = Session.object_session(self)
        return session.query(PlateHole).join(HoleMeas, PlateHoleType, CmmMeas).filter(
            CmmMeas.pk == self.pk, PlateHoleType.label == label).all()

    def __repr__(self):
        return f'<CmmMeas pk={self.pk}>'


class HoleMeas(Base):

    __tablename__ = 'hole_meas'

    def __repr__(self):
        return f'<HoleMeas: pk={self.pk}>'


class PlateHoleType(Base):

    __tablename__ = 'plate_hole_type'

    def __repr__(self):
        return f'<PlateHoleType: {self.label} (pk={self.pk})>'


class ObjectType(Base):

    __tablename__ = 'object_type'

    def __repr__(self):
        return f'<ObjectType: {self.label} (pk={self.pk})>'


class ApogeeThreshold(Base):

    __tablename__ = 'apogee_threshold'

    def __repr__(self):
        return f'<ApogeeThreshold: pk={self.pk}>'


class SurveyMode(Base):

    __tablename__ = 'survey_mode'


def define_relations():
    """Defines the relations between tables.

    This function is called when the base is prepared. It must be added as the
    ``_define_relations`` attribute to the base.

    """

    PlateRun.plates = relation(Plate, order_by=Plate.plate_id, backref='platerun')

    Plate.design = relation(Design, primaryjoin=(Plate.design_pk == Design.pk), backref='plate')
    Plate.location = relation(PlateLocation, backref='plates')
    Plate.surveys = relation(Survey, secondary=PlateToSurvey.__table__, backref='plates')
    Plate.pluggings = relation(Plugging, order_by=Plugging.fscan_mjd, backref='plate')
    Plate.cmmMeasurements = relation(CmmMeas, backref='plate')
    Plate.currentSurveyMode = relation(SurveyMode,
                                       primaryjoin=(Plate.current_survey_mode_pk == SurveyMode.pk),
                                       backref='plates')

    PlatePointing.plate = relation(Plate, backref='plate_pointings')
    PlatePointing.pointing = relation(Pointing, backref='plate_pointings')
    PlatePointing.observations = relation(Observation, order_by='Observation.mjd.desc()',
                                          backref='plate_pointing')

    Plate.statuses = relation('PlateStatus',
                              secondary=PlateToPlateStatus.__table__,
                              backref='plates')
    Plate.completionStatus = relation(PlateCompletionStatus, backref='plates')

    PlateCompletionStatusHistory.plate = relation(Plate, backref='completionStatusHistory')
    PlateCompletionStatusHistory.completionStatus = relation(
        PlateCompletionStatus, backref='completionStatusHistory')

    Tile.plates = relation(Plate, order_by=Plate.plate_id, backref='tile')
    Tile.status = relation(TileStatus, backref='tiles')

    TileStatusHistory.tile = relation(Tile, backref='statusHistory')
    TileStatusHistory.status = relation(TileStatus, backref='statusHistory')

    Tile.ra = lambda self: self.plates[0].plate_pointings[0].pointing.center_ra
    Tile.dec = lambda self: self.plates[0].plate_pointings[0].pointing.center_dec

    Design.pointings = relation(Pointing, backref='design')
    Design.values = relation(DesignValue, backref='design')
    Design.inputs = relation(PlateInput, backref='design')

    DesignValue.field = relation(DesignField, backref='design_values')

    Plugging.cartridge = relation(Cartridge, backref='pluggings')
    Plugging.plplugmapm = relation(PlPlugMapM, backref='plugging')
    Plugging.instruments = relation(Instrument,
                                    secondary=PluggingToInstrument.__table__,
                                    backref='pluggings')
    Plugging.observations = relation(Observation, backref='plugging')
    Plugging.activePlugging = relation(ActivePlugging, backref='plugging')
    Plugging.status = relation(PluggingStatus, backref='pluggings')

    Observation.status = relation(ObservationStatus, backref='observations')
    Observation.exposures = relation(Exposure,
                                     backref='observation',
                                     order_by=(Exposure.start_time, Exposure.exposure_no))

    Exposure.camera = relation(Camera, backref='exposures')
    Exposure.survey = relation(Survey, backref='exposures')
    Exposure.flavor = relation(ExposureFlavor, backref='exposures')
    Exposure.status = relation(ExposureStatus, backref='exposures')
    Exposure.headerValues = relation(ExposureHeaderValue,
                                     order_by='ExposureHeaderValue.index',
                                     backref='exposure')
    ExposureHeaderValue.header = relation(ExposureHeaderKeyword, backref='headerValues')
    Exposure.surveyMode = relation(SurveyMode, backref='exposures')

    Camera.instrument = relation(Instrument, backref='cameras')

    CameraFrame.camera = relation(Camera, backref='cameraFrames')
    CameraFrame.exposure = relation(Exposure, backref='cameraFrames')

    Gprobe.cartridge = relation(Cartridge, backref='gprobes')

    BossPluggingInfo.plugging = relation(Plugging, backref='bossPluggingInfo')

    BossSN2Threshold.camera = relation(Camera, backref='bossSN2Threshold')

    Profilometry.plugging = relation(Plugging, backref='profilometries')
    Profilometry.measurements = relation(ProfilometryMeasurement,
                                         backref='profilometry',
                                         order_by='ProfilometryMeasurement.number',
                                         cascade='all, delete, delete-orphan')
    Profilometry.tolerances = relation(ProfilometryTolerances, backref='profilometry')
    ProfilometryTolerances.survey = relation(Survey, backref='profilometry_tolerances')

    PlateHolesFile.plate = relation(Plate, backref='plateHolesFile')

    PlPlugMapM.fibers = relation(Fiber, backref='plPlugMapM')

    Fiber.plateHoles = relation(PlateHole, backref='fiber')

    PlateHole.plateHoleType = relation(PlateHoleType, backref='plateHole')
    PlateHole.plateHolesFile = relation(PlateHolesFile, backref='plateHole')
    PlateHole.objectType = relation(ObjectType, backref='plateHole')

    CmmMeas.measHoles = relation(HoleMeas, backref='cmmMeas')

    HoleMeas.plateHole = relation(PlateHole, backref='holeMeas')


# Adds the base to the database connection.
database.add_base(Base)
