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

from playhouse.postgres_ext import ArrayField

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

    # Load minidb docs data.
    minidb_pickle_file = pathlib.Path(minidb_pickle_file)

    with minidb_pickle_file.open("rb") as f:
        minidb_docs = pickle.load(f)

    metadata: list[dict[str, str]] = []

    # The data release. Used to remove the prefix from the minidb table names.
    dr = minidb_docs["dr"]

    # Loop over each model in catalogdb.
    for model in catalogdb.CatalogdbModel.__subclasses__():
        model_meta = model._meta  # type: ignore[attr-defined]
        table_name = model_meta.table_name  # type: ignore[attr-defined]

        # Exclude tables as necessary.
        if table_name in exclude_tables:
            continue

        # Associated name of the table in minidb docs.
        minidb_table_name = f"{dr}_{table_name}"

        # If the table exists in the minidb docs, extract metadata from there.
        if minidb_table_name in minidb_docs["tables"]:
            docs_table_info = minidb_docs["tables"][minidb_table_name]

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
                for col in docs_table_info.get("columns", []):
                    if col["name"] == col_name:
                        minidb_col = col
                        break

                if minidb_col is None:
                    # Emit a warning but include the column with empty description.
                    print(f"Warning: Column {col_name!r} not found in docs for {table_name!r}.")
                else:
                    col_metadata["description"] = minidb_col.get("description", "")
                    col_metadata["unit"] = minidb_col.get("unit", "None") or "None"

                col_metadata["column_name"] = col_name
                col_metadata["display_name"] = col_name

                col_metadata["sql_type"] = field.field_type.lower()
                if isinstance(field, ArrayField):
                    col_metadata["sql_type"] += "[]"

                metadata.append(col_metadata)

        else:
            # Table not found in minidb docs. Emit a warning and add stubs.
            # We deal with catalog_to_ tables specially since those always have the same
            # columns and we can include complete descriptions.

            if not table_name.startswith("catalog_to_"):
                print(f"Warning: Model for table {table_name!r} not found in docs. Adding stub.")

            for col_name, field in model_meta.columns.items():
                field_type = field.field_type.lower()
                if isinstance(field, ArrayField):
                    field_type += "[]"

                col_metadata: dict[str, str] = {
                    "schema": "catalogdb",
                    "table_name": table_name,
                    "col_name": col_name,
                    "display_name": col_name,
                    "sql_type": field_type,
                    "description": "",
                    "unit": "None",
                }

                if table_name.startswith("catalog_to_"):
                    associated_table = table_name.replace("catalog_to_", "")
                    if col_name == "catalogid":
                        col_metadata["description"] = (
                            f"The catalogid identifier in the {table_name} table."
                        )
                    elif col_name == "targetid":
                        col_metadata["description"] = (
                            "The primary key identifier in the associated "
                            f"table {associated_table}."
                        )
                    elif col_name == "version_id":
                        col_metadata["description"] = "The internal version for the cross-match."
                    elif col_name == "best":
                        col_metadata["description"] = (
                            "Whether this is considered the best match between "
                            f"the catalog entry and {associated_table}."
                        )
                    elif col_name == "separation":
                        col_metadata["description"] = (
                            "The distance between the catalog and target coordinates if best=F."
                        )
                    elif col_name == "added_by_phase":
                        col_metadata["description"] = (
                            "Phase of the cross-match that added this entry."
                        )
                    elif col_name == "plan_id":
                        col_metadata["description"] = (
                            "Identifier of the cross-matching plan used to generate this file."
                        )

                metadata.append(col_metadata)

    if write_json:
        if isinstance(write_json, bool):
            json_path = pathlib.Path.cwd() / "catalogdb_metadata.json"
        else:
            json_path = pathlib.Path(write_json)

        with json_path.open("w") as f:
            (json.dump({"metadata": metadata}, f, indent=2))

    return metadata
