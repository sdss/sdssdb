/*

BHM-SPIDERS eFEDS veto catalogue

* A minimalist catalogue of 6300 science targets in the SPIDERS eFEDS field
that received SDSS-IV spectroscopy during the March2020 SPIDERS observing run
(and hence are not in SDSS-SpecObj-DR16)
* Many of these objects have v low SNR and so we will want to observe them again,
but we will take account of this in the Carton code
* Available now on Utah systems under
* /uufs/chpc.utah.edu/common/home/sdss10/sdss5/target/catalogs/bhm_veto_lists/bhm_efeds_veto/v0.1.0/
* Datamodel:
  * This is a subset (in both rows and columns) of the spAll-v5_13_1.fits file
      * orig file from: https://data.sdss.org/sas/ebosswork/eboss/spectro/redux/v5_13_1/
      * orig data model at: https://data.sdss.org/datamodel/files/BOSS_SPECTRO_REDUX/RUN2D/spAll.html

  No. Type     EXTNAME      BITPIX Dimensions(columns)      PCOUNT  GCOUNT

   0  PRIMARY                  8     0                           0    1
   1  BINTABLE                 8     174(26) 6300                0    1

      Column Name                Format     Dims       Units     TLMIN  TLMAX
      1 PROGRAMNAME                5A
      2 CHUNK                      7A
      3 PLATESN2                   E
      4 PLATE                      J
      5 TILE                       J
      6 MJD                        J
      7 FIBERID                    J
      8 RUN2D                      7A
      9 RUN1D                      7A
     10 PLUG_RA                    D
     11 PLUG_DEC                   D
     12 Z_ERR                      E
     13 RCHI2                      E
     14 DOF                        J
     15 RCHI2DIFF                  E
     16 WAVEMIN                    E
     17 WAVEMAX                    E
     18 WCOVERAGE                  E
     19 ZWARNING                   J
     20 SN_MEDIAN                  5E
     21 SN_MEDIAN_ALL              E
     22 SPECTROFLUX                5E
     23 SPECTROFLUX_IVAR           5E
     24 ANYANDMASK                 J
     25 ANYORMASK                  J
     26 SPECOBJID                  K

Note: the SPECOBJID column overflows the data type so it was removed when
converting the FITS table to CSV.

*/

CREATE TABLE catalogdb.bhm_efeds_veto (
    programname VARCHAR(5),
    chunk VARCHAR(7),
    platesn2 REAL,
    plate INTEGER,
    tile INTEGER,
    mjd INTEGER,
    fiberid INTEGER,
    run2d VARCHAR(7),
    run1d VARCHAR(7),
    plug_ra DOUBLE PRECISION,
    plug_dec DOUBLE PRECISION,
    z_err REAL,
    rchi2 REAL,
    dof INTEGER,
    rchi2diff REAL,
    wavemin REAL,
    wavemax REAL,
    wcoverage REAL,
    zwarning INTEGER,
    sn_median REAL[5],
    sn_median_all REAL,
    spectroflux REAL[5],
    spectroflux_ivar REAL[5],
    anyandmask INTEGER,
    anyormask INTEGER
);

\COPY catalogdb.bhm_efeds_vetoexit
 FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/bhm_veto_lists/bhm_efeds_veto/v0.1.0/BHM_EFEDS_VETO_v0.1.0.csv WITH CSV HEADER DELIMITER E'\t' NULL '\N';

-- Query to create a new column with the correct specobjid. 1301 is the result of
-- (N-5)*10000+M*100+P for RUN2D v5_13_1 (see https://www.sdss.org/dr16/help/glossary/#specobj).
-- These specobjid are uint64 and larger than what can be stored as a BIGINT, so we're not
-- creating them for now.

-- ALTER TABLE catalogdb.bhm_efeds_vetoexit
 ADD COLUMN specobjid BIGINT;
-- UPDATE catalogdb.bhm_efeds_vetoexit

--     SET specobjid = (plate::bigint<<50 ) + (fiberid::bigint<<38) +
--                     ((mjd-50000)::bigint<<24) + (1301::bigint<<10);

-- CREATE INDEX ON catalogdb.bhm_efeds_vetoexit
 (specobjid);

CREATE INDEX ON catalogdb.bhm_efeds_vetoexit
 (mjd, plate, fiberid, run2d);

CREATE INDEX ON catalogdb.bhm_efeds_vetoexit
 (q3c_ang2ipix(plug_ra, plug_dec));
CLUSTER bhm_efeds_vetoexit
_q3c_ang2ipix_idx ON catalogdb.bhm_efeds_vetoexit
;
ANALYZE catalogdb.bhm_efeds_vetoexit
;
