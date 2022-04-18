-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tycho2tdsc_merge_best_neighbour.html

create table catalogdb.gaia_edr3_tycho2tdsc_merge_best_neighbour(
source_id bigint, -- Unique Gaia source identifier (long)
original_ext_source_id text, -- Original External Catalogue source identifier (string)
angular_distance real, -- Angular Distance between the two sources (float, Angle[arcsec])
xm_flag smallint, -- Cross-match algorithm flag (short)
tycho2tdsc_merge_oid bigint, -- External Catalogue source identifier (int)
number_of_neighbours smallint -- Number of neighbours in Gaia Catalogue (byte)
);
