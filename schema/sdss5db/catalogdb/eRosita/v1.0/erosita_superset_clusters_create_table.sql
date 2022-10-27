-- Based on the information in the below SDSS wiki page
-- Coordinated+follow+up+of+X-ray+sources+in+SDSS-V

create table catalogdb.erosita_superset_v1_clusters (
ero_version text,
ero_detuid text,
ero_flux real,
ero_flux_type text,
ero_mjd text,
ero_morph text,
ero_flags bigint,
ero_det_like real,
ero_ra double precision,
ero_dec double precision,
ero_radec_err real,
xmatch_method text,
xmatch_version text,
xmatch_dist real,
xmatch_metric real,
xmatch_flags bigint,
target_class text,
target_priority integer,
target_has_spec bigint,
opt_cat text,
ls_id bigint,
gaia_dr3_source_id bigint,
opt_ra double precision,
opt_dec double precision,
opt_pmra real,
opt_pmdec real,
opt_epoch real,
eromapper_lambda real,
eromapper_z_lambda real
);
