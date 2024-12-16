from roboscheduler.cadence import CadenceList

output = ""

for i in range(2,41):
    output += f"[bright_mc_{i}x1_v2]\nlabel_root = bright_mc_{i}x1\n"
    output += f"label_version = _v2\nnepochs = {i}\n"
    output += f"skybrightness = {' '.join(['1.00' for j in range(i)])}\n"
    output += f"instrument = {' '.join(['BOSS' for j in range(i)])}\n"
    output += f"delta = {' '.join(['0.00' for j in range(i)])}\n"
    output += f"delta_min = {' '.join(['0.00' for j in range(i)])}\n"
    output += f"delta_max = {' '.join(['0.00' for j in range(i)])}\n"
    output += f"nexp = {' '.join(['1' for j in range(i)])}\n"
    output += f"max_length = {' '.join(['0.50' for j in range(i)])}\n"
    output += f"obsmode_pk = {' '.join(['bright_mc' for j in range(i)])}\n"
    output += f"min_moon_sep = {' '.join(['15' for j in range(i)])}\n"
    output += f"min_deltav_ks91 = {' '.join(['-3' for j in range(i)])}\n"
    output += f"min_twilight_ang = {' '.join(['8' for j in range(i)])}\n"
    output += f"max_airmass = {' '.join(['2' for j in range(i)])}\n\n"

with open("bright_mc_ext.cfg", "w") as cfg_file:
    print(output, file=cfg_file)

clist = CadenceList()
clist.fromcfg("bright_mc_ext.cfg")

clist.tocsv("bright_mc_ext.csv")
