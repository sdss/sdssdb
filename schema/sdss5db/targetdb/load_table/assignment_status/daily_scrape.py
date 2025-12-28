import os
import argparse
import sys
import time
from collections import defaultdict

import numpy as np
from astropy.time import Time
import pydl.pydlutils.yanny as yanny
import pandas as pd

from sdssdb.peewee.sdss5db import database
database.set_profile('operations')
database.become_admin()
from sdssdb.peewee.sdss5db import targetdb

def assnDict():
    # we're abusing the ddict default_factory
    return {"mjd": 0, "catalogid": 0}

def scrapeRecent(obs="APO", mjd_today=00000, base="", 
                 n_days=2):
    unixNow = time.time()
    secInDay = 60 * 60 * 24

    os.environ["OBSERVATORY"] = obs.upper()
    from sdssdb.peewee.sdss5db import opsdb
    d2s = opsdb.DesignToStatus

    doneDesigns = d2s.select(d2s.design_id)\
                    .where(d2s.completion_status_pk == 3)

    doneDesigns = [d.design_id for d in doneDesigns]

    base_dir = os.getenv('SDSSCORE_DIR')

    obs_dir = os.path.join(base_dir, f"{obs.lower()}/summary_files")

    top_level = os.listdir(obs_dir)

    designs = defaultdict(lambda: defaultdict(assnDict))

    check_mid_level = list()

    for tdir in top_level:
        thisdir = os.path.join(obs_dir, tdir)
        sub_dirs = os.listdir(thisdir)
        for sdir in sub_dirs:
            subdir = os.path.join(thisdir, sdir)
            timeStamp = os.path.getctime(subdir)

            if (unixNow - timeStamp) / secInDay < n_days and os.path.isdir(subdir):
                check_mid_level.append(subdir)

    for sub in check_mid_level:
        sum_files = os.listdir(sub)
        for s in sum_files:
            if "parquet" in s:
                continue
            sum_name = os.path.join(sub, s)
            timeStamp = os.path.getctime(sum_name)
            if (unixNow - timeStamp) / secInDay > n_days:
                continue

            summary = yanny.yanny(sum_name)
            mjd = int(summary["MJD"])
            if "is_dithered" in summary:
                is_dithered = int(summary["is_dithered"])
            else:
                is_dithered = False
            try:
                design_id = int(summary["design_id"])
                mjd = int(summary["MJD"])
            except ValueError as E:
                print(ValueError)
                print(summary["design_id"], s)
                continue

            if design_id not in doneDesigns or design_id < 0\
               or is_dithered or mjd_today - mjd > n_days:
                print(mjd_today - mjd)
                continue
            print(mjd, design_id)
            if design_id in designs:
                designs[design_id] = defaultdict(assnDict)
                print(f"resetting {design_id}, for {s}")
            n = 0
            for f in summary["FIBERMAP"]:
                if not f["assigned"] or (f["on_target"] and f["valid"]):
                    n += 1
                    continue
                if designs[design_id][f['carton_to_target_pk']]["mjd"] < mjd:
                    designs[design_id][f['carton_to_target_pk']]["mjd"] = mjd
                    designs[design_id][f['carton_to_target_pk']]["catalogid"] = f["catalogid"]

    # base = os.getcwd()

    knocked_out_file = f"{base}/bad_assn_{obs}_{mjd_today}.dat"
    with open(knocked_out_file, "w") as writeBad:
        print("design_id, mjd, carton_to_target_pk, catalogid \n", file=writeBad)
        for design_id in designs.keys():
            for pk, adict in designs[design_id].items():
                print(f"{design_id}, {adict['mjd']}, {pk}, {adict['catalogid']}", file=writeBad)
    
    return knocked_out_file

