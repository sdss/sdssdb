from astropy.io import fits


# input_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/cantat_gaudin/'
hdu = fits.open(input_dir + 'nodup.fits', memmap=True)
data = hdu[1].data
num_lines_fits = len(data)

ftemp = open('temp1', 'w')

for i in range(num_lines_fits):
    print(data[i], file=ftemp)

ftemp.close()

fin = open('temp1', 'r')
fout = open(input_dir + 'nodup.csv', 'w')

for line in fin:
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    print(line, file=fout)

fin.close()
fout.close()
