\o ps1_update_extid_hi_lo.out
alter table catalogdb.panstarrs1 add column extid_hi_lo bigint;
update catalogdb.panstarrs1 set extid_hi_lo = (extid_hi::bit(32) || extid_lo::bit(32))::bit(64)::bigint;
\o
