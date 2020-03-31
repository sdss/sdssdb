/*

schema for sdss gaia xmatch:

http://gea.esac.esa.int/archive/documentation/GDR2/Gaia_archive/chap_datamodel/sec_dm_crossmatches/ssec_dm_sdssdr9_best_neighbour.html

*/

CREATE TABLE catalogdb.gaiadr2_sdssdr9_best_neighbour(
    sdssdr9_oid bigint,
    number_of_neighbours integer,
    number_of_mates integer,
    best_neighbour_multiplicity integer,
    source_id bigint,
    original_ext_source_id text,
    angular_distance double precision,
    gaia_astrometric_params integer
);


\COPY catalogdb.gaiadr2_sdssdr9_best_neighbour
    FROM '/uufs/chpc.utah.edu/common/home/sdss/sdsswork/gaia/dr2/crossmatch/csv_catalogs/sdssdr9_best_neighbour.csv'
    WITH CSV HEADER;

ALTER TABLE catalogdb.gaiadr2_sdssdr9_best_neighbour ADD PRIMARY KEY (source_id);
