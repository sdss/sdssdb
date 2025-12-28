CREATE TABLE targetdb.assignment_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    assignment_pk INTEGER,
    status INTEGER,
    mjd REAL);

ALTER TABLE ONLY targetdb.assignment_status
    ADD CONSTRAINT assignment_fk
    FOREIGN KEY (assignment_pk) REFERENCES targetdb.assignment(pk);

insert into targetdb.assignment_status (pk, assignment_pk, status, mjd)
select nextval('targetdb.assignment_status_pk_seq'), 
asn.pk, d2s.completion_status_pk, d2s.mjd
from targetdb.assignment as asn
join targetdb.design as des on asn.design_id = des.design_id
join opsdb_apo.design_to_status as d2s on d2s.design_id = des.design_id
join targetdb.hole as hole on asn.hole_pk = hole.pk
join targetdb.observatory as obs on hole.observatory_pk = obs.pk
where obs.label = 'APO' ON CONFLICT DO NOTHING;

insert into targetdb.assignment_status (pk, assignment_pk, status, mjd)
select nextval('targetdb.assignment_status_pk_seq'), 
asn.pk, d2s.completion_status_pk, d2s.mjd
from targetdb.assignment as asn
join targetdb.design as des on asn.design_id = des.design_id
join opsdb_lco.design_to_status as d2s on d2s.design_id = des.design_id
join targetdb.hole as hole on asn.hole_pk = hole.pk
join targetdb.observatory as obs on hole.observatory_pk = obs.pk
where obs.label = 'LCO' ON CONFLICT DO NOTHING;

update targetdb.assignment_status set status = 0, mjd = null
where status = 1 or status = 2;

update targetdb.assignment_status set status = 1
where status = 3;

with boss_stat as (
select stat.pk
from targetdb.assignment_status as stat
join targetdb.assignment as assn on assn.pk = stat.assignment_pk
join targetdb.hole as hole on assn.hole_pk = hole.pk
join targetdb.observatory as obs on hole.observatory_pk = obs.pk
where stat.mjd < 60000 and assn.instrument_pk = 0
and obs.label = 'LCO'
)

update targetdb.assignment_status assn_stat
set status = 0, mjd = null
from boss_stat
where boss_stat.pk = assn_stat.pk;

-- actually this is unnecessary? Nothing is done before 59853
with ap_stat as (
select stat.pk
from targetdb.assignment_status as stat
join targetdb.assignment as assn on assn.pk = stat.assignment_pk
join targetdb.hole as hole on assn.hole_pk = hole.pk
join targetdb.observatory as obs on hole.observatory_pk = obs.pk
where stat.mjd < 59853 and assn.instrument_pk = 1
and obs.label = 'LCO'
)

update targetdb.assignment_status assn_stat
set status = 0, mjd = null
from ap_stat
where ap_stat.pk = assn_stat.pk;

-- just an example below, to be used for incremental updates as needed

with new_stat as (
select stat.pk, d2s.mjd
from targetdb.assignment_status as stat
join targetdb.assignment as assn on assn.pk = stat.assignment_pk
join opsdb_apo.design_to_status as d2s on d2s.design_id = assn.design_id 
where d2s.mjd > 60076.0 and d2s.completion_status_pk = 3
)

update targetdb.assignment_status assn_stat
set status = 1, mjd = new_stat.mjd
from new_stat
where new_stat.pk = assn_stat.pk;

-- "orphaned" designs from both observatories
with new_stat as (
select stat.pk
from targetdb.assignment_status as stat
join targetdb.assignment as assn on assn.pk = stat.assignment_pk
join targetdb.carton_to_target as c2t on c2t.pk = assn.carton_to_target_pk
join targetdb.cadence as cad on cad.pk = c2t.cadence_pk
where stat.status = 1 and cad.label like '%x1%'
and assn.design_id in 
(57900, 43705, 117191, 117193, 120943, 121590, 129252, 129569, 
129799, 129649, 119033, 130833, 130200, 117550, 185828, 186333, 
186403, 203741, 209171, 180378, 185915, 185764, 185896, 186070, 
202311)
)

update targetdb.assignment_status assn_stat
set status = 0, mjd = null
from new_stat
where new_stat.pk = assn_stat.pk;

-- add a new RS run

select max(des.design_id)
from targetdb.design as des
join targetdb.design_to_field as d2f on d2f.design_id = des.design_id
join targetdb.field as f on d2f.field_pk = f.pk
join targetdb.version as v on f.version_pk = v.pk
where v.plan = 'theta-1';

--> 447859 this time

insert into targetdb.assignment_status (pk, assignment_pk, status, mjd)
select nextval('targetdb.assignment_status_pk_seq1'), 
asn.pk, 0, null
from targetdb.assignment as asn
join targetdb.design as des on asn.design_id = des.design_id
join targetdb.hole as hole on asn.hole_pk = hole.pk
join targetdb.observatory as obs on hole.observatory_pk = obs.pk
join targetdb.design_to_field as d2f on d2f.design_id = des.design_id
join targetdb.field as f on d2f.field_pk = f.pk
join targetdb.version as v on f.version_pk = v.pk
where v.plan = 'iota-1' and des.design_id > 734759
ON CONFLICT DO NOTHING;