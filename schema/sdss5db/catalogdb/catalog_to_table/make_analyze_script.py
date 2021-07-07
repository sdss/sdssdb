import catalog_to_table_list as ct
# print(ct.catalog_to_table)

# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    table_name = ct.catalog_to_table[i]

    output_file_sql = output_dir_sql + table_name + ".analyze.sql"

    f = open(output_file_sql, "w")

    # lower bound is inclusive bound
    # upper bound is exclusive bound

    output_line = "analyze " + table_name + ";\n"
    f.write(output_line)

    part_table_name = table_name.replace("catalogdb", "part_table")

    output_line = "analyze " + part_table_name + "_01_11;\n"
    f.write(output_line)

    for j in range(11, 100):
        output_line = "analyze " + part_table_name + \
                      "_" + str(j) + "_" + str(j + 1) + ";\n"
        f.write(output_line)

    f.close()
