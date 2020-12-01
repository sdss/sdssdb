from astropy.io import fits


# input_dir and output_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/RM/bhm_rm_tweaks/'  # noqa: E501

output_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/RM/bhm_rm_tweaks/csv/'  # noqa: E501

input_fits_file_list =\
    ['vi_rm_targets_catv0b.fits']

for input_fits_file in input_fits_file_list:
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

    # We use ; as the CSV delimiter since comma
    # is used as the delimiter for the array elements
    for line in fin:
        line = line.strip()
        line = line.lstrip('(')
        line = line.rstrip(')')
        line = line.replace("'", "")
        line = line.replace('array([    ', '')
        line = line.replace('], dtype=float32)', '')
        line = line.replace(', ', ',')

        tags = line.split(',')

        line_out = ''
        for i in range(10):
            line_out = line_out + tags[i] + ';'

        line_out = line_out + '{'
        for i in range(10, 15):
            line_out = line_out + tags[i] + ','

        line_out = line_out.rstrip(',')
        line_out = line_out + '};'
        line_out = line_out + tags[15] + ';' + tags[16]

        print(line_out, file=fout)

    fin.close()
    fout.close()
