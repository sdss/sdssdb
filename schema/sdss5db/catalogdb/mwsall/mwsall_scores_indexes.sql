\o mwsall_scores_indexes.out
-- mwsall_scores does not have (target_ra,target_dec) and (ra,dec)
create index on catalogdb.mwsall_scores(targetid);
\o
