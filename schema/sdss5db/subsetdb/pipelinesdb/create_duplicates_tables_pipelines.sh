# run this on pipelines only
#
# run this with bash -x so that the command is printed to the screen.
# do not use ampersand & since we want to run this one by one.
psql -d sdss5db -a -f catalog_duplicates.sql
psql -d sdss5db -a -f allwise_duplicates.sql
psql -d sdss5db -a -f catwise_duplicates.sql
psql -d sdss5db -a -f catwise2020_duplicates.sql
psql -d sdss5db -a -f gaia_dr2_source_duplicates.sql
psql -d sdss5db -a -f gaia_dr3_astro_duplicates.sql
psql -d sdss5db -a -f gaia_dr3_source_duplicates.sql
psql -d sdss5db -a -f legacy_survey_dr10_duplicates.sql
psql -d sdss5db -a -f legacy_survey_dr8_duplicates.sql
psql -d sdss5db -a -f panstarrs1_duplicates.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_duplicates.sql
psql -d sdss5db -a -f sdss_dr13_photoobj_primary_duplicates.sql
psql -d sdss5db -a -f supercosmos_duplicates.sql
psql -d sdss5db -a -f tic_v8_duplicates.sql
psql -d sdss5db -a -f unwise_duplicates.sql
