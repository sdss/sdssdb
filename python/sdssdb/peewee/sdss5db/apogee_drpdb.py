from peewee import IntegerField

from .. import BaseModel
from . import database


class ApogeeDRPDBmodel(BaseModel):
    class Meta:
        database = database
        schema = "apogee_drp"
        primary_key = False
        use_reflection = True
        reflection_options = {"skip_foreign_keys": True, "use_peewee_reflection": False}


class CalibrationStatus(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "calib_status"


class DailyStatus(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "daily_status"


class Exposure(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "exposure"


class ExposureStatus(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "exposure_status"


class MasterCalibrationStatus(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "mastercal_status"


class Plan(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "mastercal_status"


class RvStatus(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "rv_status"


class RvVisit(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "rv_visit"


class Star(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "star"


class StarLatest(ApogeeDRPDBmodel):
    class Meta:
        table_name = "star_latest"


class Version(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "version"


class Visit(ApogeeDRPDBmodel):

    pk = IntegerField(primary_key=True)

    class Meta:
        table_name = "visit"


class VisitLatest(ApogeeDRPDBmodel):
    class Meta:
        table_name = "visit_latest"


class VisitStatus(ApogeeDRPDBmodel):
    class Meta:
        table_name = "visit_status"
