from astropy.io import fits

input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/galah_dr3/'
input_file = 'GALAH_DR3_main_allstar_v2.fits'

output_dir = input_dir
output_file = input_file.replace('fits', 'csv')

hdu = fits.open(input_dir + input_file, memmap=True)
data = hdu[1].data
num_lines_fits = len(data)

print("num_lines_fits =", num_lines_fits)

ftemp = open('temp1', 'w')

for i in range(num_lines_fits):
    print(data[i], file=ftemp)

ftemp.close()

fin = open('temp1', 'r')
fout = open(output_dir + output_file, 'w')

for line in fin:
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    line = line.replace("'", "")
    line = line.replace(', ', ',')
    print(line, file=fout)

fin.close()
fout.close()
