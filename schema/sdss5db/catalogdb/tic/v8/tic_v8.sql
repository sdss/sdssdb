/*

schema for tess:

/uufs/chpc.utah.edu/common/home/sdss50/sdsswork/target/catalogs/tic/v8/tic_column_description.txt

*/

CREATE TABLE catalogdb.tic_v8 (
	id BIGINT PRIMARY KEY,
	version VARCHAR(8),
	hip INTEGER,
	tyc VARCHAR(12),
	ucac VARCHAR(10),
	twomass VARCHAR(20),
	sdss BIGINT,
	allwise VARCHAR(20),
	gaia BIGINT,
	apass VARCHAR(30),
	kic INTEGER,
	objtype VARCHAR(16),
	typesrc VARCHAR(16),
	ra DOUBLE PRECISION,
	dec DOUBLE PRECISION,
	posflag VARCHAR(12),
	pmra REAL,
	e_pmra REAL,
	pmdec REAL,
	e_pmdec REAL,
	pmflag VARCHAR(12),
	plx REAL,
	e_plx REAL,
	parflag VARCHAR(12),
	gallong DOUBLE PRECISION,
	gallat DOUBLE PRECISION,
	eclong DOUBLE PRECISION,
	eclat DOUBLE PRECISION,
	bmag REAL,
	e_bmag REAL,
	vmag REAL,
	e_vmag REAL,
	umag REAL,
	e_umag REAL,
	gmag REAL,
	e_gmag REAL,
	rmag REAL,
	e_rmag REAL,
	imag REAL,
	e_imag REAL,
	zmag REAL,
	e_zmag REAL,
	jmag REAL,
	e_jmag REAL,
	hmag REAL,
	e_hmag REAL,
	kmag REAL,
	e_kmag REAL,
	twomflag VARCHAR(20),
	prox REAL,
	w1mag REAL,
	e_w1mag REAL,
	w2mag REAL,
	e_w2mag REAL,
	w3mag REAL,
	e_w3mag REAL,
	w4mag REAL,
	e_w4mag REAL,
	gaiamag REAL,
	e_gaiamag REAL,
	tmag REAL,
	e_tmag REAL,
	tessflag VARCHAR(20),
	spflag VARCHAR(20),
	teff REAL,
	e_teff REAL,
	logg REAL,
	e_logg REAL,
	mh REAL,
	e_mh REAL,
	rad REAL,
	e_rad REAL,
	mass REAL,
	e_mass REAL,
	rho REAL,
	e_rho REAL,
	lumclass VARCHAR(10),
	lum REAL,
	e_lum REAL,
	d REAL,
    e_d REAL,
	ebv REAL,
	e_ebv REAL,
	numcont INTEGER,
	contratio REAL,
	disposition VARCHAR(10),
	duplicate_id BIGINT,
	priority REAL,
	eneg_ebv REAL,
	epos_ebv REAL,
	ebvflag VARCHAR(20),
	eneg_mass REAL,
	epos_mass REAL,
	eneg_rad REAL,
	epos_rad REAL,
	eneg_rho REAL,
	epos_rho REAL,
	eneg_logg REAL,
	epos_logg REAL,
	eneg_lum REAL,
	epos_lum REAL,
	eneg_dist REAL,
	epos_dist REAL,
	distflag VARCHAR(20),
	eneg_teff REAL,
	epos_teff REAL,
	tefflag VARCHAR(20),
	gaiabp REAL,
	e_gaiabp REAL,
	gaiarp REAL,
	e_gaiarp REAL,
	gaiaqflag INTEGER,
	starchareflag VARCHAR(20),
	vmagflag VARCHAR(20),
	bmagflag VARCHAR(20),
	splits VARCHAR(20),
	e_ra DOUBLE PRECISION,
	e_dec DOUBLE PRECISION,
	ra_orig DOUBLE PRECISION,
	dec_orig DOUBLE PRECISION,
	e_ra_orig DOUBLE PRECISION,
	e_dec_orig DOUBLE PRECISION,
	raddflag INTEGER,
	wdflag INTEGER,
	objid BIGINT
)  WITHOUT OIDS;
