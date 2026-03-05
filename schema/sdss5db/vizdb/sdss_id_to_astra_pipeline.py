#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2026-01-29
# @Filename: sdss_id_to_astra_pipeline.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

from time import time

from typing import Sequence

from rich.console import Console

import peewee

from sdssdb.peewee import sdss5db


SPERCTRUM_TABLES: list[str] = [
    "apogee_visit_spectrum",
    "apogee_combined_spectrum",
    "apogee_coadded_spectrum_in_ap_star",
    "apogee_visit_spectrum_in_ap_star",
    "boss_visit_spectrum",
    "boss_combined_spectrum",
    "boss_rest_frame_visit_spectrum",
]


def update_sdss_id_to_astra_pipeline_table(
    uri: str,
    astra_version: str,
    pipeline_names: Sequence[str],
    drp_tables: Sequence[str] = SPERCTRUM_TABLES,
    quiet: bool = False,
    verbose: bool = False,
) -> None:
    """Updates the ``sdss_id_to_astra_pipeline`` table in the ``vizdb`` schema.

    Parameters
    ----------
    uri
        The database URI to connect to. Must be in the form
        ``postgresql://user:password@host:port/dbname`` (the scheme can be omitted).
        E.g., ``u0931042@pipelines.sdss.org/sdss5db``.
    astra_version
        The Astra version to update the table for. Must be a string like ``0.8.0``.
    pipeline_names
        The list of pipeline names to update the mapping for. They must match the
        names of tables in the Astra schema.
    drp_tables
        The list of DRP tables to process. If not provided, uses the default
        list of DRP tables.
    quiet
        If ``True``, suppresses output messages.
    verbose
        If ``True``, enables verbose output messages.

    """

    console = Console(quiet=quiet, highlighter=None)
    t0 = time()

    if "postgresql://" not in uri and "postgresql+psycopg://" not in uri:
        uri = "postgresql://" + uri

    try:
        if verbose:
            console.print(f"[gray]Connecting to database at {uri} ...[/]")

        database = sdss5db.database
        database.connect(uri)
        conn = database.connection()
    except Exception as e:
        raise ConnectionError(f"Could not connect to the database: {e}")

    if conn.closed:
        raise ConnectionError("Could not connect to the database.")

    console.print(f"[green]Connected to database at {uri}.[/]")

    # Schema name
    astra_schema = f"astra_{astra_version.replace('.', '')}"
    if astra_version == "0.6.0":
        astra_schema = "astra_050"  # Special case: astra 0.6.0 is included in the astra_050 schema

    if verbose:
        console.print(f"[gray]Using Astra schema '{astra_schema}'.[/]")

    # Check that the schema exists
    with conn.cursor() as cur:
        cur.execute(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name = %s;",
            (astra_schema,),
        )
        if cur.rowcount == 0:
            raise ValueError(f"The schema '{astra_schema}' does not exist in the database.")

    # We need to check which of the spectrum tables exist for a specific astra schema.
    found_drp_tables = []
    with conn.cursor() as cur:
        for table in drp_tables:
            cur.execute(
                """SELECT table_name
                   FROM information_schema.tables
                   WHERE table_schema = %s AND table_name = %s;""",
                (astra_schema, table),
            )
            if cur.rowcount > 0:
                found_drp_tables.append(table)

        console.print(
            f"[gray]Found {len(found_drp_tables)} DRP tables in schema "
            f"'{astra_schema}': {', '.join(found_drp_tables)}.[/]"
        )

    sdss_id_table = peewee.Table("sdss_id_flat", schema="vizdb").bind(database)
    astra_source_table = peewee.Table("source", schema=astra_schema).bind(database)

    for pipeline in pipeline_names:
        console.print(f"[blue]Processing pipeline '{pipeline}' ...[/]")

        # Check if the pipeline table exists.
        with conn.cursor() as cur:
            cur.execute(
                """SELECT table_name
                   FROM information_schema.tables
                   WHERE table_schema = %s AND table_name = %s;""",
                (astra_schema, pipeline),
            )
            if cur.rowcount == 0:
                console.print(
                    f"   [red]... Pipeline table '{pipeline}' does not exist in schema "
                    f"'{astra_schema}'. Skipping.[/]"
                )
                continue

        # Check if the pipeline has already been processed. If so, skip it.
        with conn.cursor() as cur:
            cur.execute(
                """SELECT 1 FROM vizdb.sdss_id_to_astra_pipeline
                   WHERE pipeline_name = %s AND v_astra = %s LIMIT 1;""",
                (pipeline, astra_version),
            )
            if cur.rowcount > 0:
                console.print(
                    f"   [yellow]... Pipeline {pipeline!r} for Astra version {astra_version!r} "
                    "already processed. Skipping.[/]"
                )
                continue

        # For some versions astra uses "source_pk" and "spectrum_pk" in the pipeline tables,
        # for others "source_pk_id" and "spectrum_pk_id". We need to figure out which one to use.
        query = """SELECT column_name
                    FROM information_schema.columns
                    WHERE table_name = %s AND table_schema = %s;
        """

        with conn.cursor() as cur:
            cur.execute(query, (pipeline, astra_schema))
            columns = [row[0] for row in cur.fetchall()]

        if "source_pk" in columns and "spectrum_pk" in columns:
            source_pk_col = "source_pk"
            spectrum_pk_col = "spectrum_pk"
        elif "source_pk_id" in columns and "spectrum_pk_id" in columns:
            source_pk_col = "source_pk_id"
            spectrum_pk_col = "spectrum_pk_id"
        else:
            raise ValueError(f"Could not find source_pk and spectrum_pk columns in '{pipeline}'.")

        # Phase 1: Join sdss_id with the pipeline table and get the spectra associated with
        # that source. Store that in a temporary table.

        pipeline_table = peewee.Table(pipeline, schema=astra_schema).bind(database)
        pipeline_spectrum_col = getattr(pipeline_table.c, spectrum_pk_col)

        query = (
            sdss_id_table.select(
                *[
                    sdss_id_table.c.sdss_id,
                    peewee.Value(pipeline).alias("pipeline_name"),
                    peewee.Value(astra_version).alias("v_astra"),
                    astra_source_table.c.pk.alias("source_pk"),
                    pipeline_spectrum_col.alias("spectrum_pk"),
                ]
            )
            .distinct(pipeline_spectrum_col)
            .join(
                astra_source_table,
                on=(sdss_id_table.c.sdss_id == astra_source_table.c.sdss_id),
            )
            .join(
                pipeline_table,
                on=(astra_source_table.c.pk == getattr(pipeline_table.c, source_pk_col)),
            )
            .where(pipeline_table.c.v_astra == astra_version)
            .order_by(pipeline_spectrum_col.desc(), pipeline_table.c.created.desc())
            .group_by(
                sdss_id_table.c.sdss_id,
                astra_source_table.c.pk,
                pipeline_spectrum_col,
                pipeline_table.c.created,
            )
        )

        t1 = time()

        with conn.cursor() as cur:
            cur.execute(f"CREATE TEMP TABLE tmp_astra_{pipeline}_1 AS {query!s};")
            console.print(
                f"   [green]... Identified {cur.rowcount:,} rows for pipeline {pipeline!r} "
                f"in {time() - t1:.2f} seconds.[/]"
            )

        # Phase 2: Left outer join each row in the temporary table with each one of the DRP
        # tables and get the DRP version. Only one of the DRP tables should match. We'll get the
        # valid result later.

        t2 = time()

        temp_table_1 = peewee.Table(f"tmp_astra_{pipeline}_1").bind(database)

        query = temp_table_1.select(temp_table_1.__star__)

        for drp_table_name in found_drp_tables:
            drp_table = peewee.Table(drp_table_name, schema=astra_schema).bind(database)
            drp_table_spectrum_pk_col = getattr(drp_table.c, spectrum_pk_col)

            if drp_table_name.startswith("apogee"):
                drp_version_col = getattr(drp_table.c, "apred")
            else:
                drp_version_col = getattr(drp_table.c, "run2d")

            query = query.join(
                drp_table,
                peewee.JOIN.LEFT_OUTER,
                on=(temp_table_1.c.spectrum_pk == drp_table_spectrum_pk_col),
            ).select_extend(drp_version_col.alias(drp_table_name))

        with conn.cursor() as cur:
            cur.execute(f"CREATE TEMP TABLE tmp_astra_{pipeline}_2 AS {query!s};")
            console.print(
                f"   [green]... Matched pipeline results with DRP tables in "
                f"{time() - t2:.2f} seconds.[/]"
            )

        # Phase 3: Coalesce the DRP version columns and get the name of the DRP table that matched.
        # Insert the information into the final sdss_id_to_astra_pipeline table.

        t3 = time()

        temp_table_2 = peewee.Table(f"tmp_astra_{pipeline}_2").bind(database)
        coalesce_expr = peewee.fn.COALESCE(
            *[getattr(temp_table_2.c, col) for col in found_drp_tables],
            None,
        )

        query = temp_table_2.select(
            temp_table_2.c.sdss_id,
            temp_table_2.c.pipeline_name,
            temp_table_2.c.v_astra,
            temp_table_2.c.source_pk,
            temp_table_2.c.spectrum_pk,
            peewee.Case(
                None,
                (
                    (
                        getattr(temp_table_2.c, col).is_null(False),
                        peewee.Value(col),
                    )
                    for col in found_drp_tables
                ),
                None,
            ).alias("drp_table"),
            coalesce_expr.alias("drp_version"),
        ).where(coalesce_expr.is_null(False))

        with conn.cursor() as cur:
            cur.execute(
                f"""INSERT INTO vizdb.sdss_id_to_astra_pipeline
                    (sdss_id, pipeline_name, v_astra, source_pk, spectrum_pk, drp_table, drp_version)
                    {query!s};"""
            )
            console.print(
                f"   [green]... Inserted {cur.rowcount:,} rows into "
                f"'vizdb.sdss_id_to_astra_pipeline' in {time() - t3:.2f} seconds.[/]"
            )

        # Phase 4: Fil out the "is_coadd" and "mjd" columns for the rows we just inserted.
        # For coadd tables we set "is_coadd" to True and leave "mjd" as NULL.
        # For visit tables we set "is_coadd" to False and get the MJD from the DRP table.

        t4 = time()

        for drp_table_name in found_drp_tables:
            is_coadd = "visit" not in drp_table_name
            if is_coadd:
                update_query = """
                    UPDATE vizdb.sdss_id_to_astra_pipeline
                    SET is_coadd = TRUE
                    WHERE pipeline_name = %s AND v_astra = %s AND drp_table = %s;
                """
                with conn.cursor() as cur:
                    cur.execute(update_query, (pipeline, astra_version, drp_table_name))
                continue

            drp_table = peewee.Table(drp_table_name, schema=astra_schema).bind(database)
            drp_table_spectrum_pk_col = getattr(drp_table.c, spectrum_pk_col)

            query = f"""
                UPDATE vizdb.sdss_id_to_astra_pipeline AS t
                SET mjd = d.mjd, is_coadd = FALSE
                FROM {astra_schema}.{drp_table_name} AS d
                WHERE t.pipeline_name = %s
                AND t.v_astra = %s
                AND t.drp_table = %s
                AND t.spectrum_pk = d.{drp_table_spectrum_pk_col.name};
            """

            with conn.cursor() as cur:
                cur.execute(query, (pipeline, astra_version, drp_table_name))

        console.print(
            f"   [green]... Updated 'is_coadd' and 'mjd' columns for pipeline '{pipeline}' in "
            f"{time() - t4:.2f} seconds.[/]"
        )

        # All done for this pipeline.

        console.print(
            f"   [green]... Finished processing pipeline '{pipeline}' in "
            f"{time() - t1:.2f} seconds.[/]"
        )

    console.print(
        "[blue]Finished updating 'sdss_id_to_astra_pipeline'"
        f" table in {time() - t0:.2f} seconds.[/]"
    )
    return
