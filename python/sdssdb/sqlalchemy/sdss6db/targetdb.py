#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-11-24
# @Filename: targetdb.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import datetime
import uuid
from typing import List, Optional

from sqlalchemy import (
    ARRAY,
    REAL,
    BigInteger,
    Boolean,
    CheckConstraint,
    Date,
    Double,
    ForeignKey,
    Integer,
    Text,
    UniqueConstraint,
    text,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship

from sdssdb.sqlalchemy.sdss6db import SDSS6dbBase, database


SCHEMA = "targetdb"


class Base(SDSS6dbBase):
    __abstract__ = True
    _schema = SCHEMA
    _relations = "define_relations"

    @declared_attr
    def __table_args__(cls):
        return {"schema": cls._schema}


class Version(Base):
    __tablename__ = "version"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    plan: Mapped[Optional[str]] = mapped_column(Text, unique=True)
    tag: Mapped[Optional[str]] = mapped_column(Text)
    target_selection: Mapped[Optional[bool]] = mapped_column(Boolean)
    robostrategy: Mapped[Optional[bool]] = mapped_column(Boolean)


class Obsmode(Base):
    __tablename__ = "obsmode"

    label: Mapped[str] = mapped_column(Text, primary_key=True)
    min_moon_sep: Mapped[Optional[float]] = mapped_column(REAL)
    min_deltav_ks91: Mapped[Optional[float]] = mapped_column(REAL)
    min_twilight_ang: Mapped[Optional[float]] = mapped_column(REAL)
    max_airmass_apo: Mapped[Optional[float]] = mapped_column(REAL)
    max_airmass_lco: Mapped[Optional[float]] = mapped_column(REAL)


class Cadence(Base):
    __tablename__ = "cadence"
    __table_args__ = (
        CheckConstraint("label = label_root || label_version", name="label_constraint"),
        {"schema": SCHEMA},
    )

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[str] = mapped_column(Text, nullable=False, unique=True)
    label_root: Mapped[Optional[str]] = mapped_column(Text)
    label_version: Mapped[Optional[str]] = mapped_column(Text, server_default=text("''"))
    nepochs: Mapped[Optional[int]] = mapped_column(Integer, index=True)
    delta: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    skybrightness: Mapped[Optional[list]] = mapped_column(ARRAY(REAL))
    delta_max: Mapped[Optional[list]] = mapped_column(ARRAY(REAL))
    delta_min: Mapped[Optional[list]] = mapped_column(ARRAY(REAL))
    nexp: Mapped[Optional[list]] = mapped_column(ARRAY(Integer))
    max_length: Mapped[Optional[list]] = mapped_column(ARRAY(REAL))
    obsmode_pk: Mapped[Optional[list]] = mapped_column(ARRAY(Text))


class Instrument(Base):
    __tablename__ = "instrument"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[Optional[str]] = mapped_column(Text)
    default_lambda_eff: Mapped[Optional[float]] = mapped_column(REAL)


class Observatory(Base):
    __tablename__ = "observatory"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[str] = mapped_column(Text, nullable=False)


class PositionerStatus(Base):
    __tablename__ = "positioner_status"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[Optional[str]] = mapped_column(Text)


class Category(Base):
    __tablename__ = "category"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[Optional[str]] = mapped_column(Text)


class Explorer(Base):
    __tablename__ = "explorer"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[Optional[str]] = mapped_column(Text)


class DesignMode(Base):
    __tablename__ = "design_mode"

    label: Mapped[str] = mapped_column(Text, primary_key=True)
    boss_skies_min: Mapped[Optional[int]] = mapped_column(Integer)
    boss_skies_fov: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_skies_min: Mapped[Optional[int]] = mapped_column(Integer)
    apogee_skies_fov: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_stds_min: Mapped[Optional[int]] = mapped_column(Integer)
    boss_stds_mags_min: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_stds_mags_max: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_stds_fov: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_stds_min: Mapped[Optional[int]] = mapped_column(Integer)
    apogee_stds_mags_min: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_stds_mags_max: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_stds_fov: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_bright_limit_targets_min: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_bright_limit_targets_max: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    boss_trace_diff_targets: Mapped[Optional[float]] = mapped_column(Double)
    boss_sky_neighbors_targets: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_bright_limit_targets_min: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_bright_limit_targets_max: Mapped[Optional[list]] = mapped_column(ARRAY(Double))
    apogee_trace_diff_targets: Mapped[Optional[float]] = mapped_column(Double)
    apogee_sky_neighbors_targets: Mapped[Optional[list]] = mapped_column(ARRAY(Double))


class FieldReservation(Base):
    __tablename__ = "field_reservation"

    field_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=False)


