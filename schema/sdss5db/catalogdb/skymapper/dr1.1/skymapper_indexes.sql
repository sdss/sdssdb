
CREATE INDEX ON catalogdb.skymapper_dr1_1 (q3c_ang2ipix(raj2000, decj2000));
CLUSTER skymapper_dr1_1_q3c_ang2ipix_idx ON catalogdb.skymapper_dr1_1;
ANALYZE catalogdb.skymapper_dr1_1;
