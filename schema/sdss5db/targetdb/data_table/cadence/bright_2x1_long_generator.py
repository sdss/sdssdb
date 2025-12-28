#!/usr/bin/env python

import roboscheduler.cadence

from sdssdb.peewee.sdss5db import database
database.set_profile('operations')

def copy_cadence(from_cadence, to_cadence, nepochs=None):
    if(nepochs is None):
        nepochs = cadencelist.cadences[from_cadence].nepochs

    cadencelist.add_cadence(name=to_cadence,
                            nepochs=nepochs,
                            skybrightness=cadencelist.cadences[from_cadence].skybrightness[0:nepochs],
                            delta=cadencelist.cadences[from_cadence].delta[0:nepochs],
                            delta_min=cadencelist.cadences[from_cadence].delta_min[0:nepochs],
                            delta_max=cadencelist.cadences[from_cadence].delta_max[0:nepochs],
                            nexp=cadencelist.cadences[from_cadence].nexp[0:nepochs],
                            max_length=cadencelist.cadences[from_cadence].max_length[0:nepochs],
                            min_moon_sep=cadencelist.cadences[from_cadence].min_moon_sep[0:nepochs],
                            min_deltav_ks91=cadencelist.cadences[from_cadence].min_deltav_ks91[0:nepochs],
                            min_twilight_ang=cadencelist.cadences[from_cadence].min_twilight_ang[0:nepochs],
                            max_airmass=cadencelist.cadences[from_cadence].max_airmass[0:nepochs],
                            obsmode_pk=cadencelist.cadences[from_cadence].obsmode_pk[0:nepochs])
    return

cadencelist = roboscheduler.cadence.CadenceList()

cadencelist.fromdb(version='v2')

print(cadencelist.cadences['bright_2x1'])

copy_cadence('bright_2x1', 'bright_2x1_long_v2')

cadencelist.cadences['bright_2x1_long_v2'].delta_min[1] = 2.
cadencelist.cadences['bright_2x1_long_v2'].delta_max[1] = 100000.
cadencelist.cadences['bright_2x1_long_v2'].delta[1] = 100.
cadencelist.cadences['bright_2x1_long_v2'].label_root = 'bright_2x1_long'
cadencelist.cadences['bright_2x1_long_v2'].label_version = '_v2'


cnames = list(cadencelist.cadences.keys())

for c in cnames:
    if c not in ['bright_2x1_long_v2']:
        cadencelist.cadences.pop(c)
        
cadencelist.tocsv('bright_2x1_long.csv')

fp = open('bright_2x1_long.cfg', 'w')
cnames = list(cadencelist.cadences.keys())
cnames.sort()
for c in cnames:
    fp.write(cadencelist.cadences[c].epoch_text())
fp.close()
