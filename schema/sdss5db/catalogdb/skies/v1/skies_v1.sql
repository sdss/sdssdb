/*

Sky positions catalogue v1

This is a collection of downsampled sky positions centred around
HEALPix pixels of nside 32768 (~6 arcsec) and tiled using tiles of
nside 32 (~2 deg). It's generated using the target_selection product.

Columns
-------
pix_32768 - The HEALPix of nside 32768 corresponding to this sky position.
ra - RA at the centre of the sky position.
dec - Dec at the centre of the sky position.
down_pix - HEALPix pixel of nside 256 used for uniform downsampling.
tile_32 - Tile as a HEALPix of nside 32.
gaia_sky - Whether this can be considered a sky based on Gaia DR2 sources.
sep_neighbour_gaia - Separation to the closest Gaia DR2 source, arcsec.
mag_neighbour_gaia - Gaia G magnitude of the closest Gaia DR2 source.
ls8_sky - Whether this can be considered a sky based on Legacy Surcey DR8 sources.
sep_neighbour_ls8 - Separation to the closest Legacy Surcey DR8 source, arcsec.
mag_neighbour_ls8 - Gaia G magnitude of the closest Legacy Surcey DR8 source.
tmass_sky - Whether this can be considered a sky based on 2MASS sources.
sep_neighbour_tmass - Separation to the closest 2MASS source, arcsec.
mag_neighbour_tmass - Gaia G magnitude of the closest 2MASS source.
tycho2_sky - Whether this can be considered a sky based on Tycho2 sources.
sep_neighbour_tycho2 - Separation to the closest Tycho2 source, arcsec.
mag_neighbour_tycho2 - Gaia G magnitude of the closest Tycho2 source.
tmass_xsc_sky - Whether this can be considered a sky based on 2MASS XSC sources.
sep_neighbour_tmass_xsc - Separation to the closest 2MASS XSC source, arcsec.
mag_neighbour_tmass_xsc - Gaia G magnitude of the closest 2MASS XSC source.

*/

CREATE TABLE catalogdb.skies_v1 (
    pix_32768 BIGINT PRIMARY KEY,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    down_pix INTEGER,
    tile_32 INTEGER,
    gaia_sky BOOLEAN,
    sep_neighbour_gaia REAL,
    mag_neighbour_gaia REAL,
    ls8_sky BOOLEAN,
    sep_neighbour_ls8 REAL,
    mag_neighbour_ls8 REAL,
    tmass_sky BOOLEAN,
    sep_neighbour_tmass REAL,
    mag_neighbour_tmass REAL,
    tycho2_sky BOOLEAN,
    sep_neighbour_tycho2 REAL,
    mag_neighbour_tycho2 REAL,
    tmass_xsc_sky BOOLEAN,
    sep_neighbour_tmass_xsc REAL,
    mag_neighbour_tmass_xsc REAL
);

\copy catalogdb.skies_v1 FROM PROGRAM 'bzcat $CATALOGDB_DIR/skies/v1/skies_v1.csv.bz2' WITH CSV HEADER;

CREATE INDEX ON catalogdb.skies_v1 (tile_32);
CREATE INDEX ON catalogdb.skies_v1 (gaia_sky);
CREATE INDEX ON catalogdb.skies_v1 (ls8_sky);
CREATE INDEX ON catalogdb.skies_v1 (tmass_sky);
CREATE INDEX ON catalogdb.skies_v1 (tycho2_sky);
CREATE INDEX ON catalogdb.skies_v1 (tmass_xsc_sky);

CREATE INDEX ON catalogdb.skies_v1 (q3c_ang2ipix(ra, dec));
VACUUM ANALYZE catalogdb.skies_v1;
