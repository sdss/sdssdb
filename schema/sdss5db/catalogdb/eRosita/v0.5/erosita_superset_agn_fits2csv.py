from astropy.io import fits


# input_dir and output_dir must end with /
input_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/eRosita/erosita_for_catalogdb_v0.5/sdssv_erosita_homogenise_superset_v0.1.1/erosita_superset_agn/'  # noqa: E501

output_dir = '/uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/eRosita/erosita_for_catalogdb_v0.5/sdssv_erosita_homogenise_superset_v0.1.1/csv/erosita_superset_agn/'  # noqa: E501

input_fits_file_list =\
    ['sdssv_spiders_erass1_update_v05_agn_nway_catwise2020_v0.1.1.fits',
     'sdssv_spiders_erass1_update_v05_agn_nway_gaiadr2_v0.1.1.fits',
     'sdssv_spiders_erass1_update_v05_agn_nway_lsdr8_v0.1.1.fits',
     'sdssv_spiders_erass1_update_v05_agn_nway_ps1dr2_v0.1.1.fits',
     'sdssv_spiders_erass1_update_v05_agn_nway_skymapper_dr2_v0.1.1.fits']

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

    for line in fin:
        line = line.strip()
        line = line.lstrip('(')
        line = line.rstrip(')')
        line = line.replace(' array([nan, nan], dtype=float32),', '')
        line = line.replace(', ', ',')
        line = line.replace("'", "")
        print(line, file=fout)

    fin.close()
    fout.close()
