Dear Conor,

The first versions of the BHM-X-ray mock catalogues are now ready to be ingested into the SDSS-V catalogdb (thanks Johan!).

You can retrieve them with:

wget --no-check-certificate https://firefly.mpe.mpg.de/mocks/v_apr_2018/ETC_summary_files/summary_eRASS3_agn_SDSS_V_format.fits

wget --no-check-certificate https://firefly.mpe.mpg.de/mocks/v_apr_2018/ETC_summary_files/summary_eRASS3_clusters_SDSS_V_format.fits

Please note that some of the columns are not populated with meaningful values. In particular, the values in the ALLWISE_designation, GAIA_DR2_source_id, NSC_DR1_id and SDSS_DR14_objID columns do not point to real objects in those external catalogues.

A further set of down-selections, e.g. filtering on magnitude, will have to be applied to these initial catalogues to generate a list of candidate targets to be observed within SDSS-V. In addition, we will have to convert the T_EXP column into a integer number of requested 15 minute sub-exposures.

Let me know if you need any further details, or if you would like us to provide these catalogues in a different format.

Cheers,

Tom
