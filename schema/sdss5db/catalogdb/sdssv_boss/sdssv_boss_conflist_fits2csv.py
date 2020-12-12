from astropy.io import fits


# input_dir and output_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss/sdss5/bhm/boss/spectro/redux/master/'  # noqa: E501

output_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/sdssv_boss/'  # noqa: E501

input_fits_file_list = ['conflist.fits']

for input_fits_file in input_fits_file_list:
    output_csv_file = input_fits_file.replace('fits', 'csv')

    hdu = fits.open(input_dir + input_fits_file, memmap=True)
    data = hdu[1].data
    num_lines_fits = len(data)
    print("num_lines_fits:", num_lines_fits)

    ftemp = open('temp1', 'w')

    for i in range(num_lines_fits):
        print(data[i], file=ftemp)

    ftemp.close()

    fin = open('temp1', 'r')
    fout = open(output_dir + output_csv_file, 'w')
    num_lines_csv = 0
    for line in fin:
        num_lines_csv = num_lines_csv + 1
        line = line.strip()
        line = line.lstrip('(')
        line = line.rstrip(')')
        line = line.replace(', ', ',')
        line = line.replace("'", "")
        print(line, file=fout)

    print("num_lines_csv:", num_lines_csv)
    if(num_lines_fits != num_lines_csv):
        print("error:num_lines_fits != num_lines_csv")
    fin.close()
    fout.close()
