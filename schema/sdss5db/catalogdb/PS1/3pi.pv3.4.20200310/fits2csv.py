# Program: fits2csv.py
# Aim: convert PS1 fits files to CSV.
#
# The program checks so that it does not convert fits files which already
# have a corresponding csv file.

import glob
import os.path

import numpy as np
from astropy.io import fits


DEBUG = False

# input_dir and output_dir must end with /
input_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/PS1/3pi.pv3.4.20200310/"  # noqa: E501
output_dir = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/PS1csv/"  # noqa: E501

list_of_fits_files = glob.glob(input_dir + "3pi.pv3.4.20200402.*.fits")
list_of_fits_files.sort()

fout = open(output_dir + "fits2csv.out", "a")

if DEBUG is True:
    list_of_fits_files = [input_dir +
                          "3pi.pv3.4.20200402.090.095.060.065.fits"]

for i in range(len(list_of_fits_files)):
    fits_file = os.path.basename(list_of_fits_files[i])
    csv_file = fits_file.replace('.fits', '.csv')

    # if csv file exists then skip this fits file and goto next fits file
    if os.path.isfile(output_dir + csv_file):
        print("skipping fits file since csv file already exists:", csv_file)
        print("skipping fits file since csv file already exists:", csv_file,
              file=fout, flush=True)
        continue
    hdu = fits.open(list_of_fits_files[i], memmap=True)
    data = hdu[1].data
    num_lines_fits = len(data)
    print(fits_file, ":", num_lines_fits)
    print(fits_file, ":", num_lines_fits, file=fout, flush=True)

    # savetxt() fmt is from fits2columns.py
    np.savetxt(output_dir + csv_file, data,
               fmt="%.16e,%.16e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%.8e,%.8e,%d,%d,%d,%d,%d,%d,%d,%.8e,%.8e")  # noqa: E501
    wc_output = os.popen("wc -l " + output_dir + csv_file).read()
    num_lines_csv, file_name = wc_output.split()
    print(csv_file, ":", num_lines_csv)
    print(csv_file, ":", num_lines_csv, file=fout, flush=True)
    if(num_lines_fits != num_lines_csv):
        print("fits2csv error:num_lines_fits!=num_lines_csv", csv_file)
        print("fits2csv error:num_lines_fits!=num_lines_csv",
              csv_file, file=fout, flush=True)

print("converted all fits files to csv")
print("converted all fits files to csv", file=fout, flush=True)

fout.close()

# #####################################################

# Some examples of creating and loading table:
# https://github.com/sdss/sdssdb/tree/master/schema/sdss5db/catalogdb/PS1/g18
