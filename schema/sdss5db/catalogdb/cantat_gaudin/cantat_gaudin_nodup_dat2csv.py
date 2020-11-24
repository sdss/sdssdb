# dir must end with /
dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/" +\
      "cantat_gaudin/"

fin = open(dir + "nodup.dat", "r")

fout = open(dir + "nodup.csv", "w")

# For some lines, in the middle of the line,
# there are fields with blank spaces.
# Hence, len(tags) is not the same for each line.
# Hence, we use tags[-3] and tags[-2] to count
# from the last element of tags.
# For some lines, the last field teff50 is missing.
# Hence, we use tags[-2] and tags[-1] for these lines.
# Fields are described in the below link:
# https://cdsarc.unistra.fr/ftp/J/A+A/640/A1/ReadMe
 
n = 0
for line in fin:
    n = n + 1
    tags = line.split()
    radeg = tags[0]
    dedeg = tags[1]
    gaiadr2 = tags[2]
    if(tags[-2][0].isalpha()):
        proba = tags[-3]
        cluster = tags[-2]
    elif(tags[-1][0].isalpha()):
        proba = tags[-2]
        cluster = tags[-1]
    else:
        print("error:line:" + n +
              ":tags[-2][0] and tags[-1][0] are not letters")

    line_out = radeg + "," + dedeg + "," + gaiadr2 + "," +\
               proba + "," + cluster # noqa: E127
    print(line_out, file=fout)

fin.close()

fout.close()
