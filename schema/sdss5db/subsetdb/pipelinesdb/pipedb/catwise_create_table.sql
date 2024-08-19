/*

CatWISE Catalog Output Table File Description (Rev. 1.4, May 11, 2019)
Based on WPHot Output Table File Description [pht12] Rev 1.5 Dec. 10, 2018
and on output from stf 1.7  B90210 run on IRSA table format files with -L option.

Interface Name:     CatWISE catalog table file for Preliminary CatWISE Processing
Type of Interface:  disk i/o

Written By:         J.Fowler, P.Eisenhardt

Read By:            CatWISE Software Team

Description:

Extension of Version 7 of WPHotpm for multiframe processing of two bands
(unWISE W1 and W2 coadds) with additional table-file columns derived from:
- merging the separate mdex files for ascending and descending scans of a tile
- adding cc_flags from the AllWISE catalog
- adding flags based on unWISE artifact bitmasks
- adding primary source in tile designation flag

_______________________________________________________________________________________

Specification of output variables:

Table Header information:

-- # sources tabulated
-- unWISE epoch coadds engaged (ascending and descending for option 1)
-- WISE bands engaged (always bands 1 and 2 only for CatWISE)
-- zero point mag used
-- standard aperture radius in arcsec and pixel units (one line per band)
-- circular aperture radii in arcsec and pixel units (one line per band)
-- Modified Julian Date of the CatWISE coordinate epoch (MJD 56700.00 for Preliminary Catalog)
-- CatWISE processing history (6 lines)

Tabular data:

Note that the first column in the width is occupied by a "pipe" or "bar" delimiter ("|")

 Field 	 cols    Width	  Units  Type    Format   Name    	Description
  ----   ----    -----   ------- ----   -------   ------------  ------------------------------------
   1      1-21      21    --     char   a21	  source_name	source hexagesimal designation
   2     22-46      25    --     char   a25	  source_id	tile name + processing code + wphot index
   3     47-58      12   deg     R*8    f12.7	  ra		right ascension (J2000)
   4     59-70      12   deg     R*8    f12.7	  dec		declination (J2000)
   5     71-79       9   asec    R*4    f9.4	  sigra		uncertainty in ra (arcsec)
   6     80-88       9   asec    R*4    f9.4	  sigdec	uncertainty in dec (arcsec)
   7     89-97       9   asec    R*4    f9.4	  sigradec	uncertainty cross-term (arcsec)

#   the following positions reflect the source xy position in the unWISE full depth coadd

   8     98-106      9   pix     R*4    f9.3	  wx		x-pixel coordinate
   9    107-115      9   pix     R*4    f9.3	  wy		y-pixel coordinate

# The next set of columns are aperture/annulus measurements from the unWISE epoch coadds:

  10    116-125     10   dn      R*4    f10.3	  w1sky		frame sky background value, band-1
  11    126-133      8   dn      R*4    f8.3	  w1sigsk	frame sky background value uncertainty, band-1
  12    134-141      8   dn      R*4    f8.3	  w1conf	frame sky confusion based on the UNC images
  13    142-151     10   dn      R*4    f10.3	  w2sky		frame sky background value, band-2
  14    152-159      8   dn      R*4    f8.3	  w2sigsk	frame sky background value uncertainty, band-2
  15    160-167      8   dn      R*4    f8.3	  w2conf	frame sky confusion based on the UNC images

# WPRO epoch coadd measurements:

  16    168-174      7   asec    R*4    f7.2	  w1fitr	fitting radius, band-1 (clipped at 999.99)
  17    175-181      7   asec    R*4    f7.2	  w2fitr	fitting radius, band-2 (clipped at 999.99)
  18    182-188      7    --     R*4    f7.1	  w1snr		S/N ratio, band-1
  19    189-195      7    --     R*4    f7.1	  w2snr		S/N ratio, band-2
  20    196-207     12   dn      R*4  	1pe12.4	  w1flux	WPRO raw flux, band-1
  21    208-221     14   dn      R*4  	1pe14.4	  w1sigflux	WPRO raw flux uncertainty, band-1
  22    222-233     12   dn      R*4  	1pe12.4	  w2flux	WPRO raw flux, band-2
  23    234-247     14   dn      R*4  	1pe14.4	  w2sigflux	WPRO raw flux uncertainty, band-2
  24    248-254      7   mag     R*4    f7.3	  w1mpro	WPRO flux in mag units, band-1
  25    255-264     10   mag     R*4    f10.3	  w1sigmpro	WPRO flux uncertainty in mag units, band-1
  26    265-275     11   --      R*4  	1pe11.3	  w1rchi2	WPRO reduced chi^2, band-1
  27    276-282      7   mag     R*4    f7.3	  w2mpro	WPRO flux in mag units, band-2
  28    283-292     10   mag     R*4    f10.3	  w2sigmpro	WPRO flux uncertainty in mag units, band-2
  29    293-303     11   --      R*4  	1pe11.3	  w2rchi2	WPRO reduced chi^2, band-2
  30    304-314     11   --      R*4  	1pe11.3	  rchi2		reduced chi squared, total

  31    315-318      4   --   	 int    i4	  nb		number of blend components used in each fit
  32    319-322      4   --   	 int    i4	  na		number of actively deblended components
  33    323-330      8   --      R*4    f8.5	  w1Sat		fraction of pixels saturated, band-1
  34    331-338      8   --      R*4    f8.5	  w2Sat		fraction of pixels saturated, band-2

# full depth coadd measurements: WAPPco, standard aperture w/ aperture correction;
# the standard (aperture corrected) aperture radius is 8.25 arcsec.

  35    339-345      7   mag     R*4    f7.3	  w1mag		standard aperture mag w/ correction applied
  36    346-352      7   mag     R*4    f7.3	  w1sigm	standard aperture mag uncertainty, band-1
  37    353-358      6    --     int    i6	  w1flg		standard aperture flag, band-1
  38    359-366      8    --     R*4    f8.2	  w1Cov		mean coverage depth, band-1
  39    367-373      7   mag     R*4    f7.3	  w2mag		standard aperture mag w/ correction applied
  40    374-380      7   mag     R*4    f7.3	  w2sigm	standard aperture mag uncertainty, band-2
  41    381-386      6    --     int    i6	  w2flg		standard aperture flag, band-2
  42    387-394      8    --     R*4    f8.2	  w2Cov		mean coverage depth, band-2

# full depth coadd measurements: WAPPco, circular apertures, no aperture correction is applied;
# radii:    5.50   8.25  11.00  13.75  16.50  19.25  22.00  24.75 arcsec

  43    395-404     10   mag     R*4    f10.3	  w1mag_1	Aper 1, aperture mag, band-1
  44    405-414     10   mag     R*4    f10.3	  w1sigm_1	Aper 1, aperture mag uncertainty, band-1
  45    415-422      8    --     int    i8	  w1flg_1	Aper 1, aperture flag, band-1
  46    423-432     10   mag     R*4    f10.3	  w2mag_1	Aper 1, aperture mag, band-2
  47    433-442     10   mag     R*4    f10.3	  w2sigm_1	Aper 1, aperture mag uncertainty, band-2
  48    443-450      8   --      int    i8	  w2flg_1	Aper 1, aperture flag, band-2

  49    451-460     10   mag     R*4    f10.3	  w1mag_2	Aper 2, aperture mag, band-1
  50    461-470     10   mag     R*4    f10.3	  w1sigm_2	Aper 2, aperture mag uncertainty, band-1
  51    471-478      8    --     int    i8	  w1flg_2	Aper 2, aperture flag, band-1
  52    479-488     10   mag     R*4    f10.3	  w2mag_2	Aper 2, aperture mag, band-2
  53    489-498     10   mag     R*4    f10.3	  w2sigm_2	Aper 2, aperture mag uncertainty, band-2
  54    499-506      8    --     int    i8	  w2flg_2	Aper 2, aperture flag, band-2

  55    507-516     10   mag     R*4    f10.3	  w1mag_3	Aper 3, aperture mag, band-1
  56    517-526     10   mag     R*4    f10.3	  w1sigm_3	Aper 3, aperture mag uncertainty, band-1
  57    527-534      8    --     int    i8	  w1flg_3	Aper 3, aperture flag, band-1
  58    535-544     10   mag     R*4    f10.3	  w2mag_3	Aper 3, aperture mag, band-2
  59    545-554     10   mag     R*4    f10.3	  w2sigm_3	Aper 3, aperture mag uncertainty, band-2
  60    555-562      8    --     int    i8	  w2flg_3	Aper 3, aperture flag, band-2

  61    563-572     10   mag     R*4    f10.3	  w1mag_4	Aper 4, aperture mag, band-1
  62    573-582     10   mag     R*4    f10.3	  w1sigm_4	Aper 4, aperture mag uncertainty, band-1
  63    583-590      8    --     int    i8	  w1flg_4	Aper 4, aperture flag, band-1
  64    591-600     10   mag     R*4    f10.3	  w2mag_4	Aper 4, aperture mag, band-2
  65    601-610     10   mag     R*4    f10.3	  w2sigm_4	Aper 4, aperture mag uncertainty, band-2
  66    611-618      8    --     int    i8	  w2flg_4	Aper 4, aperture flag, band-2

  67    619-628     10   mag     R*4    f10.3	  w1mag_5	Aper 5, aperture mag, band-1
  68    629-638     10   mag     R*4    f10.3	  w1sigm_5	Aper 5, aperture mag uncertainty, band-1
  69    639-646      8    --     int    i8	  w1flg_5	Aper 5, aperture flag, band-1
  70    647-656     10   mag     R*4    f10.3	  w2mag_5	Aper 5, aperture mag, band-2
  71    657-666     10   mag     R*4    f10.3	  w2sigm_5	Aper 5, aperture mag uncertainty, band-2
  72    667-674      8    --     int    i8	  w2flg_5	Aper 5, aperture flag, band-2

  73    675-684     10   mag     R*4    f10.3	  w1mag_6	Aper 6, aperture mag, band-1
  74    685-694     10   mag     R*4    f10.3	  w1sigm_6	Aper 6, aperture mag uncertainty, band-1
  75    695-702      8    --     int    i8	  w1flg_6	Aper 6, aperture flag, band-1
  76    703-712     10   mag     R*4    f10.3	  w2mag_6	Aper 6, aperture mag, band-2
  77    713-722     10   mag     R*4    f10.3	  w2sigm_6	Aper 6, aperture mag uncertainty, band-2
  78    723-730      8    --     int    i8	  w2flg_6	Aper 6, aperture flag, band-2

  79    731-740     10   mag     R*4    f10.3	  w1mag_7	Aper 7, aperture mag, band-1
  80    741-750     10   mag     R*4    f10.3	  w1sigm_7	Aper 7, aperture mag uncertainty, band-1
  81    751-758      8    --     int    i8	  w1flg_7	Aper 7, aperture flag, band-1
  82    759-768     10   mag     R*4    f10.3	  w2mag_7	Aper 7, aperture mag, band-2
  83    769-778     10   mag     R*4    f10.3	  w2sigm_7	Aper 7, aperture mag uncertainty, band-2
  84    779-786      8    --     int    i8	  w2flg_7	Aper 7, aperture flag, band-2

  85    787-796     10   mag     R*4    f10.3	  w1mag_8	Aper 8, aperture mag, band-1
  86    797-806     10   mag     R*4    f10.3	  w1sigm_8	Aper 8, aperture mag uncertainty, band-1
  87    807-814      8    --     int    i8	  w1flg_8	Aper 8, aperture flag, band-1
  88    815-824     10   mag     R*4    f10.3	  w2mag_8	Aper 8, aperture mag, band-2
  89    825-834     10   mag     R*4    f10.3	  w2sigm_8	Aper 8, aperture mag uncertainty, band-2
  90    835-842      8    --     int    i8	  w2flg_8	Aper 8, aperture flag, band-2

# the following are "N of M" counters for WPRO measurements
# w?M   - The number of individual epochs for band ? that are
#         available to make a profile-fit measurement.
# w?NM  - The number of individual epochs for band ? on which
#         WPRO extracted a flux measurement that has snr>3.
# w?mLQ - variability indicator mLogQ for the flux array

  91    843-849      7    --     int    i7	  w1NM		WPRO, N (of M), band-1
  92    850-855      6    --     int    i6	  w1M		WPRO, M , band-1
  93    856-863      8   mag     R*4    f8.3	  w1magP	WPRO repeatability mag; band-1
  94    864-871      8   mag     R*4    f8.3	  w1sigP1	WPRO mag population sigma; band-1
  95    872-879      8   mag     R*4    f8.3	  w1sigP2	WPRO mag uncertainty of the mean; band-1
  96    880-891     12    --     R*4    f12.5	  w1k		Stetson k index for variability; band-1
  97    892-897      6    --     int    i6	  w1Ndf		No. degrees of freedom in var chi-square; band-1
  98    898-903      6    --     R*4    f6.2	  w1mLQ		-log(Q), Q = 1-P(chi-square);  band-1
  99    904-921     18    --     R*8    f18.8	  w1mJDmin	minimum mJD; band-1
 100    922-939     18    --     R*8    f18.8	  w1mJDmax	maximum mJD; band-1
 101    940-957     18    --     R*8    f18.8	  w1mJDmean	mean mJD; band-1

 102    958-964      7    --     int    i7	  w2NM		WPRO, N (of M), band-2
 103    965-970      6    --     int    i6	  w2M		WPRO, M , band-2
 104    971-978      8   mag     R*4    f8.3	  w2magP	WPRO repeatability mag; band-2
 105    979-986      8   mag     R*4    f8.3	  w2sigP1	WPRO mag population sigma; band-2
 106    987-994      8   mag     R*4    f8.3	  w2sigP2	WPRO mag uncertainty of the mean; band-2
 107    995-1006    12    --     R*4    f12.5	  w2k		Stetson k index for variability; band-2
 108   1007-1012     6    --     int    i6	  w2Ndf		No. degrees of freedom in var chi-square; band-2
 109   1013-1018     6    --     R*4    f6.2	  w2mLQ		-log(Q), Q = 1-P(chi-square);  band-2
 110   1019-1036    18    --     R*8    f18.8	  w2mJDmin	minimum mJD; band-2
 111   1037-1054    18    --     R*8    f18.8	  w2mJDmax	maximum mJD; band-2
 112   1055-1072    18    --     R*8    f18.8	  w2mJDmean	mean mJD; band-2

#  band-to-band sample correlation coefficients and their probabilities for adjacent bands

 113   1073-1078     6    %      int    i4	  rho12		W1W2 correlation coefficient
 114   1079-1084     6    --   	 int    i4	  q12		-log10(1-P(rho12)) given no real correlation

 115   1085-1091     7    --     int    i7	  nIters	number of chi-square-minimization iterations
 116   1092-1098     7    --     int    i7	  nSteps	number of steps in all iterations

# MDET-Related Parameters
# p1 and p2 are clipped to the range (-99.99999, +99.99999) if necessary

 117   1099-1105     7     --     int    i7	  mdetID	source ID in mdet list
 118   1106-1115    10   asec     R*4   f10.5	  p1		P vector component 1
 119   1116-1125    10   asec     R*4   f10.5	  p2		P vector component 2

# Motion Fit Solution Parameters
# ra_pm and dec_pm are in the equinox J2000 frame at the CatWISE epoch
# (MJD 56700.00 for the Preliminary Catalog) based on PMRA and PMDec

 120   1126-1138    13    MJD     R*8   f13.6	  MeanObsMJD	mean observation epoch
 121   1139-1150    12    deg     R*8   f12.7	  ra_pm		right ascension (J2000)
 122   1151-1162    12    deg     R*8   f12.7	  dec_pm	declination (J2000)
 123   1163-1171     9   asec     R*4    f9.4	  sigra_pm	uncertainty in ra_pm
 124   1172-1181    10   asec     R*4   f10.4	  sigdec_pm	uncertainty in dec_pm
 125   1182-1193    12   asec     R*4   f12.4	  sigradec_pm	uncertainty cross-term
 126   1194-1203    10   asec/yr  R*4   f10.4	  PMRA		motion in ra
 127   1204-1213    10   asec/yr  R*4   f10.4	  PMDec		proper motion in dec
 128   1214-1222     9   asec/yr  R*4    f9.4	  sigPMRA	uncertainty in PMRA
 129   1223-1231     9   asec/yr  R*4    f9.4	  sigPMDec	uncertainty in PMDec

 130   1232-1240     9   --       R*4    f9.1	  w1snr_pm	flux S/N ratio, band-1
 131   1241-1249     9   --       R*4    f9.1	  w2snr_pm	flux S/N ratio, band-2
 132   1250-1261    12   dn       R*4  	1pe12.4	  w1flux_pm	WPRO raw flux, band-1
 133   1262-1275    14   dn       R*4  	1pe14.4	  w1sigflux_pm	WPRO raw flux uncertainty, band-1
 134   1276-1287    12   dn       R*4  	1pe12.4	  w2flux_pm	WPRO raw flux, band-2
 135   1288-1301    14   dn       R*4  	1pe14.4	  w2sigflux_pm	fit WPRO raw flux uncertainty, band-2
 136   1302-1311    10   mag      R*4   f10.3	  w1mpro_pm	WPRO flux in mag units, band-1
 137   1312-1324    13   mag      R*4   f13.3	  w1sigmpro_pm	WPRO flux uncertainty in mag units, band-1
 138   1325-1335    11    --   	  R*4 	1pe11.3	  w1rchi2_pm	WPRO reduced chi^2, band-1
 139   1336-1345    10   mag      R*4   f10.3	  w2mpro_pm	WPRO flux in mag units, band-2
 140   1346-1358    13   mag      R*4   f13.3	  w2sigmpro_pm	WPRO flux uncertainty in mag units, band-2
 141   1359-1369    11    --   	  R*4 	1pe11.3	  w2rchi2_pm	WPRO reduced chi^2, band-2
 142   1370-1380    11    --   	  R*4 	1pe11.3	  rchi2_pm	reduced chi squared, total

# pmcode provides information that may correlate with the quality of the PM solution.
# The format is ABCCC, where A is the number of components in the passive blend group
# (including the primary) before any are removed or added,
# B is "Y" or "N" to indicate "Yes" or "No" that a secondary blend component replaced the primary,
# CCC is the distance in hundredths of an arcsec between the
# PM position solution for the mean observation epoch and the stationary solution

 143   1381-1387     7    --    char     A5	  pmcode	quality of the PM solution

 144   1388-1397    10    --     int     i10	  nIters_pm	number of chi-square-minimization iterations
 145   1398-1407    10    --     int     i10	  nSteps_pm	number of steps in all iterations

# Parameters Derived From Ascending-Descending Scan Differences

 146   1408-1416     9   asec    R*4    f9.3	  dist		radial distance between apparitions
 147   1417-1423     7    mag    R*4    f7.3	  dw1mag	w1mpro difference
 148   1424-1430     7    --     R*4    f7.3	  rch2w1	chi-square for dw1mag (1 DF)
 149   1431-1437     7    mag    R*4    f7.3	  dw2mag	w2mpro difference
 150   1438-1444     7    --     R*4    f7.3	  rch2w2	chi-square for dw2mag (1 DF)
 151   1445-1455    11    deg    R*8    f11.6	  elon_avg	averaged ecliptic longitude
 152   1456-1466    11   asec    R*4    f11.3	  elonSig	one-sigma uncertainty in elon
 153   1467-1477    11    deg    R*8    f11.6	  elat_avg	averaged ecliptic latitude
 154   1478-1487    10   asec    R*4    f10.3	  elatSig	one-sigma uncertainty in elat
 155   1488-1498    11   asec    R*4    f11.3	  Delon		desc-asce ecliptic longitude
 156   1499-1509    11   asec    R*4    f11.3	  DelonSig	one-sigma uncertainty in Delon
 157   1510-1520    11   asec    R*4    f11.3	  Delat		desc-asce ecliptic latitude
 158   1521-1530    10   asec    R*4    f10.3	  DelatSig	one-sigma uncertainty in Delat
 159   1531-1541    11    --     R*4    f11.3	  DelonSNR	|Delon|/DelonSig
 160   1542-1552    11    --     R*4    f11.3	  DelatSNR	|Delat|/DelatSig
 161   1553-1562    10    --     R*4    1pE10.3	  chi2pmra	chi-square for PMRA difference (1 DF)
 162   1563-1572    10    --     R*4    1pE10.3	  chi2pmdec	chi-square for PMRA difference (1 DF)
 163   1573-1575     3    --     int    i3	  ka		astrometry usage code
 164   1576-1578     3    --     int    i3	  k1		W1 photometry usage code
 165   1579-1581     3    --     int    i3	  k2		W2 photometry usage code
 166   1582-1584     3    --     int    i3	  km		proper motion usage code
 167   1585-1595    11   asec    R*4    f11.3	  par_pm	parallax from PM desc-asce elon
 168   1596-1606    11   asec    R*4    f11.3	  par_pmSig	one-sigma uncertainty in par_pm
 169   1607-1617    11   asec    R*4    f11.3	  par_stat	parallax estimate from stationary solution
 170   1618-1628    11   asec    R*4    f11.3	  par_sigma	one-sigma uncertainty in par_stat

# Parameters Derived from AllWISE Artifact Flags

 171   1629-1641    13   asec    R*4    f13.6	  dist_x	distance between CatWISE and AllWISE source
 172   1642-1657    16    --     char   a16	  cc_flags	worst case 4 character cc_flag from AllWISE
 173   1658-1670    13    --     int    i13	  w1cc_map	worst case w1cc_map from AllWISE
 174   1671-1690    20    --     char   a20	  w1cc_map_str	worst case w1cc_map_str from AllWISE
 175   1691-1703    13    --     int    i13	  w2cc_map	worst case w2cc_map from AllWISE
 176   1704-1723    20    --     char   a20	  w2cc_map_str	worst case w2cc_map_str from AllWISE
 177   1724-1728     5    --     int    i5	  n_aw		number of AllWISE matches within 2.75 asec

# Parameters Derived from unWISE Artifact Bitmasks

 178   1729-1737     9    --     char   a9	  ab_flags	Two character (W1 W2) artifact flag
 179   1738-1746     9    --     int    i9	  w1ab_map	w1 artifact code value
 180   1747-1759    13    --     char   a13	  w1ab_map_str	w1 artifact string
 181   1760-1768     9    --     int    i9	  w2ab_map	w2 artifact code value
 182   1769-1781    13    --     char   a13	  w2ab_map_str	w2 artifact string

# Indexed Coordinates Derived from Stationary ra and dec

 183   1782-1793    12    deg     R*8   f12.6	  glon		galactic longitude
 184   1794-1805    12    deg     R*8   f12.6	  glat		galactic latitude
 185   1806-1817    12    deg     R*8   f12.7	  elon		ecliptic longitude
 186   1818-1829    12    deg     R*8   f12.7	  elat		ecliptic latitude

# The reject table also includes

 187   1830-1835     6    --     int    i6 	  P		Flag to indicate if source is primary in tile


NOTES
1.) Delon may have a bias correction for a systematic error induced by residual
    PSF errors that manifest themselves in ascending-descending differences; see
    the "-pb" command line option of the mrgad program.
2.) Delon is defined as descending position minus ascending position in order to
    have the proper sign for parallax (~Delon/2).
3.) the usage codes ka, k1, k2, and km have values of 0 - 3 meaning
    0: neither the ascending nor the descending scan provided a solution
    1: only the ascending scan provided a solution
    2: only the descending scan provided a solution
    3: both scans provided solutions which were combined in the relevant way
4.) Delon is the straightforward difference in ecliptic longitude, ignoring the
    different effective observation epochs of ascending and descending scans;
    par_pm is computed from the motion-solution positions, which are translated
    by WPHotpmc to the standard epoch (MJD0), so except for estimation errors,
    par_pm is the parallax; the par_stat column is computed by using the
    motion estimate to move the ascending stationary-solution position from the
    ascending effective observation epoch to that of the descending solution, then
    dividing the ecliptic longitude difference by 2.
5.) Delon will be null unless ka = 3; par_pm will be null unless km = 3;
    par_stat will be null unless ka = 3 AND km > 0 AND all W?mJDmin/max/mean values
    are non-null in both ascending and descending mdex files.

____________________________________________________________________________________

N of M Statistics

M == number of flux measurements for a given source
N == number of M sources that have SNR >= 3

____________________________________________________________________________________

Photometry Flags:

Standard aperture measurement quality flag.  This flag
indicates if one or more image pixels in the measurement aperture for this
band is confused with nearby objects, is contaminated by saturated
or otherwise ususable pixels, or is an upper limit. The flag value
is the integer sum of any of following values which correspond to
different conditions.

value    Condition
-----    ------------------------------------------------------
  0      nominal -- no contamination
  1      source confusion -- another source falls within the measurement aperture
  2      bad or fatal pixels:  presence of bad pixels in the measurement aperture
        (bit 2 or 18 set)
  4      non-zero bit flag tripped (other than 2 or 18)
  8      corruption -- all pixels are flagged as unusable, or the aperture flux is
         negative; in the former case, the aperture magnitude is NULL;  in the
         latter case, the aperture magnitude is a 95% confidence upper limit
 16      saturation -- here are one or more saturated pixels in the measurement
         aperture
 32      upper limit -- the magnitude is a 95% confidence upper limit

combinations:

  3      source confusion + bad pixels
  5      source confusion + non-zero bit flag
  6      bad pixels + non-zero bit flag
  7      source confusion + bad pixels + non-zero bit flag
  9      source confusion + corruption
 10      bad pixels + corruption
 11      source confusion + bad pixels + corruption
 12      non-zero bit flag + corruption
 13      source confusion +  non-zero bit flag + corruption
 14      bad pixels +  non-zero bit flag + corruption
 15      source confusion + bad pixels +  non-zero bit flag + corruption
 17      source confusion + saturation
 18      bad pixels  + saturation
 19      source confusion + bad pixels  + saturation
 20      non-zero bit flag +  saturation
 21      source confusion + non-zero bit flag +  saturation
 22      bad pixels  + non-zero bit flag +  saturation
 23      source confusion + bad pixels  + non-zero bit flag +  saturation
 24      corruption + saturation
 25      source confusion + corruption + saturation
 26      bad pixels  +   corruption + saturation
 27      source confusion + bad pixels  +  corruption + saturation
 28      non-zero bit flag +  corruption + saturation
 29      source confusion + non-zero bit flag +  corruption + saturation
 30      bad pixels  + non-zero bit flag +  corruption + saturation
 31      source confusion + bad pixels  + non-zero bit flag +  corruption + saturation

______________________________________________________________________________________________

Note about upper limits:

threshold = 2 * RMS
if ( f < threshold) then
    if (f < 0) then
      upper_limit = threshold
    else
      upper_limit = f + threshold

where f is the flux of the source, RMS is the source flux uncertainty

The upper limit is reported in the WPRO and standard aperture MAG columns;
the reported uncertainty is set to 9.99 mag.

______________________________________________________________________________________________

Note:  Null values are now indicated by the character string "null"

*/


