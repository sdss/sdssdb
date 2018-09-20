/*

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


agn:
    name = 'eRO_detUID'; format = '32A'
    name = 'eRO_souUID'; format = '14A'
    name = 'eRO_RA'; format = 'D'; unit = 'deg'
    name = 'eRO_DEC'; format = 'D'; unit = 'deg'
    name = 'eRO_RADEC_ERR'; format = 'E'; unit = 'arcsec'
    name = 'eRO_DET_LIKE_0'; format = 'E'
    name = 'eRO_FLUX'; format = 'E'; unit = 'erg/cm2/s'
    name = 'eRO_FLUX_ERR'; format = 'E'; unit = 'erg/cm2/s'
    name = 'ALLWISE_designation'; format = '20A'
    name = 'GAIA_DR2_source_id'; format = 'K'
    name = 'NSC_DR1_id'; format = '16A'
    name = 'SDSS_DR14_objID'; format = 'K'
    name = 'TARGET_ORIGIN'; format = 'J'
    name = 'TARGET_MATCH_PROB'; format = 'E'
    name = 'TARGET_PRIORITY'; format = 'J'
    name = 'TARGET_RA'; format = 'D'; unit = 'deg'
    name = 'TARGET_DEC'; format = 'D'; unit = 'deg'
    name = 'TARGET_PMRA'; format = 'E'; unit = 'mas/yr'
    name = 'TARGET_PMDEC'; format = 'E'; unit = 'mas/yr'
    name = 'TARGET_MAG_r'; format = 'E'; unit = 'mag,AB'
    name = 'TARGET_MAGERR_r'; format = 'E'; unit = 'mag'
    name = 'T_EXP'; format = 'D'; unit = 'minutes'


clusters:
    name = 'eRO_detUID'; format = '32A'
    name = 'eRO_souUID'; format = '14A'
    name = 'eRO_RA'; format = 'D'; unit = 'deg'
    name = 'eRO_DEC'; format = 'D'; unit = 'deg'
    name = 'eRO_RADEC_ERR'; format = 'E'; unit = 'arcsec'
    name = 'eRO_DET_LIKE_0'; format = 'E'
    name = 'eRO_FLUX'; format = 'E'; unit = 'erg/cm2/s'
    name = 'eRO_FLUX_ERR'; format = 'E'; unit = 'erg/cm2/s'
    name = 'ALLWISE_designation'; format = '20A'
    name = 'GAIA_DR2_source_id'; format = 'K'
    name = 'NSC_DR1_id'; format = '16A'
    name = 'SDSS_DR14_objID'; format = 'K'
    name = 'TARGET_ORIGIN'; format = 'J'
    name = 'TARGET_MATCH_PROB'; format = 'E'
    name = 'TARGET_PRIORITY'; format = 'J'
    name = 'TARGET_RA'; format = 'D'; unit = 'deg'
    name = 'TARGET_DEC'; format = 'D'; unit = 'deg'
    name = 'TARGET_PMRA'; format = 'E'; unit = 'mas/yr'
    name = 'TARGET_PMDEC'; format = 'E'; unit = 'mas/yr'
    name = 'TARGET_MAG_r'; format = 'E'; unit = 'mag,AB'
    name = 'TARGET_MAGERR_r'; format = 'E'; unit = 'mag'
    name = 'eRO_EXT'; format = 'E'; unit = 'arcsec'
    name = 'eRO_EXT_ERR'; format = 'E'; unit = 'arcsec'
    name = 'eRO_EXT_LIKE'; format = 'E'
    name = 'T_EXP'; format = 'D'; unit = 'minutes'

FITS format code         Description                     8-bit bytes

L                        logical (Boolean)               1
X                        bit                             *
B                        Unsigned byte                   1
I                        16-bit integer                  2
J                        32-bit integer                  4
K                        64-bit integer                  4
A                        character                       1
E                        single precision floating point 4
D                        double precision floating point 8
C                        single precision complex        8
M                        double precision complex        16
P                        array descriptor                8
Q                        array descriptor                16

*/


CREATE TABLE catalogdb.erosita_agn_mock (
    eRO_detUID text,
    eRO_souUID text,
    eRO_RA double precision,
    eRO_DEC double precision,
    eRO_RADEC_ERR real,
    eRO_DET_LIKE_0 real,
    eRO_FLUX real,
    eRO_FLUX_ERR real,
    ALLWISE_designation text,
    GAIA_DR2_source_id bigint,
    NSC_DR1_id text,
    SDSS_DR14_objID bigint,
    TARGET_ORIGIN integer,
    TARGET_MATCH_PROB real,
    TARGET_PRIORITY integer,
    TARGET_RA double precision,
    TARGET_DEC double precision,
    TARGET_PMRA real,
    TARGET_PMDEC real,
    TARGET_MAG_r real,
    TARGET_MAGERR_r real,
    T_EXP double precision
    );

CREATE TABLE catalogdb.erosita_clusters_mock (
    eRO_detUID text,
    eRO_souUID text,
    eRO_RA double precision,
    eRO_DEC double precision,
    eRO_RADEC_ERR real,
    eRO_DET_LIKE_0 real,
    eRO_FLUX real,
    eRO_FLUX_ERR real,
    ALLWISE_designation text,
    GAIA_DR2_source_id bigint,
    NSC_DR1_id text,
    SDSS_DR14_objID bigint,
    TARGET_ORIGIN integer,
    TARGET_MATCH_PROB real,
    TARGET_PRIORITY integer,
    TARGET_RA double precision,
    TARGET_DEC double precision,
    TARGET_PMRA real,
    TARGET_PMDEC real,
    TARGET_MAG_r real,
    TARGET_MAGERR_r real,
    eRO_EXT real,
    eRO_EXT_ERR real,
    eRO_EXT_LIKE real,
    T_EXP double precision
    );




