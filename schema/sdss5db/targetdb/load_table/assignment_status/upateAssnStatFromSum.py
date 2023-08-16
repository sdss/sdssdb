#!/usr/bin/env python

import argparse
import sys
import os
import yaml
import numpy as np
import pandas as pd
from sdssdb.peewee.sdss5db import database
database.set_profile('operations')
database.become_admin()
from sdssdb.peewee.sdss5db import targetdb

# targetdb.database.connect_from_parameters(user='sdss',
#                                           host='operations.sdss.utah.edu',
#                                           port=5432)

def updateAssnStat(obs="APO", base="", start=0):
    os.environ["OBSERVATORY"] = obs
    from sdssdb.peewee.sdss5db import opsdb

    if start:
        suffix = f"_{start}"
    else:
        suffix = ""

    badTargs = np.genfromtxt(f"{base}/bad_assn_{obs}{suffix}.dat",
                            names=True, encoding="UTF-8",
                            dtype=('<i8', '<i8', '<i8', '<i8'), delimiter=",")

    Assn = targetdb.Assignment
    AssnStat = targetdb.AssignmentStatus
    Design = targetdb.Design
    d2f = targetdb.DesignToField
    Field = targetdb.Field
    c2t = targetdb.CartonToTarget
    Target = targetdb.Target
    d2s = opsdb.DesignToStatus

    if obs.upper() == "APO":
        dbVersion = targetdb.Version.get(plan="zeta-3")
    else:
        dbVersion = targetdb.Version.get(plan="zeta-4-commissioning-0")
    boss = targetdb.Instrument.get(label="BOSS")

    dones = AssnStat.select(Assn.carton_to_target, Design.design_id,
                            Assn.pk, Target.catalogid, AssnStat.mjd,
                            Assn.instrument_pk)\
                    .join(Assn, on=(AssnStat.assignment_pk == Assn.pk))\
                    .join(Design)\
                    .join(d2f).join(Field)\
                    .switch(Assn)\
                    .join(c2t).join(Target)\
                    .where(AssnStat.status == 1,
                        Field.version == dbVersion)

    assnDone = pd.DataFrame(dones.dicts())
    designs = np.unique(assnDone["design_id"])

    badFieldsMjds = yaml.load(open(f"{base}/badFieldMjds_{obs.lower()}.yml"), Loader=yaml.FullLoader)

    designsToOverride = list()
    for mjd, fieldList in badFieldsMjds.items():
        # we're gonna want all boss assignments
        doneOnMjd = d2s.select(d2s.design_id)\
                        .where(d2s.mjd > mjd, d2s.mjd < mjd + 1)
        if len(fieldList) > 0:
            # this feature worked even if we aren't using it anymore
            doneOnMjd = doneOnMjd.join(d2f, on=(d2f.design_id == d2s.design_id))\
                                    .join(Field)\
                                    .where(Field.field_id << fieldList,
                                        Field.version == dbVersion)
        designsToOverride.extend([d.design_id for d in doneOnMjd])
        print(f"{mjd} found {len([d.design_id for d in doneOnMjd])}, up to {len(designsToOverride)} total")

    setNotDone = list()
    notDoneCat = list()

    for d in designs:
        missed_cut = np.where(badTargs["design_id"] == d)
        assn_cut = np.where(assnDone["design_id"] == d)
        if len(assn_cut[0]) == 0 or len(missed_cut[0]) == 0:
            print("skipped?", d)
            continue
        missed_c2t = badTargs["catalogid"][missed_cut]
        assn_c2t = assnDone["catalogid"].values[assn_cut]

        where_bad_cfg = np.isin(assn_c2t, missed_c2t)

        rm_assn = np.unique(assnDone["pk"].values[assn_cut][where_bad_cfg])
        rm_assn = list(rm_assn)

        if len(assnDone["mjd"].values[assn_cut][where_bad_cfg]) == 0:
            print(f"{d} has no more assnDone?")
            continue

        conf_sum_mjd = np.max(assnDone["mjd"].values[assn_cut][where_bad_cfg])
        complete_mjd = np.max(badTargs["mjd"][missed_cut])

        if complete_mjd > conf_sum_mjd:
            print(f"design {d} completed {complete_mjd}, after bad conf {conf_sum_mjd}")
            continue

        if len(rm_assn) != len(missed_c2t):
            print(f"{d} has {len(missed_c2t)-len(rm_assn)} of {len(missed_c2t)} unaccounted for or already incomplete")

        # assert len(rm_assn) == len(missed_c2t), "assignment not found"
        setNotDone.extend(rm_assn)
        notDoneCat.extend(list(missed_c2t))

        where_bad_cfg = np.isin(missed_c2t, assn_c2t, invert=True)
        uncaught_mjds = badTargs["mjd"][missed_cut][where_bad_cfg]
        if len(uncaught_mjds) > 0:
            print("MISSING BAD FIBERS", d, np.unique(uncaught_mjds))

        if d in designsToOverride:
            w_assn_boss = np.where(assnDone["instrument"].values[assn_cut] == boss.pk)
            rm_boss = assnDone["pk"].values[assn_cut][w_assn_boss]
            print(f"removing {len(rm_boss)} on {d} for bad field mjd")

            # returns rm boss not in rm assn
            check_repeat = np.isin(rm_boss, rm_assn, invert=True)
            rm_boss2 = list(rm_boss[check_repeat])
            setNotDone.extend(rm_boss2)

    print(f"setting {len(setNotDone)} not done, from {len(notDoneCat)} scraped")

    # print(f"draft, if live would mark {len(setNotDone)} not done")

    AssnStat.update(status=0).where(AssnStat.pk << setNotDone).execute()


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        prog=os.path.basename(sys.argv[0]),
        description="""update assignmentStatus from conf summary""")

    parser.add_argument("-l", "--loc", dest="loc", type=str,
                        required=False, help="location, default both",
                        default=None)
    parser.add_argument("-b", "--base", dest="base", type=str,
                        required=False, help="base directory to save output",
                        default=None)
    parser.add_argument("-s", "--start", dest="start", type=int,
                        required=False, help="start configuration",
                        default=0)

    args = parser.parse_args()
    base = args.base
    start = args.start

    if base is None:
        base = os.path.expanduser("~/")

    if args.loc is None:
        updateAssnStat(obs="APO", base=base, start=start)
        updateAssnStat(obs="LCO", base=base, start=start)
    else:
        loc = args.loc.upper()
        updateAssnStat(obs=loc.upper(), base=base, start=start)