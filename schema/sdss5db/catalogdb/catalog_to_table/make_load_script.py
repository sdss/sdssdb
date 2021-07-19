import catalog_to_table_list as ct
# print(ct.catalog_to_table)

# output_dir_csv must end with /
output_dir_csv = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/csv/"

# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    table_name = ct.catalog_to_table[i]
    output_file_csv = output_dir_csv + table_name + ".csv"

    output_file_sql = output_dir_sql + table_name + ".load.sql"

    # r" is to tell flake8 that \c is not an escape sequence
    output_line = r"\copy " + table_name + "_new" + " from " + \
        "'" + output_file_csv + "'" + " delimiter ','"

    f = open(output_file_sql, "w")

    f.write(output_line)
    f.write("\n")

    f.close()
