CREATE MATERIALIZED VIEW sandbox.done_to_sdssid
AS
select at.mjd, t.catalogid, c.program, c.carton, 
i.label, i.default_lambda_eff, sdssid.sdss_id
from targetdb.assignment_status as at
join targetdb.assignment as assn on assn.pk = at.assignment_pk
join targetdb.carton_to_target as c2t on c2t.pk = assn.carton_to_target_pk
join targetdb.target as t on c2t.target_pk = t.pk
join targetdb.carton as c on c.pk = c2t.carton_pk
join targetdb.instrument as i on i.pk = assn.instrument_pk
join catalogdb.sdss_id_flat as sdssid on sdssid.catalogid = t.catalogid
where at.status = 1;
