/*

schema for gaia dr2 wd candidate list

https://warwick.ac.uk/fac/sci/physics/research/astro/research/catalogues/


WDJ000000.36+490633.05,0.539516,0,Gaia DR2 393458006914856832,393458006914856832,0.0014773967973118027,0.7075813322070995,49.10918286363004,0.6641273352805627,2.476942395997654,1.2176430965201257,-4.682789193136515,1.4129456311736603,0.663950819151247,1.1348776959699016,0.0,1.453872,95.05306850702841,0.7570307654762249,20.74345,69.11764786915664,9.752674060693113,20.752417,72.87538141677395,4.6030663657083375,20.105469,1.493829,114.33689767238835,-12.902338613036298,29958.045,0.34128380270573405,,,,,,,,,,,,,,,,,,,,,,,,,



*/


CREATE TABLE catalogdb.gaia_dr2_wd_candidates_v1 (
    White_dwarf_name text,
    Pwd real,
    Pwd_correction real,
    designation text,
    source_id bigint,
    ra double precision,
    ra_error double precision,
    dec double precision,
    dec_error double precision,
    parallax double precision,
    parallax_error double precision,
    pmra double precision,
    pmra_error double precision
    pmdec double precision,
    pmdec_error double precision,
    astrometric_excess_noise double precision,
    astrometric_sigma5d_max double precision,
    phot_g_mean_flux double precision,
    phot_g_mean_flux_error double precision,
    phot_g_mean_mag double precision,
    phot_bp_mean_flux double precision,
    phot_bp_mean_flux_error double precision,
    phot_bp_mean_mag double precision,
    phot_rp_mean_flux double precision,
    phot_rp_mean_flux_error double precision,
    phot_rp_mean_mag double precision,
    phot_bp_rp_excess_factor double precision,
    l double precision,
    b double precision,
    density integer,
    AG double precision,
    SDSS_name text,
    umag double precision,
    e_umag double precision,
    gmag double precision,
    e_gmag double precision,
    rmag double precision,
    e_rmag double precision,
    imag double precision,
    e_imag double precision,
    zmag double precision,
    e_zmag double precision,
    Teff double precision,
    eTeff double precision,
    log_g double precision,
    elog_g double precision,
    mass double precision,
    emass double precision,
    chi2 double precision,
    Teff_He double precision,
    eTeff_He double precision,
    log_g_He double precision,
    elog_g_He double precision,
    mass_He double precision,
    emass_He double precision,
    chisq_He double precision,
    );
