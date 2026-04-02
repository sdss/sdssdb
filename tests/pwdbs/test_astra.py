
import pytest
from sdssdb.peewee.sdss5db import database, astradb as astra

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
    # assert 050 schema stay the same
    assert astra.Grok._meta.schema == "astra_050"


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
