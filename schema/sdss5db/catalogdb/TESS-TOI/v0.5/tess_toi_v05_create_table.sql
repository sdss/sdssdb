-- Based on the information in the below fits file.
-- TESS_Observedv0.5.fits

create table catalogdb.tess_toi_v05 (
    ticid bigint, -- format = 'K'
    target_type char(8), -- format = '8A'
    toi char(32), -- format = '32A'
    tess_disposition char(4), -- format = '4A'
    tfopwg_disposition char(3), -- format = '3A'
    ctoi char(32), -- format = '32A'
    user_disposition char(2), -- format = '2A'
    num_sectors double precision -- format = 'D'
);
