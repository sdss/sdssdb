
ALTER TABLE catalogdb.dr14q_v4_4 ADD PRIMARY KEY (pk);

CREATE INDEX ON catalogdb.dr14q_v4_4 (q3c_ang2ipix(ra, dec));
CLUSTER dr14q_v4_4_q3c_ang2ipix_idx ON catalogdb.dr14q_v4_4;
ANALYZE catalogdb.dr14q_v4_4;
