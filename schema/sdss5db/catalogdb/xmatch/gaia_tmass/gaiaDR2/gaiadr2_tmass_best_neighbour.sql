/*

schema for 2mass gaia xmatch:

http://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_tmass_best_neighbour.html

*/

CREATE TABLE catalogdb.gaiadr2_tmass_best_neighbour(
    tmass_oid bigint,
    number_of_neighbours integer,
    number_of_mates integer,
    best_neighbour_multiplicity integer,
    source_id bigint,
    original_ext_source_id character(17),
    angular_distance double precision,
    gaia_astrometric_params integer,
    tmass_pts_key integer
);

\COPY catalogdb.gaiadr2_tmass_best_neighbour FROM '$CATALOGDB_DIR/xmatch/gaia_tmass/gaiaDR2/tmass_best_neighbour.csv' WITH CSV HEADER;

ALTER TABLE catalogdb.gaiadr2_tmass_best_neighbour ADD PRIMARY KEY (source_id);

CREATE INDEX ON catalogdb.gaiadr2_tmass_best_neighbour USING BTREE (tmass_oid);
CREATE INDEX ON catalogdb.gaiadr2_tmass_best_neighbour USING BTREE (original_ext_source_id);
