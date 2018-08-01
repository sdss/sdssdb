/*

primary keys for catalogdb tables, to be run after bulk uploads

2mass says:
A column in a table that has data that are never null and are not duplicated
elsewhere in that column in the table may be used to uniquely identify lines.
Pts_key, scan_key, and ext_key are integer columns in the Point Source,
Scan Information, and Extended Source tables that uniquely identify lines in
the respective tables. Note that, although pts_key, scan_key, and ext_key may
be present in more than one table, pts_key is only a unique identifier for
the Point Source table, scan_key is only a unique identifier in the Scan
Information table, and ext_key is only a unique identifier for the Extended
Source table. Some database servers assign a hidden unique object identifier
(oid) to lines in tables. The user may wish to suppress the generation of
oids as pts_key, scan_key, and ext_key can serve to identify lines uniquely.
These columns are used to make joins between tables. The declaration of a
column as a primary key may slow the loading of the data considerably
because of concurrent indexing.

psql -f pks.sql -U sdss -p 5432 sdss5db

*/

/* 10:25 start done by 2pm */
alter table catalogdb.gaia_dr2_source add primary key(source_id);
alter table catalogdb.kepler_input_10 add primary key(kic_kepler_id);
alter table catalogdb.twomass_psc add primary key(pts_key);
alter table catalogdb.tess_input_v6 add primary key(ID);