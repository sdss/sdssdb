-- This table is based on the below link.
-- https://gea.esac.esa.int/archive/documentation/GDR3/Gaia_archive/chap_datamodel/sec_dm_variability_tables/ssec_dm_vari_rrlyrae.html

create table catalogdb.gaia_dr3_vari_rrlyrae(
solution_id bigint,  -- Solution Identifier (long)
source_id bigint,  -- Unique source identifier (long)
pf double precision,  -- Period corresponding to the fundamental pulsation mode in the G band time series (double, Time[day])
pf_error real,  -- Uncertainty of the pf period (float, Time[day])
p1_o double precision,  -- Period corresponding to the first overtone pulsation mode in the G band time series (double, Time[day])
p1_o_error real,  -- Uncertainty of the p1_o period (float, Time[day])
epoch_g double precision,  -- Epoch of the maximum of the light curve in the G band (double, Time[Barycentric JD in TCB −
epoch_g_error float,  -- Uncertainty on the epoch parameter epoch_g (float, Time[day])
epoch_bp double precision,  -- Epoch of the maximum of the light curve in the BP band (double, Time[Barycentric JD in TCB −
epoch_bp_error real,  -- Uncertainty on the epoch parameter epoch_bp (float, Time[day])
epoch_rp double precision,  -- Epoch of the maximum of the light curve in the RP band (double, Time[Barycentric JD in TCB −
epoch_rp_error real,  -- Uncertainty on the epoch parameter epoch_rp (float, Time[day])
epoch_rv double precision,  -- Epoch of the minimum of the radial velocity curve (double, Time[Barycentric JD in TCB −
epoch_rv_error real,  -- Uncertainty on the epoch parameter epoch_rv (float, Time[day])
int_average_g real,  -- Intensity-averaged magnitude in the G band (float, Magnitude[mag])
int_average_g_error real,  -- Uncertainty on int_average_g parameter (float, Magnitude[mag])
int_average_bp real,  -- Intensity-averaged magnitude in the BP band (float, Magnitude[mag])
int_average_bp_error real,  -- Uncertainty on int_average_bp parameter (float, Magnitude[mag])
int_average_rp real,  -- Intensity-averaged magnitude in the RP band (float, Magnitude[mag])
int_average_rp_error real,  -- Uncertainty on int_average_rp parameter (float, Magnitude[mag])
average_rv real,  -- Mean radial velocity (float, Velocity[km s−1
average_rv_error real,  -- Uncertainty on average_rv parameter (float, Velocity[km s−1
peak_to_peak_g real,  -- Peak-to-peak amplitude of the G band light curve (float, Magnitude[mag])
peak_to_peak_g_error real,  -- Uncertainty on the peak_to_peak_g parameter (float, Magnitude[mag])
peak_to_peak_bp real,  -- Peak-to-peak amplitude of the BP band light curve (float, Magnitude[mag])
peak_to_peak_bp_error real,  -- Uncertainty on the peak_to_peak_bp parameter (float, Magnitude[mag])
peak_to_peak_rp real,  -- Peak-to-peak amplitude of the RP band light curve (float, Magnitude[mag])
peak_to_peak_rp_error real,  -- Uncertainty on the peak_to_peak_rp parameter (float, Magnitude[mag])
peak_to_peak_rv double precision,  -- Peak-to-peak amplitude of the radial velocity curve (double, Velocity[km s−1
peak_to_peak_rv_error double precision,  -- Uncertainty on the peak_to_peak_rv parameter (double, Velocity[km s−1
metallicity real,  -- Metallicity of the star from the Fourier parameters of the light curve (float, Abundances[dex])
metallicity_error real,  -- Uncertainty of the metallicity parameter (float, Abundances[dex])
r21_g real,  -- Fourier decomposition parameter r21_g: A2/A1 (for G band) (float)
r21_g_error real,  -- Uncertainty on the r21_g parameter: A2/A1 (for G band) (float)
r31_g real,  -- Fourier decomposition parameter r31_g: A3/A1 (for G band) (float)
r31_g_error real,  -- Uncertainty on the r31_g parameter: A3/A1 (for G band) (float)
phi21_g real,  -- Fourier decomposition parameter phi21_g: phi2 - 2*phi1 (for G band) (float, Angle[rad])
phi21_g_error real,  -- Uncertainty on the phi21_g parameter: phi2 - 2*phi1 (for G band) (float, Angle[rad])
phi31_g real,  -- Fourier decomposition parameter phi31_g: phi3 - 3*phi1 (for G band) (float, Angle[rad])
phi31_g_error real,  -- Uncertainty on the phi31_g parameter: phi3 - 3*phi1 (for G band) (float, Angle[rad])
num_clean_epochs_g smallint,  -- Number of G FoV epochs used in the fitting algorithm (short)
num_clean_epochs_bp smallint,  -- Number of BP epochs used in the fitting algorithm (short)
num_clean_epochs_rp smallint,  -- Number of RP epochs used in the fitting algorithm (short)
num_clean_epochs_rv smallint,  -- Number of radial velocity epochs used in the fitting algorithm (short)
zp_mag_g real,  -- Zero point (mag) of the final model of the G band light curve (float, Magnitude[mag])
zp_mag_bp real,  -- Zero point (mag) of the final model of the BP band light curve (float, Magnitude[mag])
zp_mag_rp real,  -- Zero point (mag) of the final model of the RP band light curve (float, Magnitude[mag])
num_harmonics_for_p1_g smallint,  -- Number of harmonics used to model the first periodicity of the G-band light curve (byte)
num_harmonics_for_p1_bp smallint,  -- Number of harmonics used to model the first periodicity of the BP-band light curve (byte)
num_harmonics_for_p1_rp smallint,  -- Number of harmonics used to model the first periodicity of the RP-band light curve (byte)
num_harmonics_for_p1_rv smallint,  -- Number of harmonics used to model the first periodicity of the radial velocity curve (byte)
reference_time_g double precision,  -- Reference time of the Fourier modelled G-band light curve (double, Time[Barycentric JD in TCB −
reference_time_bp double precision,  -- Reference time of the Fourier modelled BP-band light curve (double, Time[Barycentric JD in TCB −
reference_time_rp double precision,  -- Reference time of the Fourier modelled RP-band light curve (double, Time[Barycentric JD in TCB −
reference_time_rv double precision,  -- Reference time of the Fourier modelled radial velocity curve (double, Time[Barycentric JD in TCB −
fund_freq1 double precision,  -- First frequency of the non-linear Fourier modelling (double, Frequency[day−1
fund_freq1_error real,  -- Error of the first frequency of the non-linear Fourier modelling (float, Frequency[day−1
fund_freq2 double precision,  -- Second frequency of the non-linear Fourier modelling in the G band (double, Frequency[day−1
fund_freq2_error real,  -- Error of the second frequency of the non-linear Fourier modelling in the G band (float, Frequency[day−1
fund_freq1_harmonic_ampl_g text,  -- Amplitudes of the Fourier model for the first frequency in the G band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_ampl_g_error text,  -- Errors of the amplitudes of the Fourier model for the first frequency in the G band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_phase_g text,  -- Phases of the Fourier model for the first frequency in the G band (float[16] array, Angle[rad])
fund_freq1_harmonic_phase_g_error text,  -- Errors of the phases of the Fourier model for the first frequency in the G band (float[16] array, Angle[rad])
fund_freq1_harmonic_ampl_bp text,  -- Amplitudes of the Fourier model for the first frequency in the BP band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_ampl_bp_error text,  -- Errors of the amplitudes of the Fourier model for the first frequency in the BP band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_phase_bp text,  -- Phases of the Fourier model for the first frequency in the BP band (float[16] array, Angle[rad])
fund_freq1_harmonic_phase_bp_error text,  -- Errors of the phases of the Fourier model for the first frequency in the BP band (float[16] array, Angle[rad])
fund_freq1_harmonic_ampl_rp text,  -- Amplitudes of the Fourier model for the first frequency in the RP band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_ampl_rp_error text,  -- Errors of the amplitudes of the Fourier model for the first frequency in the RP band (float[16] array, Magnitude[mag])
fund_freq1_harmonic_phase_rp text,  -- Phases of the Fourier model for the first frequency in the RP band (float[16] array, Angle[rad])
fund_freq1_harmonic_phase_rp_error text,  -- Errors of the phases of the Fourier model for the first frequency in the RP band (float[16] array, Angle[rad])
fund_freq1_harmonic_ampl_rv text,  -- Amplitudes of the Fourier model for the first frequency of the radial velocity curve (float[16] array, Velocity[km s−1
fund_freq1_harmonic_ampl_rv_error text,  -- Errors of the amplitudes of the Fourier model for the first frequency of the radial velocity curve (float[16] array, Velocity[km s−1
fund_freq1_harmonic_phase_rv text,  -- Phases of the Fourier model for the first frequency of the radial velocity curve (float[16] array, Angle[rad])
fund_freq1_harmonic_phase_rv_error text,  -- Errors of the phases of the Fourier model for the first frequency of the radial velocity curve (float[16] array, Angle[rad])
best_classification text,  -- Best RR Lyrae classification estimate out of: ‘RRc’, ‘RRab’, ‘RRd’ (string)
g_absorption real,  -- Interstellar absorption in the G-band (float, Magnitude[mag])
g_absorption_error real  -- Error on the interstellar absorption in the G-band (float, Magnitude[mag])
);
