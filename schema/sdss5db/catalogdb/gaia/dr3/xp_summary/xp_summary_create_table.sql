-- This table is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_spectroscopic_tables/ssec_dm_xp_summary.html

create table catalogdb.gaia_dr3_xp_summary(
source_id bigint,  -- Unique source identifier (unique within a particular Data Release) (long)
solution_id bigint,  -- Solution Identifier (long)
bp_n_relevant_bases smallint,  -- Number of bases that are relevant for the representation of this mean BP spectrum (short)
bp_relative_shrinking real,  -- Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean BP spectrum (float)
bp_n_measurements smallint,  -- Number of measurements used for the BP spectrum generation (short)
bp_n_rejected_measurements smallint,  -- Number of rejected measurements in the BP spectrum generation (short)
bp_standard_deviation real,  -- Standard deviation for the BP spectrum representation (float, Flux[e− pix−1 s−1])
bp_chi_squared real,  -- Chi squared for the BP spectrum representation (float)
bp_n_transits smallint,  -- Number of transits contributing to the mean in BP (short)
bp_n_contaminated_transits smallint,  -- Number of contaminated transits in BP (short)
bp_n_blended_transits smallint,  -- Number of blended transits in BP (short)
rp_n_relevant_bases smallint,  -- Number of bases that are relevant for the representation of this mean RP spectrum (short)
rp_relative_shrinking real,  -- Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean RP spectrum (float)
rp_n_measurements smallint,  -- Number of measurements used for the RP spectrum generation (short)
rp_n_rejected_measurements smallint,  -- Number of rejected measurements in the RP spectrum generation (short)
rp_standard_deviation real,  -- Standard deviation for the RP spectrum representation (float, Flux[e− pix−1 s−1])
rp_chi_squared real,  -- Chi squared for the RP spectrum representation (float)
rp_n_transits smallint,  -- Number of transits contributing to the mean in RP (short)
rp_n_contaminated_transits smallint,  -- Number of contaminated transits in RP (short)
rp_n_blended_transits smallint  -- Number of blended transits in RP (short)
);