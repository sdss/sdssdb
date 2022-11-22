from astropy.io import ascii


input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/wd_gaia_dr3/'
input_file = 'maincat.dat'

output_dir = input_dir
output_file = input_file.replace('dat', 'csv')

# this will give a warning about units which cannot be ignored
table = ascii.read("maincat.dat", readme="ReadMe")

# this will write table to csv
ascii.write(table, output_dir + output_file, format='csv', fast_writer=False)
