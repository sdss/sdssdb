alter table targetdb.obsmode rename max_airmass to max_airmass_apo;
alter table targetdb.obsmode add column max_airmass_lco real;

update targetdb.obsmode set max_airmass_lco = max_airmass_apo where label like '%dark%';
update targetdb.obsmode set max_airmass_lco = 1.8 where label like '%bright%';
