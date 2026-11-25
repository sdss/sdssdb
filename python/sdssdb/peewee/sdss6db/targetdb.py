#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-11-24
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

import datetime
import os

import numpy as np

from peewee import (
    AutoField,
    BigAutoField,
    BigIntegerField,
    BooleanField,
    DateField,
    DeferredThroughModel,
    DoubleField,
    FloatField,
    ForeignKeyField,
    IntegerField,
    ManyToManyField,
    TextField,
    UUIDField,
    fn,
)
from playhouse.postgres_ext import ArrayField

from .. import BaseModel
from . import database


class TargetdbBase(BaseModel):
    class Meta:
        schema = "targetdb"
        database = database
        use_reflection = False


TargetingGenerationToCartonDeferred = DeferredThroughModel()


class Version(TargetdbBase):
    pk = AutoField()
    plan = TextField(null=True, unique=True)
    tag = TextField(null=True)
    target_selection = BooleanField(null=True)
    robostrategy = BooleanField(null=True)

    class Meta:
        table_name = "version"


class ObsMode(TargetdbBase):
    label = TextField(primary_key=True)
    min_moon_sep = FloatField(null=True)
    min_deltav_ks91 = FloatField(null=True)
    min_twilight_ang = FloatField(null=True)
    max_airmass_apo = FloatField(null=True)
    max_airmass_lco = FloatField(null=True)

    class Meta:
        table_name = "obsmode"


class Cadence(TargetdbBase):
    pk = AutoField()
    label = TextField(null=False, unique=True)
    label_root = TextField(null=True)
    label_version = TextField(null=True, default="")
    nepochs = IntegerField(null=True, index=True)
    delta = ArrayField(field_class=DoubleField, null=True)
    skybrightness = ArrayField(field_class=FloatField, null=True)
    delta_max = ArrayField(field_class=FloatField, null=True)
    delta_min = ArrayField(field_class=FloatField, null=True)
    nexp = ArrayField(field_class=IntegerField, null=True)
    max_length = ArrayField(field_class=FloatField, null=True)
    obsmode_pk = ArrayField(field_class=TextField, null=True)

    class Meta:
        table_name = "cadence"


class Observatory(TargetdbBase):
    pk = AutoField()
    label = TextField(null=False)

    class Meta:
        table_name = "observatory"


class Overplan(TargetdbBase):
    pk = AutoField()
    input_file = TextField(null=True)
    plan = TextField(null=True)

    class Meta:
        table_name = "overplan"


