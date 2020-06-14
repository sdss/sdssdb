
CREATE MATERIALIZED VIEW catalogdb.allwise_lite AS
    SELECT
        designation::TEXT,
        ra::DOUBLE PRECISION,
        dec::DOUBLE PRECISION,
        glon::DOUBLE PRECISION,
        glat::DOUBLE PRECISION,
        elon::DOUBLE PRECISION,
        elat::DOUBLE PRECISION,
        cntr,
        source_id,
        coadd_id,
        src,
        w1mpro::REAL,
        w2mpro::REAL,
        w3mpro::REAL,
        w4mpro::REAL,
        ra_pm::DOUBLE PRECISION,
        dec_pm::DOUBLE PRECISION,
        pmra::DOUBLE PRECISION,
        pmdec::DOUBLE PRECISION,
        w1flux::REAL,
        w2flux::REAL,
        w3flux::REAL,
        w4flux::REAL,
        w1mag::REAL,
        w2mag::REAL,
        w3mag::REAL,
        w4mag::REAL,
        tmass_key,
        r_2mass::REAL,
        pa_2mass::REAL,
        n_2mass,
        j_m_2mass::REAL,
        j_msig_2mass::REAL,
        h_m_2mass::REAL,
        h_msig_2mass::REAL,
        k_m_2mass::REAL,
        k_msig_2mass::REAL,
        x::DOUBLE PRECISION,
        y::DOUBLE PRECISION,
        z::DOUBLE PRECISION
    FROM catalogdb.allwise
    ORDER BY q3c_ang2ipix(ra::DOUBLE PRECISION, dec::DOUBLE PRECISION);


CREATE UNIQUE INDEX on catalogdb.allwise_lite (cntr);

CREATE INDEX ON catalogdb.allwise_lite USING BTREE (ra);
CREATE INDEX ON catalogdb.allwise_lite USING BTREE (dec);
CREATE INDEX ON catalogdb.allwise_lite USING BTREE (glat);
CREATE INDEX ON catalogdb.allwise_lite using BTREE (glon);

CREATE INDEX ON catalogdb.allwise_lite (w1mpro);
CREATE INDEX ON catalogdb.allwise_lite (w2mpro);
CREATE INDEX ON catalogdb.allwise_lite (w3mpro);
CREATE INDEX ON catalogdb.allwise_lite (w4mpro);

CREATE INDEX ON catalogdb.allwise_lite ((w1mpro - w2mpro));
CREATE INDEX ON catalogdb.allwise_lite ((w2mpro - w3mpro));
CREATE INDEX ON catalogdb.allwise_lite ((w3mpro - w4mpro));

CREATE UNIQUE INDEX ON allwise_lite_designation (designation);

CREATE INDEX ON catalogdb.allwise_lite (q3c_ang2ipix(ra, dec));
ANALYZE catalogdb.allwise_lite;
