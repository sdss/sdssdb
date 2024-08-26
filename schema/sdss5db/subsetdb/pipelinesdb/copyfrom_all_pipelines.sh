# run this on pipelines only
# run this with bash -x so that the commands are echoed to the screen.
# do not use ampersand & since we want to run them one by one.
psql -d sdss5db -a -f catalog_copyfrom.sql
psql -d sdss5db -a -f allwise_copyfrom.sql
psql -d sdss5db -a -f catwise_copyfrom.sql
psql -d sdss5db -a -f catwise2020_copyfrom.sql
psql -d sdss5db -a -f gaia_dr2_source_copyfrom.sql
psql -d sdss5db -a -f gaia_dr3_astro_copyfrom.sql
psql -d sdss5db -a -f gaia_dr3_source_copyfrom.sql
psql -d sdss5db -a -f legacy_survey_dr10_copyfrom.sql
psql -d sdss5db -a -f legacy_survey_dr8_copyfrom.sql
psql -d sdss5db -a -f panstarrs1_copyfrom.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_copyfrom.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_primary_copyfrom.sql
psql -d sdss5db -a -f supercosmos_copyfrom.sql
psql -d sdss5db -a -f tic_v8_copyfrom.sql
psql -d sdss5db -a -f unwise_copyfrom.sql
