from astropy.io import fits


# input_dir and output_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/sdssv_plateholes/update_09Dec2020/'  # noqa: E501

output_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/sdssv_plateholes/update_09Dec2020/'  # noqa: E501

input_fits_file_list = ['plateholes_STRUCT1.fits']

for input_fits_file in input_fits_file_list:
    output_csv_file = input_fits_file.replace('fits', 'csv')

    hdu = fits.open(input_dir + input_fits_file, memmap=True)
    data = hdu[1].data
    num_lines_fits = len(data)
    print("num_lines_fits:", num_lines_fits)

    ftemp1 = open('temp1', 'w')

    for i in range(num_lines_fits):
        print(data[i], end='', file=ftemp1)
        print('', file=ftemp1)
        print("ENDOFLINE", file=ftemp1)

    ftemp1.close()

    # Above loop prints each row on many lines
    # Below loop prints each row on one line
    ftemp1 = open('temp1', 'r')
    ftemp2 = open('temp2', 'w')
    line_out = ''
    for line in ftemp1:
        line = line.strip()
        if(line == 'ENDOFLINE'):
            print(line_out, file=ftemp2)
            line_out = ''
        else:
            line_out = line_out + line

    ftemp1.close()
    ftemp2.close()

    fin = open('temp2', 'r')
    fout = open(output_dir + output_csv_file, 'w')

    # We use ; as the CSV delimiter since comma
    # is used as the delimiter for the array elements
    num_lines_csv = 0
    for line in fin:
        num_lines_csv = num_lines_csv + 1

        line = line.strip()
        line = line.rstrip(')')
        line = line.lstrip('(')
        line = line.replace("'", "")
        line = line.replace('array([', '{,')
        line = line.replace('],dtype=float32)', ',}')
        line = line.replace('], dtype=float32)', ',}')
        line = line.replace('],dtype=int32)', ',}')
        line = line.replace('], dtype=int32)', ',}')
        line = line.replace(', ', ',')

        tags = line.split(',')

        line_out = ''
        delimiter = ';'
        for i in range(len(tags)):
            if(tags[i] == '{'):
                delimiter = ','
                line_out = line_out + '{'
            elif(tags[i] == '}'):
                delimiter = ';'
                line_out = line_out.rstrip(',') + '};'
            else:
                line_out = line_out + tags[i] + delimiter
        line_out = line_out.rstrip(';')
        print(line_out, file=fout)

    print("num_lines_csv:", num_lines_csv)
    if(num_lines_fits != num_lines_csv):
        print("error:num_lines_fits != num_lines_csv")
    fin.close()
    fout.close()
