#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime
import os

import numpy as np

from peewee import (SQL, AutoField, BigIntegerField, BooleanField,
                    DateTimeField, DeferredThroughModel, DoubleField,
                    FloatField, ForeignKeyField, IntegerField,
                    SmallIntegerField, TextField, UUIDField, fn)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import catalogdb, database  # noqa


class TargetdbBase(BaseModel):

    class Meta:
        schema = 'targetdb'
        database = database


# AssignmentDeferred = DeferredThroughModel()
CartonToTargetDeferred = DeferredThroughModel()


class Version(TargetdbBase):
    plan = TextField()
    pk = AutoField()
    target_selection = BooleanField()
    robostrategy = BooleanField()
    tag = TextField()

    class Meta:
        table_name = 'version'


class ObsMode(TargetdbBase):
    label = TextField(null=False)
    min_moon_sep = FloatField(null=True)
    min_deltav_ks91 = FloatField(null=True)
    min_twilight_ang = FloatField(null=True)
    max_airmass_apo = FloatField(null=True)
    max_airmass_lco = FloatField(null=True)

    class Meta:
        table_name = 'obsmode'


class Cadence(TargetdbBase):
    label = TextField(null=False)
    label_version = TextField(null=False)
    label_root = TextField(null=False)
    nepochs = IntegerField(null=True)
    skybrightness = ArrayField(field_class=FloatField, null=True)
    delta = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    # instrument_pk = ArrayField(field_class=IntegerField, null=True)
    nexp = ArrayField(field_class=SmallIntegerField, null=True)
    pk = AutoField()
    skybrightness = ArrayField(field_class=FloatField, null=True)
    max_length = ArrayField(field_class=FloatField, null=True)
    obsmode_pk = ArrayField(field_class=TextField, null=True)

    class Meta:
        table_name = 'cadence'


class Observatory(TargetdbBase):
    label = TextField()
    pk = AutoField()

    class Meta:
        table_name = 'observatory'


class Field(TargetdbBase):

    pk = AutoField()
    field_id = IntegerField(null=False)
    racen = DoubleField(null=False)
    deccen = DoubleField(null=False)
    position_angle = FloatField(null=True)
    slots_exposures = ArrayField(field_class=IntegerField, null=True)
    cadence = ForeignKeyField(column_name='cadence_pk',
                              field='pk',
                              model=Cadence,
                              null=True)
    observatory = ForeignKeyField(column_name='observatory_pk',
                                  field='pk',
                                  model=Observatory,
                                  null=True)
    version = ForeignKeyField(column_name='version_pk',
                              field='pk',
                              model=Version)

    class Meta:
        table_name = 'field'


class FieldReservation(TargetdbBase):
    field_id = IntegerField(null=False)

    @classmethod
    def requestNext(cls, N=1, commit=True, commissioning=False):
        """inserts N new ids after max id and returns list of new ids"""
        if commissioning:
            next_id = cls.select(fn.MAX(cls.field_id))\
                         .where(cls.field_id < 99999).scalar() + 1
        else:
            next_id = cls.select(fn.MAX(cls.field_id)).scalar() + 1
        ids = [next_id + i for i in range(N)]
        if commit:
            db_format = [{"field_id": i} for i in ids]
            cls.insert_many(db_format).execute()
        return ids

    class Meta:
        table_name = 'field_reservation'


class DesignMode(TargetdbBase):
    label = TextField(null=False)
    boss_skies_min = IntegerField(null=True)
    boss_skies_fov = ArrayField(field_class=DoubleField, null=True)
    apogee_skies_min = IntegerField(null=True)
    apogee_skies_fov = ArrayField(field_class=DoubleField, null=True)
    boss_stds_min = IntegerField(null=True)
    boss_stds_mags_min = ArrayField(field_class=DoubleField, null=True)
    boss_stds_mags_max = ArrayField(field_class=DoubleField, null=True)
    boss_stds_fov = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_min = IntegerField(null=True)
    apogee_stds_mags_min = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_mags_max = ArrayField(field_class=DoubleField, null=True)
    apogee_stds_fov = ArrayField(field_class=DoubleField, null=True)
    boss_bright_limit_targets_min = ArrayField(field_class=DoubleField, null=True)
    boss_bright_limit_targets_max = ArrayField(field_class=DoubleField, null=True)
    boss_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_min = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_max = ArrayField(field_class=DoubleField, null=True)
    apogee_trace_diff_targets = ArrayField(field_class=DoubleField, null=True)
    apogee_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)

    class Meta:
        table_name = 'design_mode'


