#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2025-12-27
# @Filename: catalogdb_metadata.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import json
import os
import pathlib
import pickle

from sdssdb.peewee.sdss5db import catalogdb


def get_model(table_name: str) -> type[catalogdb.CatalogdbModel] | None:
    """Returns the Peewee model for a given ``catalogdb`` table name.

    Parameters
    ----------
    table_name
        The name of the table.

    Returns
    -------
    catalogdb.CatalogdbModel | None
        The Peewee model for the table, or :obj:`None` if not found.

    """

    for model in catalogdb.CatalogdbModel.__subclasses__():
        if model._meta.table_name == table_name:  # type: ignore[attr-defined]
            return model

    return None


def generate_catalogdb_metadata(
    minidb_pickle_file: os.PathLike | pathlib.Path,
    exclude_tables: list[str] = [],
    write_json: bool | os.PathLike | pathlib.Path = False,
) -> list[dict[str, str]]:
    """Generates metadata for the ``catalogdb`` tables.

    Parameters
    ----------
    minidb_pickle_file
        The path to a pickle file containing ``catalogdb`` documentation data from minidb.
        This can be generated using ``serialise_docs`` and then dumping the resulting dictionary
        to a pickle file. The
    write_json
        If :obj:`True`, writes the metadata to a JSON file named ``catalogdb_metadata.json`` in
        the current working directory. If a path is given, writes to that path instead.

    Returns
    -------
    list
        A list of column metadata dictionaries.

    """

    # Change this connection profile as necessary.
    catalogdb.database.set_profile("tunnel_operations")

    minidb_pickle_file = pathlib.Path(minidb_pickle_file)

    with minidb_pickle_file.open("rb") as f:
        minidb_docs = pickle.load(f)

    metadata: list[dict[str, str]] = []
    tables_done: list[str] = []

    # The data release. Used to remove the prefix from the minidb table names.
    dr = minidb_docs["dr"]

    for dr_table_name, table_info in minidb_docs["tables"].items():
        table_name: str = dr_table_name.replace(f"{dr}_", "", 1)
        tables_done.append(table_name)

        if table_name in exclude_tables:
            continue

        model = get_model(table_name)
        if model is None:
            print(f"Warning: No model found for table {table_name!r}.")
            continue

        model_meta = model._meta  # type: ignore[attr-defined]

        for col_name, field in model_meta.columns.items():
            col_metadata: dict[str, str] = {
                "schema": "catalogdb",
                "table_name": table_name,
                "column_name": "",
                "display_name": "",
                "sql_type": "",
                "description": "",
                "unit": "None",
            }

            minidb_col: dict[str, str] | None = None
            for col in table_info.get("columns", []):
                if col["name"] == col_name:
                    minidb_col = col
                    break

            if minidb_col is None:
                print(f"Warning: Column {col_name!r} not found in docs for table {table_name!r}.")
                continue
            else:
                col_metadata["description"] = minidb_col.get("description", "")
                col_metadata["unit"] = minidb_col.get("unit", "None") or "None"

            col_metadata["column_name"] = col_name
            col_metadata["display_name"] = col_name
            col_metadata["sql_type"] = field.field_type.lower()

            metadata.append(col_metadata)

    # Check tables with catalodb models that we have not processed.
    for model in catalogdb.CatalogdbModel.__subclasses__():
        model_meta = model._meta  # type: ignore[attr-defined]
        model_table_name = model_meta.table_name  # type: ignore[attr-defined]
        if model_table_name not in tables_done and model_table_name not in exclude_tables:
            print(f"Warning: Model for table {model_table_name!r} not found in minidb docs.")

            for col_name, field in model_meta.columns.items():
                col_metadata: dict[str, str] = {
                    "schema": "catalogdb",
                    "table_name": model_table_name,
                    "col_name": col_name,
                    "display_name": col_name,
                    "sql_type": field.field_type.lower(),
                    "description": "",
                    "unit": "None",
                }
                metadata.append(col_metadata)

    if write_json:
        if isinstance(write_json, bool):
            json_path = pathlib.Path.cwd() / "catalogdb_metadata.json"
        else:
            json_path = pathlib.Path(write_json)

        with json_path.open("w") as f:
            (json.dump({"metadata": metadata}, f, indent=2))

    return metadata
