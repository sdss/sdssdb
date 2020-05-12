#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: platedb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from peewee import (BigIntegerField, BooleanField, CharField, CompositeKey, DateField,
                    DateTimeField, DeferredThroughModel, FloatField, ForeignKeyField,
                    IntegerField, ManyToManyField, PrimaryKeyField, TextField)

from . import OperationsDBModel, database  # noqa


class UnknownField(object):

    def __init__(self, *_, **__):
        pass


class Cartridge(OperationsDBModel):
    broken_fibers = TextField(null=True)
    guide_fiber_throughput = FloatField(null=True)
    number = IntegerField(null=True, unique=True)
    online = BooleanField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'cartridge'
        schema = 'platedb'


class Design(OperationsDBModel):
    comment = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'design'
        schema = 'platedb'

    def get_value_for_field(self, field):
        """Returns the value of a design field."""

        design_field = DesignField.select().where(DesignField.label == field.lower()).first()
        if design_field is None:
            raise ValueError('invalid field name')

        return DesignValue.select().where((DesignValue.design == self) &
                                          (DesignValue.field == design_field)).first()


class PlateCompletionStatus(OperationsDBModel):
    label = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'plate_completion_status'
        schema = 'platedb'


class PlateLocation(OperationsDBModel):
    label = TextField(unique=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'plate_location'
        schema = 'platedb'


class PlateRun(OperationsDBModel):
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()
    year = IntegerField(null=True)

    class Meta:
        db_table = 'plate_run'
        schema = 'platedb'


class TileStatus(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'tile_status'
        schema = 'platedb'


class Tile(OperationsDBModel):
    pk = PrimaryKeyField()
    id = IntegerField()
    tile_status = ForeignKeyField(column_name='tile_status_pk',
                                  model=TileStatus,
                                  backref='tiles',
                                  field='pk')

    class Meta:
        db_table = 'tile'
        schema = 'platedb'


class SurveyMode(OperationsDBModel):
    definition_label = TextField(null=True)
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'survey_mode'
        schema = 'platedb'


class Survey(OperationsDBModel):
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()
    plateplan_name = TextField()

    class Meta:
        db_table = 'survey'
        schema = 'platedb'


class PlateStatus(OperationsDBModel):
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'plate_status'
        schema = 'platedb'


PlateSurveyThroughModel = DeferredThroughModel()
PlateStatusThroughModel = DeferredThroughModel()


class Plate(OperationsDBModel):

    chunk = TextField(null=True)
    comment = TextField(null=True)
    current_survey_mode = ForeignKeyField(column_name='current_survey_mode_pk',
                                          null=True,
                                          model=SurveyMode,
                                          field='pk')
    design = ForeignKeyField(column_name='design_pk',
                             null=True,
                             model=Design,
                             backref='plates',
                             field='pk')
    epoch = FloatField(null=True)
    location_id = BigIntegerField(column_name='location_id', null=True)
    name = TextField(null=True)
    pk = PrimaryKeyField()
    plate_completion_status_pk = ForeignKeyField(
        column_name='plate_completion_status_pk',
        null=True,
        model=PlateCompletionStatus,
        backref='plates',
        field='pk')
    plate_id = IntegerField(column_name='plate_id', unique=True)
    plate_location = ForeignKeyField(column_name='plate_location_pk',
                                     model=PlateLocation,
                                     field='pk')
    plate_run = ForeignKeyField(column_name='plate_run_pk',
                                null=True,
                                model=PlateRun,
                                field='pk')
    rerun = TextField(null=True)
    temperature = FloatField(null=True)
    tile_id = IntegerField(column_name='tile_id', null=True)
    tile = ForeignKeyField(column_name='tile_pk',
                           null=True,
                           model=Tile,
                           backref='plates',
                           field='pk')
    surveys = ManyToManyField(model=Survey,
                              through_model=PlateSurveyThroughModel,
                              backref='plates')
    statuses = ManyToManyField(model=PlateStatus,
                               through_model=PlateStatusThroughModel,
                               backref='plates')

    @property
    def mangadb_plate(self):
        """One-to-one backref for mangadb.plate.platedb_plate."""

        from sdssdb.peewee.operationsdb import mangadb

        return mangadb.Plate.get_or_none(platedb_plate_pk=self.pk)

    class Meta:
        db_table = 'plate'
        schema = 'platedb'
        print_fields = ['plate_id']


class PluggingStatus(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'plugging_status'
        schema = 'platedb'


class Instrument(OperationsDBModel):
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()
    short_label = TextField(null=True)

    class Meta:
        db_table = 'instrument'
        schema = 'platedb'


PluggingInstrumentDeferred = DeferredThroughModel()


class Plugging(OperationsDBModel):
    cartridge = ForeignKeyField(column_name='cartridge_pk',
                                null=True,
                                model=Cartridge,
                                backref='pluggings',
                                field='pk')
    fscan = IntegerField(column_name='fscan_id', null=True)
    fscan_mjd = IntegerField(null=True)
    name = TextField(null=True)
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk',
                            model=Plate,
                            backref='pluggings',
                            field='pk')
    status = ForeignKeyField(column_name='plugging_status_pk',
                             model=PluggingStatus, field='pk',
                             backref='pluggings')

    instruments = ManyToManyField(model=Instrument,
                                  through_model=PluggingInstrumentDeferred,
                                  backref='pluggings')

    class Meta:
        db_table = 'plugging'
        schema = 'platedb'


class ActivePlugging(OperationsDBModel):
    pk = PrimaryKeyField()
    plugging = ForeignKeyField(column_name='plugging_pk', model=Plugging,
                               backref='active_plugging',
                               field='pk', unique=True)

    class Meta:
        db_table = 'active_plugging'
        schema = 'platedb'


class ApogeeThreshold(OperationsDBModel):
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'apogee_threshold'
        schema = 'platedb'


class BossPluggingInfo(OperationsDBModel):
    first_dr = TextField(null=True)
    pk = PrimaryKeyField()
    plugging = ForeignKeyField(column_name='plugging_pk', model=Plugging,
                               backref='boss_plugging_info', field='pk')

    class Meta:
        db_table = 'boss_plugging_info'
        schema = 'platedb'


class Camera(OperationsDBModel):
    instrument = ForeignKeyField(column_name='instrument_pk', null=True,
                                 model=Instrument,
                                 backref='cameras', field='pk')
    label = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'camera'
        schema = 'platedb'


class BossSn2Threshold(OperationsDBModel):
    camera = ForeignKeyField(column_name='camera_pk', model=Camera,
                             backref='boss_sn2_thresholds', field='pk')
    min_exposures = IntegerField(null=True)
    pk = PrimaryKeyField()
    sn2_min = FloatField(null=True)
    sn2_threshold = FloatField()
    version = IntegerField(null=True)

    class Meta:
        db_table = 'boss_sn2_threshold'
        schema = 'platedb'


class ExposureFlavor(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'exposure_flavor'
        schema = 'platedb'


class ExposureStatus(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'exposure_status'
        schema = 'platedb'


class Pointing(OperationsDBModel):
    center_dec = FloatField(null=True)
    center_ra = FloatField(null=True)
    design = ForeignKeyField(column_name='design_pk', model=Design,
                             backref='pointings', field='pk')
    pk = PrimaryKeyField()
    pointing_no = IntegerField(null=True)

    class Meta:
        db_table = 'pointing'
        schema = 'platedb'


class PlatePointing(OperationsDBModel):
    ha_observable_max = FloatField(null=True)
    ha_observable_min = FloatField(null=True)
    hour_angle = FloatField(null=True)
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk', null=True, model=Plate,
                            backref='plate_pointings', field='pk')
    pointing_name = CharField(null=False)
    pointing = ForeignKeyField(column_name='pointing_pk', null=True,
                               model=Pointing, field='pk',
                               backref='plate_pointings')
    priority = IntegerField()

    class Meta:
        db_table = 'plate_pointing'
        indexes = (
            (('plate_pk', 'pointing_name'), True),
        )
        schema = 'platedb'


class ObservationStatus(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'observation_status'
        schema = 'platedb'


class Observation(OperationsDBModel):
    comment = TextField(null=True)
    mjd = FloatField(null=True)
    observation_status = ForeignKeyField(column_name='observation_status_pk',
                                         model=ObservationStatus,
                                         backref='observations',
                                         field='pk')
    pk = PrimaryKeyField()
    plate_pointing = ForeignKeyField(column_name='plate_pointing_pk', null=True,
                                     model=PlatePointing,
                                     backref='observtions', field='pk')
    plugging = ForeignKeyField(column_name='plugging_pk', null=True,
                               model=Plugging, backref='observations', field='pk')

    class Meta:
        db_table = 'observation'
        schema = 'platedb'


class Exposure(OperationsDBModel):
    camera = ForeignKeyField(column_name='camera_pk', null=True,
                             model=Camera, backref='exposures', field='pk')
    comment = TextField(null=True)
    exposure_flavor = ForeignKeyField(column_name='exposure_flavor_pk',
                                      null=True,
                                      model=ExposureFlavor,
                                      field='pk')
    exposure_no = IntegerField(null=True)
    exposure_status = ForeignKeyField(column_name='exposure_status_pk',
                                      model=ExposureStatus,
                                      field='pk')
    exposure_time = FloatField(null=True)
    observation = ForeignKeyField(column_name='observation_pk', null=True, model=Observation,
                                  backref='exposures', field='pk')
    pk = PrimaryKeyField()
    start_time = FloatField(null=True)
    survey_mode = ForeignKeyField(column_name='survey_mode_pk',
                                  null=True, model=SurveyMode, field='pk')
    survey = ForeignKeyField(column_name='survey_pk', null=True,
                             model=Survey, backref='exposures', field='pk')

    class Meta:
        db_table = 'exposure'
        indexes = (
            (('exposure_no', 'survey_pk'), True),
        )
        schema = 'platedb'


class CameraFrame(OperationsDBModel):
    camera = ForeignKeyField(column_name='camera_pk', model=Camera,
                             backref='camera_frames', field='pk')
    comment = TextField(null=True)
    exposure = ForeignKeyField(column_name='exposure_pk', model=Exposure,
                               backref='camera_frames', field='pk')
    pk = PrimaryKeyField()
    sn2 = FloatField(null=True)

    class Meta:
        db_table = 'camera_frame'
        schema = 'platedb'


# class CartridgeToSurvey(OperationsDBModel):
#     cartridge_pk = ForeignKeyField(column_name='cartridge_pk', model=Cartridge,
#                                    backref='cartridge_cartridge_pk_set', field='pk')
#     survey_pk = ForeignKeyField(column_name='survey_pk', model=Survey,
#                                 backref='survey_survey_pk_set', field='pk')
#
#     class Meta:
#         db_table = 'cartridge_to_survey'
#         indexes = (
#             (('cartridge_pk', 'survey_pk'), True),
#         )
#         schema = 'platedb'
#         primary_key = CompositeKey('cartridge_pk', 'survey_pk')


class CmmMeas(OperationsDBModel):
    cmmfilename = TextField(null=True)
    date = DateField(null=True)
    fitoffsetx = FloatField(null=True)
    fitoffsety = FloatField(null=True)
    fitqpang = FloatField(null=True)
    fitqpmag = FloatField(null=True)
    fitrot = FloatField(null=True)
    fitscale = FloatField(null=True)
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk', null=True, model=Plate,
                            backref='cmm_measurements', field='pk')

    class Meta:
        db_table = 'cmm_meas'
        schema = 'platedb'


class Constants(OperationsDBModel):
    name = CharField(primary_key=True)
    value = CharField(null=True)

    class Meta:
        db_table = 'constants'
        schema = 'platedb'


class DesignField(OperationsDBModel):
    label = TextField(unique=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'design_field'
        schema = 'platedb'


class DesignValue(OperationsDBModel):
    field = ForeignKeyField(column_name='design_field_pk',
                            null=True, model=DesignField, field='pk')
    design = ForeignKeyField(column_name='design_pk', null=True,
                             model=Design, backref='values', field='pk')
    pk = PrimaryKeyField()
    value = TextField(null=True)

    class Meta:
        db_table = 'design_value'
        indexes = ((('design_pk', 'design_field_pk'), True),)
        schema = 'platedb'

    def __repr__(self):
        return '<DesignValue: pk={0}, design={1}, field={2}, value={3}>'.format(self.pk,
                                                                                self.design_pk,
                                                                                self.field.label,
                                                                                self.value)


class ExposureHeaderKeyword(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'exposure_header_keyword'
        schema = 'platedb'


class ExposureHeaderValue(OperationsDBModel):
    comment = TextField(null=True)
    exposure_header_keyword = ForeignKeyField(column_name='exposure_header_keyword_pk',
                                              model=ExposureHeaderKeyword,
                                              field='pk')
    exposure = ForeignKeyField(column_name='exposure_pk', model=Exposure,
                               backref='exposure_header_values', field='pk')
    index = IntegerField()
    pk = PrimaryKeyField()
    value = TextField()

    class Meta:
        db_table = 'exposure_header_value'
        schema = 'platedb'


class PlPlugmapM(OperationsDBModel):
    checked_in = BooleanField(null=True)
    dirname = TextField(null=True)
    file = TextField(null=True)
    filename = TextField(null=True)
    fscan = IntegerField(column_name='fscan_id', null=True)
    fscan_mjd = IntegerField(null=True)
    md5_checksum = TextField(null=True)
    pk = PrimaryKeyField()
    plugging = ForeignKeyField(column_name='plugging_pk', null=True,
                               model=Plugging, backref='plplugmapms', field='pk')
    pointing_name = CharField(null=True)

    class Meta:
        db_table = 'pl_plugmap_m'
        schema = 'platedb'


class ObjectType(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'object_type'
        schema = 'platedb'


class PlateHoleType(OperationsDBModel):
    label = TextField()
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'plate_hole_type'
        schema = 'platedb'


class PlateHolesFile(OperationsDBModel):
    filename = TextField()
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk', model=Plate,
                            backref='plate_hole_files', field='pk')

    class Meta:
        db_table = 'plate_holes_file'
        schema = 'platedb'


class PlateHole(OperationsDBModel):
    apogee_target1 = IntegerField(null=True)
    apogee_target2 = IntegerField(null=True)
    catalog_object_pk = IntegerField(index=True, null=True)
    object_type = ForeignKeyField(column_name='object_type_pk',
                                  null=True, model=ObjectType, field='pk')
    pk = PrimaryKeyField()
    plate_hole_type = ForeignKeyField(column_name='plate_hole_type_pk',
                                      null=True,
                                      model=PlateHoleType,
                                      field='pk')
    plate_holes_file = ForeignKeyField(column_name='plate_holes_file_pk',
                                       null=True,
                                       model=PlateHolesFile,
                                       field='pk',
                                       backref='plate_holes')
    pointing_number = IntegerField(null=True)
    tmass_h = FloatField(null=True)
    tmass_j = FloatField(null=True)
    tmass_k = FloatField(null=True)
    xfocal = FloatField(null=True)
    yfocal = FloatField(null=True)

    class Meta:
        db_table = 'plate_hole'
        schema = 'platedb'


class Fiber(OperationsDBModel):
    fiber = IntegerField(column_name='fiber_id')
    pk = PrimaryKeyField()
    pl_plugmap_m = ForeignKeyField(column_name='pl_plugmap_m_pk',
                                   model=PlPlugmapM, field='pk')
    plate_hole = ForeignKeyField(column_name='plate_hole_pk', model=PlateHole,
                                 backref='fibers', field='pk')

    class Meta:
        db_table = 'fiber'
        schema = 'platedb'


class Gprobe(OperationsDBModel):
    cartridge = ForeignKeyField(column_name='cartridge_pk', null=True, model=Cartridge,
                                backref='gprobes', field='pk')
    exists = IntegerField(null=True)
    fiber_type = UnknownField()  # USER-DEFINED
    focus_offset = FloatField(null=True)
    gprobe = IntegerField(column_name='gprobe_id', null=True)
    pk = PrimaryKeyField()
    radius = FloatField(null=True)
    rotation = FloatField(null=True)
    x_center = FloatField(null=True)
    x_ferrule_offset = FloatField(null=True)
    y_center = FloatField(null=True)
    y_ferrule_offset = FloatField(null=True)

    class Meta:
        db_table = 'gprobe'
        schema = 'platedb'


class HoleMeas(OperationsDBModel):
    cmm_meas = ForeignKeyField(column_name='cmm_meas_pk', null=True,
                               model=CmmMeas, field='pk')
    diaerr = FloatField(null=True)
    measx = FloatField(null=True)
    measy = FloatField(null=True)
    nomdia = FloatField(null=True)
    nomx = FloatField(null=True)
    nomy = FloatField(null=True)
    pk = PrimaryKeyField()
    plate_hole = ForeignKeyField(column_name='plate_hole_pk', null=True, model=PlateHole,
                                 backref='hole_measurements', field='pk')
    qpresidr = FloatField(null=True)
    qpresidx = FloatField(null=True)
    qpresidy = FloatField(null=True)
    residr = FloatField(null=True)
    residx = FloatField(null=True)
    residy = FloatField(null=True)

    class Meta:
        db_table = 'hole_meas'
        schema = 'platedb'


class PlateCompletionStatusHistory(OperationsDBModel):
    comment = TextField()
    first_name = TextField(null=True)
    last_name = TextField(null=True)
    pk = PrimaryKeyField()
    plate_completion_status = ForeignKeyField(column_name='plate_completion_status_pk',
                                              model=PlateCompletionStatus,
                                              backref='plate_completion_status_history',
                                              field='pk')
    plate = ForeignKeyField(column_name='plate_pk', model=Plate,
                            backref='plate_completion_status_history', field='pk')
    timestamp = DateTimeField()

    class Meta:
        db_table = 'plate_completion_status_history'
        schema = 'platedb'


class PlateInput(OperationsDBModel):
    comment = TextField(null=True)
    design = ForeignKeyField(column_name='design_pk', null=True,
                             model=Design, backref='inputs', field='pk')
    filepath = TextField(null=True)
    input_number = IntegerField(null=True)
    md5_checksum = TextField(null=True)
    pk = PrimaryKeyField()
    priority = IntegerField(null=True)

    class Meta:
        db_table = 'plate_input'
        schema = 'platedb'


# class PlatePointingToPointingStatus(OperationsDBModel):
#     pk = BigIntegerField(primary_key=True)
#     plate_pointing_pk = ForeignKeyField(column_name='plate_pointing_pk',
#                                         null=True,
#                                         model=PlatePointing,
#                                         backref='plate_pointing_plate_pointing_pk_set',
#                                         field='pk')
#     pointing_status_pk = ForeignKeyField(
#         column_name='pointing_status_pk', null=True, model=PlateStatus, field='pk')
#
#     class Meta:
#         db_table = 'plate_pointing_to_pointing_status'
#         indexes = (
#             (('plate_pointing_pk', 'pointing_status_pk'), True),
#         )
#         schema = 'platedb'


class PlateRunToDesign(OperationsDBModel):
    design_pk = BigIntegerField(null=True)
    pk = PrimaryKeyField()
    plate_run_pk = BigIntegerField(null=True)

    class Meta:
        db_table = 'plate_run_to_design'
        indexes = (
            (('plate_run_pk', 'design_pk'), True),
        )
        schema = 'platedb'


# class PlateToInstrument(OperationsDBModel):
#     instrument_pk = ForeignKeyField(column_name='instrument_pk', null=True, model=Instrument,
#                                     backref='instrument_instrument_pk_set', field='pk')
#     pk = BigIntegerField(primary_key=True)
#     plate_pk = ForeignKeyField(column_name='plate_pk', null=True, model=Plate,
#                                backref='plate_plate_pk_set', field='pk')
#
#     class Meta:
#         db_table = 'plate_to_instrument'
#         indexes = (
#             (('plate_pk', 'instrument_pk'), True),
#         )
#         schema = 'platedb'


class PlateToPlateStatus(OperationsDBModel):
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk', null=True,
                            model=Plate,
                            field='pk')
    plate_status = ForeignKeyField(column_name='plate_status_pk', null=True,
                                   model=PlateStatus, field='pk')

    class Meta:
        db_table = 'plate_to_plate_status'
        indexes = (
            (('plate_status_pk', 'plate_pk'), True),
        )
        schema = 'platedb'


class PlateToSurvey(OperationsDBModel):
    pk = PrimaryKeyField()
    plate = ForeignKeyField(column_name='plate_pk', null=True, model=Plate,
                            field='pk')
    survey = ForeignKeyField(column_name='survey_pk', null=True,
                             model=Survey, field='pk')

    class Meta:
        db_table = 'plate_to_survey'
        indexes = (
            (('plate_pk', 'survey_pk'), True),
        )
        schema = 'platedb'


class PluggingToBossSn2Threshold(OperationsDBModel):
    boss_sn2_threshold_version = IntegerField()
    plugging_pk = IntegerField()

    class Meta:
        db_table = 'plugging_to_boss_sn2_threshold'
        indexes = (
            (('plugging_pk', 'boss_sn2_threshold_version'), True),
        )
        schema = 'platedb'
        primary_key = CompositeKey('boss_sn2_threshold_version', 'plugging_pk')


class PluggingToInstrument(OperationsDBModel):
    instrument = ForeignKeyField(column_name='instrument_pk', null=True, model=Instrument,
                                 field='pk')
    pk = PrimaryKeyField()
    plugging = ForeignKeyField(column_name='plugging_pk', null=True,
                               model=Plugging, field='pk')

    class Meta:
        db_table = 'plugging_to_instrument'
        indexes = (
            (('plugging_pk', 'instrument_pk'), True),
        )
        schema = 'platedb'


class PointingStatus(OperationsDBModel):
    label = TextField(null=True, unique=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'pointing_status'
        schema = 'platedb'


class ProfTolerances(OperationsDBModel):
    pk = PrimaryKeyField()
    r1_high = FloatField()
    r1_low = FloatField()
    r2_high = FloatField()
    r2_low = FloatField()
    r3_high = FloatField()
    r3_low = FloatField()
    r4_high = FloatField()
    r4_low = FloatField()
    r5_high = FloatField()
    r5_low = FloatField()
    survey = ForeignKeyField(column_name='survey_pk', model=Survey,
                             backref='prof_tolerances', field='pk')
    version = IntegerField()

    class Meta:
        db_table = 'prof_tolerances'
        schema = 'platedb'


class Profilometry(OperationsDBModel):
    comment = TextField(null=True)
    pk = PrimaryKeyField()
    plugging = ForeignKeyField(column_name='plugging_pk', model=Plugging,
                               backref='profilometries', field='pk')
    prof_tolerances = ForeignKeyField(column_name='prof_tolerances_pk', model=ProfTolerances,
                                      backref='profilometries', field='pk')
    timestamp = DateTimeField()

    class Meta:
        db_table = 'profilometry'
        schema = 'platedb'


class ProfMeasurement(OperationsDBModel):
    number = IntegerField()
    pk = PrimaryKeyField()
    profilometry = ForeignKeyField(column_name='profilometry_pk',
                                   model=Profilometry, field='pk')
    r1 = FloatField(null=True)
    r2 = FloatField(null=True)
    r3 = FloatField(null=True)
    r4 = FloatField(null=True)
    r5 = FloatField(null=True)
    timestamp = DateTimeField(null=True)

    class Meta:
        db_table = 'prof_measurement'
        schema = 'platedb'


class Test(OperationsDBModel):
    label = TextField(null=True)
    pk = PrimaryKeyField()

    class Meta:
        db_table = 'test'
        schema = 'platedb'


class TileStatusHistory(OperationsDBModel):
    comment = TextField()
    first_name = TextField(null=True)
    last_name = TextField(null=True)
    pk = PrimaryKeyField()
    tile = ForeignKeyField(column_name='tile_pk', model=Tile,
                           backref='tile_status_history', field='pk')
    tile_status = ForeignKeyField(column_name='tile_status_pk', model=TileStatus,
                                  backref='tile_status_history', field='pk')
    timestamp = DateTimeField()

    class Meta:
        db_table = 'tile_status_history'
        schema = 'platedb'


PlateSurveyThroughModel.set_model(PlateToSurvey)
PlateStatusThroughModel.set_model(PlateToPlateStatus)
PluggingInstrumentDeferred.set_model(PluggingToInstrument)
