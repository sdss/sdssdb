/*

GLIMPSE I+II+3D (Archive)

https://irsa.ipac.caltech.edu/data/SPITZER/GLIMPSE/overview.html

\fixlen = T
\                       Default Data Dictionary
\
\
\alias     = none
\longitude = ra
\latitude  = dec
\primary   = cntr
\spt_ind   = spt_ind
\x  = x
\y  = y
\z  = z
\
\
|    cntr|              name|     original_name|                                                                             description|           units|                        intype|                  format|                        dbtype|nulls|tableflg| groupid| irsadef| sel|indx|                                                                                                                                                                                                   notes|
| integer|              char|              char|                                                                                    char|            char|                          char|                    char|                          char| char| integer| integer|   char |char|char|                                                                                                                                                                                                    char|
        1        designation        designation                                                         GLIMPSEI source designation name                                            char                                           character(26)    n        2        1       y     y    n
        2  tmass_designation  tmass_designation                  Source name (designation) from 2MASS All-Sky point source catalog (PSC)                                            char                                           character(16)    y        2        2       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#designation
        3         tmass_cntr         tmass_cntr               Unique id number (counter) for the 2MASS source from the 2MASS All-Sky PSC                                             int                                                 integer    y        2        3       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#pts_key
        4                  l                  l                                                                       Galactic longitude              deg                         double                                                   float    n        2        4       y     y    n
        5                  b                  b                                                                        Galactic latitude              deg                         double                                                   float    n        2        5       y     y    n
        6                 dl                 dl                                                              error in Galactic longitude           arcsec                         double                                                   float    n        2        6       y     y    n
        7                 db                 db                                                               error in Galactic latitude           arcsec                         double                                                   float    n        2        7       y     y    n
        8                 ra                 ra                                                                    Right ascension J2000              deg                         double                                                   float    n        2        8       y     y    n
        9                dec                dec                                                                        Declination J2000              deg                         double                                                   float    n        2        9       y     y    n
       10                dra                dra                                                                 error in Right ascension           arcsec                         double                                                   float    n        2       10       y     y    n
       11               ddec               ddec                                                                     error in Declination           arcsec                         double                                                   float    n        2       11       y     y    n
       12                csf                csf                                                                        close source flag                                             int                                                 integer    n        2       12       y     y    n
       13              mag_J              mag_J                                                       2MASS All-Sky PSC J Band magnitude              mag                           real                                              smallfloat    y        2       13       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#j_m
       14               dJ_m               dJ_m                                                   2MASS All-Sky PSC J Band 1 sigma error              mag                           real                                              smallfloat    y        2       13       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#j_msigcom
       15              mag_H              mag_H                                                       2MASS All-Sky PSC H Band magnitude              mag                           real                                              smallfloat    y        2       15       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#h_m
       16               dH_m               dH_m                                                   2MASS All-Sky PSC H Band 1 sigma error              mag                           real                                              smallfloat    y        2       15       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#h_msigcom
       17             mag_Ks             mag_Ks                                                      2MASS All-Sky PSC Ks Band magnitude              mag                           real                                              smallfloat    y        2       17       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#k_m
       18              dKs_m              dKs_m                                                  2MASS All-Sky PSC Ks Band 1 sigma error              mag                           real                                              smallfloat    y        2       17       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#k_msigcom
       19             mag3_6             mag3_6                                                            3.6um IRAC (Band 1) magnitude              mag                           real                                              smallfloat    y        2       19       y     y    n
       20              d3_6m              d3_6m                                                        3.6um IRAC (Band 1) 1 sigma error              mag                           real                                              smallfloat    y        2       19       y     y    n
       21             mag4_5             mag4_5                                                            4.5um IRAC (Band 2) magnitude              mag                           real                                              smallfloat    y        2       21       y     y    n
       22              d4_5m              d4_5m                                                        4.5um IRAC (Band 2) 1 sigma error              mag                           real                                              smallfloat    y        2       21       y     y    n
       23             mag5_8             mag5_8                                                            5.8um IRAC (Band 3) magnitude              mag                           real                                              smallfloat    y        2       23       y     y    n
       24              d5_8m              d5_8m                                                        5.8um IRAC (Band 3) 1 sigma error              mag                           real                                              smallfloat    y        2       23       y     y    n
       25             mag8_0             mag8_0                                                            8.0um IRAC (Band 4) magnitude              mag                           real                                              smallfloat    y        2       25       y     y    n
       26              d8_0m              d8_0m                                                        8.0um IRAC (Band 4) 1 sigma error              mag                           real                                              smallfloat    y        2       25       y     y    n
       27                f_J                f_J                                                            2MASS All-Sky PSC J Band flux              mJy                           real                                              smallfloat    y        2       27       y     y    n
       28               df_J               df_J                                                   2MASS All-Sky PSC J Band 1 sigma error              mJy                           real                                              smallfloat    y        2       27       y     y    n
       29                f_H                f_H                                                            2MASS All-Sky PSC H Band flux              mJy                           real                                              smallfloat    y        2       29       y     y    n
       30               df_H               df_H                                                   2MASS All-Sky PSC H Band 1 sigma error              mJy                           real                                              smallfloat    y        2       29       y     y    n
       31               f_Ks               f_Ks                                                           2MASS All-Sky PSC Ks Band flux              mJy                           real                                              smallfloat    y        2       31       y     y    n
       32              df_Ks              df_Ks                                                  2MASS All-Sky PSC Ks Band 1 sigma error              mJy                           real                                              smallfloat    y        2       31       y     y    n
       33               f3_6               f3_6                                                                 3.6um IRAC (Band 1) flux              mJy                           real                                              smallfloat    y        2       33       y     y    n
       34              df3_6              df3_6                                                        3.6um IRAC (Band 1) 1 sigma error              mJy                           real                                              smallfloat    y        2       33       y     y    n
       35               f4_5               f4_5                                                                 4.5um IRAC (Band 2) flux              mJy                           real                                              smallfloat    y        2       35       y     y    n
       36              df4_5              df4_5                                                        4.5um IRAC (Band 2) 1 sigma error              mJy                           real                                              smallfloat    y        2       35       y     y    n
       37               f5_8               f5_8                                                                 5.8um IRAC (Band 3) flux              mJy                           real                                              smallfloat    y        2       37       y     y    n
       38              df5_8              df5_8                                                        5.8um IRAC (Band 3) 1 sigma error              mJy                           real                                              smallfloat    y        2       37       y     y    n
       39               f8_0               f8_0                                                                 8.0um IRAC (Band 4) flux              mJy                           real                                              smallfloat    y        2       39       y     y    n
       40              df8_0              df8_0                                                        8.0um IRAC (Band 4) 1 sigma error              mJy                           real                                              smallfloat    y        2       39       y     y    n
       41           rms_f3_6           rms_f3_6            rms deviation of the individual detections from the final flux for 3.6um IRAC              mJy                           real                                              smallfloat    y        2       41       y     y    n
       42           rms_f4_5           rms_f4_5            rms deviation of the individual detections from the final flux for 4.5um IRAC              mJy                           real                                              smallfloat    y        2       42       y     y    n
       43           rms_f5_8           rms_f5_8            rms deviation of the individual detections from the final flux for 5.8um IRAC              mJy                           real                                              smallfloat    y        2       43       y     y    n
       44           rms_f8_0           rms_f8_0            rms deviation of the individual detections from the final flux for 8.0um IRAC              mJy                           real                                              smallfloat    y        2       44       y     y    n
       45            sky_3_6            sky_3_6                                             Local sky background for 3.6um IRAC (Band 1)           MJy/sr                           real                                              smallfloat    y        2       45       y     y    n    see Appendix B of http://www.astro.wisc.edu/glimpse/glimpse_photometry_v1.0.pdf
       46            sky_4_5            sky_4_5                                             Local sky background for 4.5um IRAC (Band 2)           MJy/sr                           real                                              smallfloat    y        2       46       y     y    n    see Appendix B of http://www.astro.wisc.edu/glimpse/glimpse_photometry_v1.0.pdf
       47            sky_5_8            sky_5_8                                             Local sky background for 5.8um IRAC (Band 3)           MJy/sr                           real                                              smallfloat    y        2       47       y     y    n    see Appendix B of http://www.astro.wisc.edu/glimpse/glimpse_photometry_v1.0.pdf
       48            sky_8_0            sky_8_0                                             Local sky background for 8.0um IRAC (Band 4)           MJy/sr                           real                                              smallfloat    y        2       48       y     y    n    see Appendix B of http://www.astro.wisc.edu/glimpse/glimpse_photometry_v1.0.pdf
       49               sn_J               sn_J                                                    2MASS All-Sky PSC J Band Signal/Noise                                            real                                              smallfloat    y        2       49       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#j_snr
       50               sn_H               sn_H                                                    2MASS All-Sky PSC H Band Signal/Noise                                            real                                              smallfloat    y        2       50       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#h_snr
       51              sn_Ks              sn_Ks                                                   2MASS All-Sky PSC Ks Band Signal/Noise                                            real                                              smallfloat    y        2       51       y     y    n    http://www.ipac.caltech.edu/2mass/releases/allsky/doc/sec2_2a.html#k_snr
       52             sn_3_6             sn_3_6                                                         3.6um IRAC (Band 1) Signal/Noise                                            real                                              smallfloat    y        2       52       y     y    n
       53             sn_4_5             sn_4_5                                                         4.5um IRAC (Band 2) Signal/Noise                                            real                                              smallfloat    y        2       53       y     y    n
       54             sn_5_8             sn_5_8                                                         5.8um IRAC (Band 3) Signal/Noise                                            real                                              smallfloat    y        2       54       y     y    n
       55             sn_8_0             sn_8_0                                                         8.0um IRAC (Band 4) Signal/Noise                                            real                                              smallfloat    y        2       55       y     y    n
       56           dens_3_6           dens_3_6                                             Local source density for 3.6um IRAC (Band 1)         #/sqamin                           real                                              smallfloat    y        2       56       y     y    n    see section 5.1 of http://www.astro.wisc.edu/glimpse/glimpse1_dataprod_v2.0.pdf
       57           dens_4_5           dens_4_5                                             Local source density for 4.5um IRAC (Band 2)         #/sqamin                           real                                              smallfloat    y        2       57       y     y    n    see section 5.1 of http://www.astro.wisc.edu/glimpse/glimpse1_dataprod_v2.0.pdf
       58           dens_5_8           dens_5_8                                             Local source density for 5.8um IRAC (Band 3)         #/sqamin                           real                                              smallfloat    y        2       58       y     y    n    see section 5.1 of http://www.astro.wisc.edu/glimpse/glimpse1_dataprod_v2.0.pdf
       59           dens_8_0           dens_8_0                                             Local source density for 8.0um IRAC (Band 4)         #/sqamin                           real                                              smallfloat    y        2       59       y     y    n    see section 5.1 of http://www.astro.wisc.edu/glimpse/glimpse1_dataprod_v2.0.pdf
       60               m3_6               m3_6                                             Number of detections for 3.6um IRAC (Band 1)                                             int                                                 integer    n        2       60       y     y    n
       61               m4_5               m4_5                                             Number of detections for 4.5um IRAC (Band 2)                                             int                                                 integer    n        2       61       y     y    n
       62               m5_8               m5_8                                             Number of detections for 5.8um IRAC (Band 3)                                             int                                                 integer    n        2       62       y     y    n
       63               m8_0               m8_0                                             Number of detections for 8.0um IRAC (Band 4)                                             int                                                 integer    n        2       63       y     y    n
       64               n3_6               n3_6                                    Number of possible detections for 3.6um IRAC (Band 1)                                             int                                                 integer    n        2       64       y     y    n
       65               n4_5               n4_5                                    Number of possible detections for 4.5um IRAC (Band 2)                                             int                                                 integer    n        2       65       y     y    n
       66               n5_8               n5_8                                    Number of possible detections for 5.8um IRAC (Band 3)                                             int                                                 integer    n        2       66       y     y    n
       67               n8_0               n8_0                                    Number of possible detections for 8.0um IRAC (Band 4)                                             int                                                 integer    n        2       67       y     y    n
       68              sqf_J              sqf_J                                             2MASS All-Sky PSC J Band Source Quality Flag                                             int                                                 integer    y        2       68       y     y    n
       69              sqf_H              sqf_H                                             2MASS All-Sky PSC H Band Source Quality Flag                                             int                                                 integer    y        2       69       y     y    n
       70             sqf_Ks             sqf_Ks                                            2MASS All-Sky PSC Ks Band Source Quality Flag                                             int                                                 integer    y        2       70       y     y    n
       71            sqf_3_6            sqf_3_6                                              Source Quality Flag for 3.6um IRAC (Band 1)                                             int                                                 integer    y        2       71       y     y    n
       72            sqf_4_5            sqf_4_5                                              Source Quality Flag for 4.5um IRAC (Band 2)                                             int                                                 integer    y        2       72       y     y    n
       73            sqf_5_8            sqf_5_8                                              Source Quality Flag for 5.8um IRAC (Band 3)                                             int                                                 integer    y        2       73       y     y    n
       74            sqf_8_0            sqf_8_0                                              Source Quality Flag for 8.0um IRAC (Band 4)                                             int                                                 integer    y        2       74       y     y    n
       75              mf3_6              mf3_6                                         Flux calculation method flag 3.6um IRAC (Band 1)                                             int                                                 integer    y        2       75       y     y    n
       76              mf4_5              mf4_5                                         Flux calculation method flag 4.5um IRAC (Band 2)                                             int                                                 integer    y        2       76       y     y    n
       77              mf5_8              mf5_8                                         Flux calculation method flag 5.8um IRAC (Band 3)                                             int                                                 integer    y        2       77       y     y    n
       78              mf8_0              mf8_0                                         Flux calculation method flag 8.0um IRAC (Band 4)                                             int                                                 integer    y        2       78       y     y    n

*/

