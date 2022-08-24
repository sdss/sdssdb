-- https://dc.zah.uni-heidelberg.de/tableinfo/gedr3spur.main
-- https://dc.zah.uni-heidelberg.de/getRR/gedr3spur/q/main

alter table catalogdb.gedr3spur_main add primary key (source_id);

create index on catalogdb.gedr3spur_main (fidelity_v2);

create index on catalogdb.gedr3spur_main (fidelity_v1);

