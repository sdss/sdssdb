from astropy.io import fits

# input_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/galex_gr7_gaia_dr3/'
input_file = 'GR7_eDR3_arc3_lite.fits'
output_file = input_file.replace('fits', 'csv')

hdu = fits.open(input_dir + input_file, memmap=True)

data = hdu[1].data
num_lines_fits = len(data)

print("num_lines_fits =", num_lines_fits)

ftemp = open(input_dir + 'temp1', 'w')

for i in range(num_lines_fits):
    print(data[i], file=ftemp)

ftemp.close()

fin = open(input_dir + 'temp1', 'r')
fout = open(input_dir + output_file, 'w')

for line in fin:
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    line = line.replace("'", "")
    line = line.replace(', ', ',')
    print(line, file=fout)

fin.close()
fout.close()
