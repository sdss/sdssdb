-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tmass_psc_xsc_best_neighbour.html
-- below table only contains the psc rows of the above data

create table catalogdb.gaia_edr3_tmass_psc_xsc_best_neighbour2(
source_id bigint, -- Unique Gaia source identifier (long)
original_ext_source_id text, -- Original External Catalogue source identifier (string)
angular_distance real, -- Angular Distance between the two sources (float, Angle[arcsec])
xm_flag smallint, -- Cross-match algorithm flag (short)
clean_tmass_psc_xsc_oid bigint, -- External Catalogue source identifier (int)
number_of_neighbours smallint, -- Number of neighbours in External Catalogue (byte)
number_of_mates smallint -- Number of mates in Gaia Catalogue (byte)
);
