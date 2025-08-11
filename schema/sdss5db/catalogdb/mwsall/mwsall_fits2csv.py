from astropy.io import fits

# fits file is from
# https://data.desi.lbl.gov/public/dr1/vac/dr1/mws/iron/v1.0/mwsall-pix-iron.fits

# end input_dir with a forward slash /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/mwsall/'
input_file = 'mwsall-pix-iron.fits'

# end output_dir with a forward slash /
output_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/mwsall/'

# data model is from
# https://desi-mws-dr1-datamodel.readthedocs.io/en/latest/mwsall.html

#

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
# In the fits file, the hdu[2] for table sptab has array columns called
# param, covar, elem, and elem_error.
# The column covar is a 2 dimensional array.
#
# Do not use this program for hdu_unit=2.
# Use mwsall_fits2csv_sptab.py for hdu_unit=2.

hdu_unit = 5

output_file = output_dir + hdu_unit_tablename[hdu_unit] + '.csv'

hdu = fits.open(input_dir + input_file, memmap=True)
data = hdu[hdu_unit].data
num_lines_fits = len(data)
fout = open(output_file, 'w')

for i in range(num_lines_fits):
    line = str(data[i])
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    line = line.replace("'", "")
    line = line.replace(', ', ',')
    print(line, file=fout)

fout.close()
