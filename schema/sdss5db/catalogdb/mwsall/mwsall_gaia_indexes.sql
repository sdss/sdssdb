\o mwsall_gaia_indexes.out
create index on catalogdb.mwsall_gaia(q3c_ang2ipix(ra,dec));
-- mwsall_gaia does not have column targetid.
-- So we do not create an index on targetid.
\o
