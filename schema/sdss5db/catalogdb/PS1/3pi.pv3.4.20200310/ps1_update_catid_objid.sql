\o ps1_update_catid_objid.out
alter table catalogdb.panstarrs1 add column catid_objid bigint;
update catalogdb.panstarrs1 set catid_objid = (catid::bit(32) || objid::bit(32))::bit(64)::bigint;
\o
