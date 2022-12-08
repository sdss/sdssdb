CREATE TABLE targetdb.assignment_status (
    pk SERIAL PRIMARY KEY NOT NULL,
    assignment_pk INTEGER,
    status INTEGER,
    mjd REAL);

ALTER TABLE ONLY targetdb.assignment_status
    ADD CONSTRAINT assignment_fk
    FOREIGN KEY (assignment_pk) REFERENCES targetdb.assignment(pk);

-- script that adds all current design.field_pk (and exposure/field_exposure) to new table

insert into targetdb.assignment_status (pk, assignment_pk, status, mjd)
select nextval('targetdb.assignment_status_pk_seq'), 
asn.pk, d2s.completion_status_pk, d2s.mjd
from targetdb.assignment as asn
join targetdb.design as des on asn.design_id = des.design_id
join opsdb_apo.design_to_status as d2s on d2s.design_id = des.design_id
where true ON CONFLICT DO NOTHING;

update targetdb.assignment_status set status = 0, mjd = null
where status = 1 or status = 2;

update targetdb.assignment_status set status = 1, mjd = null
where status = 3;
