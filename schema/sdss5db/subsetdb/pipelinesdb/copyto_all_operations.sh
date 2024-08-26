# run this on operations only
# run this with bash -x so that the commands are echoed to the screen.
#
# do not use ampersand & since we want to run them one by one.
psql -d sdss5db -U postgres -a -f catalog_copyto.sql
psql -d sdss5db -U postgres -a -f allwise_copyto.sql
psql -d sdss5db -U postgres -a -f catwise_copyto.sql
psql -d sdss5db -U postgres -a -f catwise2020_copyto.sql
psql -d sdss5db -U postgres -a -f gaia_dr2_source_copyto.sql
psql -d sdss5db -U postgres -a -f gaia_dr3_astro_copyto.sql
psql -d sdss5db -U postgres -a -f gaia_dr3_source_copyto.sql
psql -d sdss5db -U postgres -a -f legacy_survey_dr10_copyto.sql
psql -d sdss5db -U postgres -a -f legacy_survey_dr8_copyto.sql
psql -d sdss5db -U postgres -a -f panstarrs1_copyto.sql
psql -d sdss5db -U postgres -a -f sdss_dr13_photoobj_copyto.sql
psql -d sdss5db -U postgres -a -f sdss_dr13_photoobj_primary_copyto.sql
psql -d sdss5db -U postgres -a -f supercosmos_copyto.sql
psql -d sdss5db -U postgres -a -f tic_v8_copyto.sql
psql -d sdss5db -U postgres -a -f unwise_copyto.sql
