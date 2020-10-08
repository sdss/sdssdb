# Program: catwise2020_tbl2csv.py
# Aim: convert catwise2020 tbl files to CSV.
#
# The program checks so that it does not convert tbl files which already
# have a corresponding csv file.

import glob
import os.path

import sys

import astropy.table
from astropy.io import ascii

DEBUG = False

# input_dir and output_dir must end with /
input_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/CatWISE/2020/"  # noqa: E501
output_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/CatWISE/2020csv/"  # noqa: E501

list_of_tbl_files = glob.glob(input_dir + "*ab_v5_cat*.tbl")
list_of_tbl_files.sort()

if (len(sys.argv) != 2):
    print("usage:")
    print("catwise2020_tbl2csv.py n")
    print("where n = 0 or 1 or 2")

n = int(sys.arv[1])
if(n == 0):
    out_file = "tbl2csv.out"
elif(n == 1):
    out_file = "tbl2csv.1.out"
elif(n == 2):
    out_file = "tbl2csv.2.out"
else:
    print("tbl2csv:error:n =", n)
    sys.exit(1)

fout = open(output_dir + out_file, "a")


num_tbl_files = len(list_of_tbl_files)
if(n == 0):
    lower_limit = 0
    upper_limit = num_tbl_files
elif(n == 1):
    lower_limit = 0
    upper_limit = num_tbl_files // 2
elif(n == 2):
    lower_limit = num_tbl_files // 2
    upper_limit = num_tbl_files
else:
    print("tbl2csv:error:n =", n)
    sys.exit(1)

if DEBUG is True:
    list_of_tbl_files = [input_dir +
                         "0000m016_opt1_20191208_213403_ab_v5_cat_b0.tbl"]
    lower_limit = 0
    upper_limit = 1

for i in range(lower_limit, upper_limit):
    tbl_file = os.path.basename(list_of_tbl_files[i])
    csv_file = tbl_file.replace('.tbl', '.csv')
    full_tbl_file = input_dir + tbl_file
    full_csv_file = output_dir + csv_file
    # if csv file exists then skip this tbl file and goto the next tbl file
    if os.path.isfile(full_csv_file):
        print("tbl2csv:info:skipping tbl file since csv file already exists:",
              csv_file)
        print("tbl2csv:info:skipping tbl file since csv file already exists:",
              csv_file, file=fout, flush=True)
        continue

    wc_output = os.popen("wc -l " + full_tbl_file).read()
    num_lines_tbl_str, file_name = wc_output.split()
    num_lines_tbl = int(num_lines_tbl_str)
    # Most catwise2020 .tbl files have 19 header lines e.g.
    # 0791m137_opt1_20191128_221825_ab_v5_cat_b0.tbl
    # Some catwise2020 .tbl files have 20 line header e.g.
    # 0791m682_opt0_20200110085825_ab_v5_cat_b0.tbl
    #
    # Do not count the  19 header lines.
    # So reduce num_lines_tbl by 19.
    num_lines_tbl = num_lines_tbl - 19
    print(tbl_file, ":", num_lines_tbl)
    print(tbl_file, ":", num_lines_tbl, file=fout, flush=True)

    table = astropy.table.Table.read(full_tbl_file, format='ascii.ipac')
    table.meta = {}
    # fill_values replaces null in the tbl file with NULL
    # See the section on NULL in the below link:
    # https://www.postgresql.org/docs/12/sql-copy.html
    #
    # format='csv' will print a one line header with the column names
    table.write(full_csv_file,
                format='csv',
                fill_values=[(ascii.masked, 'NULL')],
                overwrite=True)

    wc_output = os.popen("wc -l " + full_csv_file).read()
    num_lines_csv_str, file_name = wc_output.split()
    num_lines_csv = int(num_lines_csv_str)
    # Do not count the CSV header line.
    # So reduce num_lines_csv by one.
    num_lines_csv = num_lines_csv - 1
    print(csv_file, ":", num_lines_csv)
    print(csv_file, ":", num_lines_csv, file=fout, flush=True)
    if(num_lines_tbl != num_lines_csv):
        # Some .tbl files have one more header line.
        # See the above comment about 19 header lines.
        if(num_lines_tbl == num_lines_csv + 1):
            print("tbl2csv:info:num_lines_tbl==num_lines_csv+1", csv_file)
            print("tbl2csv:info:num_lines_tbl==num_lines_csv+1",
                  csv_file, file=fout, flush=True)
        else:
            print("tbl2csv:error:num_lines_tbl!=num_lines_csv", csv_file)
            print("tbl2csv:error:num_lines_tbl!=num_lines_csv",
                  csv_file, file=fout, flush=True)

print("tbl2csv:info:converted all tbl files to csv")
print("tbl2csv:info:converted all tbl files to csv", file=fout, flush=True)

fout.close()
