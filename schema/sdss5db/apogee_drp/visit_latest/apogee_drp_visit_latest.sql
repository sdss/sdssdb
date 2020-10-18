/*

APOGEE DRP visit_latest VIEW

*/

CREATE VIEW apogee_drp.visit_latest AS
  SELECT v.apogee_id,v.target_id,v.apred_vers,v.file,v.uri,v.fiberid,v.plate,v.mjd,v.telescope,
         v.survey,v.field,v.programname,v.alt_id,v.location_id,v.ra,v.dec,v.glon,v.glat,v.j,
         v.j_err,v.h,v.h_err,v.k,v.k_err,v.src_h,v.wash_m,v.wash_m_err,v.wash_t2,v.wash_t2_err,
         v.ddo51,v.ddo51_err,v.irac_3_6,v.irac_3_6_err,v.irac_4_5,v.irac_4_5_err,v.irac_5_8,
         v.irac_5_8_err,v.irac_8_0,v.irac_8_0_err,v.wise_4_5,v.wise_4_5_err,v.targ_4_5,
         v.targ_4_5_err,v.wash_ddo51_giant_flag,v.wash_ddo51_star_flag,v.pmra,v.pmdec,v.pm_src,
         v.ak_targ,v.ak_targ_method,v.ak_wise,v.sfd_ebv,v.apogee_target1,v.apogee_target2,
         v.apogee_target3,v.apogee_target4,v.targflags,v.snr,v.starflag,v.starflags,v.dateobs,
         v.jd,rv.starver,rv.bc,rv.vtype,rv.vrel,rv.vrelerr,rv.vhelio,rv.chisq,rv.rv_teff,
         rv.rv_feh,rv.rv_logg,rv.xcorr_vrel,rv.xcorr_vrelerr,rv.xcorr_vhelio,rv.n_components,
         rv.rv_components
  FROM apogee_drp.rv_visit AS rv JOIN apogee_drp.visit AS v ON rv.visit_pk=v.pk
  WHERE (rv.apogee_id, rv.apred_vers, rv.telescope, rv.starver) IN
    (SELECT apogee_id, apred_vers, telescope, max(starver) FROM apogee_drp.rv_visit 
     GROUP BY apogee_id, apred_vers, telescope);
