-- This table is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_cross-matches/ssec_dm_ravedr6_best_neighbour.html

create table catalogdb.gaia_dr3_ravedr6_best_neighbour(
source_id bigint,  -- Unique Gaia source identifier (long)
original_ext_source_id text,  -- Original External Catalogue source identifier (string)
angular_distance real,  -- Angular Distance between the two sources (float, Angle[arcsec])
xm_flag smallint,  -- Cross-match algorithm flag (short)
ravedr6_oid integer,  -- External Catalogue source identifier (int)
number_of_neighbours smallint -- Number of neighbours in Gaia Catalogue (byte)
);
