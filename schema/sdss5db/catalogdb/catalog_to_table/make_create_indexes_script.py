import catalog_to_table_list as ct
# print(ct.catalog_to_table)
#
# In PostgreSQL 12 and later, creating a primary key and index on the base table
# also creates primary key and index on the sub tables.
# See 5.11.2.1. item 3 of the below link:
# https://www.postgresql.org/docs/12/ddl-partitioning.html
#
# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    table_name = ct.catalog_to_table[i]

    output_file_sql = output_dir_sql + table_name + ".create_indexes.sql"

    line1 = "create index on " + table_name + "_new" + "(catalogid);" + "\n"
    line2 = "create index on " + table_name + "_new" + "(target_id);" + "\n"
    line3 = "create index on " + table_name + "_new" + "(version_id);" + "\n"
    line4 = "create index on " + table_name + "_new" + "(best);" + "\n"
    line5 = "create index on " + table_name + "_new" + \
        "(version_id, target_id, best);" + "\n"

    f = open(output_file_sql, "w")

    f.write(line1)
    f.write(line2)
    f.write(line3)
    f.write(line4)
    f.write(line5)

    f.close()
