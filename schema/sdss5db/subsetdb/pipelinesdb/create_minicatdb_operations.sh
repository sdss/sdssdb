# run this on operations server only
#
# run this with bash -x so that the commands are printed to the screen.
# below order *.sql  is as in READMEpg.
# do not use & at the end since we want to do it one by one.
#
# First three commands must complete properly since the 
# some of the remaining tables depend on the first three tables.
#
# There are 14 tables below since
# script for the minicatdb.catalog
# can have three different types. 
# That script must run before the scripts below.
# See READMEsteps.

psql -U postgres -d sdss5db -a -f minicatdb_tic_v8.sql 

psql -U postgres -d sdss5db -a -f minicatdb_gaia_dr3_source.sql 

psql -U postgres -d sdss5db -a -f minicatdb_sdss_dr13_photoobj_primary.sql  

psql -U postgres -d sdss5db -a -f minicatdb_allwise.sql 
psql -U postgres -d sdss5db -a -f minicatdb_catwise2020.sql 
psql -U postgres -d sdss5db -a -f minicatdb_catwise.sql 
psql -U postgres -d sdss5db -a -f minicatdb_gaia_dr2_source.sql 
psql -U postgres -d sdss5db -a -f minicatdb_gaia_dr3_astro.sql  
psql -U postgres -d sdss5db -a -f minicatdb_legacy_survey_dr10.sql 
psql -U postgres -d sdss5db -a -f minicatdb_legacy_survey_dr8.sql 
psql -U postgres -d sdss5db -a -f minicatdb_panstarrs1.sql 
psql -U postgres -d sdss5db -a -f minicatdb_sdss_dr13_photoobj.sql 
psql -U postgres -d sdss5db -a -f minicatdb_supercosmos.sql 
psql -U postgres -d sdss5db -a -f minicatdb_unwise.sql 
