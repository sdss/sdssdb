\o sdss_dr17_specobj_create_indexes.out

CREATE INDEX ON catalogdb.sdss_dr17_specobj(q3c_ang2ipix(plug_ra, plug_dec));

CREATE INDEX ON catalogdb.sdss_dr17_specobj(bestobjid);
CREATE INDEX ON catalogdb.sdss_dr17_specobj(plateid);
CREATE INDEX ON catalogdb.sdss_dr17_specobj(fiberid);
CREATE INDEX ON catalogdb.sdss_dr17_specobj(mjd);
CREATE INDEX ON catalogdb.sdss_dr17_specobj(run2d);
CREATE INDEX ON catalogdb.sdss_dr17_specobj(specprimary);

ANALYZE catalogdb.sdss_dr17_specobj;
