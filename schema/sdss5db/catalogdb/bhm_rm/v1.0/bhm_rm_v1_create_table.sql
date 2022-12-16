-- Based on the information in the below SDSS wiki page
-- https://wiki.sdss.org/display/BHM/Updates+to+BHM+RM+catalogs+and+cartons+in+v1.0+targeting

create table catalogdb.bhm_rm_v1 (
rm_field_name char(8) not null,
ra double precision,
dec double precision,
catalogidv05 bigint,
rm_known_spec boolean,
rm_core boolean,
rm_var boolean,
rm_ancillary boolean,
mag_g real,
mag_r real,
mag_i real,
mag_z real,
gaia_g real,
gaia_bp real,
gaia_rp real,
ls_id_dr8 bigint,
ls_id_dr10 bigint,
gaia_dr2_source_id bigint,
gaia_dr3_source_id bigint,
panstarrs1_catid_objid bigint,
rm_unsuitable boolean,
rm_xrayqso integer,
);
