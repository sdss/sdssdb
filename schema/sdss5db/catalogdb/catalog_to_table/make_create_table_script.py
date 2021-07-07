import catalog_to_table_list as ct
# print(ct.catalog_to_table)

# output_dir_sql must end with /
output_dir_sql = "/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/" + \
    "catalogs/catalog_to_table/sql/"

for i in range(len(ct.catalog_to_table)):
    table_name = ct.catalog_to_table[i]

    output_file_sql = output_dir_sql + table_name + ".create_table.sql"

    if(table_name == "catalogdb.catalog_to_catwise"):
        target_id_column = "target_id varchar(25) not null,"

    elif(table_name == "catalogdb.catalog_to_catwise2020"):
        target_id_column = "target_id varchar(25) not null,"

    elif(table_name == "catalogdb.catalog_to_gaia_dr2_wd_sdss"):
        target_id_column = "target_id integer not null,"

    elif(table_name == "catalogdb.catalog_to_sdss_dr16_apogeestar"):
        target_id_column = "target_id text not null,"

    elif(table_name == "catalogdb.catalog_to_sdss_dr16_specobj"):
        target_id_column = "target_id numeric(20, 0) not null,"

    elif(table_name == "catalogdb.catalog_to_tycho2"):
        target_id_column = "target_id text not null,"

    elif(table_name == "catalogdb.catalog_to_unwise"):
        target_id_column = "target_id text not null,"

    else:
        target_id_column = "target_id bigint not null,\n"

    output_line = "create table " + table_name + "_new" + "(\n" + \
        "catalogid bigint not null,\n" + \
        target_id_column + \
        "version_id smallint not null,\n" + \
        "distance double precision,\n" + \
        "best boolean not null)\n" + \
        "partition by range(version_id);"

    f = open(output_file_sql, "w")

    f.write(output_line)
    f.write("\n")

    f.close()
