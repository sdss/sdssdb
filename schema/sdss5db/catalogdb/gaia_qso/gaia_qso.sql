/*

Title: Compilation of known QSOs for the Gaia mission (Liao+, 2019)
URL: http://vizier.u-strasbg.fr/viz-bin/VizieR?-source=J/other/RAA/19.29

The ;-separated file downloaded from Vizier has been modified by removing
all the comments except the header and then opening and saving it with
Pandas using the skipinitialspace=True option.

Columns:

Name        (a23)       Name (1)
RAJ2000     (F15.11)    Right ascension (J2000.0) (2)
DEJ2000     (F15.11)    Declination (J2000.0) (2)
e_RAJ2000   (F13.11)    Error in Right ascension
e_DEJ2000   (F13.11)    Error in Declination
z           (F13.10)    Redshift (3)
umag        (F11.8)     u photographic magnitude (4)
gmag        (F11.8)     g photographic magnitude (4)
rmag        (F11.8)     r photographic magnitude (4)
imag        (F11.8)     i photographic magnitude (4)
zmag        (F11.8)     z photographic magnitude (4)
Ref         (a15)       Reference catalog (5)
W1-W2       (F5.2)      W1-W2 photographic magnitude (6)
W2-W3       (F5.2)      W2-W3 photographic magnitude (6)
W1mag       (F5.2)      W1 photographic magnitude (6)

*/

CREATE TABLE catalogdb.gaia_qso (
    name TEXT,
    raj2000 DOUBLE PRECISION,
    dej2000 DOUBLE PRECISION,
    e_raj2000 DOUBLE PRECISION,
    e_dej2000 DOUBLE PRECISION,
    z DOUBLE PRECISION,
    umag REAL,
    gmag REAL,
    rmag REAL,
    imag REAL,
    zmag REAL,
    ref TEXT,
    w1_w2 REAL,
    w2_w3 REAL,
    w1mag REAL
) WITHOUT OIDS;

\copy catalogdb.gaia_qso FROM PROGRAM 'cat $CATALOGDB_DIR/gaia_qso/Gaia_QSO_Liao_2019.csv' WITH CSV HEADER;

ALTER TABLE catalogdb.gaia_qso ADD COLUMN pk BIGSERIAL;
ALTER TABLE catalogdb.gaia_qso ADD PRIMARY KEY (pk);


CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso (q3c_ang2ipix(raj2000, dej2000));
CLUSTER gaia_qso_q3c_ang2ipix_idx ON catalogdb.gaia_qso;
ANALYZE catalogdb.gaia_qso;

CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (umag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (gmag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (rmag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (imag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (zmag);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (w1_w2);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (w2_w3);
CREATE INDEX CONCURRENTLY ON catalogdb.gaia_qso USING BTREE (w1mag);

ALTER TABLE catalogdb.gaia_qso ALTER COLUMN pk SET STATISTICS 5000;
ALTER INDEX catalogdb.gaia_qso_q3c_ang2ipix_idx ALTER COLUMN q3c_ang2ipix SET STATISTICS 5000;
