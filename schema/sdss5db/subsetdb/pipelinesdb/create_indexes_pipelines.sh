# run this on pipelines only
#
# do not use ampersand  & since we want to run this one by one
psql -d sdss5db -a -f catalog_create_indexes.sql
psql -d sdss5db -a -f allwise_create_indexes.sql
psql -d sdss5db -a -f catwise_create_indexes.sql
psql -d sdss5db -a -f catwise2020_create_indexes.sql
psql -d sdss5db -a -f gaia_dr2_source_create_indexes.sql
psql -d sdss5db -a -f gaia_dr3_astro_create_indexes.sql
psql -d sdss5db -a -f gaia_dr3_source_create_indexes.sql
psql -d sdss5db -a -f legacy_survey_dr10_create_indexes.sql
psql -d sdss5db -a -f legacy_survey_dr8_create_indexes.sql
psql -d sdss5db -a -f panstarrs1_create_indexes.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_create_indexes.sql
# psql -d sdss5db -a -f sdss_dr13_photoobj_primary_create_indexes.sql
psql -d sdss5db -a -f supercosmos_create_indexes.sql
psql -d sdss5db -a -f tic_v8_create_indexes.sql
psql -d sdss5db -a -f unwise_create_indexes.sql
