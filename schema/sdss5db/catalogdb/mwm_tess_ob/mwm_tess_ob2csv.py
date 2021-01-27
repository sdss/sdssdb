# See below link for details
# https://wiki.sdss.org/display/OPS/Cartons+for+v0.5#Cartonsforv0.5-TESSCVZOBAFPulsatingBinaries

#      Gaia ID                   coord1 (ICRS,J2000/2000)               Mag H
# --------------------------------------------------------------------------
# Gaia DR2 5496276314480471040   97.1905111991394   -55.9171573520957   8.326


fout = open("mwm_tess_ob.csv", "w")

f1 = open("mwm_tess_ob_8x1_GaiaID.csv", "r")

# skip first two lines
line = f1.readline()
line = f1.readline()

for line in f1:
    tags = line.split()

    gaia_dr2_id = tags[2]
    ra = tags[3]
    dec = tags[4]
    h_mag = tags[5]
    cadence = "apogee_bright_8x1"
    print(gaia_dr2_id, ra, dec, h_mag, cadence, sep=',', file=fout)

f1.close()

f2 = open("mwm_tess_ob_8x3_GaiaID.csv", "r")

# skip first two lines
line = f2.readline()
line = f2.readline()

for line in f2:
    tags = line.split()

    gaia_dr2_id = tags[2]
    ra = tags[3]
    dec = tags[4]
    h_mag = tags[5]
    h_mag = float(h_mag)
    # if H < 11 then use apogee_bright_8x2
    # if H > =11 then use  apogee_bright_8x4
    if (h_mag < 11):
        cadence = "apogee_bright_8x2"
    else:
        cadence = "apogee_bright_8x4"
    print(gaia_dr2_id, ra, dec, h_mag, cadence, sep=',', file=fout)

f2.close()
fout.close()
