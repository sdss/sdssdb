\o sdss_dr19p_speclite_create_indexes.out

CREATE INDEX ON catalogdb.sdss_dr19p_speclite(catalogid);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(bestobjid);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(plate, mjd, fiberid);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(mjd);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(zwarning);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(z);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(z_err);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(sn_median_all);
CREATE INDEX ON catalogdb.sdss_dr19p_speclite(q3c_ang2ipix(plug_ra, plug_dec));

ANALYZE catalogdb.sdss_dr19p_speclite;