def updateDB(obs="APO", badTargsFile=""):
    os.environ["OBSERVATORY"] = obs
    from sdssdb.peewee.sdss5db import opsdb

    badTargs = np.genfromtxt(badTargsFile,
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

    if obs == "APO":
        dbVersion = targetdb.Version.get(plan="iota-1")
    else:
        dbVersion = targetdb.Version.get(plan="iota-1")

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

    # badFieldsMjds = yaml.load(open(f"{base}/badFieldMjds_{obs.lower()}.yml"), Loader=yaml.FullLoader)

    # designsToOverride = list()
    # for mjd, fieldList in badFieldsMjds.items():
    #     # we're gonna want all boss assignments
    #     doneOnMjd = d2s.select(d2s.design_id)\
    #                     .where(d2s.mjd > mjd, d2s.mjd < mjd + 1)
    #     if len(fieldList) > 0:
    #         # this feature worked even if we aren't using it anymore
    #         doneOnMjd = doneOnMjd.join(d2f, on=(d2f.design_id == d2s.design_id))\
    #                                 .join(Field)\
    #                                 .where(Field.field_id << fieldList,
    #                                     Field.version == dbVersion)
    #     designsToOverride.extend([d.design_id for d in doneOnMjd])
    #     print(f"{mjd} found {len([d.design_id for d in doneOnMjd])}, up to {len(designsToOverride)} total")

    setNotDone = list()
    notDoneCat = list()

    for d in designs:
        missed_cut = np.where(badTargs["design_id"] == d)
        assn_cut = np.where(assnDone["design_id"] == d)
        if len(assn_cut[0]) == 0 or len(missed_cut[0]) == 0:
            # print("skipped?", d)
            continue
        missed_c2t = badTargs["catalogid"][missed_cut]
        assn_c2t = assnDone["catalogid"].values[assn_cut]

        where_bad_cfg = np.isin(assn_c2t, missed_c2t)

        rm_assn = np.unique(assnDone["pk"].values[assn_cut][where_bad_cfg])
        rm_assn = list(rm_assn)

        if len(assnDone["mjd"].values[assn_cut][where_bad_cfg]) == 0:
            # print(f"{d} has no more assnDone?")
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

        # if d in designsToOverride:
        #     w_assn_boss = np.where(assnDone["instrument"].values[assn_cut] == boss.pk)
        #     rm_boss = assnDone["pk"].values[assn_cut][w_assn_boss]
        #     print(f"removing {len(rm_boss)} on {d} for bad field mjd")

        #     # returns rm boss not in rm assn
        #     check_repeat = np.isin(rm_boss, rm_assn, invert=True)
        #     rm_boss2 = list(rm_boss[check_repeat])
        #     setNotDone.extend(rm_boss2)

    print(f"setting {len(setNotDone)} not done, from {len(notDoneCat)} scraped for {obs}")

    # print(f"draft, if live would mark {len(setNotDone)} not done")
    # return

    for i in range(len(setNotDone)+300)[::300]:
        this_set = setNotDone[i:i+300]
        res = AssnStat.update(status=0)\
                    .where(AssnStat.assignment_pk << this_set).execute()
        print(i, res)


def cpOpsdbToStat(mjd, obs):
    res = database.execute_sql(f"""
    with new_stat as (
    select stat.pk, d2s.mjd
    from targetdb.assignment_status as stat
    join targetdb.assignment as assn on assn.pk = stat.assignment_pk
    join opsdb_{obs}.design_to_status as d2s on d2s.design_id = assn.design_id 
    where d2s.mjd > {mjd-0.2} and d2s.completion_status_pk = 3
    )

    update targetdb.assignment_status assn_stat
    set status = 1, mjd = new_stat.mjd
    from new_stat
    where new_stat.pk = assn_stat.pk;
    """)

    print("DB result", res)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog=os.path.basename(sys.argv[0]),
        description="""update assignmentStatus from conf summary""")

    parser.add_argument("-l", "--loc", dest="loc", type=str,
                        required=False, help="location, default both",
                        default="apo")
    parser.add_argument("-b", "--base", dest="base", type=str,
                        required=False, help="base directory to save output",
                        default=None)
    parser.add_argument("-n", "--n_days", dest="n_days", type=str,
                        required=False, help="number of days to scrape",
                        default=2)


    args = parser.parse_args()
    base = args.base
    loc = args.loc.upper()
    n_days = int(args.n_days)

    if base is None:
        base = os.path.join(os.getcwd(), "logs")

    now = Time.now()
    now.format = "mjd"
    mjd_now = now.value - 1

    mjd_now = round(mjd_now)

    badTargsFile = scrapeRecent(obs=loc, mjd_today=mjd_now, base=base, n_days=n_days)
    cpOpsdbToStat(mjd_now, loc)
    updateDB(obs=loc, badTargsFile=badTargsFile)