CREATE TABLE catalogdb.glimpse (
    designation TEXT,
    tmass_designation VARCHAR(18),
    tmass_cntr INTEGER,
    l DOUBLE PRECISION,
    b DOUBLE PRECISION,
    dl DOUBLE PRECISION,
    db DOUBLE PRECISION,
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    dra DOUBLE PRECISION,
    ddec DOUBLE PRECISION,
    csf INTEGER,
    mag_J REAL,
    dJ_m REAL,
    mag_H REAL,
    dH_m REAL,
    mag_Ks REAL,
    dKs_m REAL,
    mag3_6 REAL,
    d3_6m REAL,
    mag4_5 REAL,
    d4_5m REAL,
    mag5_8 REAL,
    d5_8m REAL,
    mag8_0 REAL,
    d8_0m REAL,
    f_J REAL,
    df_J REAL,
    f_H REAL,
    df_H REAL,
    f_Ks REAL,
    df_Ks REAL,
    f3_6 REAL,
    df3_6 REAL,
    f4_5 REAL,
    df4_5 REAL,
    f5_8 REAL,
    df5_8 REAL,
    f8_0 REAL,
    df8_0 REAL,
    rms_f3_6 REAL,
    rms_f4_5 REAL,
    rms_f5_8 REAL,
    rms_f8_0 REAL,
    sky_3_6 REAL,
    sky_4_5 REAL,
    sky_5_8 REAL,
    sky_8_0 REAL,
    sn_J REAL,
    sn_H REAL,
    sn_Ks REAL,
    sn_3_6 REAL,
    sn_4_5 REAL,
    sn_5_8 REAL,
    sn_8_0 REAL,
    dens_3_6 REAL,
    dens_4_5 REAL,
    dens_5_8 REAL,
    dens_8_0 REAL,
    m3_6 INTEGER,
    m4_5 INTEGER,
    m5_8 INTEGER,
    m8_0 INTEGER,
    n3_6 INTEGER,
    n4_5 INTEGER,
    n5_8 INTEGER,
    n8_0 INTEGER,
    sqf_J INTEGER,
    sqf_H INTEGER,
    sqf_Ks INTEGER,
    sqf_3_6 INTEGER,
    sqf_4_5 INTEGER,
    sqf_5_8 INTEGER,
    sqf_8_0 INTEGER,
    mf3_6 INTEGER,
    mf4_5 INTEGER,
    mf5_8 INTEGER,
    mf8_0 INTEGER
) WITHOUT OIDS;
