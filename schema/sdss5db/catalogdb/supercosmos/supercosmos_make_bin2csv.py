# Program: supercosmos_make_bin2csv.py
# Aim: make bash script to convert supercosmos .bin files to csv.
#
# Usage:
# python supercosmos_make_bin2csv.py > supercosmos_bin2csv.sh
# and then run
# bash supercosmos_bin2csv.sh &
#

# input_dir and output_dir must end with /
input_dir = "/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/SuperCOSMOS/"  # noqa: E501
output_dir = "/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/SuperCOSMOS/csv/"  # noqa: E501

# This list is from the SuperCOSMOS  filelist.
list_of_bin_files = ["ssaSource000ra030.bin",
                     "ssaSource030ra060.bin",
                     "ssaSource060ra090.bin",
                     "ssaSource090ra120.bin",
                     "ssaSource120ra150.bin",
                     "ssaSource150ra180.bin",
                     "ssaSource180ra210.bin",
                     "ssaSource210ra240.bin",
                     "ssaSource240ra270.bin",
                     "ssaSource270ra300.bin",
                     "ssaSource300ra330.bin",
                     "ssaSource330ra360.bin"]

for i in range(len(list_of_bin_files)):
    bin_file = list_of_bin_files[i]
    base_file, extension = bin_file.split('.')
    csv_file = base_file + ".csv"
    full_bin_file = input_dir + bin_file
    full_csv_file = output_dir + csv_file
    print("./supercosmos_binary " +
          full_bin_file + " " + full_csv_file + " > " +
          full_csv_file + ".out")
    print("")