class Design(TargetdbBase):
    # field = ForeignKeyField(column_name='field_pk',
    #                         field='pk',
    #                         model=Field,
    #                         null=True,
    #                         backref="designs")
    # exposure = IntegerField(null=True)
    design_id = AutoField()
    design_mode = ForeignKeyField(column_name='design_mode_label',
                                  field='label',
                                  model=DesignMode,
                                  null=True)
    mugatu_version = TextField()
    run_on = DateTimeField(default=datetime.datetime.now())
    assignment_hash = UUIDField()
    version = ForeignKeyField(column_name='design_version_pk',
                              field='pk',
                              model=Version)
    # field_exposure = IntegerField()

    class Meta:
        table_name = 'design'

    @property
    def field(self):
        """Gets the Field entry for a design."""

        rs_version = os.environ.get('RS_VERSION', None)
        if rs_version is None:
            raise ValueError("$RS_VERSION not defined.")

        fields = (Field.select()
                  .join(DesignToField)
                  .join(Design)
                  .where(Design.design_id == self.design_id))

        # Fields that match the current RS version.
        fields_version = (fields.switch(Field)
                          .join(Version)
                          .where(Version.plan == rs_version)
                          .where(Version.robostrategy == True))  # noqa

        n_fields = fields_version.count()
        if n_fields > 1:
            # raise ValueError(f"Multiple fields found for design {self.design_id}.")
            max_pk = np.max([f.pk for f in fields_version])
            w_max = np.where([f.pk == max_pk for f in fields_version])[0][0]
            return fields_version[w_max]
        elif n_fields == 1:
            return fields_version.first()
        else:
            # Fallback for commissioning designs and other designs without
            # an associated RS version.
            return fields.first()


class DesignToField(TargetdbBase):
    pk = AutoField()
    design = ForeignKeyField(model=Design,
                             column_name='design_id',
                             field='design_id',)
    field = ForeignKeyField(column_name='field_pk',
                            field='pk',
                            model=Field)
    exposure = IntegerField()
    field_exposure = IntegerField()

    class Meta:
        table_name = 'design_to_field'


class DesignModeCheckResults(TargetdbBase):
    pk = IntegerField(null=False, primary_key=True)
    design = ForeignKeyField(Design,
                             column_name='design_id',
                             field='design_id',
                             backref="design_mode_check_resultss")
    # whether or not design passes recent
    # validation and should be observed
    design_pass = BooleanField(null=False)

    # bitmask to describe current status of
    # design validation
    design_status = IntegerField(null=True)

    # values and passing status for design-wide
    # designmode criteria
    boss_skies_min_pass = BooleanField(null=True)
    boss_skies_min_value = IntegerField(null=True)
    boss_skies_fov_pass = BooleanField(null=True)
    boss_skies_fov_value = DoubleField(null=True)
    apogee_skies_min_pass = BooleanField(null=True)
    apogee_skies_min_value = IntegerField(null=True)
    apogee_skies_fov_pass = BooleanField(null=True)
    apogee_skies_fov_value = DoubleField(null=True)
    boss_stds_min_pass = BooleanField(null=True)
    boss_stds_min_value = IntegerField(null=True)
    boss_stds_fov_pass = BooleanField(null=True)
    boss_stds_fov_value = DoubleField(null=True)
    apogee_stds_min_pass = BooleanField(null=True)
    apogee_stds_min_value = IntegerField(null=True)
    apogee_stds_fov_pass = BooleanField(null=True)
    apogee_stds_fov_value = DoubleField(null=True)

    # just passing status for target-specific
    # designmode criteria
    boss_stds_mags_pass = BooleanField(null=True)
    apogee_stds_mags_pass = BooleanField(null=True)
    boss_bright_limit_targets_pass = BooleanField(null=True)
    apogee_bright_limit_targets_pass = BooleanField(null=True)
    boss_sky_neighbors_targets_pass = BooleanField(null=True)
    apogee_sky_neighbors_targets_pass = BooleanField(null=True)
    apogee_trace_diff_targets_pass = BooleanField(null=True)

    class Meta:
        table_name = 'design_mode_check_results'


