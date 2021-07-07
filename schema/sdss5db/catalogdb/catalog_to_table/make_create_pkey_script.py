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

    output_file_sql = output_dir_sql + table_name + ".create_pkey.sql"

    output_line = "alter table " + table_name + "_new" + \
                  " add primary key (version_id, catalogid, target_id);" + "\n"

    f = open(output_file_sql, "w")

    f.write(output_line)
    f.write("\n")

    f.close()
