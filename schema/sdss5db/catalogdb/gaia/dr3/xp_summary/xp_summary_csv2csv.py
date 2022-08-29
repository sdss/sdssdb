# Program: xp_summary_csv2csv.py
# Aim: Do below changes to Gaia DR3 xp_summary CSV files
#      The original CSV files are not modified.
#      The modified files have the extension nometa.csv.
#      (1) remove 140 lines of metadata at beginning of the file.
#
# sed -i -e '1,140d' temp1.csv

import glob
import os.path
import sys


DEBUG = False

# Note that csv_dir and csvout_dir must end with /

csv_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/gaia/dr3/xp_summary/"  # noqa E501
csvout_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/gaia/dr3/xp_summary/csvout/"  # noqa E501

list_of_csv_files = glob.glob(csv_dir + "XpSummary*.csv")
list_of_csv_files.sort()

fout = open(csvout_dir + "nometa.csv.out", "a")

if DEBUG is True:
    list_of_csv_files = [csv_dir + "XpSummary_000000-003111.csv"]

for i in range(len(list_of_csv_files)):
    full_csv_file = list_of_csv_files[i]
    csv_file = os.path.basename(full_csv_file)
    csv_sh_file = csv_file.replace('.csv', '.nometa.sh')
    csv_nometa_file = csv_file.replace('.csv', '.nometa.csv')

    # both csv_sh_file and csv_nometa_file are put in csvout_dir directory
    full_csv_sh_file = csvout_dir + csv_sh_file
    full_csv_nometa_file = csvout_dir + csv_nometa_file
    # if full_csv_nometa_file exists then exit
    if os.path.isfile(full_csv_nometa_file):
        print("exiting csv file since .nometa.csv file already exists:",
              csv_nometa_file)
        print("exiting csv file since .nometa.csv file already exists:",
              csv_nometa_file,
              file=fout, flush=True)
        sys.exit(1)

    fpgscript = open(full_csv_sh_file, "w")
    # We do not use -i option for first sed command since
    # we do not want to modify the original CSV file.
    # We use use '1,140d' so that the first 140 lines are deleted
    # These deleted lines contain metadata about the file.
    # We do not delete the header line in the CSV file.
    print("sed  -e '1,140d' " + full_csv_file + " > " + full_csv_nometa_file, file=fpgscript)
    print("", file=fpgscript)
    fpgscript.close()

    print("sed start:", csv_file)
    print("sed start:", csv_file, file=fout, flush=True)

    sed_output = os.popen("bash " + full_csv_sh_file).read()

    wc_output = os.popen("wc -l " + full_csv_nometa_file).read()
    num_lines_str, file_name = wc_output.split()
    num_lines = int(num_lines_str)
    # do not count the header line
    # so reduce num_lines by one
    num_lines = num_lines - 1
    print(csv_nometa_file, ":contains:", num_lines)
    print(csv_nometa_file, ":contains:", num_lines, file=fout, flush=True)

    print("sed end:", csv_file)
    print("sed end:", csv_file, file=fout, flush=True)

print("sed end all csv files")
print("sed end all csv files", file=fout, flush=True)

fout.close()
