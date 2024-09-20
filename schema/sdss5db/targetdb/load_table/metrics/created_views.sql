CREATE MATERIALIZED VIEW sandbox.rs_run_to_sdssid
AS
select assn.pk as assignment_pk, at.mjd, t.catalogid, c.program, c.carton,
i.label as instrument, i.default_lambda_eff, sdssid.sdss_id,
obs.label as observatory, at.status as done,
f.field_id
from targetdb.assignment_status as at
join targetdb.assignment as assn on assn.pk = at.assignment_pk
join targetdb.hole as hole on hole.pk = assn.hole_pk
join targetdb.observatory as obs on obs.pk = hole.observatory_pk
join targetdb.carton_to_target as c2t on c2t.pk = assn.carton_to_target_pk
join targetdb.target as t on c2t.target_pk = t.pk
join targetdb.carton as c on c.pk = c2t.carton_pk
join targetdb.instrument as i on i.pk = assn.instrument_pk
join catalogdb.sdss_id_flat as sdssid on sdssid.catalogid = t.catalogid
join targetdb.design_to_field as d2f on d2f.design_id = assn.design_id
join targetdb.field as f on f.pk = d2f.field_pk
join targetdb.version as v on v.pk = f.version_pk
where v.plan = 'eta-9';

CREATE MATERIALIZED VIEW sandbox.carton_to_sdssid
AS
select t.catalogid, c.program, c.carton, 
i.label as instrument,
i.default_lambda_eff, sdssid.sdss_id,
(select sum(n) from unnest(cad.nexp) as n) as nexp
from targetdb.carton_to_target as c2t 
join targetdb.target as t on c2t.target_pk = t.pk
join targetdb.carton as c on c.pk = c2t.carton_pk
join targetdb.cadence as cad on cad.pk = c2t.cadence_pk
join targetdb.instrument as i on i.pk = c2t.instrument_pk
join catalogdb.sdss_id_flat as sdssid on sdssid.catalogid = t.catalogid
where c.version_pk >= 136;

-- TO DO: use Tom's targeting generation table once it's on pipelines
