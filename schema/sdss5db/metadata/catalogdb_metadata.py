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

from typing import Sequence

from playhouse.postgres_ext import ArrayField

from sdssdb.peewee.sdss5db import catalogdb


CATALOG_TO_DESCRIPTIONS = {
    "catalogid": "The catalogid identifier in the {table_name} table.",
    "target_id": "The primary key identifier in the associated table {associated_table}.",
    "version_id": "The internal version for the cross-match.",
    "best": "Whether this is considered the best match between the catalog entry and {associated_table}.",
    "distance": ("The distance between the catalog and target coordinates if best=F."),
    "added_by_phase": "Phase of the cross-match that added this entry.",
    "plan_id": "Identifier of the cross-matching plan used to generate this file.",
}


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
                    print(f"Warning: Column '{table_name}.{col_name}' not found in minidb docs.")
                else:
                    col_metadata["description"] = minidb_col.get("description", "")
                    col_metadata["unit"] = minidb_col.get("unit", "None") or "None"

                if col_metadata["description"] == "" and table_name.startswith("catalog_to_"):
                    associated_table = table_name.replace("catalog_to_", "")
                    if col_name in CATALOG_TO_DESCRIPTIONS:
                        col_metadata["description"] = CATALOG_TO_DESCRIPTIONS[col_name].format(
                            table_name=table_name,
                            associated_table=associated_table,
                        )

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
                print(f"Warning: Table {table_name!r} not found in minidb docs. Adding stub.")

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

                if table_name.startswith("catalog_to_") and col_name in CATALOG_TO_DESCRIPTIONS:
                    associated_table = table_name.replace("catalog_to_", "")
                    col_metadata["description"] = CATALOG_TO_DESCRIPTIONS[col_name].format(
                        table_name=table_name,
                        associated_table=associated_table,
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


def get_table_data(
    table_name: str,
    metadata_path: os.PathLike | pathlib.Path | None = None,
) -> list[dict[str, str]]:
    """Lists the columns of a given ``catalogdb`` table.

    Parameters
    ----------
    table_name
        The name of the table.
    metadata_path
        The path to the JSON file containing the metadata. If :obj:`None`, assumes the default
        location in ``sdssdb``.

    Returns
    -------
    list
        A list of column data.

    """

    if metadata_path is None:
        cwd = pathlib.Path(__file__).parent
        metadata_path = cwd / "catalogdb.json"
    else:
        metadata_path = pathlib.Path(metadata_path)

    data = json.loads(open(metadata_path, "r").read())

    table_data: list[dict[str, str]] = []
    for col in data["metadata"]:
        if col["table_name"] == table_name:
            table_data.append(col)

    return table_data


def update_catalogdb_metadata(
    data: list[dict[str, str]] | dict[str, str],
    metadata_path: os.PathLike | pathlib.Path | None = None,
) -> None:
    """Updates the metadata of a given column in a table.

    Parameters
    ----------
    data
        A dictionary with the fields to update, or a list of such dictionaries.
    metadata_path
        The path to the JSON file containing the metadata. If :obj:`None`, assumes the default
        location in ``sdssdb``.

    """

    if metadata_path is None:
        cwd = pathlib.Path(__file__).parent
        metadata_path = cwd / "catalogdb.json"
    else:
        metadata_path = pathlib.Path(metadata_path)

    if isinstance(data, dict):
        data = [data]
    elif isinstance(data, Sequence):
        pass
    else:
        raise ValueError("data must be a dictionary or a list of dictionaries.")

    catalogdb_metadata = json.loads(open(metadata_path, "r").read())

    for data_col in data:
        if not isinstance(data_col, dict):
            raise ValueError("Each item in data must be a dictionary.")
        if "table_name" not in data_col or "column_name" not in data_col:
            raise ValueError("Each dictionary must contain 'table_name' and 'column_name' keys.")

    for col in catalogdb_metadata["metadata"]:
        for data_col in data:
            if (
                col["table_name"] == data_col["table_name"]
                and col["column_name"] == data_col["column_name"]
            ):
                col.update(data_col)

    with metadata_path.open("w") as f:
        json.dump(catalogdb_metadata, f, indent=2)


def update_catalog_to_descriptions(
    metadata_path: os.PathLike | pathlib.Path | None = None,
) -> None:
    """Updates all ``catalog_to_`` table descriptions in the metadata.

    Parameters
    ----------
    metadata_path
        The path to the JSON file containing the metadata. If :obj:`None`, assumes the default
        location in ``sdssdb``.

    """

    if metadata_path is None:
        cwd = pathlib.Path(__file__).parent
        metadata_path = cwd / "catalogdb.json"
    else:
        metadata_path = pathlib.Path(metadata_path)

    data = json.loads(open(metadata_path, "r").read())

    updated_data: list[dict[str, str]] = []
    for col in data["metadata"]:
        if col["table_name"].startswith("catalog_to_") and col["description"].strip() == "":
            associated_table = col["table_name"].replace("catalog_to_", "")
            if col["column_name"] in CATALOG_TO_DESCRIPTIONS:
                col["description"] = CATALOG_TO_DESCRIPTIONS[col["column_name"]].format(
                    table_name=col["table_name"],
                    associated_table=associated_table,
                )
                updated_data.append(col)

    update_catalogdb_metadata(updated_data, metadata_path=metadata_path)


def list_missing_descriptions(
    metadata_path: os.PathLike | pathlib.Path | None = None,
    only_tables: bool = False,
    only_arrays: bool = False,
) -> list[str]:
    """Lists all columns in ``catalogdb`` missing descriptions.

    Parameters
    ----------
    metadata_path
        The path to the JSON file containing the metadata. If :obj:`None`, assumes the default
        location in ``sdssdb``.
    only_tables
        Returns a list of tables in which at least one column is missing a description.
    only_arrays
        If :obj:`True`, only lists array columns missing descriptions.

    Returns
    -------
    list
        A list of column names missing descriptions.

    """

    if metadata_path is None:
        cwd = pathlib.Path(__file__).parent
        metadata_path = cwd / "catalogdb.json"
    else:
        metadata_path = pathlib.Path(metadata_path)

    data = json.loads(open(metadata_path, "r").read())

    missing: list[str] = []
    for col in data["metadata"]:
        if col["description"].strip() == "":
            if only_arrays and not col["sql_type"].endswith("[]"):
                continue
            missing.append(f"{col['table_name']}.{col['column_name']}")

    if only_tables:
        tables = set()
        for col in missing:
            table_name = col.split(".")[0]
            tables.add(table_name)
        return sorted(list(tables))

    return missing