class TargetingGeneration(Base):
    __tablename__ = "targeting_generation"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[Optional[str]] = mapped_column(Text)
    first_release: Mapped[Optional[str]] = mapped_column(Text)

    cartons: Mapped[List["Carton"]] = relationship(
        "Carton",
        secondary="targetdb.targeting_generation_to_carton",
        back_populates="generations",
        viewonly=True,
    )


class Overplan(Base):
    __tablename__ = "overplan"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    input_file: Mapped[Optional[str]] = mapped_column(Text)
    plan: Mapped[Optional[str]] = mapped_column(Text)


class Target(Base):
    __tablename__ = "target"

    catalogid: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=False)
    healpix_29: Mapped[Optional[int]] = mapped_column(BigInteger, index=True)
    ra: Mapped[Optional[float]] = mapped_column(Double)
    dec: Mapped[Optional[float]] = mapped_column(Double)
    pmra: Mapped[Optional[float]] = mapped_column(REAL)
    pmdec: Mapped[Optional[float]] = mapped_column(REAL)
    epoch: Mapped[Optional[float]] = mapped_column(REAL)
    parallax: Mapped[Optional[float]] = mapped_column(REAL)

    carton_to_targets: Mapped[List["CartonToTarget"]] = relationship(
        "CartonToTarget", back_populates="target"
    )


class Carton(Base):
    __tablename__ = "carton"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    explorer_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.explorer.pk", ondelete="CASCADE", onupdate="CASCADE"),
    )
    category_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.category.pk", ondelete="CASCADE", onupdate="CASCADE"),
    )
    version_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.version.pk", ondelete="CASCADE", onupdate="CASCADE"),
    )
    carton: Mapped[Optional[str]] = mapped_column(Text)
    program: Mapped[Optional[str]] = mapped_column(Text)
    run_on: Mapped[Optional[datetime.date]] = mapped_column(Date)

    explorer: Mapped[Optional["Explorer"]] = relationship("Explorer")
    category: Mapped[Optional["Category"]] = relationship("Category")
    version: Mapped[Optional["Version"]] = relationship("Version")

    generations: Mapped[List["TargetingGeneration"]] = relationship(
        "TargetingGeneration",
        secondary="targetdb.targeting_generation_to_carton",
        back_populates="cartons",
        viewonly=True,
    )


class CartonToTarget(Base):
    __tablename__ = "carton_to_target"

    pk: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    catalogid: Mapped[Optional[int]] = mapped_column(
        BigInteger,
        ForeignKey("targetdb.target.catalogid", deferrable=True, initially="DEFERRED"),
        index=True,
    )
    lambda_eff: Mapped[Optional[float]] = mapped_column(REAL)
    instrument_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.instrument.pk"), index=True
    )
    delta_ra: Mapped[Optional[float]] = mapped_column(Double)
    delta_dec: Mapped[Optional[float]] = mapped_column(Double)
    can_offset: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default=text("false"))
    inertial: Mapped[Optional[bool]] = mapped_column(Boolean)
    priority: Mapped[Optional[int]] = mapped_column(Integer, index=True)
    value: Mapped[Optional[float]] = mapped_column(REAL)
    carton_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey(
            "targetdb.carton.pk",
            ondelete="CASCADE",
            onupdate="CASCADE",
            deferrable=True,
            initially="DEFERRED",
        ),
        index=True,
    )
    cadence_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.cadence.pk"), index=True
    )

    target: Mapped[Optional["Target"]] = relationship("Target", back_populates="carton_to_targets")
    instrument: Mapped[Optional["Instrument"]] = relationship("Instrument")
    carton: Mapped[Optional["Carton"]] = relationship("Carton")
    cadence: Mapped[Optional["Cadence"]] = relationship("Cadence")

    magnitudes: Mapped[List["Magnitude"]] = relationship(
        "Magnitude", back_populates="carton_to_target"
    )
    revised_magnitudes: Mapped[List["RevisedMagnitude"]] = relationship(
        "RevisedMagnitude", back_populates="carton_to_target"
    )


