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
  SELECT v.apogee_id,v.target_id,v.catalogid,v.sdss_id,v.apred_vers,v.v_apred,
         v.file,v.uri,v.fiberid,v.plate,v.exptime,v.nframes,
  	 v.mjd,v.telescope,v.survey,v.field,v.design,v.programname,v.ra,v.dec,v.glon,v.glat,v.jmag,
         v.jerr,v.hmag,v.herr,v.kmag,v.kerr,v.src_h,v.pmra,v.pmdec,v.pm_src,
         v.apogee_target1,v.apogee_target2,v.apogee_target3,v.apogee_target4,
	 v.sdssv_apogee_target0,v.firstcarton,v.cadence,v.program,v.category,
	 v.targflags,v.gaia_release,v.gaia_plx,v.gaia_plx_error,v.gaia_pmra,v.gaia_pmra_error,v.gaia_pmdec,
	 v.gaia_pmdec_error,v.gaia_gmag,v.gaia_gerr,v.gaia_bpmag,v.gaia_bperr,v.gaia_rpmag,
	 v.gaia_rperr,v.snr,v.starflag,v.starflags,v.dateobs,v.jd,
         rv.starver,rv.bc,rv.vtype,rv.vrel,rv.vrelerr,rv.vrad,rv.chisq,rv.rv_teff,
         rv.rv_feh,rv.rv_logg,rv.xcorr_vrel,rv.xcorr_vrelerr,rv.xcorr_vrad,rv.n_components,
         rv.rv_components
  FROM apogee_drp.visit AS v LEFT JOIN rv ON rv.visit_pk=v.pk;
