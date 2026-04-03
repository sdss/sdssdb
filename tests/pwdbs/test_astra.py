
import pytest
from sdssdb.peewee.sdss5db import database, astradb as astra
from sdssdb.peewee.sdss5db.astradb import _select_module

schemas = ['050', '080', '081']

@pytest.fixture(params=schemas)
def schema(request):
    return f'astra_{request.param}'


def test_change_astra_schema(schema):
    """test we can change the astra schema"""
    database.set_astra_schema(schema)
    assert database.astra_schema == schema
    assert astra.ASTRA_SCHEMA == schema
    assert astra.BossNet._meta.schema == schema


def test_model_changes():
    """test that changing the astra schema changes the model definitions"""
    database.set_astra_schema("astra_050")
    assert astra.BossNet._meta.schema == "astra_050"
    assert hasattr(astra.BossNet, "v_rad")
    assert hasattr(astra.BossNet, "spectrum_pk_id")
    assert not hasattr(astra.BossNet, "spectrum_pk")
    assert not hasattr(astra.BossNet, "bn_v_r")
    assert not hasattr(astra.BossNet, "v_astra_major_minor")

    database.set_astra_schema("astra_081")
    assert astra.BossNet._meta.schema == "astra_081"
    assert not hasattr(astra.BossNet, "v_rad")
    assert not hasattr(astra.BossNet, "spectrum_pk_id")
    assert hasattr(astra.BossNet, "spectrum_pk")
    assert hasattr(astra.BossNet, "bn_v_r")
    assert hasattr(astra.BossNet, "v_astra_major_minor")


def test_fk_accessors_exist(schema):
    """test that source/spectrum FK accessors are present on all schema variants"""
    database.set_astra_schema(schema)
    assert hasattr(astra.BossNet, 'source')
    assert hasattr(astra.BossNet, 'spectrum')
    assert hasattr(astra.ApogeeNet, 'source')
    assert hasattr(astra.ApogeeNet, 'spectrum')


def test_fk_column_names():
    """test that v050 uses _id-suffixed FK columns and v080/v081 use bare names"""
    database.set_astra_schema("astra_050")
    assert astra.BossNet.source.column_name == 'source_pk_id'
    assert astra.BossNet.spectrum.column_name == 'spectrum_pk_id'

    database.set_astra_schema("astra_081")
    assert astra.BossNet.source.column_name == 'source_pk'
    assert astra.BossNet.spectrum.column_name == 'spectrum_pk'


def test_invalid_schema_raises():
    """test that an unsupported schema name raises ValueError"""
    with pytest.raises(ValueError, match="Unsupported astra schema"):
        _select_module("astra_999")


def test_schema_exclusive_models():
    database.set_astra_schema("astra_050")
    assert not hasattr(astra, 'MwmSpectrumProductStatus')
    assert hasattr(astra, 'Grok')
    assert astra.Grok._meta.schema == "astra_050"

    database.set_astra_schema("astra_081")
    assert not hasattr(astra, 'Grok')
    assert hasattr(astra, 'MwmSpectrumProductStatus')
    assert astra.MwmSpectrumProductStatus._meta.schema == "astra_081"

    database.set_astra_schema("astra_080")
    assert astra.MwmSpectrumProductStatus._meta.schema == "astra_080"
    assert not hasattr(astra, 'Grok')
