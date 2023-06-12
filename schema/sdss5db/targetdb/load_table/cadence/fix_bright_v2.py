from sdssdb.peewee.sdss5db import targetdb

targetdb.database.connect_from_parameters(user='sdss',
                                          host='operations.sdss.utah.edu',
                                          port=5432)

Cadence = targetdb.Cadence

v2 = Cadence.select()\
            .where(Cadence.label % "%v2%")\
            .where(Cadence.label % "%mixed%" or
                   Cadence.label % "%bright%")

for cad in v2:
    obs_mode = cad.obsmode_pk
    fixed = ["bright_time" if "bright" in i else i for i in obs_mode]

    if fixed != obs_mode:
        res = Cadence.update(obsmode_pk = fixed)\
                     .where(Cadence.pk == cad.pk).execute()
        print(cad.pk, res)
