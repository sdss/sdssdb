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

import psycopg
import psycopg.sql
from rich.console import Console


def update_sdss_id_to_astra_pipeline_table(
    uri: str,
    astra_version: str,
    pipeline_names: Sequence[str],
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
        The list of pipeline names to update the mapping for. They must match the names of tables
        in the Astra schema.
    quiet
        If ``True``, suppresses output messages.
    verbose
        If ``True``, enables verbose output messages.

    """

    console = Console(quiet=quiet, highlighter=None)

    if "postgresql://" not in uri and "postgresql+psycopg://" not in uri:
        uri = "postgresql://" + uri

    try:
        if verbose:
            console.print(f"[gray]Connecting to database at {uri} ...[/]")
        conn = psycopg.Connection.connect(uri)
    except Exception as e:
        raise ConnectionError(f"Could not connect to the database: {e}")

    if conn.closed:
        raise ConnectionError("Could not connect to the database.")

    console.print(f"[green]Connected to database at {uri}.[/]")

    # Schema name
    astra_schema = f"astra_{astra_version.replace('.', '')}"
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
            source_pk_col = psycopg.sql.Identifier("p", "source_pk")
            spectrum_pk_col = psycopg.sql.Identifier("p", "spectrum_pk")
        elif "source_pk_id" in columns and "spectrum_pk_id" in columns:
            source_pk_col = psycopg.sql.Identifier("p", "source_pk_id")
            spectrum_pk_col = psycopg.sql.Identifier("p", "spectrum_pk_id")
        else:
            raise ValueError(f"Could not find source_pk and spectrum_pk columns in '{pipeline}'.")

        query = """INSERT INTO vizdb.sdss_id_to_astra_pipeline (sdss_id, pipeline_name, v_astra, source_pk, spectrum_pk)
                    SELECT s.sdss_id, %s AS pipeline_name, %s AS v_astra,
                        {source_pk_col} AS source_pk, {spectrum_pk_col} AS spectrum_pk
                    FROM vizdb.sdss_id_flat s
                    JOIN {astra_source_table} a ON s.sdss_id = a.sdss_id
                    JOIN {astra_pipeline_table} p ON a.pk = {source_pk_col}
                    GROUP BY s.sdss_id, {source_pk_col}, {spectrum_pk_col};
        """

        astra_source_table = psycopg.sql.Identifier(astra_schema, "source")
        astra_pipeline_table = psycopg.sql.Identifier(astra_schema, pipeline)

        t0 = time()

        with conn.cursor() as cur:
            cur.execute(
                psycopg.sql.SQL(query).format(
                    astra_source_table=astra_source_table,
                    astra_pipeline_table=astra_pipeline_table,
                    source_pk_col=source_pk_col,
                    spectrum_pk_col=spectrum_pk_col,
                ),
                (pipeline, astra_version),
            )
            conn.commit()

            console.print(
                f"   [green]... Inserted {cur.rowcount:,} rows for pipeline {pipeline!r} "
                f"in {time() - t0:.2f} seconds.[/]"
            )

    return