class Field(TargetdbBase):
    pk = AutoField()
    field_id = IntegerField(null=True, index=True)
    racen = DoubleField(null=False)
    deccen = DoubleField(null=False)
    position_angle = FloatField(null=True)
    slots_exposures = ArrayField(field_class=IntegerField, dimensions=2, null=True)
    version = ForeignKeyField(
        Version,
        column_name="version_pk",
        field="pk",
        null=True,
        backref="fields",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    cadence = ForeignKeyField(
        Cadence,
        column_name="cadence_pk",
        field="pk",
        null=True,
        index=True,
        backref="fields",
    )
    observatory = ForeignKeyField(
        Observatory,
        column_name="observatory_pk",
        field="pk",
        null=True,
        index=True,
        backref="fields",
    )
    overplan = ForeignKeyField(
        Overplan,
        column_name="overplan_pk",
        field="pk",
        null=True,
        backref="fields",
    )

    class Meta:
        table_name = "field"


class FieldReservation(TargetdbBase):
    field_id = IntegerField(primary_key=True)

    @classmethod
    def requestNext(cls, N=1, commit=True, commissioning=False):
        """Inserts N new ids after max id and returns list of new ids."""

        if commissioning:
            next_id = cls.select(fn.MAX(cls.field_id)).where(cls.field_id < 99999).scalar() + 1
        else:
            next_id = cls.select(fn.MAX(cls.field_id)).scalar() + 1

        ids = [next_id + i for i in range(N)]

        if commit:
            db_format = [{"field_id": i} for i in ids]
            cls.insert_many(db_format).execute()

        return ids

    class Meta:
        table_name = "field_reservation"


class DesignMode(TargetdbBase):
    label = TextField(primary_key=True)
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
    boss_trace_diff_targets = DoubleField(null=True)
    boss_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_min = ArrayField(field_class=DoubleField, null=True)
    apogee_bright_limit_targets_max = ArrayField(field_class=DoubleField, null=True)
    apogee_trace_diff_targets = DoubleField(null=True)
    apogee_sky_neighbors_targets = ArrayField(field_class=DoubleField, null=True)

    class Meta:
        table_name = "design_mode"


class Design(TargetdbBase):
    design_id = AutoField()
    design_mode = ForeignKeyField(
        DesignMode,
        column_name="design_mode_label",
        field="label",
        null=True,
        backref="designs",
    )
    mugatu_version = TextField(null=True)
    run_on = DateField(null=True, default=datetime.date.today)
    assignment_hash = UUIDField(null=True, index=True)
    version = ForeignKeyField(
        Version,
        column_name="design_version_pk",
        field="pk",
        null=True,
        backref="designs",
        on_delete="CASCADE",
        on_update="CASCADE",
    )

    class Meta:
        table_name = "design"

    @property
    def field(self):
        """Gets the Field entry for a design."""

        rs_version = os.environ.get("RS_VERSION", None)
        if rs_version is None:
            raise ValueError("$RS_VERSION not defined.")

        fields = (
            Field.select()
            .join(DesignToField)
            .join(Design)
            .where(Design.design_id == self.design_id)
        )

        # Fields that match the current RS version.
        fields_version = (
            fields.switch(Field)
            .join(Version)
            .where(Version.plan == rs_version)
            .where(Version.robostrategy == True)  # noqa: E712
        )

        n_fields = fields_version.count()
        if n_fields > 1:
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
    design = ForeignKeyField(
        Design,
        column_name="design_id",
        field="design_id",
        null=True,
        index=True,
        backref="design_to_fields",
    )
    field = ForeignKeyField(
        Field,
        column_name="field_pk",
        field="pk",
        null=True,
        index=True,
        backref="design_to_fields",
    )
    exposure = BigIntegerField(null=True)
    field_exposure = BigIntegerField(null=True)

    class Meta:
        table_name = "design_to_field"


class Instrument(TargetdbBase):
    pk = AutoField()
    label = TextField(null=True)
    default_lambda_eff = FloatField(null=True)

    class Meta:
        table_name = "instrument"


class PositionerStatus(TargetdbBase):
    pk = AutoField()
    label = TextField(null=True)

    class Meta:
        table_name = "positioner_status"


class Hole(TargetdbBase):
    pk = AutoField()
    row = IntegerField(null=True)
    column = IntegerField(null=True)
    holeid = TextField(null=True, index=True)
    observatory = ForeignKeyField(
        Observatory,
        column_name="observatory_pk",
        field="pk",
        null=False,
        index=True,
        backref="holes",
    )

    class Meta:
        table_name = "hole"
        indexes = ((("holeid", "observatory"), True),)


class Category(TargetdbBase):
    pk = AutoField()
    label = TextField(null=True)

    class Meta:
        table_name = "category"


class Explorer(TargetdbBase):
    pk = AutoField()
    label = TextField(null=True)

    class Meta:
        table_name = "explorer"


class Carton(TargetdbBase):
    pk = AutoField()
    explorer = ForeignKeyField(
        Explorer,
        column_name="explorer_pk",
        field="pk",
        null=True,
        backref="cartons",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    category = ForeignKeyField(
        Category,
        column_name="category_pk",
        field="pk",
        null=True,
        backref="cartons",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    version = ForeignKeyField(
        Version,
        column_name="version_pk",
        field="pk",
        null=True,
        backref="cartons",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    carton = TextField(null=True)
    program = TextField(null=True)
    manual = BooleanField(null=False, default=False)
    run_on = DateField(null=True)

    class Meta:
        table_name = "carton"


class Target(TargetdbBase):
    catalogid = BigIntegerField(primary_key=True)
    healpix_29 = BigIntegerField(null=True, index=True)
    ra = DoubleField(null=True)
    dec = DoubleField(null=True)
    pmra = FloatField(null=True)
    pmdec = FloatField(null=True)
    epoch = FloatField(null=True)
    parallax = FloatField(null=True)

    class Meta:
        table_name = "target"


class CartonToTarget(TargetdbBase):
    pk = BigAutoField()
    target = ForeignKeyField(
        Target,
        column_name="catalogid",
        field="catalogid",
        null=True,
        index=True,
        backref="carton_to_targets",
    )
    lambda_eff = FloatField(null=True)
    instrument = ForeignKeyField(
        Instrument,
        column_name="instrument_pk",
        field="pk",
        null=True,
        index=True,
        backref="carton_to_targets",
    )
    delta_ra = DoubleField(null=True)
    delta_dec = DoubleField(null=True)
    can_offset = BooleanField(null=False, default=False)
    inertial = BooleanField(null=True)
    priority = IntegerField(null=True, index=True)
    value = FloatField(null=True)
    carton = ForeignKeyField(
        Carton,
        column_name="carton_pk",
        field="pk",
        null=True,
        index=True,
        backref="carton_to_targets",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    cadence = ForeignKeyField(
        Cadence,
        column_name="cadence_pk",
        field="pk",
        null=True,
        index=True,
        backref="carton_to_targets",
    )

    class Meta:
        table_name = "carton_to_target"


class Magnitude(TargetdbBase):
    pk = BigAutoField()
    carton_to_target = ForeignKeyField(
        CartonToTarget,
        column_name="carton_to_target_pk",
        field="pk",
        null=True,
        index=True,
        backref="magnitudes",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    g = FloatField(null=True)
    r = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    j = FloatField(null=True)
    h = FloatField(null=True, index=True)
    k = FloatField(null=True)
    gaia_g = FloatField(null=True)
    gaia_bp = FloatField(null=True)
    gaia_rp = FloatField(null=True)
    optical_prov = TextField(null=True)

    class Meta:
        table_name = "magnitude"


class RevisedMagnitude(TargetdbBase):
    """Revised optical magnitudes.

    This table contains SDSS g,r,i,z magnitudes calculated from Gaia DR3 XP
    spectra (see Gaia_dr3_synthetic_photometry_gspc).

    """

    pk = BigAutoField()
    # There is no foreign key constraint in the database for this column.
    carton_to_target = ForeignKeyField(
        CartonToTarget,
        column_name="carton_to_target_pk",
        field="pk",
        null=True,
        index=True,
        backref="revised_magnitudes",
    )
    g = FloatField(null=True)
    r = FloatField(null=True)
    i = FloatField(null=True)
    z = FloatField(null=True)
    j = FloatField(null=True)
    h = FloatField(null=True)
    k = FloatField(null=True)
    gaia_g = FloatField(null=True)
    gaia_bp = FloatField(null=True)
    gaia_rp = FloatField(null=True)
    optical_prov = TextField(null=True)

    class Meta:
        table_name = "revised_magnitude"


class Assignment(TargetdbBase):
    pk = AutoField()
    carton_to_target = ForeignKeyField(
        CartonToTarget,
        column_name="carton_to_target_pk",
        field="pk",
        null=True,
        index=True,
        backref="assignments",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    hole = ForeignKeyField(
        Hole,
        column_name="hole_pk",
        field="pk",
        null=True,
        index=True,
        backref="assignments",
    )
    instrument = ForeignKeyField(
        Instrument,
        column_name="instrument_pk",
        field="pk",
        null=True,
        index=True,
        backref="assignments",
    )
    design = ForeignKeyField(
        Design,
        column_name="design_id",
        field="design_id",
        null=True,
        index=True,
        backref="assignments",
        on_delete="CASCADE",
        on_update="CASCADE",
    )

    class Meta:
        table_name = "assignment"


class AssignmentStatus(TargetdbBase):
    pk = AutoField()
    assignment = ForeignKeyField(
        Assignment,
        column_name="assignment_pk",
        field="pk",
        null=True,
        unique=True,
        backref="status",
    )
    status = IntegerField(null=True)
    mjd = FloatField(null=True)

    class Meta:
        table_name = "assignment_status"


class TargetingGeneration(TargetdbBase):
    pk = AutoField()
    label = TextField(null=True)
    first_release = TextField(null=True)

    cartons = ManyToManyField(
        Carton,
        backref="generations",
        through_model=TargetingGenerationToCartonDeferred,
    )

    class Meta:
        table_name = "targeting_generation"


class TargetingGenerationToCarton(TargetdbBase):
    pk = AutoField()
    targeting_generation = ForeignKeyField(
        TargetingGeneration,
        column_name="generation_pk",
        field="pk",
        null=True,
        index=True,
        backref="+",
    )
    carton = ForeignKeyField(
        Carton,
        column_name="carton_pk",
        field="pk",
        null=True,
        index=True,
        backref="+",
    )
    rs_stage = TextField(null=True)
    rs_active = BooleanField(null=True)

    class Meta:
        table_name = "targeting_generation_to_carton"
        indexes = ((("targeting_generation", "carton", "rs_stage", "rs_active"), True),)


class TargetingGenerationToVersion(TargetdbBase):
    pk = AutoField()
    targeting_generation = ForeignKeyField(
        TargetingGeneration,
        column_name="generation_pk",
        field="pk",
        null=False,
        index=True,
        backref="+",
    )
    version = ForeignKeyField(
        Version,
        column_name="version_pk",
        field="pk",
        null=False,
        index=True,
        backref="+",
    )

    class Meta:
        table_name = "targeting_generation_to_version"
        indexes = ((("targeting_generation", "version"), True),)


TargetingGenerationToCartonDeferred.set_model(TargetingGenerationToCarton)
