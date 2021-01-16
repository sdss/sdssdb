# See below link for details
# https://wiki.sdss.org/display/OPS/Cartons+for+v0.5#Cartonsforv0.5-TESSCVZOBAFPulsatingBinaries

#       identifier        	   		coord1 (ICRS,J2000/2000)      		Mag H
# ----------------------------	 -----------------------------------	------
# GaiaDR2 5.496271233536168e+18    97.4753547741182   -55.8477293540202  11.487


fout = open("mwm_tess_ob.csv", "w")

f1 = open("mwm_tess_ob_8x1_GaiaID.csv", "r")

# skip first two lines
line = f1.readline()
line = f1.readline()

for line in f1:
    tags = line.split()

    temp = tags[1]
    temp = temp.replace(".", "")
    temp = temp.replace("e+18", "")
    gaia_dr2_id = temp

    ra = tags[2]
    dec = tags[3]
    h_mag = tags[4]
    cadence = "apogee_bright_8x1"
    print(gaia_dr2_id, ra, dec, h_mag, cadence, sep=',', file=fout)

f1.close()

f2 = open("mwm_tess_ob_8x3_GaiaID.csv", "r")

# skip first two lines
line = f2.readline()
line = f2.readline()

for line in f2:
    tags = line.split()

    temp = tags[1]
    temp = temp.replace(".", "")
    temp = temp.replace("e+18", "")
    gaia_dr2_id = temp

    ra = tags[2]
    dec = tags[3]
    h_mag = tags[4]
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
