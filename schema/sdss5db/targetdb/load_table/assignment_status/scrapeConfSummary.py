#!/usr/bin/env/python

import os
import argparse
import sys
from collections import defaultdict
import pydl.pydlutils.yanny as yanny

from sdssdb.peewee.sdss5db import database
database.set_profile('operations')


def assnDict():
    # we're abusing the ddict default_factory
    return {"mjd": 0, "catalogid": 0}


def checkObs(obs="APO", base="", start=0):
    os.environ["OBSERVATORY"] = obs
    from sdssdb.peewee.sdss5db import opsdb
    d2s = opsdb.DesignToStatus

    doneDesigns = d2s.select(d2s.design_id)\
                    .where(d2s.completion_status_pk == 3)

    doneDesigns = [d.design_id for d in doneDesigns]

    base_dir = os.getenv('SDSSCORE_DIR')

    obs_dir = os.path.join(base_dir, f"{obs.lower()}/summary_files")

    sub_dirs = os.listdir(obs_dir)

    designs = defaultdict(lambda: defaultdict(assnDict))

    skipped = 0
    bad_fibers = 0
    for i, sdir in enumerate(sub_dirs):
        percent_done = int(i/len(sub_dirs) * 100)
        print(f"working on {sdir}, {percent_done}, skipped {skipped}, bad {bad_fibers}")
        thisdir = os.path.join(obs_dir, sdir)
        sum_files = os.listdir(thisdir)
        for s in sum_files:
            cfg = s.split("-")[-1].split(".")[0]
            if start > int(cfg):
                continue
            sum_name = os.path.join(thisdir, s)
            summary = yanny.yanny(sum_name)
            mjd = int(summary["MJD"])
            try:
                design_id = int(summary["design_id"])
            except ValueError as E:
                print(ValueError)
                print(summary["design_id"], s)
                continue
            if design_id not in doneDesigns or design_id < 0:
                skipped += 1
                continue
            for f in summary["FIBERMAP"]:
                if not f["assigned"] or (f["on_target"] and f["valid"]):
                    continue
                if designs[design_id][f['carton_to_target_pk']]["mjd"] < mjd:
                    bad_fibers += 1
                    designs[design_id][f['carton_to_target_pk']]["mjd"] = mjd
                    designs[design_id][f['carton_to_target_pk']]["catalogid"] = f["catalogid"]

        # knocked_out_file = f"summaries/{sdir}.dat"
        # with open(knocked_out_file, "w") as writeKnocked:
        #     print(knocked_out, file=writeKnocked)

    if start:
        suffix = f"_{start}"
    else:
        suffix = ""
    knocked_out_file = f"{base}/bad_assn_{obs}{suffix}.dat"
    with open(knocked_out_file, "w") as writeBad:
        print("design_id, mjd, carton_to_target_pk, catalogid \n", file=writeBad)
        for design_id in designs.keys():
            for pk, adict in designs[design_id].items():
                print(f"{design_id}, {adict['mjd']}, {pk}, {adict['catalogid']}", file=writeBad)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        prog=os.path.basename(sys.argv[0]),
        description="""scrape conf summary yanny files""")

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
    loc = args.loc
    base = args.base
    start = args.start

    if base is None:
        base = os.path.expanduser("~/")

    if loc is None:
        checkObs(obs="APO", base=base, start=start)
        checkObs(obs="LCO", base=base, start=start)
    else:
        checkObs(obs=loc.upper(), base=base, start=start)
