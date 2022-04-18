-- https://gea.esac.esa.int/archive/documentation/GEDR3/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_panstarrs1_best_neighbour.html

create table catalogdb.gaia_edr3_panstarrs1_best_neighbour(
source_id bigint, -- Unique Gaia source identifier (long)
clean_panstarrs1_oid bigint, -- External Catalogue source identifier (long)
original_ext_source_id bigint, -- Original External Catalogue source identifier (long)
angular_distance real, -- Angular Distance between the two sources (float, Angle[arcsec])
number_of_neighbours smallint, -- Number of neighbours in External Catalogue (byte)
number_of_mates smallint, -- Number of mates in Gaia Catalogue (byte)
xm_flag smallint -- Cross-match algorithm flag (short)
);
