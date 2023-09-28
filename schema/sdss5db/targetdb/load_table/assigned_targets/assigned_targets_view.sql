CREATE MATERIALIZED VIEW targetdb.assigned_targets
AS
SELECT c.program, c.pk as carton_pk,
       c2t.pk as c2t_pk, c2t.target_pk,
       assn.pk as assignment_pk, d.design_id, 
       f.field_id, f.pk as field_pk,
       o.pk as observatory_pk,
       v.pk as version_pk,
       c2t.cadence_pk,
       d2s.mjd, d2s.completion_status_pk
FROM targetdb.assignment AS assn
INNER JOIN targetdb.design AS d ON (assn.design_id = d.design_id)
INNER JOIN targetdb.design_to_field AS d2f ON (d.design_id = d2f.design_id)
INNER JOIN opsdb_lco.design_to_status AS d2s ON (d.design_id = d2s.design_id)
INNER JOIN targetdb.field AS f ON (f.pk = d2f.field_pk)
INNER JOIN targetdb.carton_to_target AS c2t ON (assn.carton_to_target_pk = c2t.pk)
INNER JOIN targetdb.carton AS c ON (c2t.carton_pk = c.pk)
INNER JOIN targetdb.observatory as o on (f.observatory_pk = o.pk)
INNER JOIN targetdb.version as v on (f.version_pk = v.pk)
WHERE v.plan = 'eta-5'
WITH DATA;

create unique index at_assn_idx on targetdb.assigned_targets (assignment_pk);