class Instrument(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()
    default_lambda_eff = FloatField()

    class Meta:
        table_name = 'instrument'


class Hole(TargetdbBase):
    pk = IntegerField(null=False, primary_key=True)
    observatory = ForeignKeyField(column_name='observatory_pk',
                                  field='pk',
                                  model=Observatory)
    row = SmallIntegerField()
    column = SmallIntegerField()
    holeid = TextField()

    class Meta:
        table_name = 'hole'


class Category(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'category'


class Mapper(TargetdbBase):
    label = TextField(null=True)
    pk = AutoField()

    class Meta:
        table_name = 'mapper'


class Carton(TargetdbBase):
    category = ForeignKeyField(column_name='category_pk',
                               field='pk',
                               model=Category)
    carton = TextField()
    pk = AutoField()
    mapper = ForeignKeyField(column_name='mapper_pk',
                             field='pk',
                             model=Mapper)
    program = TextField()
    version = ForeignKeyField(column_name='version_pk',
                              field='pk',
                              model=Version)
    run_on = DateTimeField()

    class Meta:
        table_name = 'carton'


class Target(TargetdbBase):
    catalogid = BigIntegerField(null=False)
    dec = DoubleField(null=True)
    epoch = FloatField(null=True)
    pk = AutoField()
    pmdec = FloatField(null=True)
    pmra = FloatField(null=True)
    ra = DoubleField(null=True)
    # designs = ManyToManyField(Design,
    #                           through_model=AssignmentDeferred,
    #                           backref='targets')
    # instruments = ManyToManyField(Instrument,
    #                               through_model=AssignmentDeferred,
    #                               backref='targets')
    # cadences = ManyToManyField(Cadence,
    #                            through_model=CartonToTargetDeferred,
    #                            backref='targets')
    parallax = FloatField(null=True)

    class Meta:
        table_name = 'target'


class CartonToTarget(TargetdbBase):
    cadence = ForeignKeyField(Cadence,
                              column_name='cadence_pk',
                              field='pk')
    lambda_eff = FloatField(null=True)
    pk = AutoField()
    carton = ForeignKeyField(Carton,
                             column_name='carton_pk',
                             field='pk')
    target = ForeignKeyField(Target,
                             column_name='target_pk',
                             field='pk',
                             on_delete='CASCADE')
    priority = IntegerField()
    value = FloatField()
    instrument = ForeignKeyField(Instrument,
                                 column_name='instrument_pk',
                                 field='pk')
    delta_ra = DoubleField()
    delta_dec = DoubleField()
    can_offset = BooleanField(default=False)
    inertial = BooleanField()

    class Meta:
        table_name = 'carton_to_target'


class Assignment(TargetdbBase):
    design = ForeignKeyField(Design,
                             column_name='design_id',
                             field='design_id',
                             backref="assignments")
    instrument = ForeignKeyField(Instrument,
                                 column_name='instrument_pk',
                                 field='pk')
    pk = AutoField()
    hole = ForeignKeyField(Hole,
                           column_name='hole_pk',
                           field='pk')
    carton_to_target = ForeignKeyField(CartonToTarget,
                                       column_name='carton_to_target_pk',
                                       field='pk')

    class Meta:
        table_name = 'assignment'
        constraints = [SQL('UNIQUE(holeid, observatory_pk)')]


class Magnitude(TargetdbBase):
    bp = FloatField(null=True)
    g = FloatField(null=True)
    h = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    pk = AutoField()
    r = FloatField(null=True)
    rp = FloatField(null=True)
    gaia_g = FloatField(null=True)
    j = FloatField(null=True)
    k = FloatField(null=True)
    optical_prov = TextField(null=True)
    carton_to_target = ForeignKeyField(column_name='carton_to_target_pk',
                                       field='pk',
                                       model=CartonToTarget,
                                       backref='magnitudes')

    class Meta:
        table_name = 'magnitude'


class RevisedMagnitude(TargetdbBase):
    """Revised optical magnitudes.

    This table contains SDSS g,r,i,z magnitudes calculated from Gaia DR3 XP
    spectra (see Gaia_dr3_synthetic_photometry_gspc). This only applies
    to v0.1 and v0.5. For v1 targets with r<15 automatically use XP synthetic
    magnitudes.

    """

    bp = FloatField(null=True)
    g = FloatField(null=True)
    h = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    pk = AutoField()
    r = FloatField(null=True)
    rp = FloatField(null=True)
    gaia_g = FloatField(null=True)
    j = FloatField(null=True)
    k = FloatField(null=True)
    optical_prov = TextField(null=True)
    carton_to_target = ForeignKeyField(column_name='carton_to_target_pk',
                                       field='pk',
                                       model=CartonToTarget,
                                       backref='revised_magnitudes')

    class Meta:
        table_name = 'revised_magnitude'


class AssignedTargets(TargetdbBase):
    program = TextField()
    carton_pk = ForeignKeyField(column_name="carton_pk",
                                field="pk",
                                model=Carton)
    c2t_pk = ForeignKeyField(column_name="c2t_pk",
                             field="pk",
                             model=CartonToTarget)
    target_pk = ForeignKeyField(column_name="target_pk",
                                field="pk",
                                model=Target)
    assignment_pk = ForeignKeyField(column_name="assignment_pk",
                                    field="pk",
                                    model=Assignment)
    design_id = ForeignKeyField(column_name="design_id",
                                field="design_id",
                                model=Design)
    field_id = IntegerField()
    field_pk = ForeignKeyField(column_name="field_pk",
                               field="pk",
                               model=Field)
    observatory_pk = ForeignKeyField(column_name="observatory_pk",
                                     field="pk",
                                     model=Observatory)
    version_pk = ForeignKeyField(column_name="version_pk",
                                 field="pk",
                                 model=Version)
    cadence_pk = ForeignKeyField(column_name="cadence_pk",
                                 field="pk",
                                 model=Cadence)
    mjd = FloatField()
    completion_status_pk = IntegerField()

    class Meta:
        table_name = 'assigned_targets'


class AssignmentStatus(TargetdbBase):
    pk = AutoField()
    assignment_pk = ForeignKeyField(column_name="assignment_pk",
                                    field="pk",
                                    model=Assignment)
    mjd = FloatField()
    status = IntegerField()

    class Meta:
        table_name = 'assignment_status'


# AssignmentDeferred.set_model(Assignment)
CartonToTargetDeferred.set_model(CartonToTarget)
