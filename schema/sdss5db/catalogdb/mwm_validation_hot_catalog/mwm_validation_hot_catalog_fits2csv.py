from astropy.io import fits


hdu = fits.open('mwm_validation_hot_catalog.fits', memmap=True)
data = hdu[1].data
num_lines_fits = len(data)

print("num_lines_fits =", num_lines_fits)

ftemp = open('temp1', 'w')

for i in range(num_lines_fits):
    print(data[i], file=ftemp)

ftemp.close()

fin = open('temp1', 'r')
fout = open('mwm_validation_hot_catalog.csv', 'w')

for line in fin:
    line = line.strip()
    line = line.lstrip('(')
    line = line.rstrip(')')
    line = line.replace("'", "")
    line = line.replace(', ', ',')
    print(line, file=fout)

fin.close()
fout.close()
