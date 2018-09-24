\timing
SELECT pts_key, designation, ra, decl, h_m into catalogdb.twomass_clean FROM catalogdb.twomass_psc
    WHERE h_m < 11
    and (ph_qual like '_A_' or ph_qual like '_B_')
    and cc_flg like '_0_'
    and gal_contam = '0' and
    and (rd_flg like '_1_' or rd_flg like '_2_');

alter table catalogdb.twomass_clean add primary key(designation);
ALTER TABLE catalogdb.twomass_clean ADD CONSTRAINT twomass_psc_desig_unique UNIQUE (designation);
CREATE INDEX CONCURRENTLY ON catalogdb.twomass_clean using BTREE (h_m);
create index on catalogdb.twomass_clean (q3c_ang2ipix(ra, decl));
CLUSTER twomass_clean_q3c_ang2ipix_idx on catalogdb.twomass_clean;
analyze catalogdb.twomass_clean;

\timing