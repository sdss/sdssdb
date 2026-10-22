create schema if not exists opsdb_lco_dr21;

select *
into opsdb_lco_dr21.configuration
from opsdb_lco.configuration cfg
where cfg.epoch < 2461235.1;

select *
into opsdb_lco_dr21.exposure
from opsdb_lco.exposure exp
where exp.configuration_id in 
(select cfg.configuration_id 
from opsdb_lco_dr21.configuration cfg)
and exp.exposure_no < 4000000;

select *
into opsdb_lco_dr21.camera_frame
from opsdb_lco.camera_frame cf
where cf.exposure_pk in 
(select exp.pk
from opsdb_lco_dr21.exposure exp);

select *
into opsdb_lco_dr21.camera
from opsdb_lco.camera;

select *
into opsdb_lco_dr21.design_to_status
from opsdb_lco.design_to_status;

update opsdb_lco_dr21.design_to_status 
set completion_status_pk = 1,
mjd = null,
manual = false
where mjd > 61235;

select *
into opsdb_lco_dr21.completion_status
from opsdb_lco.completion_status;

-- APO 
create schema if not exists opsdb_apo_dr21;

select *
into opsdb_apo_dr21.configuration
from opsdb_apo.configuration cfg
where cfg.epoch < 2461235.1;

select *
into opsdb_apo_dr21.exposure
from opsdb_apo.exposure exp
where exp.configuration_id in 
(select cfg.configuration_id 
from opsdb_apo_dr21.configuration cfg)
and exp.exposure_no < 3000000;

insert into opsdb_apo_dr21.exposure
select *
from opsdb_apo_60130.exposure;

select * 
into opsdb_apo_dr21.camera_frame
from opsdb_apo.camera_frame cf
where cf.exposure_pk in 
(select exp.pk
from opsdb_apo_dr21.exposure exp);

select * 
into opsdb_apo_dr21.camera
from opsdb_apo.camera;

select *
into opsdb_apo_dr21.design_to_status
from opsdb_lco.design_to_status;

update opsdb_apo_dr21.design_to_status
set completion_status_pk = 1,
mjd = null,
manual = false
where mjd > 61235;

select *
into opsdb_apo_dr21.completion_status
from opsdb_apo.completion_status;
