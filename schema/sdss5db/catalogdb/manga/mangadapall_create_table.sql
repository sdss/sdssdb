-- Below columns are nullable
-- versdap
-- rdxqakey
-- binkey
-- sckey
-- elmkey
-- elfkey
-- sikey
-- tplkey
-- bintype
-- binsnr
-- datedap

CREATE TABLE catalogdb.mangaDAPall (
------------------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Analysis Pipeline (DAP).
------------------------------------------------------------------------------
--/T Collated summary information about the DAP methods, and global metrics 
--/T derived from the DAP analysis products useful for sample selection.
------------------------------------------------------------------------------
    plate int NOT NULL, --/U  --/D Plate number  
    ifudesign int NOT NULL, --/U  --/D IFU design number  
    plateifu varchar(32) NOT NULL, --/U  --/D String combination of PLATE-IFU to ease searching  
    mangaid varchar(16) NOT NULL, --/U  --/D MaNGA ID string  
    drpallindx int NOT NULL, --/U  --/D Row index of the observation in the DRPall file  
    mode varchar(16) NOT NULL, --/U  --/D 3D mode of the DRP file (CUBE or RSS)  
    daptype varchar(32) NOT NULL, --/U  --/D Keyword of the analysis approach used (e.g., HYB10-GAU-MILESHC)  
    dapdone bit NOT NULL, --/U  --/D Flag that MAPS file successfully produced  
    objra float NOT NULL, --/U deg --/D RA of the galaxy center  
    objdec float NOT NULL, --/U deg --/D Declination of the galaxy center  
    ifura float NOT NULL, --/U deg --/D RA of the IFU pointing center (generally the same as OBJRA)  
    ifudec float NOT NULL, --/U deg --/D Declination of the IFU pointing center (generally the same as OBJDEC)  
    mngtarg1 int NOT NULL, --/U  --/D Main survey targeting bit  
    mngtarg2 int NOT NULL, --/U  --/D Non-galaxy targeting bit  
    mngtarg3 int NOT NULL, --/U  --/D Ancillary targeting bit  
    z real NOT NULL, --/U  --/D Redshift used to set initial guess velocity (typically identical to NSA_Z)  
    ldist_z real NOT NULL, --/U h^{-1} Mpc --/D Luminosity distance based on Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7) 
    adist_z real NOT NULL, --/U h^{-1} Mpc --/D Angular-diameter distance based on Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    nsa_z real NOT NULL, --/U  --/D Redshift from the NASA-Sloan Atlas  
    nsa_zdist real NOT NULL, --/U  --/D NSA distance estimate using pecular velocity model of Willick et al. (1997); multiply by c/H0 for Mpc.  
    ldist_nsa_z real NOT NULL, --/U h^{-1} Mpc --/D Luminosity distance based on NSA_Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    adist_nsa_z real NOT NULL, --/U h^{-1} Mpc --/D Angular-diameter distance based on NSA_Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    nsa_elpetro_ba real NOT NULL, --/U  --/D NSA isophotal axial ratio from elliptical Petrosian analysis  
    nsa_elpetro_phi real NOT NULL, --/U deg --/D NSA isophotal position angle from elliptical Petrosian analysis  
    nsa_elpetro_th50_r real NOT NULL, --/U arcsec --/D NSA elliptical Petrosian effective radius in the r-band; the is the same as R_{e} below.  
    nsa_sersic_ba real NOT NULL, --/U  --/D NSA isophotal axial ratio from Sersic fit  
    nsa_sersic_phi real NOT NULL, --/U deg --/D NSA isophotal position angle from Sersic fit  
    nsa_sersic_th50 real NOT NULL, --/U arcsec --/D NSA effective radius from the Sersic fit  
    nsa_sersic_n real NOT NULL, --/U  --/D NSA Sersic index  
    versdrp2 varchar(16) NOT NULL, --/U  --/D Version of DRP used for 2d reductions  
    versdrp3 varchar(16) NOT NULL, --/U  --/D Version of DRP used for 3d reductions  
    verscore varchar(16) NOT NULL, --/U  --/D Version of mangacore used by the DAP  
    versutil varchar(16) NOT NULL, --/U  --/D Version of idlutils used by the DAP  
    versdap varchar(16),  -- NOT NULL, --/U  --/D Version of mangadap  
    drp3qual int NOT NULL, --/U  --/D DRP 3D quality bit  
    dapqual int NOT NULL, --/U  --/D DAP quality bit  
    rdxqakey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword for the method used to assess the reduced data  
    binkey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword for the spatial binning method  
    sckey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword for the method used to model the stellar-continuum  
    elmkey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword that defines the emission-line moment measurement method  
    elfkey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword that defines the emission-line modeling method  
    sikey varchar(32),  -- NOT NULL, --/U  --/D Configuration keyword that defines the spectral-index measurement method  
    bintype varchar(16), -- NOT NULL, --/U  --/D Type of binning used  
    binsnr real,  -- NOT NULL, --/U  --/D Target for bin S/N, if Voronoi binning  
    tplkey varchar(32),  -- NOT NULL, --/U  --/D The identifier of the template library, e.g., MILES.  
    datedap varchar(12),  -- NOT NULL, --/U  --/D Date the DAP file was created and/or last modified.  
    dapbins int NOT NULL, --/U  --/D The number of "binned" spectra analyzed by the DAP.  
    rcov90 real NOT NULL, --/U arcsec --/D Semi-major axis radius (R) below which spaxels cover at least 90% of elliptical annuli with width R +/- 2.5 arcsec.  This should be independent of the DAPTYPE.  
    snr_med_g real NOT NULL, --/F SNR_MED 0 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for g.  
    snr_med_r real NOT NULL, --/F SNR_MED 1 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for r.  
    snr_med_i real NOT NULL, --/F SNR_MED 2 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for i.  
    snr_med_z real NOT NULL, --/F SNR_MED 3 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for z.  
    snr_ring_g real NOT NULL, --/F SNR_RING 0 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for g.  
    snr_ring_r real NOT NULL, --/F SNR_RING 1 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for r.  
    snr_ring_i real NOT NULL, --/F SNR_RING 2 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for i.  
    snr_ring_z real NOT NULL, --/F SNR_RING 3 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for z.  
    sb_1re real NOT NULL, --/U 10^{-17} erg/s/cm^{2}/angstrom/spaxel --/D Mean g-band surface brightness of valid spaxels within 1 R_e}.  This should be independent of the DAPTYPE.  
    bin_rmax real NOT NULL, --/U R_{e} --/D Maximum g-band luminosity-weighted semi-major radius of any "valid" binned spectrum.  
    bin_r_n_05 real NOT NULL, --/F BIN_R_N 0 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 05.  
    bin_r_n_10 real NOT NULL, --/F BIN_R_N 1 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 10.  
    bin_r_n_20 real NOT NULL, --/F BIN_R_N 2 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 20.  
    bin_r_snr_05 real NOT NULL, --/F BIN_R_SNR 0 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 05.  
    bin_r_snr_10 real NOT NULL, --/F BIN_R_SNR 1 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 10.  
    bin_r_snr_20 real NOT NULL, --/F BIN_R_SNR 2 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 20.  
    stellar_z real NOT NULL, --/U  --/D Flux-weighted mean redshift of the stellar component within a 2.5 arcsec aperture at the galaxy center.  
    stellar_vel_lo real NOT NULL, --/U km/s --/D Stellar velocity at 2.5% growth of all valid spaxels.  
    stellar_vel_hi real NOT NULL, --/U km/s --/D Stellar velocity at 97.5% growth of all valid spaxels.  
    stellar_vel_lo_clip real NOT NULL, --/U km/s --/D Stellar velocity at 2.5% growth after iteratively clipping 3-sigma outliers.  
    stellar_vel_hi_clip real NOT NULL, --/U km/s --/D Stellar velocity at 97.5% growth after iteratively clipping 3-sigma outliers.  
    stellar_sigma_1re real NOT NULL, --/U km/s --/D Flux-weighted mean stellar velocity dispersion of all spaxels within 1 R_{e}.  
    stellar_rchi2_1re real NOT NULL, --/U  --/D Median reduced chi^{2} of the stellar-continuum fit within 1 R_{e}.  
    ha_z real NOT NULL, --/U  --/D Flux-weighted mean redshift of the Hα line within a 2.5 arcsec aperture at the galaxy center.  
    ha_gvel_lo real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth of all valid spaxels.  
    ha_gvel_hi real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth of all valid spaxels.  
    ha_gvel_lo_clip real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth after iteratively clipping 3-sigma outliers.  
    ha_gvel_hi_clip real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth after iteratively clipping 3-sigma outliers.  
    ha_gsigma_1re real NOT NULL, --/U km/s --/D Flux-weighted H-alpha velocity dispersion (from Gaussian fit) of all spaxels within 1 R_{e}.  
    ha_gsigma_hi real NOT NULL, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth of all valid spaxels.  
    ha_gsigma_hi_clip real NOT NULL, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth after iteratively clipping 3-sigma outliers.  
    emline_rchi2_1re real NOT NULL, --/U  --/D Median reduced chi^{2} of the continuum+emission-line fit within 1 R_{e}.  
    emline_sflux_cen_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_CEN 0 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIId_3728.  
    emline_sflux_cen_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_CEN 1 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3729.  
    emline_sflux_cen_h12_3751 real NOT NULL, --/F EMLINE_SFLUX_CEN 2 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for H12_3751.  
    emline_sflux_cen_h11_3771 real NOT NULL, --/F EMLINE_SFLUX_CEN 3 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for H11_3771.  
    emline_sflux_cen_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_CEN 4 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hthe_3798.  
    emline_sflux_cen_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_CEN 5 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heta_3836.  
    emline_sflux_cen_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_CEN 6 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3869.
    emline_sflux_cen_hei_3889 real NOT NULL, --/F EMLINE_SFLUX_CEN 7 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_3889.  
    emline_sflux_cen_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_CEN 8 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hzet_3890.  
    emline_sflux_cen_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_CEN 9 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3968.
    emline_sflux_cen_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_CEN 10 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heps_3971.  
    emline_sflux_cen_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_CEN 11 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hdel_4102.  
    emline_sflux_cen_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_CEN 12 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hgam_4341.  
    emline_sflux_cen_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_CEN 13 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeII_4687.  
    emline_sflux_cen_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_CEN 14 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hb_4862.  
    emline_sflux_cen_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_CEN 15 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_4960.  
    emline_sflux_cen_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_CEN 16 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_5008.  
    emline_sflux_cen_ni_5199 real NOT NULL, --/F EMLINE_SFLUX_CEN 17 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NI_5199.  
    emline_sflux_cen_ni_5201 real NOT NULL, --/F EMLINE_SFLUX_CEN 18 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NI_5201.  
    emline_sflux_cen_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_CEN 19 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_5877.  
    emline_sflux_cen_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_CEN 20 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6302.  
    emline_sflux_cen_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_CEN 21 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6365.  
    emline_sflux_cen_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_CEN 22 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6549.  
    emline_sflux_cen_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_CEN 23 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Ha_6564.  
    emline_sflux_cen_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_CEN 24 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6585.  
    emline_sflux_cen_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_CEN 25 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6718.  
    emline_sflux_cen_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_CEN 26 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6732.  
    emline_sflux_cen_hei_7067 real NOT NULL, --/F EMLINE_SFLUX_CEN 27 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_7067.  
    emline_sflux_cen_ariii_7137 real NOT NULL, --/F EMLINE_SFLUX_CEN 28 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for ArIII_7137.
    emline_sflux_cen_ariii_7753 real NOT NULL, --/F EMLINE_SFLUX_CEN 29 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for ArIII_7753.
    emline_sflux_cen_peta_9017 real NOT NULL, --/F EMLINE_SFLUX_CEN 30 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Peta_9017.  
    emline_sflux_cen_siii_9071 real NOT NULL, --/F EMLINE_SFLUX_CEN 31 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SIII_9071.  
    emline_sflux_cen_pzet_9231 real NOT NULL, --/F EMLINE_SFLUX_CEN 32 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Pzet_9231.  
    emline_sflux_cen_siii_9533 real NOT NULL, --/F EMLINE_SFLUX_CEN 33 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SIII_9533.  
    emline_sflux_cen_peps_9548 real NOT NULL, --/F EMLINE_SFLUX_CEN 34 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Peps_9548.  
    emline_sflux_1re_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_1RE 0 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIId_3728.  
    emline_sflux_1re_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_1RE 1 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3729.  
    emline_sflux_1re_h12_3751 real NOT NULL, --/F EMLINE_SFLUX_1RE 2 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for H12_3751.  
    emline_sflux_1re_h11_3771 real NOT NULL, --/F EMLINE_SFLUX_1RE 3 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for H11_3771.  
    emline_sflux_1re_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_1RE 4 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hthe_3798.  
    emline_sflux_1re_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_1RE 5 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heta_3836.  
    emline_sflux_1re_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_1RE 6 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3869.
    emline_sflux_1re_hei_3889 real NOT NULL, --/F EMLINE_SFLUX_1RE 7 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_3889.  
    emline_sflux_1re_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_1RE 8 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hzet_3890.  
    emline_sflux_1re_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_1RE 9 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3968.
    emline_sflux_1re_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_1RE 10 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heps_3971.  
    emline_sflux_1re_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_1RE 11 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hdel_4102.  
    emline_sflux_1re_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_1RE 12 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hgam_4341.  
    emline_sflux_1re_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_1RE 13 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeII_4687.  
    emline_sflux_1re_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_1RE 14 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hb_4862.  
    emline_sflux_1re_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_1RE 15 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_4960.  
    emline_sflux_1re_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_1RE 16 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_5008.  
    emline_sflux_1re_ni_5199 real NOT NULL, --/F EMLINE_SFLUX_1RE 17 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NI_5199.  
    emline_sflux_1re_ni_5201 real NOT NULL, --/F EMLINE_SFLUX_1RE 18 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NI_5201.  
    emline_sflux_1re_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_1RE 19 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_5877.  
    emline_sflux_1re_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_1RE 20 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6302.  
    emline_sflux_1re_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_1RE 21 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6365.  
    emline_sflux_1re_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_1RE 22 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6549.  
    emline_sflux_1re_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_1RE 23 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Ha_6564.  
    emline_sflux_1re_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_1RE 24 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6585.  
    emline_sflux_1re_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_1RE 25 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6718.  
    emline_sflux_1re_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_1RE 26 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6732.  
    emline_sflux_1re_hei_7067 real NOT NULL, --/F EMLINE_SFLUX_1RE 27 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_7067.  
    emline_sflux_1re_ariii_7137 real NOT NULL, --/F EMLINE_SFLUX_1RE 28 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for ArIII_7137.
    emline_sflux_1re_ariii_7753 real NOT NULL, --/F EMLINE_SFLUX_1RE 29 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for ArIII_7753.
    emline_sflux_1re_peta_9017 real NOT NULL, --/F EMLINE_SFLUX_1RE 30 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Peta_9017.  
    emline_sflux_1re_siii_9071 real NOT NULL, --/F EMLINE_SFLUX_1RE 31 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SIII_9071.  
    emline_sflux_1re_pzet_9231 real NOT NULL, --/F EMLINE_SFLUX_1RE 32 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Pzet_9231.  
    emline_sflux_1re_siii_9533 real NOT NULL, --/F EMLINE_SFLUX_1RE 33 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SIII_9533.  
    emline_sflux_1re_peps_9548 real NOT NULL, --/F EMLINE_SFLUX_1RE 34 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Peps_9548.  
    emline_sflux_tot_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_TOT 0 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIId_3728.  
    emline_sflux_tot_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_TOT 1 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OII_3729.  
    emline_sflux_tot_h12_3751 real NOT NULL, --/F EMLINE_SFLUX_TOT 2 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for H12_3751.  
    emline_sflux_tot_h11_3771 real NOT NULL, --/F EMLINE_SFLUX_TOT 3 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for H11_3771.  
    emline_sflux_tot_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_TOT 4 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hthe_3798.  
    emline_sflux_tot_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_TOT 5 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Heta_3836.  
    emline_sflux_tot_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_TOT 6 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NeIII_3869.
    emline_sflux_tot_hei_3889 real NOT NULL, --/F EMLINE_SFLUX_TOT 7 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeI_3889.  
    emline_sflux_tot_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_TOT 8 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hzet_3890.  
    emline_sflux_tot_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_TOT 9 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NeIII_3968.
    emline_sflux_tot_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_TOT 10 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Heps_3971.  
    emline_sflux_tot_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_TOT 11 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hdel_4102.  
    emline_sflux_tot_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_TOT 12 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hgam_4341.  
    emline_sflux_tot_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_TOT 13 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeII_4687.  
    emline_sflux_tot_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_TOT 14 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hb_4862.  
    emline_sflux_tot_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_TOT 15 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIII_4960.  
    emline_sflux_tot_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_TOT 16 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIII_5008.  
    emline_sflux_tot_ni_5199 real NOT NULL, --/F EMLINE_SFLUX_TOT 17 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NI_5199.  
    emline_sflux_tot_ni_5201 real NOT NULL, --/F EMLINE_SFLUX_TOT 18 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NI_5201.  
    emline_sflux_tot_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_TOT 19 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeI_5877.  
    emline_sflux_tot_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_TOT 20 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OI_6302.  
    emline_sflux_tot_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_TOT 21 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OI_6365.  
    emline_sflux_tot_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_TOT 22 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NII_6549.  
    emline_sflux_tot_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_TOT 23 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Ha_6564.  
    emline_sflux_tot_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_TOT 24 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NII_6585.  
    emline_sflux_tot_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_TOT 25 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SII_6718.  
    emline_sflux_tot_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_TOT 26 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SII_6732.  
    emline_sflux_tot_hei_7067 real NOT NULL, --/F EMLINE_SFLUX_TOT 27 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeI_7067.  
    emline_sflux_tot_ariii_7137 real NOT NULL, --/F EMLINE_SFLUX_TOT 28 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for ArIII_7137.
    emline_sflux_tot_ariii_7753 real NOT NULL, --/F EMLINE_SFLUX_TOT 29 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for ArIII_7753.
    emline_sflux_tot_peta_9017 real NOT NULL, --/F EMLINE_SFLUX_TOT 30 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Peta_9017.  
    emline_sflux_tot_siii_9071 real NOT NULL, --/F EMLINE_SFLUX_TOT 31 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SIII_9071.  
    emline_sflux_tot_pzet_9231 real NOT NULL, --/F EMLINE_SFLUX_TOT 32 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Pzet_9231.  
    emline_sflux_tot_siii_9533 real NOT NULL, --/F EMLINE_SFLUX_TOT 33 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SIII_9533.  
    emline_sflux_tot_peps_9548 real NOT NULL, --/F EMLINE_SFLUX_TOT 34 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Peps_9548.  
    emline_ssb_1re_oiid_3728 real NOT NULL, --/F EMLINE_SSB_1RE 0 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIId_3728.  
    emline_ssb_1re_oii_3729 real NOT NULL, --/F EMLINE_SSB_1RE 1 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_ssb_1re_h12_3751 real NOT NULL, --/F EMLINE_SSB_1RE 2 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for H12_3751.  
    emline_ssb_1re_h11_3771 real NOT NULL, --/F EMLINE_SSB_1RE 3 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for H11_3771.  
    emline_ssb_1re_hthe_3798 real NOT NULL, --/F EMLINE_SSB_1RE 4 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_ssb_1re_heta_3836 real NOT NULL, --/F EMLINE_SSB_1RE 5 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_ssb_1re_neiii_3869 real NOT NULL, --/F EMLINE_SSB_1RE 6 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.
    emline_ssb_1re_hei_3889 real NOT NULL, --/F EMLINE_SSB_1RE 7 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_3889.  
    emline_ssb_1re_hzet_3890 real NOT NULL, --/F EMLINE_SSB_1RE 8 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_ssb_1re_neiii_3968 real NOT NULL, --/F EMLINE_SSB_1RE 9 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.
    emline_ssb_1re_heps_3971 real NOT NULL, --/F EMLINE_SSB_1RE 10 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_ssb_1re_hdel_4102 real NOT NULL, --/F EMLINE_SSB_1RE 11 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_ssb_1re_hgam_4341 real NOT NULL, --/F EMLINE_SSB_1RE 12 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_ssb_1re_heii_4687 real NOT NULL, --/F EMLINE_SSB_1RE 13 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_ssb_1re_hb_4862 real NOT NULL, --/F EMLINE_SSB_1RE 14 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_ssb_1re_oiii_4960 real NOT NULL, --/F EMLINE_SSB_1RE 15 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_ssb_1re_oiii_5008 real NOT NULL, --/F EMLINE_SSB_1RE 16 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_ssb_1re_ni_5199 real NOT NULL, --/F EMLINE_SSB_1RE 17 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NI_5199.  
    emline_ssb_1re_ni_5201 real NOT NULL, --/F EMLINE_SSB_1RE 18 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NI_5201.  
    emline_ssb_1re_hei_5877 real NOT NULL, --/F EMLINE_SSB_1RE 19 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_ssb_1re_oi_6302 real NOT NULL, --/F EMLINE_SSB_1RE 20 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_ssb_1re_oi_6365 real NOT NULL, --/F EMLINE_SSB_1RE 21 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_ssb_1re_nii_6549 real NOT NULL, --/F EMLINE_SSB_1RE 22 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_ssb_1re_ha_6564 real NOT NULL, --/F EMLINE_SSB_1RE 23 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_ssb_1re_nii_6585 real NOT NULL, --/F EMLINE_SSB_1RE 24 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_ssb_1re_sii_6718 real NOT NULL, --/F EMLINE_SSB_1RE 25 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_ssb_1re_sii_6732 real NOT NULL, --/F EMLINE_SSB_1RE 26 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_ssb_1re_hei_7067 real NOT NULL, --/F EMLINE_SSB_1RE 27 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_7067.  
    emline_ssb_1re_ariii_7137 real NOT NULL, --/F EMLINE_SSB_1RE 28 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7137.
    emline_ssb_1re_ariii_7753 real NOT NULL, --/F EMLINE_SSB_1RE 29 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7753.
    emline_ssb_1re_peta_9017 real NOT NULL, --/F EMLINE_SSB_1RE 30 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Peta_9017.  
    emline_ssb_1re_siii_9071 real NOT NULL, --/F EMLINE_SSB_1RE 31 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SIII_9071.  
    emline_ssb_1re_pzet_9231 real NOT NULL, --/F EMLINE_SSB_1RE 32 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Pzet_9231.  
    emline_ssb_1re_siii_9533 real NOT NULL, --/F EMLINE_SSB_1RE 33 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SIII_9533.  
    emline_ssb_1re_peps_9548 real NOT NULL, --/F EMLINE_SSB_1RE 34 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Peps_9548.  
    emline_ssb_peak_oiid_3728 real NOT NULL, --/F EMLINE_SSB_PEAK 0 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIId_3728.  
    emline_ssb_peak_oii_3729 real NOT NULL, --/F EMLINE_SSB_PEAK 1 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OII_3729.  
    emline_ssb_peak_h12_3751 real NOT NULL, --/F EMLINE_SSB_PEAK 2 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for H12_3751.  
    emline_ssb_peak_h11_3771 real NOT NULL, --/F EMLINE_SSB_PEAK 3 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for H11_3771.  
    emline_ssb_peak_hthe_3798 real NOT NULL, --/F EMLINE_SSB_PEAK 4 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hthe_3798.  
    emline_ssb_peak_heta_3836 real NOT NULL, --/F EMLINE_SSB_PEAK 5 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Heta_3836.  
    emline_ssb_peak_neiii_3869 real NOT NULL, --/F EMLINE_SSB_PEAK 6 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NeIII_3869.
    emline_ssb_peak_hei_3889 real NOT NULL, --/F EMLINE_SSB_PEAK 7 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeI_3889.  
    emline_ssb_peak_hzet_3890 real NOT NULL, --/F EMLINE_SSB_PEAK 8 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hzet_3890.  
    emline_ssb_peak_neiii_3968 real NOT NULL, --/F EMLINE_SSB_PEAK 9 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NeIII_3968.
    emline_ssb_peak_heps_3971 real NOT NULL, --/F EMLINE_SSB_PEAK 10 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Heps_3971.  
    emline_ssb_peak_hdel_4102 real NOT NULL, --/F EMLINE_SSB_PEAK 11 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hdel_4102.  
    emline_ssb_peak_hgam_4341 real NOT NULL, --/F EMLINE_SSB_PEAK 12 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hgam_4341.  
    emline_ssb_peak_heii_4687 real NOT NULL, --/F EMLINE_SSB_PEAK 13 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeII_4687.  
    emline_ssb_peak_hb_4862 real NOT NULL, --/F EMLINE_SSB_PEAK 14 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hb_4862.  
    emline_ssb_peak_oiii_4960 real NOT NULL, --/F EMLINE_SSB_PEAK 15 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIII_4960.  
    emline_ssb_peak_oiii_5008 real NOT NULL, --/F EMLINE_SSB_PEAK 16 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIII_5008.  
    emline_ssb_peak_ni_5199 real NOT NULL, --/F EMLINE_SSB_PEAK 17 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NI_5199.  
    emline_ssb_peak_ni_5201 real NOT NULL, --/F EMLINE_SSB_PEAK 18 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NI_5201.  
    emline_ssb_peak_hei_5877 real NOT NULL, --/F EMLINE_SSB_PEAK 19 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeI_5877.  
    emline_ssb_peak_oi_6302 real NOT NULL, --/F EMLINE_SSB_PEAK 20 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OI_6302.  
    emline_ssb_peak_oi_6365 real NOT NULL, --/F EMLINE_SSB_PEAK 21 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OI_6365.  
    emline_ssb_peak_nii_6549 real NOT NULL, --/F EMLINE_SSB_PEAK 22 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NII_6549.  
    emline_ssb_peak_ha_6564 real NOT NULL, --/F EMLINE_SSB_PEAK 23 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Ha_6564.  
    emline_ssb_peak_nii_6585 real NOT NULL, --/F EMLINE_SSB_PEAK 24 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NII_6585.  
    emline_ssb_peak_sii_6718 real NOT NULL, --/F EMLINE_SSB_PEAK 25 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SII_6718.  
    emline_ssb_peak_sii_6732 real NOT NULL, --/F EMLINE_SSB_PEAK 26 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SII_6732.  
    emline_ssb_peak_hei_7067 real NOT NULL, --/F EMLINE_SSB_PEAK 27 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeI_7067.  
    emline_ssb_peak_ariii_7137 real NOT NULL, --/F EMLINE_SSB_PEAK 28 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for ArIII_7137.
    emline_ssb_peak_ariii_7753 real NOT NULL, --/F EMLINE_SSB_PEAK 29 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for ArIII_7753.
    emline_ssb_peak_peta_9017 real NOT NULL, --/F EMLINE_SSB_PEAK 30 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Peta_9017.  
    emline_ssb_peak_siii_9071 real NOT NULL, --/F EMLINE_SSB_PEAK 31 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SIII_9071.  
    emline_ssb_peak_pzet_9231 real NOT NULL, --/F EMLINE_SSB_PEAK 32 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Pzet_9231.  
    emline_ssb_peak_siii_9533 real NOT NULL, --/F EMLINE_SSB_PEAK 33 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SIII_9533.  
    emline_ssb_peak_peps_9548 real NOT NULL, --/F EMLINE_SSB_PEAK 34 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Peps_9548.  
    emline_sew_1re_oiid_3728 real NOT NULL, --/F EMLINE_SEW_1RE 0 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIId_3728.  
    emline_sew_1re_oii_3729 real NOT NULL, --/F EMLINE_SEW_1RE 1 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_sew_1re_h12_3751 real NOT NULL, --/F EMLINE_SEW_1RE 2 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for H12_3751.  
    emline_sew_1re_h11_3771 real NOT NULL, --/F EMLINE_SEW_1RE 3 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for H11_3771.  
    emline_sew_1re_hthe_3798 real NOT NULL, --/F EMLINE_SEW_1RE 4 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_sew_1re_heta_3836 real NOT NULL, --/F EMLINE_SEW_1RE 5 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_sew_1re_neiii_3869 real NOT NULL, --/F EMLINE_SEW_1RE 6 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.
    emline_sew_1re_hei_3889 real NOT NULL, --/F EMLINE_SEW_1RE 7 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_3889.  
    emline_sew_1re_hzet_3890 real NOT NULL, --/F EMLINE_SEW_1RE 8 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_sew_1re_neiii_3968 real NOT NULL, --/F EMLINE_SEW_1RE 9 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.
    emline_sew_1re_heps_3971 real NOT NULL, --/F EMLINE_SEW_1RE 10 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_sew_1re_hdel_4102 real NOT NULL, --/F EMLINE_SEW_1RE 11 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_sew_1re_hgam_4341 real NOT NULL, --/F EMLINE_SEW_1RE 12 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_sew_1re_heii_4687 real NOT NULL, --/F EMLINE_SEW_1RE 13 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_sew_1re_hb_4862 real NOT NULL, --/F EMLINE_SEW_1RE 14 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_sew_1re_oiii_4960 real NOT NULL, --/F EMLINE_SEW_1RE 15 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_sew_1re_oiii_5008 real NOT NULL, --/F EMLINE_SEW_1RE 16 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_sew_1re_ni_5199 real NOT NULL, --/F EMLINE_SEW_1RE 17 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NI_5199.  
    emline_sew_1re_ni_5201 real NOT NULL, --/F EMLINE_SEW_1RE 18 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NI_5201.  
    emline_sew_1re_hei_5877 real NOT NULL, --/F EMLINE_SEW_1RE 19 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_sew_1re_oi_6302 real NOT NULL, --/F EMLINE_SEW_1RE 20 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_sew_1re_oi_6365 real NOT NULL, --/F EMLINE_SEW_1RE 21 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_sew_1re_nii_6549 real NOT NULL, --/F EMLINE_SEW_1RE 22 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_sew_1re_ha_6564 real NOT NULL, --/F EMLINE_SEW_1RE 23 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_sew_1re_nii_6585 real NOT NULL, --/F EMLINE_SEW_1RE 24 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_sew_1re_sii_6718 real NOT NULL, --/F EMLINE_SEW_1RE 25 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_sew_1re_sii_6732 real NOT NULL, --/F EMLINE_SEW_1RE 26 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_sew_1re_hei_7067 real NOT NULL, --/F EMLINE_SEW_1RE 27 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_7067.  
    emline_sew_1re_ariii_7137 real NOT NULL, --/F EMLINE_SEW_1RE 28 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7137.
    emline_sew_1re_ariii_7753 real NOT NULL, --/F EMLINE_SEW_1RE 29 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7753.
    emline_sew_1re_peta_9017 real NOT NULL, --/F EMLINE_SEW_1RE 30 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Peta_9017.  
    emline_sew_1re_siii_9071 real NOT NULL, --/F EMLINE_SEW_1RE 31 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SIII_9071.  
    emline_sew_1re_pzet_9231 real NOT NULL, --/F EMLINE_SEW_1RE 32 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Pzet_9231.  
    emline_sew_1re_siii_9533 real NOT NULL, --/F EMLINE_SEW_1RE 33 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SIII_9533.  
    emline_sew_1re_peps_9548 real NOT NULL, --/F EMLINE_SEW_1RE 34 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Peps_9548.  
    emline_sew_peak_oiid_3728 real NOT NULL, --/F EMLINE_SSB_PEAK 0 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OIId_3728.  
    emline_sew_peak_oii_3729 real NOT NULL, --/F EMLINE_SSB_PEAK 1 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OII_3729.  
    emline_sew_peak_h12_3751 real NOT NULL, --/F EMLINE_SSB_PEAK 2 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for H12_3751.  
    emline_sew_peak_h11_3771 real NOT NULL, --/F EMLINE_SSB_PEAK 3 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for H11_3771.  
    emline_sew_peak_hthe_3798 real NOT NULL, --/F EMLINE_SSB_PEAK 4 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Hthe_3798.  
    emline_sew_peak_heta_3836 real NOT NULL, --/F EMLINE_SSB_PEAK 5 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Heta_3836.  
    emline_sew_peak_neiii_3869 real NOT NULL, --/F EMLINE_SSB_PEAK 6 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NeIII_3869.
    emline_sew_peak_hei_3889 real NOT NULL, --/F EMLINE_SSB_PEAK 7 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for HeI_3889.  
    emline_sew_peak_hzet_3890 real NOT NULL, --/F EMLINE_SSB_PEAK 8 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Hzet_3890.  
    emline_sew_peak_neiii_3968 real NOT NULL, --/F EMLINE_SSB_PEAK 9 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NeIII_3968.
    emline_sew_peak_heps_3971 real NOT NULL, --/F EMLINE_SSB_PEAK 10 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Heps_3971.  
    emline_sew_peak_hdel_4102 real NOT NULL, --/F EMLINE_SSB_PEAK 11 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Hdel_4102.  
    emline_sew_peak_hgam_4341 real NOT NULL, --/F EMLINE_SSB_PEAK 12 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Hgam_4341.  
    emline_sew_peak_heii_4687 real NOT NULL, --/F EMLINE_SSB_PEAK 13 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for HeII_4687.  
    emline_sew_peak_hb_4862 real NOT NULL, --/F EMLINE_SSB_PEAK 14 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Hb_4862.  
    emline_sew_peak_oiii_4960 real NOT NULL, --/F EMLINE_SSB_PEAK 15 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OIII_4960.  
    emline_sew_peak_oiii_5008 real NOT NULL, --/F EMLINE_SSB_PEAK 16 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OIII_5008.  
    emline_sew_peak_ni_5199 real NOT NULL, --/F EMLINE_SSB_PEAK 17 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NI_5199.  
    emline_sew_peak_ni_5201 real NOT NULL, --/F EMLINE_SSB_PEAK 18 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NI_5201.  
    emline_sew_peak_hei_5877 real NOT NULL, --/F EMLINE_SSB_PEAK 19 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for HeI_5877.  
    emline_sew_peak_oi_6302 real NOT NULL, --/F EMLINE_SSB_PEAK 20 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OI_6302.  
    emline_sew_peak_oi_6365 real NOT NULL, --/F EMLINE_SSB_PEAK 21 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for OI_6365.  
    emline_sew_peak_nii_6549 real NOT NULL, --/F EMLINE_SSB_PEAK 22 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NII_6549.  
    emline_sew_peak_ha_6564 real NOT NULL, --/F EMLINE_SSB_PEAK 23 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Ha_6564.  
    emline_sew_peak_nii_6585 real NOT NULL, --/F EMLINE_SSB_PEAK 24 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for NII_6585.  
    emline_sew_peak_sii_6718 real NOT NULL, --/F EMLINE_SSB_PEAK 25 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for SII_6718.  
    emline_sew_peak_sii_6732 real NOT NULL, --/F EMLINE_SSB_PEAK 26 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for SII_6732.  
    emline_sew_peak_hei_7067 real NOT NULL, --/F EMLINE_SSB_PEAK 27 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for HeI_7067.  
    emline_sew_peak_ariii_7137 real NOT NULL, --/F EMLINE_SSB_PEAK 28 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for ArIII_7137.
    emline_sew_peak_ariii_7753 real NOT NULL, --/F EMLINE_SSB_PEAK 29 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for ArIII_7753.
    emline_sew_peak_peta_9017 real NOT NULL, --/F EMLINE_SSB_PEAK 30 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Peta_9017.  
    emline_sew_peak_siii_9071 real NOT NULL, --/F EMLINE_SSB_PEAK 31 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for SIII_9071.  
    emline_sew_peak_pzet_9231 real NOT NULL, --/F EMLINE_SSB_PEAK 32 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Pzet_9231.  
    emline_sew_peak_siii_9533 real NOT NULL, --/F EMLINE_SSB_PEAK 33 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for SIII_9533.  
    emline_sew_peak_peps_9548 real NOT NULL, --/F EMLINE_SSB_PEAK 34 --/U  --/D Peak summed-flux emission-line equivalent width.  Measurements specifically for Peps_9548.  
    emline_gflux_cen_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_CEN 0 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3727.  
    emline_gflux_cen_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_CEN 1 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3729.  
    emline_gflux_cen_h12_3751 real NOT NULL, --/F EMLINE_GFLUX_CEN 2 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for H12_3751.  
    emline_gflux_cen_h11_3771 real NOT NULL, --/F EMLINE_GFLUX_CEN 3 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for H11_3771.  
    emline_gflux_cen_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_CEN 4 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hthe_3798.  
    emline_gflux_cen_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_CEN 5 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heta_3836.  
    emline_gflux_cen_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_CEN 6 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3869.
    emline_gflux_cen_hei_3889 real NOT NULL, --/F EMLINE_GFLUX_CEN 7 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_3889.  
    emline_gflux_cen_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_CEN 8 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hzet_3890.  
    emline_gflux_cen_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_CEN 9 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3968.
    emline_gflux_cen_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_CEN 10 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heps_3971.  
    emline_gflux_cen_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_CEN 11 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hdel_4102.  
    emline_gflux_cen_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_CEN 12 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hgam_4341.  
    emline_gflux_cen_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_CEN 13 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeII_4687.  
    emline_gflux_cen_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_CEN 14 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hb_4862.  
    emline_gflux_cen_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_CEN 15 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_4960.  
    emline_gflux_cen_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_CEN 16 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_5008.  
    emline_gflux_cen_ni_5199 real NOT NULL, --/F EMLINE_GFLUX_CEN 17 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NI_5199.  
    emline_gflux_cen_ni_5201 real NOT NULL, --/F EMLINE_GFLUX_CEN 18 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NI_5201.  
    emline_gflux_cen_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_CEN 19 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_5877.  
    emline_gflux_cen_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_CEN 20 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6302.  
    emline_gflux_cen_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_CEN 21 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6365.  
    emline_gflux_cen_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_CEN 22 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6549.  
    emline_gflux_cen_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_CEN 23 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Ha_6564.  
    emline_gflux_cen_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_CEN 24 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6585.  
    emline_gflux_cen_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_CEN 25 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6718.  
    emline_gflux_cen_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_CEN 26 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6732.  
    emline_gflux_cen_hei_7067 real NOT NULL, --/F EMLINE_GFLUX_CEN 27 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_7067.  
    emline_gflux_cen_ariii_7137 real NOT NULL, --/F EMLINE_GFLUX_CEN 28 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for ArIII_7137.
    emline_gflux_cen_ariii_7753 real NOT NULL, --/F EMLINE_GFLUX_CEN 29 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for ArIII_7753.
    emline_gflux_cen_peta_9017 real NOT NULL, --/F EMLINE_GFLUX_CEN 30 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Peta_9017.  
    emline_gflux_cen_siii_9071 real NOT NULL, --/F EMLINE_GFLUX_CEN 31 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SIII_9071.  
    emline_gflux_cen_pzet_9231 real NOT NULL, --/F EMLINE_GFLUX_CEN 32 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Pzet_9231.  
    emline_gflux_cen_siii_9533 real NOT NULL, --/F EMLINE_GFLUX_CEN 33 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SIII_9533.  
    emline_gflux_cen_peps_9548 real NOT NULL, --/F EMLINE_GFLUX_CEN 34 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Peps_9548.  
    emline_gflux_1re_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_1RE 0 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3727.  
    emline_gflux_1re_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_1RE 1 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3729.  
    emline_gflux_1re_h12_3751 real NOT NULL, --/F EMLINE_GFLUX_1RE 2 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for H12_3751.  
    emline_gflux_1re_h11_3771 real NOT NULL, --/F EMLINE_GFLUX_1RE 3 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for H11_3771.  
    emline_gflux_1re_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_1RE 4 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hthe_3798.  
    emline_gflux_1re_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_1RE 5 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heta_3836.  
    emline_gflux_1re_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_1RE 6 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3869.
    emline_gflux_1re_hei_3889 real NOT NULL, --/F EMLINE_GFLUX_1RE 7 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_3889.  
    emline_gflux_1re_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_1RE 8 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hzet_3890.  
    emline_gflux_1re_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_1RE 9 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3968.
    emline_gflux_1re_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_1RE 10 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heps_3971.  
    emline_gflux_1re_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_1RE 11 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hdel_4102.  
    emline_gflux_1re_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_1RE 12 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hgam_4341.  
    emline_gflux_1re_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_1RE 13 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeII_4687.  
    emline_gflux_1re_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_1RE 14 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hb_4862.  
    emline_gflux_1re_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_1RE 15 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_4960.  
    emline_gflux_1re_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_1RE 16 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_5008.  
    emline_gflux_1re_ni_5199 real NOT NULL, --/F EMLINE_GFLUX_1RE 17 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NI_5199.  
    emline_gflux_1re_ni_5201 real NOT NULL, --/F EMLINE_GFLUX_1RE 18 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NI_5201.  
    emline_gflux_1re_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_1RE 19 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_5877.  
    emline_gflux_1re_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_1RE 20 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6302.  
    emline_gflux_1re_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_1RE 21 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6365.  
    emline_gflux_1re_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_1RE 22 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6549.  
    emline_gflux_1re_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_1RE 23 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Ha_6564.  
    emline_gflux_1re_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_1RE 24 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6585.  
    emline_gflux_1re_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_1RE 25 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6718.  
    emline_gflux_1re_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_1RE 26 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6732.  
    emline_gflux_1re_hei_7067 real NOT NULL, --/F EMLINE_GFLUX_1RE 27 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_7067.  
    emline_gflux_1re_ariii_7137 real NOT NULL, --/F EMLINE_GFLUX_1RE 28 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for ArIII_7137.
    emline_gflux_1re_ariii_7753 real NOT NULL, --/F EMLINE_GFLUX_1RE 29 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for ArIII_7753.
    emline_gflux_1re_peta_9017 real NOT NULL, --/F EMLINE_GFLUX_1RE 30 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Peta_9017.  
    emline_gflux_1re_siii_9071 real NOT NULL, --/F EMLINE_GFLUX_1RE 31 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SIII_9071.  
    emline_gflux_1re_pzet_9231 real NOT NULL, --/F EMLINE_GFLUX_1RE 32 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Pzet_9231.  
    emline_gflux_1re_siii_9533 real NOT NULL, --/F EMLINE_GFLUX_1RE 33 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SIII_9533.  
    emline_gflux_1re_peps_9548 real NOT NULL, --/F EMLINE_GFLUX_1RE 34 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Peps_9548.  
    emline_gflux_tot_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_TOT 0 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OII_3727.  
    emline_gflux_tot_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_TOT 1 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OII_3729.  
    emline_gflux_tot_h12_3751 real NOT NULL, --/F EMLINE_GFLUX_TOT 2 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for H12_3751.  
    emline_gflux_tot_h11_3771 real NOT NULL, --/F EMLINE_GFLUX_TOT 3 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for H11_3771.  
    emline_gflux_tot_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_TOT 4 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hthe_3798.  
    emline_gflux_tot_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_TOT 5 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Heta_3836.  
    emline_gflux_tot_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_TOT 6 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NeIII_3869.
    emline_gflux_tot_hei_3889 real NOT NULL, --/F EMLINE_GFLUX_TOT 7 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeI_3889.  
    emline_gflux_tot_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_TOT 8 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hzet_3890.  
    emline_gflux_tot_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_TOT 9 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NeIII_3968.
    emline_gflux_tot_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_TOT 10 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Heps_3971.  
    emline_gflux_tot_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_TOT 11 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hdel_4102.  
    emline_gflux_tot_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_TOT 12 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hgam_4341.  
    emline_gflux_tot_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_TOT 13 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeII_4687.  
    emline_gflux_tot_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_TOT 14 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hb_4862.  
    emline_gflux_tot_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_TOT 15 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OIII_4960.  
    emline_gflux_tot_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_TOT 16 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OIII_5008.  
    emline_gflux_tot_ni_5199 real NOT NULL, --/F EMLINE_GFLUX_TOT 17 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NI_5199.  
    emline_gflux_tot_ni_5201 real NOT NULL, --/F EMLINE_GFLUX_TOT 18 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NI_5201.  
    emline_gflux_tot_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_TOT 19 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeI_5877.  
    emline_gflux_tot_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_TOT 20 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OI_6302.  
    emline_gflux_tot_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_TOT 21 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OI_6365.  
    emline_gflux_tot_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_TOT 22 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NII_6549.  
    emline_gflux_tot_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_TOT 23 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Ha_6564.  
    emline_gflux_tot_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_TOT 24 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NII_6585.  
    emline_gflux_tot_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_TOT 25 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SII_6718.  
    emline_gflux_tot_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_TOT 26 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SII_6732.  
    emline_gflux_tot_hei_7067 real NOT NULL, --/F EMLINE_GFLUX_TOT 27 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeI_7067.  
    emline_gflux_tot_ariii_7137 real NOT NULL, --/F EMLINE_GFLUX_TOT 28 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for ArIII_7137.
    emline_gflux_tot_ariii_7753 real NOT NULL, --/F EMLINE_GFLUX_TOT 29 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for ArIII_7753.
    emline_gflux_tot_peta_9017 real NOT NULL, --/F EMLINE_GFLUX_TOT 30 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Peta_9017.  
    emline_gflux_tot_siii_9071 real NOT NULL, --/F EMLINE_GFLUX_TOT 31 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SIII_9071.  
    emline_gflux_tot_pzet_9231 real NOT NULL, --/F EMLINE_GFLUX_TOT 32 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Pzet_9231.  
    emline_gflux_tot_siii_9533 real NOT NULL, --/F EMLINE_GFLUX_TOT 33 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SIII_9533.  
    emline_gflux_tot_peps_9548 real NOT NULL, --/F EMLINE_GFLUX_TOT 34 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Peps_9548.  
    emline_gsb_1re_oii_3727 real NOT NULL, --/F EMLINE_GSB_1RE 0 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3727.  
    emline_gsb_1re_oii_3729 real NOT NULL, --/F EMLINE_GSB_1RE 1 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_gsb_1re_h12_3751 real NOT NULL, --/F EMLINE_GSB_1RE 2 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for H12_3751.  
    emline_gsb_1re_h11_3771 real NOT NULL, --/F EMLINE_GSB_1RE 3 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for H11_3771.  
    emline_gsb_1re_hthe_3798 real NOT NULL, --/F EMLINE_GSB_1RE 4 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_gsb_1re_heta_3836 real NOT NULL, --/F EMLINE_GSB_1RE 5 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_gsb_1re_neiii_3869 real NOT NULL, --/F EMLINE_GSB_1RE 6 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.
    emline_gsb_1re_hei_3889 real NOT NULL, --/F EMLINE_GSB_1RE 7 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_3889.  
    emline_gsb_1re_hzet_3890 real NOT NULL, --/F EMLINE_GSB_1RE 8 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_gsb_1re_neiii_3968 real NOT NULL, --/F EMLINE_GSB_1RE 9 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.
    emline_gsb_1re_heps_3971 real NOT NULL, --/F EMLINE_GSB_1RE 10 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_gsb_1re_hdel_4102 real NOT NULL, --/F EMLINE_GSB_1RE 11 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_gsb_1re_hgam_4341 real NOT NULL, --/F EMLINE_GSB_1RE 12 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_gsb_1re_heii_4687 real NOT NULL, --/F EMLINE_GSB_1RE 13 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_gsb_1re_hb_4862 real NOT NULL, --/F EMLINE_GSB_1RE 14 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_gsb_1re_oiii_4960 real NOT NULL, --/F EMLINE_GSB_1RE 15 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_gsb_1re_oiii_5008 real NOT NULL, --/F EMLINE_GSB_1RE 16 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_gsb_1re_ni_5199 real NOT NULL, --/F EMLINE_GSB_1RE 17 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NI_5199.  
    emline_gsb_1re_ni_5201 real NOT NULL, --/F EMLINE_GSB_1RE 18 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NI_5201.  
    emline_gsb_1re_hei_5877 real NOT NULL, --/F EMLINE_GSB_1RE 19 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_gsb_1re_oi_6302 real NOT NULL, --/F EMLINE_GSB_1RE 20 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_gsb_1re_oi_6365 real NOT NULL, --/F EMLINE_GSB_1RE 21 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_gsb_1re_nii_6549 real NOT NULL, --/F EMLINE_GSB_1RE 22 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_gsb_1re_ha_6564 real NOT NULL, --/F EMLINE_GSB_1RE 23 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_gsb_1re_nii_6585 real NOT NULL, --/F EMLINE_GSB_1RE 24 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_gsb_1re_sii_6718 real NOT NULL, --/F EMLINE_GSB_1RE 25 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_gsb_1re_sii_6732 real NOT NULL, --/F EMLINE_GSB_1RE 26 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_gsb_1re_hei_7067 real NOT NULL, --/F EMLINE_GSB_1RE 27 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_7067.  
    emline_gsb_1re_ariii_7137 real NOT NULL, --/F EMLINE_GSB_1RE 28 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7137.
    emline_gsb_1re_ariii_7753 real NOT NULL, --/F EMLINE_GSB_1RE 29 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7753.
    emline_gsb_1re_peta_9017 real NOT NULL, --/F EMLINE_GSB_1RE 30 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Peta_9017.  
    emline_gsb_1re_siii_9071 real NOT NULL, --/F EMLINE_GSB_1RE 31 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SIII_9071.  
    emline_gsb_1re_pzet_9231 real NOT NULL, --/F EMLINE_GSB_1RE 32 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Pzet_9231.  
    emline_gsb_1re_siii_9533 real NOT NULL, --/F EMLINE_GSB_1RE 33 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SIII_9533.  
    emline_gsb_1re_peps_9548 real NOT NULL, --/F EMLINE_GSB_1RE 34 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Peps_9548.  
    emline_gsb_peak_oii_3727 real NOT NULL, --/F EMLINE_GSB_PEAK 0 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OII_3727.  
    emline_gsb_peak_oii_3729 real NOT NULL, --/F EMLINE_GSB_PEAK 1 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OII_3729.  
    emline_gsb_peak_h12_3751 real NOT NULL, --/F EMLINE_GSB_PEAK 2 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for H12_3751.  
    emline_gsb_peak_h11_3771 real NOT NULL, --/F EMLINE_GSB_PEAK 3 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for H11_3771.  
    emline_gsb_peak_hthe_3798 real NOT NULL, --/F EMLINE_GSB_PEAK 4 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hthe_3798.  
    emline_gsb_peak_heta_3836 real NOT NULL, --/F EMLINE_GSB_PEAK 5 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Heta_3836.  
    emline_gsb_peak_neiii_3869 real NOT NULL, --/F EMLINE_GSB_PEAK 6 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NeIII_3869.
    emline_gsb_peak_hei_3889 real NOT NULL, --/F EMLINE_GSB_PEAK 7 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeI_3889.  
    emline_gsb_peak_hzet_3890 real NOT NULL, --/F EMLINE_GSB_PEAK 8 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hzet_3890.  
    emline_gsb_peak_neiii_3968 real NOT NULL, --/F EMLINE_GSB_PEAK 9 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NeIII_3968.
    emline_gsb_peak_heps_3971 real NOT NULL, --/F EMLINE_GSB_PEAK 10 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Heps_3971.  
    emline_gsb_peak_hdel_4102 real NOT NULL, --/F EMLINE_GSB_PEAK 11 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hdel_4102.  
    emline_gsb_peak_hgam_4341 real NOT NULL, --/F EMLINE_GSB_PEAK 12 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hgam_4341.  
    emline_gsb_peak_heii_4687 real NOT NULL, --/F EMLINE_GSB_PEAK 13 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeII_4687.  
    emline_gsb_peak_hb_4862 real NOT NULL, --/F EMLINE_GSB_PEAK 14 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hb_4862.  
    emline_gsb_peak_oiii_4960 real NOT NULL, --/F EMLINE_GSB_PEAK 15 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OIII_4960.  
    emline_gsb_peak_oiii_5008 real NOT NULL, --/F EMLINE_GSB_PEAK 16 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OIII_5008.  
    emline_gsb_peak_ni_5199 real NOT NULL, --/F EMLINE_GSB_PEAK 17 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NI_5199.  
    emline_gsb_peak_ni_5201 real NOT NULL, --/F EMLINE_GSB_PEAK 18 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NI_5201.  
    emline_gsb_peak_hei_5877 real NOT NULL, --/F EMLINE_GSB_PEAK 19 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeI_5877.  
    emline_gsb_peak_oi_6302 real NOT NULL, --/F EMLINE_GSB_PEAK 20 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OI_6302.  
    emline_gsb_peak_oi_6365 real NOT NULL, --/F EMLINE_GSB_PEAK 21 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OI_6365.  
    emline_gsb_peak_nii_6549 real NOT NULL, --/F EMLINE_GSB_PEAK 22 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NII_6549.  
    emline_gsb_peak_ha_6564 real NOT NULL, --/F EMLINE_GSB_PEAK 23 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Ha_6564.  
    emline_gsb_peak_nii_6585 real NOT NULL, --/F EMLINE_GSB_PEAK 24 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NII_6585.  
    emline_gsb_peak_sii_6718 real NOT NULL, --/F EMLINE_GSB_PEAK 25 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SII_6718.  
    emline_gsb_peak_sii_6732 real NOT NULL, --/F EMLINE_GSB_PEAK 26 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SII_6732.  
    emline_gsb_peak_hei_7067 real NOT NULL, --/F EMLINE_GSB_PEAK 27 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeI_7067.  
    emline_gsb_peak_ariii_7137 real NOT NULL, --/F EMLINE_GSB_PEAK 28 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for ArIII_7137.
    emline_gsb_peak_ariii_7753 real NOT NULL, --/F EMLINE_GSB_PEAK 29 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for ArIII_7753.
    emline_gsb_peak_peta_9017 real NOT NULL, --/F EMLINE_GSB_PEAK 30 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Peta_9017.  
    emline_gsb_peak_siii_9071 real NOT NULL, --/F EMLINE_GSB_PEAK 31 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SIII_9071.  
    emline_gsb_peak_pzet_9231 real NOT NULL, --/F EMLINE_GSB_PEAK 32 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Pzet_9231.  
    emline_gsb_peak_siii_9533 real NOT NULL, --/F EMLINE_GSB_PEAK 33 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SIII_9533.  
    emline_gsb_peak_peps_9548 real NOT NULL, --/F EMLINE_GSB_PEAK 34 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Peps_9548.  
    emline_gew_1re_oii_3727 real NOT NULL, --/F EMLINE_GEW_1RE 0 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3727.  
    emline_gew_1re_oii_3729 real NOT NULL, --/F EMLINE_GEW_1RE 1 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_gew_1re_h12_3751 real NOT NULL, --/F EMLINE_GEW_1RE 2 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for H12_3751.  
    emline_gew_1re_h11_3771 real NOT NULL, --/F EMLINE_GEW_1RE 3 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for H11_3771.  
    emline_gew_1re_hthe_3798 real NOT NULL, --/F EMLINE_GEW_1RE 4 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_gew_1re_heta_3836 real NOT NULL, --/F EMLINE_GEW_1RE 5 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_gew_1re_neiii_3869 real NOT NULL, --/F EMLINE_GEW_1RE 6 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.
    emline_gew_1re_hei_3889 real NOT NULL, --/F EMLINE_GEW_1RE 7 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_3889.  
    emline_gew_1re_hzet_3890 real NOT NULL, --/F EMLINE_GEW_1RE 8 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_gew_1re_neiii_3968 real NOT NULL, --/F EMLINE_GEW_1RE 9 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.
    emline_gew_1re_heps_3971 real NOT NULL, --/F EMLINE_GEW_1RE 10 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_gew_1re_hdel_4102 real NOT NULL, --/F EMLINE_GEW_1RE 11 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_gew_1re_hgam_4341 real NOT NULL, --/F EMLINE_GEW_1RE 12 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_gew_1re_heii_4687 real NOT NULL, --/F EMLINE_GEW_1RE 13 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_gew_1re_hb_4862 real NOT NULL, --/F EMLINE_GEW_1RE 14 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_gew_1re_oiii_4960 real NOT NULL, --/F EMLINE_GEW_1RE 15 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_gew_1re_oiii_5008 real NOT NULL, --/F EMLINE_GEW_1RE 16 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_gew_1re_ni_5199 real NOT NULL, --/F EMLINE_GEW_1RE 17 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NI_5199.  
    emline_gew_1re_ni_5201 real NOT NULL, --/F EMLINE_GEW_1RE 18 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NI_5201.  
    emline_gew_1re_hei_5877 real NOT NULL, --/F EMLINE_GEW_1RE 19 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_gew_1re_oi_6302 real NOT NULL, --/F EMLINE_GEW_1RE 20 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_gew_1re_oi_6365 real NOT NULL, --/F EMLINE_GEW_1RE 21 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_gew_1re_nii_6549 real NOT NULL, --/F EMLINE_GEW_1RE 22 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_gew_1re_ha_6564 real NOT NULL, --/F EMLINE_GEW_1RE 23 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_gew_1re_nii_6585 real NOT NULL, --/F EMLINE_GEW_1RE 24 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_gew_1re_sii_6718 real NOT NULL, --/F EMLINE_GEW_1RE 25 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_gew_1re_sii_6732 real NOT NULL, --/F EMLINE_GEW_1RE 26 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_gew_1re_hei_7067 real NOT NULL, --/F EMLINE_GEW_1RE 27 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_7067.  
    emline_gew_1re_ariii_7137 real NOT NULL, --/F EMLINE_GEW_1RE 28 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7137.
    emline_gew_1re_ariii_7753 real NOT NULL, --/F EMLINE_GEW_1RE 29 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for ArIII_7753.
    emline_gew_1re_peta_9017 real NOT NULL, --/F EMLINE_GEW_1RE 30 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Peta_9017.  
    emline_gew_1re_siii_9071 real NOT NULL, --/F EMLINE_GEW_1RE 31 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SIII_9071.  
    emline_gew_1re_pzet_9231 real NOT NULL, --/F EMLINE_GEW_1RE 32 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Pzet_9231.  
    emline_gew_1re_siii_9533 real NOT NULL, --/F EMLINE_GEW_1RE 33 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SIII_9533.  
    emline_gew_1re_peps_9548 real NOT NULL, --/F EMLINE_GEW_1RE 34 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Peps_9548.  
    emline_gew_peak_oii_3727 real NOT NULL, --/F EMLINE_GEW_PEAK 0 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OII_3727.  
    emline_gew_peak_oii_3729 real NOT NULL, --/F EMLINE_GEW_PEAK 1 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OII_3729.  
    emline_gew_peak_h12_3751 real NOT NULL, --/F EMLINE_GEW_PEAK 2 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for H12_3751.  
    emline_gew_peak_h11_3771 real NOT NULL, --/F EMLINE_GEW_PEAK 3 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for H11_3771.  
    emline_gew_peak_hthe_3798 real NOT NULL, --/F EMLINE_GEW_PEAK 4 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Hthe_3798.  
    emline_gew_peak_heta_3836 real NOT NULL, --/F EMLINE_GEW_PEAK 5 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Heta_3836.  
    emline_gew_peak_neiii_3869 real NOT NULL, --/F EMLINE_GEW_PEAK 6 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NeIII_3869.
    emline_gew_peak_hei_3889 real NOT NULL, --/F EMLINE_GEW_PEAK 7 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for HeI_3889.  
    emline_gew_peak_hzet_3890 real NOT NULL, --/F EMLINE_GEW_PEAK 8 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Hzet_3890.  
    emline_gew_peak_neiii_3968 real NOT NULL, --/F EMLINE_GEW_PEAK 9 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NeIII_3968.
    emline_gew_peak_heps_3971 real NOT NULL, --/F EMLINE_GEW_PEAK 10 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Heps_3971.  
    emline_gew_peak_hdel_4102 real NOT NULL, --/F EMLINE_GEW_PEAK 11 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Hdel_4102.  
    emline_gew_peak_hgam_4341 real NOT NULL, --/F EMLINE_GEW_PEAK 12 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Hgam_4341.  
    emline_gew_peak_heii_4687 real NOT NULL, --/F EMLINE_GEW_PEAK 13 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for HeII_4687.  
    emline_gew_peak_hb_4862 real NOT NULL, --/F EMLINE_GEW_PEAK 14 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Hb_4862.  
    emline_gew_peak_oiii_4960 real NOT NULL, --/F EMLINE_GEW_PEAK 15 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OIII_4960.  
    emline_gew_peak_oiii_5008 real NOT NULL, --/F EMLINE_GEW_PEAK 16 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OIII_5008.  
    emline_gew_peak_ni_5199 real NOT NULL, --/F EMLINE_GEW_PEAK 17 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NI_5199.  
    emline_gew_peak_ni_5201 real NOT NULL, --/F EMLINE_GEW_PEAK 18 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NI_5201.  
    emline_gew_peak_hei_5877 real NOT NULL, --/F EMLINE_GEW_PEAK 19 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for HeI_5877.  
    emline_gew_peak_oi_6302 real NOT NULL, --/F EMLINE_GEW_PEAK 20 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OI_6302.  
    emline_gew_peak_oi_6365 real NOT NULL, --/F EMLINE_GEW_PEAK 21 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for OI_6365.  
    emline_gew_peak_nii_6549 real NOT NULL, --/F EMLINE_GEW_PEAK 22 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NII_6549.  
    emline_gew_peak_ha_6564 real NOT NULL, --/F EMLINE_GEW_PEAK 23 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Ha_6564.  
    emline_gew_peak_nii_6585 real NOT NULL, --/F EMLINE_GEW_PEAK 24 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for NII_6585.  
    emline_gew_peak_sii_6718 real NOT NULL, --/F EMLINE_GEW_PEAK 25 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for SII_6718.  
    emline_gew_peak_sii_6732 real NOT NULL, --/F EMLINE_GEW_PEAK 26 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for SII_6732.  
    emline_gew_peak_hei_7067 real NOT NULL, --/F EMLINE_GEW_PEAK 27 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for HeI_7067.  
    emline_gew_peak_ariii_7137 real NOT NULL, --/F EMLINE_GEW_PEAK 28 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for ArIII_7137.
    emline_gew_peak_ariii_7753 real NOT NULL, --/F EMLINE_GEW_PEAK 29 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for ArIII_7753.
    emline_gew_peak_peta_9017 real NOT NULL, --/F EMLINE_GEW_PEAK 30 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Peta_9017.  
    emline_gew_peak_siii_9071 real NOT NULL, --/F EMLINE_GEW_PEAK 31 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for SIII_9071.  
    emline_gew_peak_pzet_9231 real NOT NULL, --/F EMLINE_GEW_PEAK 32 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Pzet_9231.  
    emline_gew_peak_siii_9533 real NOT NULL, --/F EMLINE_GEW_PEAK 33 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for SIII_9533.  
    emline_gew_peak_peps_9548 real NOT NULL, --/F EMLINE_GEW_PEAK 34 --/U  --/D Peak Gaussian-fitted emission-line equivalent width.  Measurements specifically for Peps_9548.  
    specindex_lo_cn1 real NOT NULL, --/F SPECINDEX_LO 0 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CN1.  
    specindex_lo_cn2 real NOT NULL, --/F SPECINDEX_LO 1 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CN2.  
    specindex_lo_ca4227 real NOT NULL, --/F SPECINDEX_LO 2 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Ca4227.  
    specindex_lo_g4300 real NOT NULL, --/F SPECINDEX_LO 3 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for G4300.  
    specindex_lo_fe4383 real NOT NULL, --/F SPECINDEX_LO 4 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe4383.  
    specindex_lo_ca4455 real NOT NULL, --/F SPECINDEX_LO 5 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Ca4455.  
    specindex_lo_fe4531 real NOT NULL, --/F SPECINDEX_LO 6 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe4531.  
    specindex_lo_c24668 real NOT NULL, --/F SPECINDEX_LO 7 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for C24668.  
    specindex_lo_hb real NOT NULL, --/F SPECINDEX_LO 8 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Hb.  
    specindex_lo_fe5015 real NOT NULL, --/F SPECINDEX_LO 9 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5015.  
    specindex_lo_mg1 real NOT NULL, --/F SPECINDEX_LO 10 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mg1.  
    specindex_lo_mg2 real NOT NULL, --/F SPECINDEX_LO 11 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mg2.  
    specindex_lo_mgb real NOT NULL, --/F SPECINDEX_LO 12 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mgb.  
    specindex_lo_fe5270 real NOT NULL, --/F SPECINDEX_LO 13 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5270.  
    specindex_lo_fe5335 real NOT NULL, --/F SPECINDEX_LO 14 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5335.  
    specindex_lo_fe5406 real NOT NULL, --/F SPECINDEX_LO 15 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5406.  
    specindex_lo_fe5709 real NOT NULL, --/F SPECINDEX_LO 16 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5709.  
    specindex_lo_fe5782 real NOT NULL, --/F SPECINDEX_LO 17 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5782.  
    specindex_lo_nad real NOT NULL, --/F SPECINDEX_LO 18 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaD.  
    specindex_lo_tio1 real NOT NULL, --/F SPECINDEX_LO 19 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO1.  
    specindex_lo_tio2 real NOT NULL, --/F SPECINDEX_LO 20 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO2.  
    specindex_lo_hdeltaa real NOT NULL, --/F SPECINDEX_LO 21 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HDeltaA.  
    specindex_lo_hgammaa real NOT NULL, --/F SPECINDEX_LO 22 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HGammaA.  
    specindex_lo_hdeltaf real NOT NULL, --/F SPECINDEX_LO 23 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HDeltaF.  
    specindex_lo_hgammaf real NOT NULL, --/F SPECINDEX_LO 24 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HGammaF.  
    specindex_lo_cahk real NOT NULL, --/F SPECINDEX_LO 25 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaHK.  
    specindex_lo_caii1 real NOT NULL, --/F SPECINDEX_LO 26 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII1.  
    specindex_lo_caii2 real NOT NULL, --/F SPECINDEX_LO 27 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII2.  
    specindex_lo_caii3 real NOT NULL, --/F SPECINDEX_LO 28 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII3.  
    specindex_lo_pa17 real NOT NULL, --/F SPECINDEX_LO 29 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa17.  
    specindex_lo_pa14 real NOT NULL, --/F SPECINDEX_LO 30 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa14.  
    specindex_lo_pa12 real NOT NULL, --/F SPECINDEX_LO 31 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa12.  
    specindex_lo_mgicvd real NOT NULL, --/F SPECINDEX_LO 32 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for MgICvD.  
    specindex_lo_naicvd real NOT NULL, --/F SPECINDEX_LO 33 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaICvD.  
    specindex_lo_mgiir real NOT NULL, --/F SPECINDEX_LO 34 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for MgIIR.  
    specindex_lo_fehcvd real NOT NULL, --/F SPECINDEX_LO 35 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for FeHCvD.  
    specindex_lo_nai real NOT NULL, --/F SPECINDEX_LO 36 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaI.  
    specindex_lo_btio real NOT NULL, --/F SPECINDEX_LO 37 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for bTiO.  
    specindex_lo_atio real NOT NULL, --/F SPECINDEX_LO 38 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for aTiO.  
    specindex_lo_cah1 real NOT NULL, --/F SPECINDEX_LO 39 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaH1.  
    specindex_lo_cah2 real NOT NULL, --/F SPECINDEX_LO 40 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaH2.  
    specindex_lo_naisdss real NOT NULL, --/F SPECINDEX_LO 41 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaISDSS.  
    specindex_lo_tio2sdss real NOT NULL, --/F SPECINDEX_LO 42 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO2SDSS.  
    specindex_lo_d4000 real NOT NULL, --/F SPECINDEX_LO 43 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for D4000.  
    specindex_lo_dn4000 real NOT NULL, --/F SPECINDEX_LO 44 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Dn4000.  
    specindex_lo_tiocvd real NOT NULL, --/F SPECINDEX_LO 45 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiOCvD.  
    specindex_hi_cn1 real NOT NULL, --/F SPECINDEX_HI 0 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CN1.  
    specindex_hi_cn2 real NOT NULL, --/F SPECINDEX_HI 1 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CN2.  
    specindex_hi_ca4227 real NOT NULL, --/F SPECINDEX_HI 2 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Ca4227.  
    specindex_hi_g4300 real NOT NULL, --/F SPECINDEX_HI 3 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for G4300.  
    specindex_hi_fe4383 real NOT NULL, --/F SPECINDEX_HI 4 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe4383.  
    specindex_hi_ca4455 real NOT NULL, --/F SPECINDEX_HI 5 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Ca4455.  
    specindex_hi_fe4531 real NOT NULL, --/F SPECINDEX_HI 6 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe4531.  
    specindex_hi_c24668 real NOT NULL, --/F SPECINDEX_HI 7 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for C24668.  
    specindex_hi_hb real NOT NULL, --/F SPECINDEX_HI 8 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Hb.  
    specindex_hi_fe5015 real NOT NULL, --/F SPECINDEX_HI 9 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5015.  
    specindex_hi_mg1 real NOT NULL, --/F SPECINDEX_HI 10 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mg1.  
    specindex_hi_mg2 real NOT NULL, --/F SPECINDEX_HI 11 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mg2.  
    specindex_hi_mgb real NOT NULL, --/F SPECINDEX_HI 12 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mgb.  
    specindex_hi_fe5270 real NOT NULL, --/F SPECINDEX_HI 13 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5270.  
    specindex_hi_fe5335 real NOT NULL, --/F SPECINDEX_HI 14 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5335.  
    specindex_hi_fe5406 real NOT NULL, --/F SPECINDEX_HI 15 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5406.  
    specindex_hi_fe5709 real NOT NULL, --/F SPECINDEX_HI 16 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5709.  
    specindex_hi_fe5782 real NOT NULL, --/F SPECINDEX_HI 17 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5782.  
    specindex_hi_nad real NOT NULL, --/F SPECINDEX_HI 18 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaD.  
    specindex_hi_tio1 real NOT NULL, --/F SPECINDEX_HI 19 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO1.  
    specindex_hi_tio2 real NOT NULL, --/F SPECINDEX_HI 20 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO2.  
    specindex_hi_hdeltaa real NOT NULL, --/F SPECINDEX_HI 21 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HDeltaA.  
    specindex_hi_hgammaa real NOT NULL, --/F SPECINDEX_HI 22 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HGammaA.  
    specindex_hi_hdeltaf real NOT NULL, --/F SPECINDEX_HI 23 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HDeltaF.  
    specindex_hi_hgammaf real NOT NULL, --/F SPECINDEX_HI 24 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HGammaF.  
    specindex_hi_cahk real NOT NULL, --/F SPECINDEX_HI 25 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaHK.  
    specindex_hi_caii1 real NOT NULL, --/F SPECINDEX_HI 26 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII1.  
    specindex_hi_caii2 real NOT NULL, --/F SPECINDEX_HI 27 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII2.  
    specindex_hi_caii3 real NOT NULL, --/F SPECINDEX_HI 28 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII3.  
    specindex_hi_pa17 real NOT NULL, --/F SPECINDEX_HI 29 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa17.  
    specindex_hi_pa14 real NOT NULL, --/F SPECINDEX_HI 30 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa14.  
    specindex_hi_pa12 real NOT NULL, --/F SPECINDEX_HI 31 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa12.  
    specindex_hi_mgicvd real NOT NULL, --/F SPECINDEX_HI 32 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for MgICvD.  
    specindex_hi_naicvd real NOT NULL, --/F SPECINDEX_HI 33 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaICvD.  
    specindex_hi_mgiir real NOT NULL, --/F SPECINDEX_HI 34 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for MgIIR.  
    specindex_hi_fehcvd real NOT NULL, --/F SPECINDEX_HI 35 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for FeHCvD.  
    specindex_hi_nai real NOT NULL, --/F SPECINDEX_HI 36 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaI.  
    specindex_hi_btio real NOT NULL, --/F SPECINDEX_HI 37 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for bTiO.  
    specindex_hi_atio real NOT NULL, --/F SPECINDEX_HI 38 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for aTiO.  
    specindex_hi_cah1 real NOT NULL, --/F SPECINDEX_HI 39 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaH1.  
    specindex_hi_cah2 real NOT NULL, --/F SPECINDEX_HI 40 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaH2.  
    specindex_hi_naisdss real NOT NULL, --/F SPECINDEX_HI 41 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaISDSS.  
    specindex_hi_tio2sdss real NOT NULL, --/F SPECINDEX_HI 42 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO2SDSS.  
    specindex_hi_d4000 real NOT NULL, --/F SPECINDEX_HI 43 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for D4000.  
    specindex_hi_dn4000 real NOT NULL, --/F SPECINDEX_HI 44 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Dn4000.  
    specindex_hi_tiocvd real NOT NULL, --/F SPECINDEX_HI 45 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiOCvD.  
    specindex_lo_clip_cn1 real NOT NULL, --/F SPECINDEX_LO_CLIP 0 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN1.  
    specindex_lo_clip_cn2 real NOT NULL, --/F SPECINDEX_LO_CLIP 1 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN2.  
    specindex_lo_clip_ca4227 real NOT NULL, --/F SPECINDEX_LO_CLIP 2 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4227.  
    specindex_lo_clip_g4300 real NOT NULL, --/F SPECINDEX_LO_CLIP 3 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for G4300.  
    specindex_lo_clip_fe4383 real NOT NULL, --/F SPECINDEX_LO_CLIP 4 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4383.  
    specindex_lo_clip_ca4455 real NOT NULL, --/F SPECINDEX_LO_CLIP 5 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4455.  
    specindex_lo_clip_fe4531 real NOT NULL, --/F SPECINDEX_LO_CLIP 6 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4531.  
    specindex_lo_clip_c24668 real NOT NULL, --/F SPECINDEX_LO_CLIP 7 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for C24668.  
    specindex_lo_clip_hb real NOT NULL, --/F SPECINDEX_LO_CLIP 8 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Hb.  
    specindex_lo_clip_fe5015 real NOT NULL, --/F SPECINDEX_LO_CLIP 9 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5015.  
    specindex_lo_clip_mg1 real NOT NULL, --/F SPECINDEX_LO_CLIP 10 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg1.  
    specindex_lo_clip_mg2 real NOT NULL, --/F SPECINDEX_LO_CLIP 11 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg2.  
    specindex_lo_clip_mgb real NOT NULL, --/F SPECINDEX_LO_CLIP 12 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mgb.  
    specindex_lo_clip_fe5270 real NOT NULL, --/F SPECINDEX_LO_CLIP 13 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5270.  
    specindex_lo_clip_fe5335 real NOT NULL, --/F SPECINDEX_LO_CLIP 14 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5335.  
    specindex_lo_clip_fe5406 real NOT NULL, --/F SPECINDEX_LO_CLIP 15 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5406.  
    specindex_lo_clip_fe5709 real NOT NULL, --/F SPECINDEX_LO_CLIP 16 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5709.  
    specindex_lo_clip_fe5782 real NOT NULL, --/F SPECINDEX_LO_CLIP 17 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5782.  
    specindex_lo_clip_nad real NOT NULL, --/F SPECINDEX_LO_CLIP 18 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaD.  
    specindex_lo_clip_tio1 real NOT NULL, --/F SPECINDEX_LO_CLIP 19 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO1.  
    specindex_lo_clip_tio2 real NOT NULL, --/F SPECINDEX_LO_CLIP 20 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2.  
    specindex_lo_clip_hdeltaa real NOT NULL, --/F SPECINDEX_LO_CLIP 21 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaA.  
    specindex_lo_clip_hgammaa real NOT NULL, --/F SPECINDEX_LO_CLIP 22 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaA.  
    specindex_lo_clip_hdeltaf real NOT NULL, --/F SPECINDEX_LO_CLIP 23 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaF.  
    specindex_lo_clip_hgammaf real NOT NULL, --/F SPECINDEX_LO_CLIP 24 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaF.  
    specindex_lo_clip_cahk real NOT NULL, --/F SPECINDEX_LO_CLIP 25 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaHK.  
    specindex_lo_clip_caii1 real NOT NULL, --/F SPECINDEX_LO_CLIP 26 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII1.  
    specindex_lo_clip_caii2 real NOT NULL, --/F SPECINDEX_LO_CLIP 27 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII2.  
    specindex_lo_clip_caii3 real NOT NULL, --/F SPECINDEX_LO_CLIP 28 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII3.  
    specindex_lo_clip_pa17 real NOT NULL, --/F SPECINDEX_LO_CLIP 29 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa17.  
    specindex_lo_clip_pa14 real NOT NULL, --/F SPECINDEX_LO_CLIP 30 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa14.  
    specindex_lo_clip_pa12 real NOT NULL, --/F SPECINDEX_LO_CLIP 31 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa12.  
    specindex_lo_clip_mgicvd real NOT NULL, --/F SPECINDEX_LO_CLIP 32 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgICvD.  
    specindex_lo_clip_naicvd real NOT NULL, --/F SPECINDEX_LO_CLIP 33 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaICvD.  
    specindex_lo_clip_mgiir real NOT NULL, --/F SPECINDEX_LO_CLIP 34 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgIIR.  
    specindex_lo_clip_fehcvd real NOT NULL, --/F SPECINDEX_LO_CLIP 35 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for FeHCvD.  
    specindex_lo_clip_nai real NOT NULL, --/F SPECINDEX_LO_CLIP 36 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaI.  
    specindex_lo_clip_btio real NOT NULL, --/F SPECINDEX_LO_CLIP 37 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for bTiO.  
    specindex_lo_clip_atio real NOT NULL, --/F SPECINDEX_LO_CLIP 38 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for aTiO.  
    specindex_lo_clip_cah1 real NOT NULL, --/F SPECINDEX_LO_CLIP 39 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH1.  
    specindex_lo_clip_cah2 real NOT NULL, --/F SPECINDEX_LO_CLIP 40 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH2.  
    specindex_lo_clip_naisdss real NOT NULL, --/F SPECINDEX_LO_CLIP 41 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaISDSS.  
    specindex_lo_clip_tio2sdss real NOT NULL, --/F SPECINDEX_LO_CLIP 42 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2SDSS.  
    specindex_lo_clip_d4000 real NOT NULL, --/F SPECINDEX_LO_CLIP 43 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for D4000.  
    specindex_lo_clip_dn4000 real NOT NULL, --/F SPECINDEX_LO_CLIP 44 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Dn4000.  
    specindex_lo_clip_tiocvd real NOT NULL, --/F SPECINDEX_LO_CLIP 45 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiOCvD.  
    specindex_hi_clip_cn1 real NOT NULL, --/F SPECINDEX_HI_CLIP 0 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN1.  
    specindex_hi_clip_cn2 real NOT NULL, --/F SPECINDEX_HI_CLIP 1 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN2.  
    specindex_hi_clip_ca4227 real NOT NULL, --/F SPECINDEX_HI_CLIP 2 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4227.  
    specindex_hi_clip_g4300 real NOT NULL, --/F SPECINDEX_HI_CLIP 3 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for G4300.  
    specindex_hi_clip_fe4383 real NOT NULL, --/F SPECINDEX_HI_CLIP 4 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4383.  
    specindex_hi_clip_ca4455 real NOT NULL, --/F SPECINDEX_HI_CLIP 5 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4455.  
    specindex_hi_clip_fe4531 real NOT NULL, --/F SPECINDEX_HI_CLIP 6 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4531.  
    specindex_hi_clip_c24668 real NOT NULL, --/F SPECINDEX_HI_CLIP 7 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for C24668.  
    specindex_hi_clip_hb real NOT NULL, --/F SPECINDEX_HI_CLIP 8 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Hb.  
    specindex_hi_clip_fe5015 real NOT NULL, --/F SPECINDEX_HI_CLIP 9 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5015.  
    specindex_hi_clip_mg1 real NOT NULL, --/F SPECINDEX_HI_CLIP 10 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg1.  
    specindex_hi_clip_mg2 real NOT NULL, --/F SPECINDEX_HI_CLIP 11 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg2.  
    specindex_hi_clip_mgb real NOT NULL, --/F SPECINDEX_HI_CLIP 12 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mgb.  
    specindex_hi_clip_fe5270 real NOT NULL, --/F SPECINDEX_HI_CLIP 13 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5270.  
    specindex_hi_clip_fe5335 real NOT NULL, --/F SPECINDEX_HI_CLIP 14 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5335.  
    specindex_hi_clip_fe5406 real NOT NULL, --/F SPECINDEX_HI_CLIP 15 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5406.  
    specindex_hi_clip_fe5709 real NOT NULL, --/F SPECINDEX_HI_CLIP 16 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5709.  
    specindex_hi_clip_fe5782 real NOT NULL, --/F SPECINDEX_HI_CLIP 17 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5782.  
    specindex_hi_clip_nad real NOT NULL, --/F SPECINDEX_HI_CLIP 18 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaD.  
    specindex_hi_clip_tio1 real NOT NULL, --/F SPECINDEX_HI_CLIP 19 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO1.  
    specindex_hi_clip_tio2 real NOT NULL, --/F SPECINDEX_HI_CLIP 20 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2.  
    specindex_hi_clip_hdeltaa real NOT NULL, --/F SPECINDEX_HI_CLIP 21 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaA.  
    specindex_hi_clip_hgammaa real NOT NULL, --/F SPECINDEX_HI_CLIP 22 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaA.  
    specindex_hi_clip_hdeltaf real NOT NULL, --/F SPECINDEX_HI_CLIP 23 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaF.  
    specindex_hi_clip_hgammaf real NOT NULL, --/F SPECINDEX_HI_CLIP 24 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaF.  
    specindex_hi_clip_cahk real NOT NULL, --/F SPECINDEX_HI_CLIP 25 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaHK.  
    specindex_hi_clip_caii1 real NOT NULL, --/F SPECINDEX_HI_CLIP 26 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII1.  
    specindex_hi_clip_caii2 real NOT NULL, --/F SPECINDEX_HI_CLIP 27 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII2.  
    specindex_hi_clip_caii3 real NOT NULL, --/F SPECINDEX_HI_CLIP 28 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII3.  
    specindex_hi_clip_pa17 real NOT NULL, --/F SPECINDEX_HI_CLIP 29 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa17.  
    specindex_hi_clip_pa14 real NOT NULL, --/F SPECINDEX_HI_CLIP 30 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa14.  
    specindex_hi_clip_pa12 real NOT NULL, --/F SPECINDEX_HI_CLIP 31 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa12.  
    specindex_hi_clip_mgicvd real NOT NULL, --/F SPECINDEX_HI_CLIP 32 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgICvD.  
    specindex_hi_clip_naicvd real NOT NULL, --/F SPECINDEX_HI_CLIP 33 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaICvD.  
    specindex_hi_clip_mgiir real NOT NULL, --/F SPECINDEX_HI_CLIP 34 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgIIR.  
    specindex_hi_clip_fehcvd real NOT NULL, --/F SPECINDEX_HI_CLIP 35 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for FeHCvD.  
    specindex_hi_clip_nai real NOT NULL, --/F SPECINDEX_HI_CLIP 36 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaI.  
    specindex_hi_clip_btio real NOT NULL, --/F SPECINDEX_HI_CLIP 37 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for bTiO.  
    specindex_hi_clip_atio real NOT NULL, --/F SPECINDEX_HI_CLIP 38 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for aTiO.  
    specindex_hi_clip_cah1 real NOT NULL, --/F SPECINDEX_HI_CLIP 39 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH1.  
    specindex_hi_clip_cah2 real NOT NULL, --/F SPECINDEX_HI_CLIP 40 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH2.  
    specindex_hi_clip_naisdss real NOT NULL, --/F SPECINDEX_HI_CLIP 41 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaISDSS.  
    specindex_hi_clip_tio2sdss real NOT NULL, --/F SPECINDEX_HI_CLIP 42 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2SDSS.  
    specindex_hi_clip_d4000 real NOT NULL, --/F SPECINDEX_HI_CLIP 43 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for D4000.  
    specindex_hi_clip_dn4000 real NOT NULL, --/F SPECINDEX_HI_CLIP 44 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Dn4000.  
    specindex_hi_clip_tiocvd real NOT NULL, --/F SPECINDEX_HI_CLIP 45 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiOCvD.  
    specindex_1re_cn1 real NOT NULL, --/F SPECINDEX_1RE 0 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CN1.  
    specindex_1re_cn2 real NOT NULL, --/F SPECINDEX_1RE 1 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CN2.  
    specindex_1re_ca4227 real NOT NULL, --/F SPECINDEX_1RE 2 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Ca4227.  
    specindex_1re_g4300 real NOT NULL, --/F SPECINDEX_1RE 3 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for G4300.  
    specindex_1re_fe4383 real NOT NULL, --/F SPECINDEX_1RE 4 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe4383.  
    specindex_1re_ca4455 real NOT NULL, --/F SPECINDEX_1RE 5 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Ca4455.  
    specindex_1re_fe4531 real NOT NULL, --/F SPECINDEX_1RE 6 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe4531.  
    specindex_1re_c24668 real NOT NULL, --/F SPECINDEX_1RE 7 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for C24668.  
    specindex_1re_hb real NOT NULL, --/F SPECINDEX_1RE 8 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Hb.  
    specindex_1re_fe5015 real NOT NULL, --/F SPECINDEX_1RE 9 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5015.  
    specindex_1re_mg1 real NOT NULL, --/F SPECINDEX_1RE 10 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for Mg1.  
    specindex_1re_mg2 real NOT NULL, --/F SPECINDEX_1RE 11 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for Mg2.  
    specindex_1re_mgb real NOT NULL, --/F SPECINDEX_1RE 12 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Mgb.  
    specindex_1re_fe5270 real NOT NULL, --/F SPECINDEX_1RE 13 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5270.  
    specindex_1re_fe5335 real NOT NULL, --/F SPECINDEX_1RE 14 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5335.  
    specindex_1re_fe5406 real NOT NULL, --/F SPECINDEX_1RE 15 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5406.  
    specindex_1re_fe5709 real NOT NULL, --/F SPECINDEX_1RE 16 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5709.  
    specindex_1re_fe5782 real NOT NULL, --/F SPECINDEX_1RE 17 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5782.  
    specindex_1re_nad real NOT NULL, --/F SPECINDEX_1RE 18 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaD.  
    specindex_1re_tio1 real NOT NULL, --/F SPECINDEX_1RE 19 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO1.  
    specindex_1re_tio2 real NOT NULL, --/F SPECINDEX_1RE 20 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO2.  
    specindex_1re_hdeltaa real NOT NULL, --/F SPECINDEX_1RE 21 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HDeltaA.  
    specindex_1re_hgammaa real NOT NULL, --/F SPECINDEX_1RE 22 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HGammaA.  
    specindex_1re_hdeltaf real NOT NULL, --/F SPECINDEX_1RE 23 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HDeltaF.  
    specindex_1re_hgammaf real NOT NULL, --/F SPECINDEX_1RE 24 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HGammaF.  
    specindex_1re_cahk real NOT NULL, --/F SPECINDEX_1RE 25 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaHK.  
    specindex_1re_caii1 real NOT NULL, --/F SPECINDEX_1RE 26 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII1.  
    specindex_1re_caii2 real NOT NULL, --/F SPECINDEX_1RE 27 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII2.  
    specindex_1re_caii3 real NOT NULL, --/F SPECINDEX_1RE 28 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII3.  
    specindex_1re_pa17 real NOT NULL, --/F SPECINDEX_1RE 29 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa17.  
    specindex_1re_pa14 real NOT NULL, --/F SPECINDEX_1RE 30 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa14.  
    specindex_1re_pa12 real NOT NULL, --/F SPECINDEX_1RE 31 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa12.  
    specindex_1re_mgicvd real NOT NULL, --/F SPECINDEX_1RE 32 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for MgICvD.  
    specindex_1re_naicvd real NOT NULL, --/F SPECINDEX_1RE 33 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaICvD.  
    specindex_1re_mgiir real NOT NULL, --/F SPECINDEX_1RE 34 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for MgIIR.  
    specindex_1re_fehcvd real NOT NULL, --/F SPECINDEX_1RE 35 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for FeHCvD.  
    specindex_1re_nai real NOT NULL, --/F SPECINDEX_1RE 36 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaI.  
    specindex_1re_btio real NOT NULL, --/F SPECINDEX_1RE 37 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for bTiO.  
    specindex_1re_atio real NOT NULL, --/F SPECINDEX_1RE 38 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for aTiO.  
    specindex_1re_cah1 real NOT NULL, --/F SPECINDEX_1RE 39 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CaH1.  
    specindex_1re_cah2 real NOT NULL, --/F SPECINDEX_1RE 40 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CaH2.  
    specindex_1re_naisdss real NOT NULL, --/F SPECINDEX_1RE 41 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaISDSS.  
    specindex_1re_tio2sdss real NOT NULL, --/F SPECINDEX_1RE 42 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO2SDSS.  
    specindex_1re_d4000 real NOT NULL, --/F SPECINDEX_1RE 43 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for D4000.  
    specindex_1re_dn4000 real NOT NULL, --/F SPECINDEX_1RE 44 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for Dn4000.  
    specindex_1re_tiocvd real NOT NULL, --/F SPECINDEX_1RE 45 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for TiOCvD.  
    sfr_1re real NOT NULL, --/U h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within 1 effective radius based on the Gaussian-fitted Hα flux; log(SFR) = log L_{Hα} - 41.27 (Kennicutt & Evans [2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Hα} = 4π EML_FLUX_1RE (LDIST_Z)^{2} and ''no'' attentuation correction has been applied.  
    sfr_tot real NOT NULL, --/U h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within the IFU field-of-view based on the Gaussian-fitted Hα flux; log(SFR) = log L_{Hα} - 41.27 (Kennicutt & Evans [2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Hα} = 4π EML_FLUX_TOT (LDIST_Z)^{2} and ''no'' attentuation correction has been applied.  
    htmID bigint NOT NULL  --/F NOFITS --/D 20-level deep Hierarchical Triangular Mesh ID 
);

