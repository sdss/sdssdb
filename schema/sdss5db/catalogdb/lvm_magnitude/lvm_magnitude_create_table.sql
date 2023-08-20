create table catalogdb.lvm_magnitude(
    source_id bigint,  -- Unique source identifier (unique within a particular Data Release) (long)
    ra double precision,  -- Right Ascension (double, Angle[deg])
    dec double precision,  -- Declination (double, Angle[deg])
    lflux real, -- XP mean spectrum flux integrated over LVM bandpass (float32, [W m-2 nm-1])
    lmag_ab real, -- AB magnitude from lflux (float32)
    lmag_vega real -- Vega magnitude from lflux (float32)
);
