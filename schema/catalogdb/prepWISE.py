#!/usr/bin/env python
# encoding: utf-8

# remove the trailing | from each line in wise data files,
# it screws up loading via \copy


from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import os
from multiprocessing import Pool
import glob


import bz2

fromDir = "/scratch/general/lustre/u0449727/wise/irsa.ipac.caltech.edu/data/download/wise-allwise"
toDir = "/scratch/general/lustre/u0449727/wise/prepCSV"

fromFiles = sorted(glob.glob(fromDir+"/wise-allwise*.bz2"))


def writeCSV(wiseFile):
    # cant pass out dir using multiprocessing?
    outFilePath = wiseFile.split("/")[-1].split(".bz2")[0]
    outFilePath = os.path.join(toDir, outFilePath)
    outfile = open(outFilePath, "w")
    cf = bz2.BZ2File(wiseFile, "r")
    for line in cf:
        outLine = line.strip().strip("|") + "\r\n"
        outfile.write(outLine)
    cf.close()
    outfile.close()
    print("wrote: ", outFilePath)

pool = Pool(processes=12)
pool.map(writeCSV, fromFiles)


