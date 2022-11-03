-- This table is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_cross-matches/ssec_dm_ravedr6_neighbourhood.html

create table catalogdb.gaia_dr3_ravedr6_neighbourhood(
source_id bigint,  -- Unique Gaia source identifier (long)
original_ext_source_id text,  -- Original External Catalogue source identifier (string)
angular_distance real,  -- Angular Distance between the two sources (float, Angle[arcsec])
score double precision,  -- Score of neighbours (double)
xm_flag smallint,  -- Cross-match algorithm flag (short)
ravedr6_oid integer-- External Catalogue source identifier (int)
);
