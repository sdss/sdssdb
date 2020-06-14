
CREATE MATERIALIZED VIEW catalogdb.twomass_psc_lite AS
    SELECT
        ra,
        decl,
        designation,
        j_m,
        h_m,
        k_m,
        ph_qual,
        rd_flg,
        bl_flg,
        cc_flg,
        gal_contam,
        mp_flg,
        pts_key,
        glon,
        glat,
        jdate,
    FROM catalogdb.twomass_psc
    ORDER BY q3c_ang2ipix(ra, decl);


CREATE UNIQUE INDEX on catalogdb.allwise_lite (pts_key);
CREATE UNIQUE INDEX ON catalogdb.twomass_psc_lite (designation);

CREATE INDEX ON catalogdb.twomass_psc_lite (j_m);
CREATE INDEX ON catalogdb.twomass_psc_lite (h_m);
CREATE INDEX ON catalogdb.twomass_psc_lite (k_m);
CREATE INDEX ON catalogdb.twomass_psc_lite (ph_qual);
CREATE INDEX ON catalogdb.twomass_psc_lite (rd_flg);
CREATE INDEX ON catalogdb.twomass_psc_lite (bl_flg);
CREATE INDEX ON catalogdb.twomass_psc_lite (cc_flg);
CREATE INDEX ON catalogdb.twomass_psc_lite (jdate);

CREATE INDEX ON catalogdb.twomass_psc_lite (q3c_ang2ipix(ra, decl));
ANALYZE catalogdb.twomass_psc_lite;
