-- update table catalogdb.glimpse360 and set field to NULL based on
-- page 26 table 8 of the below document
-- http://www.astro.wisc.edu/sirtf/glimpse360_dataprod_v1.2.pdf

\o glimpse360_update_table_null.out

update catalogdb.glimpse360 set tmass_cntr=NULL where tmass_cntr=0 ;

update catalogdb.glimpse360 set tmass_designation=NULL where tmass_designation like'%null%' ;

\o
