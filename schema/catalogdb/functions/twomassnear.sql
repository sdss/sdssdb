--takes 12826.228 ms for first select

\timing

insert into catalogdb.twomass_clean select twomassBrightNeighbor(ra, decl, designation, h_m) as bright_neighbor from catalogdb.twomass_clean;

create index concurrently on catalogdb.twomass_clean using btree (bright_neighbor);

analyze catalogdb.twomass_clean;
\timing