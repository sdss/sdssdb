create schema if not exists opsdb_lco_dr20;

select *
into opsdb_lco_dr20.configuration
from opsdb_lco.configuration cfg
where cfg.epoch < 2460709.5;

select *
into opsdb_lco_dr20.exposure
from opsdb_lco.exposure exp
where exp.configuration_id in 
(select cfg.configuration_id 
from opsdb_lco_dr20.configuration cfg)
and exp.exposure_no < 4000000;

select *
into opsdb_lco_dr20.camera_frame
from opsdb_lco.camera_frame cf
where cf.exposure_pk in 
(select exp.pk
from opsdb_lco_dr20.exposure exp);

select *
into opsdb_lco_dr20.camera
from opsdb_lco.camera;

select *
into opsdb_lco_dr20.design_to_status
from opsdb_lco.design_to_status;

update opsdb_lco_dr20.design_to_status 
set completion_status_pk = 1,
mjd = null,
manual = false
where mjd > 60708.8;

select *
into opsdb_lco_dr20.completion_status
from opsdb_lco.completion_status;

-- APO 
create schema if not exists opsdb_apo_dr20;

select *
into opsdb_apo_dr20.configuration
from opsdb_apo.configuration cfg
where cfg.epoch < 2460709.5;

select *
into opsdb_apo_dr20.exposure
from opsdb_apo.exposure exp
where exp.configuration_id in 
(select cfg.configuration_id 
from opsdb_apo_dr20.configuration cfg)
and exp.exposure_no < 3000000;

insert into opsdb_apo_dr20.exposure
select *
from opsdb_apo_60130.exposure;

select * 
into opsdb_apo_dr20.camera_frame
from opsdb_apo.camera_frame cf
where cf.exposure_pk in 
(select exp.pk
from opsdb_apo_dr20.exposure exp);

select * 
into opsdb_apo_dr20.camera
from opsdb_apo.camera;

select *
into opsdb_apo_dr20.design_to_status
from opsdb_lco.design_to_status;

update opsdb_apo_dr20.design_to_status
set completion_status_pk = 1,
mjd = null,
manual = false
where mjd > 60708.8;

select *
into opsdb_apo_dr20.completion_status
from opsdb_apo.completion_status;