class Magnitude(Base):
    __tablename__ = "magnitude"

    pk: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    carton_to_target_pk: Mapped[Optional[int]] = mapped_column(
        BigInteger,
        ForeignKey(
            "targetdb.carton_to_target.pk",
            ondelete="CASCADE",
            onupdate="CASCADE",
            deferrable=True,
            initially="DEFERRED",
        ),
        index=True,
    )
    g: Mapped[Optional[float]] = mapped_column(REAL)
    r: Mapped[Optional[float]] = mapped_column(REAL)
    i: Mapped[Optional[float]] = mapped_column(REAL)
    z: Mapped[Optional[float]] = mapped_column(REAL)
    j: Mapped[Optional[float]] = mapped_column(REAL)
    h: Mapped[Optional[float]] = mapped_column(REAL, index=True)
    k: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_g: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_bp: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_rp: Mapped[Optional[float]] = mapped_column(REAL)
    optical_prov: Mapped[Optional[str]] = mapped_column(Text)

    carton_to_target: Mapped[Optional["CartonToTarget"]] = relationship(
        "CartonToTarget", back_populates="magnitudes"
    )


class RevisedMagnitude(Base):
    """Revised optical magnitudes.

    This table contains SDSS g,r,i,z magnitudes calculated from Gaia DR3 XP
    spectra (see Gaia_dr3_synthetic_photometry_gspc).

    """

    __tablename__ = "revised_magnitude"

    pk: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    # There is no foreign key constraint in the database for this column.
    carton_to_target_pk: Mapped[Optional[int]] = mapped_column(
        BigInteger, ForeignKey("targetdb.carton_to_target.pk"), index=True
    )
    g: Mapped[Optional[float]] = mapped_column(REAL)
    r: Mapped[Optional[float]] = mapped_column(REAL)
    i: Mapped[Optional[float]] = mapped_column(REAL)
    z: Mapped[Optional[float]] = mapped_column(REAL)
    j: Mapped[Optional[float]] = mapped_column(REAL)
    h: Mapped[Optional[float]] = mapped_column(REAL)
    k: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_g: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_bp: Mapped[Optional[float]] = mapped_column(REAL)
    gaia_rp: Mapped[Optional[float]] = mapped_column(REAL)
    optical_prov: Mapped[Optional[str]] = mapped_column(Text)

    carton_to_target: Mapped[Optional["CartonToTarget"]] = relationship(
        "CartonToTarget", back_populates="revised_magnitudes"
    )


class Hole(Base):
    __tablename__ = "hole"
    __table_args__ = (
        UniqueConstraint("holeid", "observatory_pk"),
        {"schema": SCHEMA},
    )

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    row: Mapped[Optional[int]] = mapped_column(Integer)
    column: Mapped[Optional[int]] = mapped_column(Integer)
    holeid: Mapped[Optional[str]] = mapped_column(Text, index=True)
    observatory_pk: Mapped[int] = mapped_column(
        Integer, ForeignKey("targetdb.observatory.pk"), nullable=False, index=True
    )

    observatory: Mapped["Observatory"] = relationship("Observatory")


class Design(Base):
    __tablename__ = "design"

    design_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    design_mode_label: Mapped[Optional[str]] = mapped_column(
        Text, ForeignKey("targetdb.design_mode.label")
    )
    mugatu_version: Mapped[Optional[str]] = mapped_column(Text)
    run_on: Mapped[Optional[datetime.date]] = mapped_column(Date)
    assignment_hash: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True), index=True)
    design_version_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.version.pk", ondelete="CASCADE", onupdate="CASCADE"),
    )

    design_mode: Mapped[Optional["DesignMode"]] = relationship("DesignMode")
    version: Mapped[Optional["Version"]] = relationship("Version")

    assignments: Mapped[List["Assignment"]] = relationship("Assignment", back_populates="design")


