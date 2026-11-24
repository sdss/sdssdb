CREATE TABLE catalogdb.sdss5_skies_v2 (
  pix_32768 BIGINT,
  ra DOUBLE PRECISION,
  dec DOUBLE PRECISION,
  down_pix BIGINT,
  tile_32 BIGINT,
  valid_gaia BOOLEAN,
  selected_gaia BOOLEAN,
  sep_neighbour_gaia REAL,
  mag_neighbour_gaia REAL,
  valid_ls8 BOOLEAN,
  selected_ls8 BOOLEAN,
  sep_neighbour_ls8 REAL,
  mag_neighbour_ls8 REAL,
  valid_ps1dr2 BOOLEAN,
  selected_ps1dr2 BOOLEAN,
  sep_neighbour_ps1dr2 REAL,
  mag_neighbour_ps1dr2 REAL,
  valid_tmass BOOLEAN,
  selected_tmass BOOLEAN,
  sep_neighbour_tmass REAL,
  mag_neighbour_tmass REAL,
  valid_tycho2 BOOLEAN,
  selected_tycho2 BOOLEAN,
  sep_neighbour_tycho2 REAL,
  mag_neighbour_tycho2 REAL,
  valid_tmass_xsc BOOLEAN,
  selected_tmass_xsc BOOLEAN,
  sep_neighbour_tmass_xsc REAL,
  valid_virac2 BOOLEAN,
  selected_virac2 BOOLEAN,
  sep_neighbour_virac2 REAL,
  healpix_29 BIGINT,
  hats_norder SMALLINT,
  hats_dir BIGINT,
  hats_npix BIGINT
);

ALTER TABLE catalogdb.sdss5_skies_v2 ADD PRIMARY KEY (pix_32768);

CREATE INDEX sdss5_skies_v2_hats_dir_idx ON catalogdb.sdss5_skies_v2 (hats_dir);
CREATE INDEX sdss5_skies_v2_hats_norder_idx ON catalogdb.sdss5_skies_v2 (hats_norder);
CREATE INDEX sdss5_skies_v2_hats_npix_idx ON catalogdb.sdss5_skies_v2 (hats_npix);
CREATE INDEX sdss5_skies_v2_healpix_29_idx ON catalogdb.sdss5_skies_v2 (healpix_29);
CREATE INDEX sdss5_skies_v2_q3c_ang2ipix_idx ON catalogdb.sdss5_skies_v2 (q3c_ang2ipix(ra, "dec"));
CREATE INDEX sdss5_skies_v2_tile_32_idx ON catalogdb.sdss5_skies_v2 (tile_32);
