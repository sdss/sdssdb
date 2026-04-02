#!/usr/bin/env python
# -*- coding: utf-8 -*-

import importlib

from . import database


ASTRA_SCHEMA = getattr(database, "astra_schema", "astra_050")


def _select_module(schema_name: str):
    """Select the correct astra ORM module"""
    schema_name = schema_name or "astra_050"
    if schema_name.startswith("astra_050"):
        return ".astra.v050"
    if schema_name.startswith("astra_080"):
        return ".astra.v080"
    if schema_name.startswith("astra_081"):
        return ".astra.v081"
    raise ValueError(f"Unsupported astra schema: {schema_name}")


_SELECTED = _select_module(ASTRA_SCHEMA)
_mod = importlib.import_module(_SELECTED, package=__package__)

for _name, _value in vars(_mod).items():
    if _name.startswith("_"):
        continue
    globals()[_name] = _value

__all__ = [name for name in globals() if not name.startswith("_")]
