from astropy.io import fits

# This program is for the table sptab in the below fits file.
# The table sptab corresponds to hdu[2].
# This program omits the array columns in the fits file.
#
# fits file is from
# https://data.desi.lbl.gov/public/dr1/vac/dr1/mws/iron/v1.0/mwsall-pix-iron.fits

# end input_dir with a forward slash /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/mwsall/'
input_file = 'mwsall-pix-iron.fits'

# end output_dir with a forward slash /
output_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/mwsall/'

# data model is from
# https://desi-mws-dr1-datamodel.readthedocs.io/en/latest/mwsall.html

# hdu_unit for tables starts from 1 hence zeroth element below is "None"
hdu_unit_tablename = [
    None,
    "mwsall_rvtab",
    "mwsall_sptab",
    "mwsall_fibermap",
    "mwsall_scores",
    "mwsall_gaia"]

# Usually hdu_unit is 1.
# However mwsall-pix-iron.fits has 5 tables so
# hdu_unit can be 1, 2, 3, 4, and 5.
#
# For hdu_unit=1,3,4,5 use mwsall_fits2csv.py.
#
# In the fits file, the hdu[2] for table sptab has array columns called
# param, covar, elem, and elem_error.
# The column covar is a 2 dimensional array.
# This program omits array columns in the fits file.
# Use this program for hdu_unit=2 only.
#
# hdu_unit=2 corresponds to table sptab which contains array columns.
hdu_unit = 2

output_file = output_dir + hdu_unit_tablename[hdu_unit] + '.csv'

hdu = fits.open(input_dir + input_file, memmap=True)
data = hdu[hdu_unit].data
num_lines_fits = len(data)
num_columns = len(data[1])
fout = open(output_file, 'w')

# This approach is slower than the approach in mwsall_fits2csv.py.
# However, this approach allows us to omit array columns.
for i in range(num_lines_fits):
    line = ""
    for j in range(num_columns):
        # below ensures that "line" contains only the non-array columns
        if ((j < 13) or (j > 16)):
            line = line + str(data[i][j]) + ","
    # remove last comma
    line = line.rstrip(",")

    print(line, file=fout)

fout.close()
