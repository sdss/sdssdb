# input_dir must end with /
input_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" +\
    "catalogs/cantat_gaudin/"

fin = open(input_dir + "table1.dat", "r")

fout = open(input_dir + "table1.csv", "w")

for line in fin:
    tags = line.split()
    line_out = ",".join(tags)
    print(line_out, file=fout)

fin.close()

fout.close()
