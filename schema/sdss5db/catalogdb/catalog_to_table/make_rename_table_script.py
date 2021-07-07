import catalog_to_table_list as ct
# print(ct.catalog_to_table)

# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    # table_name includes schema name e.g. catalogdb.catalog_to_tic_v8
    table_name = ct.catalog_to_table[i]
    (schema_name, table_name_only) = table_name.split(".")

    output_file_sql = output_dir_sql + table_name + ".rename_table.sql"

    output_line1 = "alter table " + table_name + \
        " rename to " + table_name_only + "_old" + ";" + "\n"

    output_line2 = "alter table " + table_name + "_new" + \
        " rename to " + table_name_only + ";" + "\n"

    output_line3 = "alter table " + table_name + "_old" + \
        " set schema deprecated;" + "\n"

    f = open(output_file_sql, "w")

    f.write(output_line1)
    f.write(output_line2)
    f.write(output_line3)

    f.write("\n")

    f.close()
