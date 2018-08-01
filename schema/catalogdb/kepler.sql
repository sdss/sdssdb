/*

schema for kepler version 10 input catalog

http://archive.stsci.edu/kepler/kic10/help/quickcol.html

these columns from utah disk are slightly re-ordered from webpage, and
the 2 mass designation column is renamed (kic_tm_designation)

to run:
psql -f kepler.sql -h db.sdss.utah.edu -U sdssdb_admin -p 5432 sdss5db
*/


CREATE TABLE catalogdb.kepler_input_10 (
    kic_ra double precision,
    kic_dec double precision,
    kic_pmra double precision,
    kic_pmdec double precision,
    kic_umag double precision,
    kic_gmag double precision,
    kic_rmag double precision,
    kic_imag double precision,
    kic_zmag double precision,
    kic_gredmag double precision,
    kic_d51mag double precision,
    kic_jmag double precision,
    kic_hmag double precision,
    kic_kmag double precision,
    kic_kepmag double precision,
    kic_kepler_id bigint,
    kic_tmid bigint,
    kic_scpid bigint,
    kic_altid bigint,
    kic_altsource bigint,
    kic_galaxy integer,
    kic_blend integer,
    kic_variable integer,
    kic_teff integer,
    kic_logg real,
    kic_feh real,
    kic_ebminusv real,
    kic_av real,
    kic_radius real,
    kic_cq TEXT,
    kic_pq TEXT,
    kic_aq integer,
    kic_catkey bigint,
    kic_scpkey bigint,
    kic_parallax real,
    kic_glon double precision,
    kic_glat double precision,
    kic_pmtotal real,
    kic_grcolor double precision,
    kic_jkcolor double precision,
    kic_gkcolor double precision,
    kic_degree_ra double precision,
    kic_fov_flag integer,
    kic_tm_designation TEXT);
