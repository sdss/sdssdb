
/*
Sky positions catalogue v2
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
valid_gaia - Whether this can be considered a sky based on Gaia DR2 sources.
selected_gaia -
sep_neighbour_gaia - Separation to the closest Gaia DR2 source, arcsec.
mag_neighbour_gaia - Gaia G magnitude of the closest Gaia DR2 source.
valid_ls8 - Whether this can be considered a sky based on Legacy Surcey DR8 sources.
selected_ls8 -
sep_neighbour_ls8 - Separation to the closest Legacy Surcey DR8 source, arcsec.
mag_neighbour_ls8 - Gaia G magnitude of the closest Legacy Surcey DR8 source.
valid_tmass - Whether this can be considered a sky based on 2MASS sources.
selected_tmass -
sep_neighbour_tmass - Separation to the closest 2MASS source, arcsec.
mag_neighbour_tmass - Gaia G magnitude of the closest 2MASS source.
valid_tycho2 - Whether this can be considered a sky based on Tycho2 sources.
selected_tycho2 -
sep_neighbour_tycho2 - Separation to the closest Tycho2 source, arcsec.
mag_neighbour_tycho2 - Gaia G magnitude of the closest Tycho2 source.
valid_tmass_xsc - Whether this can be considered a sky based on 2MASS XSC sources.
selected_tmass_xsc -
sep_neighbour_tmass_xsc - Separation to the closest 2MASS XSC source, arcsec.

Note that there is no column like below.
mag_neighbour_tmass_xsc - Gaia G magnitude of the closest 2MASS XSC source.
*/

create table catalogdb.skies_v2(
pix_32768 bigint, --  int64
ra double precision,  -- float64
dec double precision,  -- float64
down_pix  bigint,  -- int64
tile_32 bigint,  -- int64
valid_gaia boolean, -- bool
selected_gaia boolean, -- bool
sep_neighbour_gaia real,  -- float32
mag_neighbour_gaia real,  -- float32
valid_ls8 boolean,  -- bool
selected_ls8 boolean,  -- bool
sep_neighbour_ls8 real,  -- float32
mag_neighbour_ls8 real,  -- float32
valid_ps1dr2 boolean,  -- bool
selected_ps1dr2 boolean,  -- bool
sep_neighbour_ps1dr2 real,  -- float32
mag_neighbour_ps1dr2 real,  -- float32
valid_tmass boolean,  -- bool
selected_tmass boolean,  -- bool
sep_neighbour_tmass real,  -- float32
mag_neighbour_tmass real,  -- float32
valid_tycho2 boolean,  -- bool
selected_tycho2 boolean,  -- bool
sep_neighbour_tycho2 real,  -- float32
mag_neighbour_tycho2 real,  -- float32
valid_tmass_xsc  boolean,  -- bool
selected_tmass_xsc boolean,  -- bool
sep_neighbour_tmass_xsc real  -- float32
);
