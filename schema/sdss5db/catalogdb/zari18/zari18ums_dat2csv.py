fdat = open("ums.dat", "r")
fcsv = open("ums.csv", "w")

for line in fdat:
    tags = line.split()
    line_out = ",".join(tags)
    print(line_out, file=fcsv)

fdat.close()
fcsv.close()
