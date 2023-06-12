import numpy as np
from sdssdb.peewee.sdss5db import targetdb

targetdb.database.connect_from_parameters(user='sdss',
                                          host='operations.sdss.utah.edu',
                                          port=5432)

Cadence = targetdb.Cadence

v2 = Cadence.select()\
            .where(Cadence.label % "%v2%")

for cad in v2:
    obs_mode = cad.obsmode_pk
    fixed = ["bright_time" if "bright" in i else i.strip() for i in obs_mode]

    diff = [i != j for i, j in zip (obs_mode, fixed)]

    # if np.any(diff):
    #     w = np.where(diff)
    #     print(cad.pk, cad.label, "\n", np.array(fixed)[w], "\n \n", np.array(obs_mode)[w])

    if np.any(diff):
        res = Cadence.update(obsmode_pk = fixed)\
                     .where(Cadence.pk == cad.pk).execute()
        print(cad.pk, res)
