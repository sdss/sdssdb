import catalog_to_table_list as ct
# print(ct.catalog_to_table)

# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    table_name = ct.catalog_to_table[i]

    output_file_sql = output_dir_sql + table_name + ".create_partitions.sql"

    f = open(output_file_sql, "w")

    # lower bound is inclusive bound
    # upper bound is exclusive bound

    part_table_name = table_name.replace("catalogdb", "part_table")

    output_line = "create table " + part_table_name + \
                  "_01_11" + \
                  " partition of " + table_name + "_new" + \
                  " for values from (1) to (11);\n"
    f.write(output_line)

    for j in range(11, 100):
        output_line = "create table " + part_table_name + \
                      "_" + str(j) + "_" + str(j + 1) + \
                      " partition of " + table_name + "_new" + \
                      " for values from (" + str(j) + ") to (" + str(j + 1) + ");\n"
        f.write(output_line)

    f.close()