CREATE TABLE catalogdb.catwise (
    source_name VARCHAR(21),
    source_id VARCHAR(25),
    ra DOUBLE PRECISION,
    dec DOUBLE PRECISION,
    sigra REAL,
    sigdec REAL,
    sigradec REAL,
    wx REAL,
    wy REAL,
    w1sky REAL,
    w1sigsk REAL,
    w1conf REAL,
    w2sky REAL,
    w2sigsk REAL,
    w2conf REAL,
    w1fitr REAL,
    w2fitr REAL,
    w1snr REAL,
    w2snr REAL,
    w1flux DOUBLE PRECISION,
    w1sigflux DOUBLE PRECISION,
    w2flux DOUBLE PRECISION,
    w2sigflux DOUBLE PRECISION,
    w1mpro REAL,
    w1sigmpro DOUBLE PRECISION,
    w1rchi2 DOUBLE PRECISION,
    w2mpro REAL,
    w2sigmpro DOUBLE PRECISION,
    w2rchi2 DOUBLE PRECISION,
    rchi2 DOUBLE PRECISION,
    nb SMALLINT,
    na SMALLINT,
    w1Sat DOUBLE PRECISION,
    w2Sat DOUBLE PRECISION,
    w1mag REAL,
    w1sigm REAL,
    w1flg INTEGER,
    w1Cov REAL,
    w2mag REAL,
    w2sigm REAL,
    w2flg INTEGER,
    w2Cov REAL,
    w1mag_1 REAL,
    w1sigm_1 REAL,
    w1flg_1 BIGINT,
    w2mag_1 REAL,
    w2sigm_1 REAL,
    w2flg_1 BIGINT,
    w1mag_2 REAL,
    w1sigm_2 REAL,
    w1flg_2 BIGINT,
    w2mag_2 REAL,
    w2sigm_2 REAL,
    w2flg_2 BIGINT,
    w1mag_3 REAL,
    w1sigm_3 REAL,
    w1flg_3 BIGINT,
    w2mag_3 REAL,
    w2sigm_3 REAL,
    w2flg_3 BIGINT,
    w1mag_4 REAL,
    w1sigm_4 REAL,
    w1flg_4 BIGINT,
    w2mag_4 REAL,
    w2sigm_4 REAL,
    w2flg_4 BIGINT,
    w1mag_5 REAL,
    w1sigm_5 REAL,
    w1flg_5 BIGINT,
    w2mag_5 REAL,
    w2sigm_5 REAL,
    w2flg_5 BIGINT,
    w1mag_6 REAL,
    w1sigm_6 REAL,
    w1flg_6 BIGINT,
    w2mag_6 REAL,
    w2sigm_6 REAL,
    w2flg_6 BIGINT,
    w1mag_7 REAL,
    w1sigm_7 REAL,
    w1flg_7 BIGINT,
    w2mag_7 REAL,
    w2sigm_7 REAL,
    w2flg_7 BIGINT,
    w1mag_8 REAL,
    w1sigm_8 REAL,
    w1flg_8 BIGINT,
    w2mag_8 REAL,
    w2sigm_8 REAL,
    w2flg_8 BIGINT,
    w1NM BIGINT,
    w1M INTEGER,
    w1magP REAL,
    w1sigP1 REAL,
    w1sigP2 REAL,
    w1k REAL,
    w1Ndf INTEGER,
    w1mLQ REAL,
    w1mJDmin DOUBLE PRECISION,
    w1mJDmax DOUBLE PRECISION,
    w1mJDmean DOUBLE PRECISION,
    w2NM BIGINT,
    w2M INTEGER,
    w2magP REAL,
    w2sigP1 REAL,
    w2sigP2 REAL,
    w2k REAL,
    w2Ndf INTEGER,
    w2mLQ REAL,
    w2mJDmin DOUBLE PRECISION,
    w2mJDmax DOUBLE PRECISION,
    w2mJDmean DOUBLE PRECISION,
    rho12 SMALLINT,
    q12 SMALLINT,
    nIters BIGINT,
    nSteps BIGINT,
    mdetID BIGINT,
    p1 DOUBLE PRECISION,
    p2 DOUBLE PRECISION,
    MeanObsMJD DOUBLE PRECISION,
    ra_pm DOUBLE PRECISION,
    dec_pm DOUBLE PRECISION,
    sigra_pm REAL,
    sigdec_pm REAL,
    sigradec_pm REAL,
    PMRA REAL,
    PMDec REAL,
    sigPMRA REAL,
    sigPMDec REAL,
    w1snr_pm REAL,
    w2snr_pm REAL,
    w1flux_pm DOUBLE PRECISION,
    w1sigflux_pm DOUBLE PRECISION,
    w2flux_pm DOUBLE PRECISION,
    w2sigflux_pm DOUBLE PRECISION,
    w1mpro_pm REAL,
    w1sigmpro_pm REAL,
    w1rchi2_pm DOUBLE PRECISION,
    w2mpro_pm REAL,
    w2sigmpro_pm REAL,
    w2rchi2_pm DOUBLE PRECISION,
    rchi2_pm DOUBLE PRECISION,
    pmcode VARCHAR(5),
    nIters_pm BIGINT,
    nSteps_pm BIGINT,
    dist REAL,
    dw1mag REAL,
    rch2w1 REAL,
    dw2mag REAL,
    rch2w2 REAL,
    elon_avg DOUBLE PRECISION,
    elonSig REAL,
    elat_avg DOUBLE PRECISION,
    elatSig REAL,
    Delon REAL,
    DelonSig REAL,
    Delat REAL,
    DelatSig REAL,
    DelonSNR REAL,
    DelatSNR REAL,
    chi2pmra DOUBLE PRECISION,
    chi2pmdec DOUBLE PRECISION,
    ka INTEGER,
    k1 INTEGER,
    k2 INTEGER,
    km INTEGER,
    par_pm REAL,
    par_pmSig REAL,
    par_stat REAL,
    par_sigma REAL,
    dist_x DOUBLE PRECISION,
    cc_flags VARCHAR(16),
    w1cc_map BIGINT,
    w1cc_map_str VARCHAR(20),
    w2cc_map BIGINT,
    w2cc_map_str VARCHAR(20),
    n_aw INTEGER,
    ab_flags VARCHAR(9),
    w1ab_map BIGINT,
    w1ab_map_str VARCHAR(13),
    w2ab_map BIGINT,
    w2ab_map_str VARCHAR(13),
    glon DOUBLE PRECISION,
    glat DOUBLE PRECISION,
    elon DOUBLE PRECISION,
    elat DOUBLE PRECISION
);


--CREATE TABLE catalogdb.catwise_reject AS (SELECT * FROM catalogdb.catwise) WITH NO DATA;
--ALTER TABLE catalogdb.catwise_reject ADD COLUMN p BOOLEAN;
