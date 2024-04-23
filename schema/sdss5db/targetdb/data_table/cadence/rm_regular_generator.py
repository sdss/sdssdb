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

new_cadences = []

copy_cadence('dark_174x8', 'dark_174x8_3day_v2')
cadencelist.cadences['dark_174x8_3day_v2'].delta[0] = 0.0
cadencelist.cadences['dark_174x8_3day_v2'].delta_min[0] = 0.
cadencelist.cadences['dark_174x8_3day_v2'].delta_max[0] = 0.
cadencelist.cadences['dark_174x8_3day_v2'].delta[1:] = 3.0
cadencelist.cadences['dark_174x8_3day_v2'].delta_min[1:] = 2.5
cadencelist.cadences['dark_174x8_3day_v2'].delta_max[1:] = 4.5
cadencelist.cadences['dark_174x8_3day_v2'].label_root = 'dark_174x8_3day'
cadencelist.cadences['dark_174x8_3day_v2'].label_version = '_v2'
new_cadences.append('dark_174x8_3day_v2')

copy_cadence('dark_174x8', 'dark_174x8_7day_v2')
cadencelist.cadences['dark_174x8_7day_v2'].delta[0] = 0.0
cadencelist.cadences['dark_174x8_7day_v2'].delta_min[0] = 0.
cadencelist.cadences['dark_174x8_7day_v2'].delta_max[0] = 0.
cadencelist.cadences['dark_174x8_7day_v2'].delta[1:] = 7.0
cadencelist.cadences['dark_174x8_7day_v2'].delta_min[1:] = 5.5
cadencelist.cadences['dark_174x8_7day_v2'].delta_max[1:] = 10.
cadencelist.cadences['dark_174x8_7day_v2'].label_root = 'dark_174x8_7day'
cadencelist.cadences['dark_174x8_7day_v2'].label_version = '_v2'
new_cadences.append('dark_174x8_7day_v2')

copy_cadence('dark_174x8', 'dark_174x8_10day_v2')
cadencelist.cadences['dark_174x8_10day_v2'].delta[0] = 0.0
cadencelist.cadences['dark_174x8_10day_v2'].delta_min[0] = 0.
cadencelist.cadences['dark_174x8_10day_v2'].delta_max[0] = 0.
cadencelist.cadences['dark_174x8_10day_v2'].delta[1:] = 10.0
cadencelist.cadences['dark_174x8_10day_v2'].delta_min[1:] = 8.5
cadencelist.cadences['dark_174x8_10day_v2'].delta_max[1:] = 14.
cadencelist.cadences['dark_174x8_10day_v2'].label_root = 'dark_174x8_10day'
cadencelist.cadences['dark_174x8_10day_v2'].label_version = '_v2'
new_cadences.append('dark_174x8_10day_v2')

copy_cadence('dark_174x8', 'dark_174x8_30day_v2')
cadencelist.cadences['dark_174x8_30day_v2'].delta[0] = 0.0
cadencelist.cadences['dark_174x8_30day_v2'].delta_min[0] = 0.
cadencelist.cadences['dark_174x8_30day_v2'].delta_max[0] = 0.
cadencelist.cadences['dark_174x8_30day_v2'].delta[1:] = 30.0
cadencelist.cadences['dark_174x8_30day_v2'].delta_min[1:] = 21.
cadencelist.cadences['dark_174x8_30day_v2'].delta_max[1:] = 45.
cadencelist.cadences['dark_174x8_30day_v2'].label_root = 'dark_174x8_30day'
cadencelist.cadences['dark_174x8_30day_v2'].label_version = '_v2'
new_cadences.append('dark_174x8_30day_v2')

copy_cadence('dark_10x4_4yr', 'dark_10x4_regular_v2')
cadencelist.cadences['dark_10x4_regular_v2'].delta[0] = 0.0
cadencelist.cadences['dark_10x4_regular_v2'].delta_min[0] = 0.
cadencelist.cadences['dark_10x4_regular_v2'].delta_max[0] = 0.
cadencelist.cadences['dark_10x4_regular_v2'].delta[1:] = 75.0
cadencelist.cadences['dark_10x4_regular_v2'].delta_min[1:] = 60.
cadencelist.cadences['dark_10x4_regular_v2'].delta_max[1:] = 105.
cadencelist.cadences['dark_10x4_regular_v2'].label_root = 'dark_10x4_regular'
cadencelist.cadences['dark_10x4_regular_v2'].label_version = '_v2'
new_cadences.append('dark_10x4_regular_v2')

cnames = list(cadencelist.cadences.keys())

for c in cnames:
    if c not in new_cadences:
        cadencelist.cadences.pop(c)
        
cadencelist.tocsv('rm_regular.csv')

fp = open('rm_regular.cfg', 'w')
cnames = list(cadencelist.cadences.keys())
cnames.sort()
for c in cnames:
    fp.write(cadencelist.cadences[c].epoch_text())
fp.close()
