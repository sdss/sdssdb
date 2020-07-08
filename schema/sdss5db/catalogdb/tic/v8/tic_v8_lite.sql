
CREATE MATERIALIZED VIEW catalogdb.tic_v8_lite AS
    id,
    version,
    hip,
    tyc,
    ucac,
    twomass,
    sdss,
    allwise,
    gaia,
    apass,
    kic,
    objtype,
    typesrc,
    ra,
    dec,
    posflag,
    pmra,
    pmdec,
    pmflag,
    plx,
    e_plx,
    parflag,
    gallong,
    gallat,
    eclong,
    eclat,
    bmag,
    vmag,
    umag,
    gmag,
    rmag,
    imag,
    zmag,
    jmag,
    hmag,
    kmag,
    twomflag,
    prox,
    w1mag,
    w2mag,
    w3mag,
    w4mag,
    gaiamag,
    tmag,
    tessflag,
    spflag,
    teff,
    logg,
    mh,
    rad,
    mass,
    rho,
    lumclass,
    lum,
    d,
    ebv,
    gaiabp,
    gaiarp,
    ra_orig,
    dec_orig
FROM catalogdb.tic_v8;


CREATE UNIQUE INDEX on catalogdb.tic_v8_lite (id);

CREATE INDEX ON catalogdb.tic_v8_lite (jmag);
CREATE INDEX ON catalogdb.tic_v8_lite (hmag);
CREATE INDEX ON catalogdb.tic_v8_lite (kmag);
CREATE INDEX ON catalogdb.tic_v8_lite (tmag);

CREATE INDEX ON catalogdb.tic_v8_lite (plx);

CREATE INDEX ON catalogdb.tic_v8_lite (gaia_int);
CREATE INDEX ON catalogdb.tic_v8_lite (tyc);
CREATE INDEX ON catalogdb.tic_v8_lite (kic);
CREATE INDEX ON catalogdb.tic_v8_lite (allwise);
CREATE INDEX ON catalogdb.tic_v8_lite (sdss);
CREATE INDEX ON catalogdb.tic_v8_lite (twomass_psc);

CREATE INDEX ON catalogdb.tic_v8_lite (q3c_ang2ipix(ra, dec));
VACUUM ANALYZE catalogdb.tic_v8_lite;
