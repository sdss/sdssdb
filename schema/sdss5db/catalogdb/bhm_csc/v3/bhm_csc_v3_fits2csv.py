from astropy.io import fits


# input_dir and output_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/csc/2022dec_v3/'
output_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/csc/2022dec_v3/csv/'
input_fits_file = 'CSC_GAIA_LS10_PS1_2M_2022dec.fits'

output_csv_file = input_fits_file.replace('fits', 'csv')

hdu = fits.open(input_dir + input_fits_file, memmap=True)
data = hdu[1].data
num_lines_fits = len(data)

ftemp = open('temp1', 'w')

for i in range(num_lines_fits):
    print(data[i], file=ftemp)

ftemp.close()

fin = open('temp1', 'r')
fout = open(output_dir + output_csv_file, 'w')

for line in fin:
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    line = line.replace("'", "")
    line = line.replace(', ', ',')
    line = line.replace('18446744073709550617,', 'nan,')
    line = line.replace('-999,', 'nan,')
    print(line, file=fout)

fin.close()
fout.close()
