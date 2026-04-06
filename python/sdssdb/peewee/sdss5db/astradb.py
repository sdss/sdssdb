#!/usr/bin/env python
# -*- coding: utf-8 -*-

import importlib

from . import database

ASTRA_SCHEMA = getattr(database, "astra_schema", "astra_050")

def _select_module(schema_name: str):
    """Select the correct astra ORM module"""
    schema_name = schema_name or "astra_050"
    if schema_name.startswith("astra_050"):
        return "._astra.v050"
    if schema_name.startswith("astra_080"):
        return "._astra.v080"
    if schema_name.startswith("astra_081"):
        return "._astra.v081"
    raise ValueError(f"Unsupported astra schema: {schema_name}")

# remove previously loaded models from the namespace
for _old_name in list(globals().get('_astra_model_names', [])):
    globals().pop(_old_name, None)

_SELECTED = _select_module(ASTRA_SCHEMA)
_mod = importlib.import_module(_SELECTED, package=__package__)

_astra_model_names = []
for _name, _value in vars(_mod).items():
    if _name.startswith("_"):
        continue
    globals()[_name] = _value
    _astra_model_names.append(_name)

__all__ = _astra_model_names
