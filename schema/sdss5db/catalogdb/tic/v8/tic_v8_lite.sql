
CREATE MATERIALIZED VIEW catalogdb.tic_v8_lite AS
    SELECT
        id,
	    hip,
	    tyc,
        twomass_psc,
	    sdss,
	    allwise,
	    kic,
        gaia_int,
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
        ebv,
        e_ebv,
        gaiamag,
        gaiabp,
        gaiarp,
        ra_orig,
        dec_orig
    FROM catalogdb.tic_v8
    ORDER BY q3c_ang2ipix(ra, dec);


CREATE UNIQUE INDEX on catalogdb.tic_v8_lite (id);

CREATE INDEX ON catalogdb.tic_v8_lite (gaia_int);
CREATE INDEX ON catalogdb.tic_v8_lite (tyc);
CREATE INDEX ON catalogdb.tic_v8_lite (kic);
CREATE INDEX ON catalogdb.tic_v8_lite (allwise);
CREATE INDEX ON catalogdb.tic_v8_lite (sdss);
CREATE INDEX ON catalogdb.tic_v8_lite (twomass_psc);

CREATE INDEX ON catalogdb.tic_v8_lite (q3c_ang2ipix(ra, dec));
VACUUM ANALYZE catalogdb.tic_v8_lite;
