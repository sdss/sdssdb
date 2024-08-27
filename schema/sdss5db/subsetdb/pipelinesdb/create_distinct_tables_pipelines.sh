# run this on pipelines only
#
# run this with bash -x so that the commands are echoed to the screen.
# do not use ampersand  & since we want to run this one by one.
psql -d sdss5db -a -f catalog_distinct.sql
psql -d sdss5db -a -f allwise_distinct.sql
psql -d sdss5db -a -f catwise_distinct.sql
psql -d sdss5db -a -f catwise2020_distinct.sql
psql -d sdss5db -a -f gaia_dr2_source_distinct.sql
psql -d sdss5db -a -f gaia_dr3_astro_distinct.sql
psql -d sdss5db -a -f gaia_dr3_source_distinct.sql
psql -d sdss5db -a -f legacy_survey_dr10_distinct.sql
psql -d sdss5db -a -f legacy_survey_dr8_distinct.sql
psql -d sdss5db -a -f panstarrs1_distinct.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_distinct.sql
# psql -d sdss5db -a -f sdss_dr13_photoobj_primary_distinct.sql
psql -d sdss5db -a -f supercosmos_distinct.sql
psql -d sdss5db -a -f tic_v8_distinct.sql
psql -d sdss5db -a -f unwise_distinct.sql
