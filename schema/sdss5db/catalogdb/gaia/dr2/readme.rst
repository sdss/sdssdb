
readme describing folder/file contents and loading procedure

catname.sql - original handcrafted sql file
catname_index.sql - sql file of index and primary key creations, etc..
catname_standard.sql - postgres schema standardized output (contains tables, index, alters, etc)
catname_load - loading script of source files to database table
any extra needed files (e.g. prepWISE.py)

$CATALOGDB_DIR=/scratch/general/lustre/catalogdb
load scripts point to $CATALOGDB/catname/version/src/

standardized database dumps can go in $CATALOGDB_DIR/catname/version/dumps/


