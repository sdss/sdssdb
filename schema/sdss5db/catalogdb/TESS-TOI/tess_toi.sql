/*

TESS Targets of Opportunity

Original file /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/TESSobserved/TESS_Observed.fits
converted to CSV with

t = table.Table.read('./TESS_Observed.fits')
t.convert_bytestring_to_unicode()
t.to_pandas().to_csv('./TESS_Observed.csv', index=False)

*/

CREATE TABLE catalogdb.tess_toi (
    ticid BIGINT,
    target_type VARCHAR(8),
    toi VARCHAR(32),
    tess_disposition VARCHAR(2),
    tfopwg_disposition VARCHAR(2),
    ctoi VARCHAR(32),
    user_disposition VARCHAR(2),
    num_sectors REAL
) WITHOUT OIDS;

\COPY catalogdb.tess_toi FROM /uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/TESSobserved/TESS_Observed.csv WITH CSV HEADER DELIMITER ',';

ALTER TABLE catalogdb.tess_toi ADD COLUMN pk BIGSERIAL PRIMARY KEY;
