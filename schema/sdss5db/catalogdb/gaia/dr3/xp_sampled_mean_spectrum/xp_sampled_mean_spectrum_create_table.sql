-- This create table statement is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_spectroscopic_tables/ssec_dm_xp_sampled_mean_spectrum.html

create table catalogdb.gaia_dr3_xp_sampled_mean_spectrum(
source_id bigint,  -- Unique source identifier (unique within a particular Data Release) (long)
solution_id bigint,  -- Solution Identifier (long)
ra double precision,  -- Right Ascension (double, Angle[deg])
dec double precision,  -- Declination (double, Angle[deg])
flux text,  -- mean BP + RP combined spectrum flux (float[] array, Flux[W m−2 nm−1])
flux_error text  -- mean BP + RP combined spectrum flux error (float[] array, Flux[W m−2 nm−1])
);
