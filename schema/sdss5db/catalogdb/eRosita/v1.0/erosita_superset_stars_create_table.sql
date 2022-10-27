-- Based on the information in the below SDSS wiki page
-- Coordinated+follow+up+of+X-ray+sources+in+SDSS-V

create table catalogdb.erosita_superset_v1_stars (
ero_version char(24),
ero_detuid char(32),
ero_flux real,
ero_flux_type char(16),
ero_mjd text,
ero_morph char(9),
ero_det_like real,
ero_ra double precision,
ero_dec double precision,
ero_radec_err real,
ero_flags bigint,
xmatch_method char(24),
xmatch_version char(24),
xmatch_dist real,
xmatch_metric real,
xmatch_flags bigint,
target_class char(12),
target_priority integer,
target_has_spec bigint,
opt_cat char(12),
ls_id bigint,
gaia_dr3_source_id bigint,
opt_ra double precision,
opt_dec double precision,
opt_pmra real,
opt_pmdec real,
opt_epoch real
);
