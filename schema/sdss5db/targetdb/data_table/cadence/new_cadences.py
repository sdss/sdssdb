#!/usr/bin/env python

import roboscheduler.cadence

# from sdssdb.peewee.sdss5db import database
# database.set_profile('operations')

obsmode = {
   "dark_plane":{
      "min_moon_sep": 35,
      "min_deltav_ks91": -1.5,
      "min_twilight_ang": 15,
      "max_airmass": 1.6,
      },
   "dark_monit":{
      "min_moon_sep": 35,
      "min_deltav_ks91": -1.5,
      "min_twilight_ang": 15,
      "max_airmass": 1.4,
      },
   "dark_rm":{
      "min_moon_sep": 35,
      "min_deltav_ks91": -1.5,
      "min_twilight_ang": 15,
      "max_airmass": 1.4,
      },
   "dark_faint":{
      "min_moon_sep": 35,
      "min_deltav_ks91": -0.5,
      "min_twilight_ang": 15,
      "max_airmass": 1.4,
      },
   "bright_time":{
      "min_moon_sep": 15,
      "min_deltav_ks91": -3,
      "min_twilight_ang": 8,
      "max_airmass": 2.0,
      }
}

def generate_cadence(nepochs=1, nexp=1, delta_min=0.5, delta_max=1.0, delta=None, 
                     max_length=1, name=None, obsmode_pk='bright_time'):
    if name is None:
        name = f'{obsmode_pk.split("_")[0]}_{nepochs}x{nexp}_v3'
    if delta is None:
        delta = (delta_min + delta_max) / 2

    skybrightness = [1.0] * nepochs
    delta = [delta] * nepochs
    delta[0] = 0
    delta_min = [delta_min] * nepochs
    delta_min[0] = 0
    delta_max = [delta_max] * nepochs
    delta_max[0] = 0
    nexp = [nexp] * nepochs
    max_length = [max_length] * nepochs
    min_moon_sep = [obsmode[obsmode_pk].get('min_moon_sep', 15)] * nepochs
    min_deltav_ks91 = [obsmode[obsmode_pk].get('min_deltav_ks91', -3)] * nepochs
    min_twilight_ang = [obsmode[obsmode_pk].get('min_twilight_ang', 8)] * nepochs
    max_airmass = [obsmode[obsmode_pk].get('max_airmass', 2.0)] * nepochs
    obsmode_pk = [obsmode_pk] * nepochs

    cadencelist.add_cadence(name=name,
                            nepochs=nepochs,
                            skybrightness=skybrightness,
                            delta=delta,
                            delta_min=delta_min,
                            delta_max=delta_max,
                            nexp=nexp,
                            max_length=max_length,
                            min_moon_sep=min_moon_sep,
                            min_deltav_ks91=min_deltav_ks91,
                            min_twilight_ang=min_twilight_ang,
                            max_airmass=max_airmass,
                            obsmode_pk=obsmode_pk,
                            label_root=name,
                            label_version='_v3')
    return


cadencelist = roboscheduler.cadence.CadenceList()

generate_cadence()
generate_cadence(nepochs=130, nexp=1, delta_min=0.2, delta_max=2.0, obsmode_pk='bright_time',
                 delta=1, max_length=0, name="bright_130x1_dense_02_v3")
generate_cadence(nepochs=130, nexp=1, delta_min=0.1, delta_max=2.0, obsmode_pk='bright_time',
                 delta=1, max_length=0, name="bright_130x1_dense_01_v3")
generate_cadence(nepochs=130, nexp=1, delta_min=1, delta_max=7.0, obsmode_pk='bright_time',
                 delta=3, max_length=0, name="bright_130x1_sparse_v3")
generate_cadence(nepochs=25, nexp=1, delta_min=1, delta_max=14, obsmode_pk='bright_time',
                 delta=7, max_length=0)
generate_cadence(nepochs=25, nexp=2, delta_min=1, delta_max=14, obsmode_pk='bright_time',
                 delta=7, max_length=0)
generate_cadence(nepochs=12, nexp=2, delta_min=1, delta_max=14, obsmode_pk='bright_time',
                 delta=7, max_length=0)
generate_cadence(nepochs=12, nexp=4, delta_min=1, delta_max=14, obsmode_pk='bright_time',
                 delta=7, max_length=0)
generate_cadence(nepochs=1, nexp=4, delta_min=1, delta_max=1, obsmode_pk='dark_monit',
                 delta=7, max_length=0)
generate_cadence(nepochs=100, nexp=8, delta_min=4, delta_max=10, obsmode_pk='dark_rm',
                 delta=6, max_length=0)
# for cadence in cadencelist.cadences.values():
#     print(cadence.epoch_text())

cnames = list(cadencelist.cadences.keys())

# for c in cnames:
#     if c not in new_cadences:
#         cadencelist.cadences.pop(c)
        
cadencelist.tocsv('as5_pt1.csv')

fp = open('as5_pt1.cfg', 'w')
cnames = list(cadencelist.cadences.keys())
cnames.sort()
for c in cnames:
    fp.write(cadencelist.cadences[c].epoch_text().strip(" "))
fp.close()
# 