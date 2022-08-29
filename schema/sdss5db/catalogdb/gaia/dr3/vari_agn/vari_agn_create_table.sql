-- This table is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_variability_tables/ssec_dm_vari_agn.html

create table catalogdb.gaia_dr3_vari_agn(
solution_id bigint,  -- Solution Identifier (long)
source_id bigint,  -- Unique source identifier (long)
fractional_variability_g real,  -- Fractional variability in the G band (float)
structure_function_index real,  -- Index of the first-order structure function in the G band (float)
structure_function_index_scatter real,  -- Standard deviation of the index of the structure function (float)
qso_variability real,  -- Quasar variability metric in the G band (float)
non_qso_variability real  -- Non-quasar variability metric in the G band (float)
);