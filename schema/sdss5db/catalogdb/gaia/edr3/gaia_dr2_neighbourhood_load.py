# Program: gaia_dr2_neighbourhood_load.py
# Aim: load gaia_dr2_neigbourhood csv files into the postgreSQL sdss5db database.
#
# The program checks so that it does not reload csv files which already
# have a csv.load.out file.

import glob
import os.path


DEBUG = False

# Note that csv_dir and csvout_dir must end with /

csv_dir = "/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/gaia/edr3/dr2_neighbourhood/"  # noqa E501
csvout_dir = "/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/gaia/edr3/dr2_neighbourhood/csvout/"  # noqa E501

list_of_csv_files = glob.glob(csv_dir + "Dr2Neighbourhood*.csv")
list_of_csv_files.sort()

fout = open(csvout_dir + "load.csv.out", "a")

if DEBUG is True:
    list_of_csv_files = [csv_dir + "Dr2Neighbourhood_000-000-000.csv"]

for i in range(len(list_of_csv_files)):
    full_csv_file = list_of_csv_files[i]
    csv_file = os.path.basename(full_csv_file)
    csvout_file = csv_file.replace('.csv', '.csv.out')
    csvsql_file = csv_file.replace('.csv', '.csv.sql')

    # both csvout_file and csvsql_file are put in csvout_dir directory
    full_csvout_file = csvout_dir + csvout_file
    full_csvsql_file = csvout_dir + csvsql_file
    # if csv file exists then skip this csv file and goto next csv file
    if os.path.isfile(full_csvout_file):
        print("skipping loading csv file since csv.out file already exists:",
              csvout_file)
        print("skipping loading csv file since csv.out file already exists:",
              csvout_file,
              file=fout, flush=True)
        continue

    fpgscript = open(full_csvsql_file, "w")
    print("\\o " + full_csvout_file, file=fpgscript)
    print("\\copy catalogdb.gaia_dr2_neighbourhood ", file=fpgscript, end='')
    print("from '" + full_csv_file + "' ", file=fpgscript, end='')
    print(" with csv header; ", file=fpgscript)
    print("\\o", file=fpgscript)
    print("\\q", file=fpgscript)
    fpgscript.close()

    print("load start:", csv_file)
    print("load start:", csv_file, file=fout, flush=True)

    pgcopy_output = os.popen("psql -U postgres sdss5db " +
                             " -a -f " + full_csvsql_file).read()

    wc_output = os.popen("wc -l " + full_csv_file).read()
    num_lines_str, file_name = wc_output.split()
    num_lines = int(num_lines_str)
    # do not count the header line
    # so reduce num_lines by one
    num_lines = num_lines - 1
    print(csv_file, ":contains:", num_lines)
    print(csv_file, ":contains:", num_lines, file=fout, flush=True)

    fcsvout = open(full_csvout_file, "r")
    line = fcsvout.readline()
    copytext, num_rows_loaded_str = line.split()
    num_rows_loaded = int(num_rows_loaded_str)
    print(csvout_file, ":loaded:", num_rows_loaded)
    print(csvout_file, ":loaded:", num_rows_loaded, file=fout, flush=True)
    fcsvout.close()

    if(num_lines != num_rows_loaded):
        print("load error:num_lines!=num_rows_loaded", csv_file)
        print("load error:num_lines!=num_rows_loaded",
              csv_file, file=fout, flush=True)

    print("load end:", csv_file)
    print("load end:", csv_file, file=fout, flush=True)

print("loaded all csv files")
print("loaded all csv files", file=fout, flush=True)

fout.close()