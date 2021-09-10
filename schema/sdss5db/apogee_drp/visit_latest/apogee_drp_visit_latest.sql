/*

APOGEE DRP visit_latest VIEW

*/

CREATE VIEW apogee_drp.visit_latest AS
  WITH rv as (
    SELECT * from apogee_drp.rv_visit as rr
    WHERE (rr.apogee_id, rr.apred_vers, rr.telescope, rr.starver) IN
      (SELECT apogee_id, apred_vers, telescope, max(starver) FROM apogee_drp.rv_visit 
       GROUP BY apogee_id, apred_vers, telescope)
  )
  SELECT v.apogee_id,v.target_id,v.catalogid,v.apred_vers,v.v_apred,v.file,v.uri,v.fiberid,v.plate,v.mjd,v.telescope,
         v.survey,v.field,v.programname,v.ra,v.dec,v.glon,v.glat,v.jmag,
         v.jerr,v.hmag,v.herr,v.kmag,v.kerr,v.src_h,v.pmra,v.pmdec,v.pm_src,
         v.apogee_target1,v.apogee_target2,v.apogee_target3,v.apogee_target4,v.sdssv_apogee_target0,v.firstcarton,
	 v.targflags,v.gaiadr2_plx,v.gaiadr2_plx_error,v.gaiadr2_pmra,v.gaiadr2_pmra_error,v.gaiadr2_pmdec,
	 v.gaiadr2_pmdec_error,v.gaiadr2_gmag,v.gaiadr2_gerr,v.gaiadr2_bpmag,v.gaiadr2_bperr,v.gaiadr2_rpmag,
	 v.gaiadr2_rperr,v.snr,v.starflag,v.starflags,v.dateobs,v.jd,
         rv.starver,rv.bc,rv.vtype,rv.vrel,rv.vrelerr,rv.vheliobary,rv.chisq,rv.rv_teff,
         rv.rv_feh,rv.rv_logg,rv.xcorr_vrel,rv.xcorr_vrelerr,rv.xcorr_vheliobary,rv.n_components,
         rv.rv_components
  FROM apogee_drp.visit AS v LEFT JOIN rv ON rv.visit_pk=v.pk;