class Field(Base):
    __tablename__ = "field"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    field_id: Mapped[Optional[int]] = mapped_column(Integer, index=True)
    racen: Mapped[float] = mapped_column(Double, nullable=False)
    deccen: Mapped[float] = mapped_column(Double, nullable=False)
    position_angle: Mapped[Optional[float]] = mapped_column(REAL)
    # slots_exposures is 2x24, for dark/bright x LST
    slots_exposures: Mapped[Optional[list]] = mapped_column(ARRAY(Integer, dimensions=2))
    version_pk: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.version.pk", ondelete="CASCADE", onupdate="CASCADE"),
    )
    cadence_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.cadence.pk"), index=True
    )
    observatory_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.observatory.pk"), index=True
    )
    overplan_pk: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("targetdb.overplan.pk"))

    version: Mapped[Optional["Version"]] = relationship("Version")
    cadence: Mapped[Optional["Cadence"]] = relationship("Cadence")
    observatory: Mapped[Optional["Observatory"]] = relationship("Observatory")
    overplan: Mapped[Optional["Overplan"]] = relationship("Overplan")


class DesignToField(Base):
    __tablename__ = "design_to_field"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    design_id: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.design.design_id"), index=True
    )
    field_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.field.pk"), index=True
    )
    exposure: Mapped[Optional[int]] = mapped_column(BigInteger)
    field_exposure: Mapped[Optional[int]] = mapped_column(BigInteger)

    design: Mapped[Optional["Design"]] = relationship("Design")
    field: Mapped[Optional["Field"]] = relationship("Field")


class Assignment(Base):
    __tablename__ = "assignment"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    carton_to_target_pk: Mapped[Optional[int]] = mapped_column(
        BigInteger,
        ForeignKey("targetdb.carton_to_target.pk", ondelete="CASCADE", onupdate="CASCADE"),
        index=True,
    )
    hole_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.hole.pk"), index=True
    )
    instrument_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.instrument.pk"), index=True
    )
    design_id: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("targetdb.design.design_id", ondelete="CASCADE", onupdate="CASCADE"),
        index=True,
    )

    carton_to_target: Mapped[Optional["CartonToTarget"]] = relationship("CartonToTarget")
    hole: Mapped[Optional["Hole"]] = relationship("Hole")
    instrument: Mapped[Optional["Instrument"]] = relationship("Instrument")
    design: Mapped[Optional["Design"]] = relationship("Design", back_populates="assignments")


class AssignmentStatus(Base):
    __tablename__ = "assignment_status"

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    assignment_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.assignment.pk"), unique=True
    )
    status: Mapped[Optional[int]] = mapped_column(Integer)
    mjd: Mapped[Optional[float]] = mapped_column(REAL)

    assignment: Mapped[Optional["Assignment"]] = relationship("Assignment")


class TargetingGenerationToCarton(Base):
    __tablename__ = "targeting_generation_to_carton"
    __table_args__ = (
        UniqueConstraint("generation_pk", "carton_pk", "rs_stage", "rs_active"),
        {"schema": SCHEMA},
    )

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    generation_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.targeting_generation.pk"), index=True
    )
    carton_pk: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("targetdb.carton.pk"), index=True
    )
    rs_stage: Mapped[Optional[str]] = mapped_column(Text)
    rs_active: Mapped[Optional[bool]] = mapped_column(Boolean)

    targeting_generation: Mapped[Optional["TargetingGeneration"]] = relationship(
        "TargetingGeneration"
    )
    carton: Mapped[Optional["Carton"]] = relationship("Carton")


class TargetingGenerationToVersion(Base):
    __tablename__ = "targeting_generation_to_version"
    __table_args__ = (
        UniqueConstraint("generation_pk", "version_pk"),
        {"schema": SCHEMA},
    )

    pk: Mapped[int] = mapped_column(Integer, primary_key=True)
    generation_pk: Mapped[int] = mapped_column(
        Integer, ForeignKey("targetdb.targeting_generation.pk"), nullable=False, index=True
    )
    version_pk: Mapped[int] = mapped_column(
        Integer, ForeignKey("targetdb.version.pk"), nullable=False, index=True
    )

    targeting_generation: Mapped["TargetingGeneration"] = relationship("TargetingGeneration")
    version: Mapped["Version"] = relationship("Version")


def define_relations():
    """Relationships are defined in the models."""
    pass


# prepare the base
database.add_base(Base)
