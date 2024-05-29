--
-- PostgreSQL database dump
--

-- Dumped from database version 10.17
-- Dumped by pg_dump version 10.17

-- Started on 2024-05-28 19:27:08 MDT

CREATE TABLE vizdb.plate (
    plate_id numeric(20,0) NOT NULL,
    first_release character varying(32) NOT NULL,
    plate smallint NOT NULL,
    mjd integer NOT NULL,
    mjd_list character varying(512) NOT NULL,
    survey character varying(32) NOT NULL,
    programname character varying(32) NOT NULL,
    instrument character varying(32) NOT NULL,
    chunk character varying(32) NOT NULL,
    plate_run character varying(32) NOT NULL,
    design_comments character varying(128),
    quality character varying(32) NOT NULL,
    quality_comments character varying(100) NOT NULL,
    plate_sn2 real NOT NULL,
    dered_sn2 real NOT NULL,
    racen double precision NOT NULL,
    deccen double precision NOT NULL,
    run2d character varying(32) NOT NULL,
    run1d character varying(32),
    runsspp character varying(32),
    tile smallint,
    design_id integer NOT NULL,
    location_id integer NOT NULL,
    iop_version character varying(64),
    cam_version character varying(64),
    tai_hms character varying(64),
    date_obs character varying(24) NOT NULL,
    time_sys character varying(8),
    cx double precision NOT NULL,
    cy double precision NOT NULL,
    cz double precision NOT NULL,
    cartridge_id smallint NOT NULL,
    tai double precision NOT NULL,
    tai_begin double precision NOT NULL,
    tai_end double precision NOT NULL,
    airmass real NOT NULL,
    map_mjd integer NOT NULL,
    map_name character varying(32) NOT NULL,
    plug_file character varying(32) NOT NULL,
    exp_time real NOT NULL,
    exp_time_b1 real NOT NULL,
    exp_time_b2 real NOT NULL,
    exp_time_r1 real NOT NULL,
    exp_time_r2 real NOT NULL,
    vers2d character varying(32) NOT NULL,
    verscomb character varying(32) NOT NULL,
    vers1d character varying(32) NOT NULL,
    snturnoff real NOT NULL,
    nturnoff real NOT NULL,
    n_exp smallint NOT NULL,
    n_exp_b1 smallint NOT NULL,
    n_exp_b2 smallint NOT NULL,
    n_exp_r1 smallint NOT NULL,
    n_exp_r2 smallint NOT NULL,
    sn1_g real NOT NULL,
    sn1_r real NOT NULL,
    sn1_i real NOT NULL,
    sn2_g real NOT NULL,
    sn2_r real NOT NULL,
    sn2_i real NOT NULL,
    dered_sn1_g real NOT NULL,
    dered_sn1_r real NOT NULL,
    dered_sn1_i real NOT NULL,
    dered_sn2_g real NOT NULL,
    dered_sn2_r real NOT NULL,
    dered_sn2_i real NOT NULL,
    helio_rv real NOT NULL,
    g_off_std real NOT NULL,
    g_rms_std real NOT NULL,
    r_off_std real NOT NULL,
    r_rms_std real NOT NULL,
    i_off_std real NOT NULL,
    i_rms_std real NOT NULL,
    gr_off_std real NOT NULL,
    gr_rms_std real NOT NULL,
    ri_off_std real NOT NULL,
    ri_rms_std real NOT NULL,
    g_off_gal real NOT NULL,
    g_rms_gal real NOT NULL,
    r_off_gal real NOT NULL,
    r_rms_gal real NOT NULL,
    i_off_gal real NOT NULL,
    i_rms_gal real NOT NULL,
    gr_off_gal real NOT NULL,
    gr_rms_gal real NOT NULL,
    ri_off_gal real NOT NULL,
    ri_rms_gal real NOT NULL,
    n_guide integer NOT NULL,
    seeing20 real NOT NULL,
    seeing50 real NOT NULL,
    seeing80 real NOT NULL,
    rmsoff20 real NOT NULL,
    rmsoff50 real NOT NULL,
    rmsoff80 real NOT NULL,
    airtemp real NOT NULL,
    sfd_used smallint NOT NULL,
    x_sigma real NOT NULL,
    x_sig_min real NOT NULL,
    x_sig_max real NOT NULL,
    w_sigma real NOT NULL,
    w_sig_min real NOT NULL,
    w_sig_max real NOT NULL,
    x_chi2 real NOT NULL,
    x_chi2_min real NOT NULL,
    x_chi2_max real NOT NULL,
    sky_chi2 real NOT NULL,
    sky_chi2_min real NOT NULL,
    sky_chi2_max real NOT NULL,
    f_bad_pix real NOT NULL,
    f_bad_pix1 real NOT NULL,
    f_bad_pix2 real NOT NULL,
    status2d character varying(32) NOT NULL,
    statuscombine character varying(32) NOT NULL,
    status1d character varying(32) NOT NULL,
    n_total integer NOT NULL,
    n_galaxy integer NOT NULL,
    n_qso integer NOT NULL,
    n_star integer NOT NULL,
    n_sky integer NOT NULL,
    n_unknown integer NOT NULL,
    is_best smallint NOT NULL,
    is_primary smallint NOT NULL,
    is_tile smallint NOT NULL,
    ha real NOT NULL,
    mjd_design integer NOT NULL,
    theta real NOT NULL,
    fscan_version character varying(32),
    fmap_version character varying(32),
    fscan_mode character varying(32),
    fscan_speed integer NOT NULL,
    htm_id bigint NOT NULL,
    load_version integer NOT NULL,
    racen_hms character varying(12),
    deccen_dms character varying(12),
    tree_id smallint DEFAULT 18 NOT NULL
);


ALTER TABLE vizdb.plate OWNER TO sdss;

--
-- TOC entry 198 (class 1259 OID 9310029)
-- Name: specobj; Type: TABLE; Schema: vizdb; Owner: sdss
--

CREATE TABLE vizdb.specobj (
    specobj_id numeric(20,0) NOT NULL,
    bestobj_id bigint,
    fluxobj_id bigint,
    targetobj_id bigint,
    plate_id numeric(20,0),
    science_primary smallint,
    sdss_primary smallint,
    legacy_primary smallint,
    segue_primary smallint,
    segue1_primary smallint,
    segue2_primary smallint,
    boss_primary smallint,
    boss_specobj_id integer NOT NULL,
    first_release character varying(32),
    survey character varying(32) NOT NULL,
    instrument character varying(32),
    programname character varying(32) NOT NULL,
    chunk character varying(32) NOT NULL,
    plate_run character varying(32),
    mjd integer NOT NULL,
    plate smallint NOT NULL,
    fiberid smallint NOT NULL,
    run1d character varying(32),
    run2d character varying(32) NOT NULL,
    tile integer NOT NULL,
    design_id integer NOT NULL,
    legacy_target1 bigint,
    legacy_target2 bigint,
    special_target1 bigint,
    special_target2 bigint,
    segue1_target1 bigint,
    segue1_target2 bigint,
    segue2_target1 bigint,
    segue2_target2 bigint,
    boss_target1 bigint,
    eboss_target0 bigint,
    ancillary_target1 bigint,
    ancillary_target2 bigint,
    prim_target bigint NOT NULL,
    sec_target bigint NOT NULL,
    spectrograph_id smallint,
    source_type character varying(128),
    target_type character varying(128),
    ra double precision NOT NULL,
    "dec" double precision NOT NULL,
    cx double precision,
    cy double precision,
    cz double precision,
    x_focal real NOT NULL,
    y_focal real NOT NULL,
    lambda_eff real NOT NULL,
    blue_fiber integer NOT NULL,
    zoffset real NOT NULL,
    z real NOT NULL,
    zerr real NOT NULL,
    zwarning integer NOT NULL,
    objclass character varying(32),
    subclass character varying(32),
    r_chi2 real NOT NULL,
    dof real NOT NULL,
    r_chi2_diff real NOT NULL,
    z_noqso real NOT NULL,
    zerr_noqso real NOT NULL,
    zwarning_noqso integer NOT NULL,
    class_noqso character varying(32),
    subclass_noqso character varying(32),
    r_chi2_diff_noqso real NOT NULL,
    z_person real,
    class_person character varying(32),
    comments_person character varying(200),
    tfile character varying(32),
    tcolumn_0 smallint NOT NULL,
    tcolumn_1 smallint NOT NULL,
    tcolumn_2 smallint NOT NULL,
    tcolumn_3 smallint NOT NULL,
    tcolumn_4 smallint NOT NULL,
    tcolumn_5 smallint NOT NULL,
    tcolumn_6 smallint NOT NULL,
    tcolumn_7 smallint NOT NULL,
    tcolumn_8 smallint NOT NULL,
    tcolumn_9 smallint NOT NULL,
    npoly real NOT NULL,
    theta_0 real NOT NULL,
    theta_1 real NOT NULL,
    theta_2 real NOT NULL,
    theta_3 real NOT NULL,
    theta_4 real NOT NULL,
    theta_5 real NOT NULL,
    theta_6 real NOT NULL,
    theta_7 real NOT NULL,
    theta_8 real NOT NULL,
    theta_9 real NOT NULL,
    vel_disp real NOT NULL,
    vel_disp_err real NOT NULL,
    vel_disp_z real NOT NULL,
    vel_disp_zerr real NOT NULL,
    vel_disp_chi2 real NOT NULL,
    vel_disp_npix integer NOT NULL,
    vel_disp_dof integer NOT NULL,
    wave_min real NOT NULL,
    wave_max real NOT NULL,
    wcoverage real NOT NULL,
    sn_median_u real NOT NULL,
    sn_median_g real NOT NULL,
    sn_median_r real NOT NULL,
    sn_median_i real NOT NULL,
    sn_median_z real NOT NULL,
    sn_median real NOT NULL,
    chi68p real NOT NULL,
    frac_n_sigma_1 real NOT NULL,
    frac_n_sigma_2 real NOT NULL,
    frac_n_sigma_3 real NOT NULL,
    frac_n_sigma_4 real NOT NULL,
    frac_n_sigma_5 real NOT NULL,
    frac_n_sigma_6 real NOT NULL,
    frac_n_sigma_7 real NOT NULL,
    frac_n_sigma_8 real NOT NULL,
    frac_n_sigma_9 real NOT NULL,
    frac_n_sigma_10 real NOT NULL,
    frac_n_sig_hi_1 real NOT NULL,
    frac_n_sig_hi_2 real NOT NULL,
    frac_n_sig_hi_3 real NOT NULL,
    frac_n_sig_hi_4 real NOT NULL,
    frac_n_sig_hi_5 real NOT NULL,
    frac_n_sig_hi_6 real NOT NULL,
    frac_n_sig_hi_7 real NOT NULL,
    frac_n_sig_hi_8 real NOT NULL,
    frac_n_sig_hi_9 real NOT NULL,
    frac_n_sig_hi_10 real NOT NULL,
    frac_n_sig_lo_1 real NOT NULL,
    frac_n_sig_lo_2 real NOT NULL,
    frac_n_sig_lo_3 real NOT NULL,
    frac_n_sig_lo_4 real NOT NULL,
    frac_n_sig_lo_5 real NOT NULL,
    frac_n_sig_lo_6 real NOT NULL,
    frac_n_sig_lo_7 real NOT NULL,
    frac_n_sig_lo_8 real NOT NULL,
    frac_n_sig_lo_9 real NOT NULL,
    frac_n_sig_lo_10 real NOT NULL,
    spectro_flux_u real NOT NULL,
    spectro_flux_g real NOT NULL,
    spectro_flux_r real NOT NULL,
    spectro_flux_i real NOT NULL,
    spectro_flux_z real NOT NULL,
    spectro_syn_flux_u real NOT NULL,
    spectro_syn_flux_g real NOT NULL,
    spectro_syn_flux_r real NOT NULL,
    spectro_syn_flux_i real NOT NULL,
    spectro_syn_flux_z real NOT NULL,
    spectro_flux_ivar_u real NOT NULL,
    spectro_flux_ivar_g real NOT NULL,
    spectro_flux_ivar_r real NOT NULL,
    spectro_flux_ivar_i real NOT NULL,
    spectro_flux_ivar_z real NOT NULL,
    spectro_syn_flux_ivar_u real NOT NULL,
    spectro_syn_flux_ivar_g real NOT NULL,
    spectro_syn_flux_ivar_r real NOT NULL,
    spectro_syn_flux_ivar_i real NOT NULL,
    spectro_syn_flux_ivar_z real NOT NULL,
    spectro_sky_flux_u real NOT NULL,
    spectro_sky_flux_g real NOT NULL,
    spectro_sky_flux_r real NOT NULL,
    spectro_sky_flux_i real NOT NULL,
    spectro_sky_flux_z real NOT NULL,
    any_and_mask integer NOT NULL,
    any_or_mask integer NOT NULL,
    plate_sn2 real NOT NULL,
    dered_sn2 real NOT NULL,
    sn_turnoff real,
    sn1_g real,
    sn1_r real,
    sn1_i real,
    sn2_g real,
    sn2_r real,
    sn2_i real,
    elodie_filename character varying(32),
    elodie_object character varying(32),
    elodie_sp_type character varying(32),
    elodie_bv real NOT NULL,
    elodie_t_eff real NOT NULL,
    elodie_logg real NOT NULL,
    elodie_fe_h real NOT NULL,
    elodie_z real NOT NULL,
    elodie_zerr real NOT NULL,
    elodie_zmodelerr real NOT NULL,
    elodie_r_chi2 real NOT NULL,
    elodie_dof real NOT NULL,
    htm_id bigint,
    load_version integer,
    ra_hms character varying(12),
    dec_dms character varying(12),
    specprimary smallint DEFAULT 0 NOT NULL,
    tree_id smallint DEFAULT 18 NOT NULL,
    eboss_target1 bigint,
    eboss_target2 bigint,
    eboss_target_id bigint,
    thing_id_targeting bigint,
    thing_id integer,
    catalogid bigint,
    field smallint,
    sdssv_boss_target0 bigint
);


ALTER TABLE vizdb.specobj OWNER TO sdss;

--
-- TOC entry 3548 (class 2606 OID 9310052)
-- Name: plate plate_pkey; Type: CONSTRAINT; Schema: vizdb; Owner: sdss
--

ALTER TABLE ONLY vizdb.plate
    ADD CONSTRAINT plate_pkey PRIMARY KEY (tree_id, plate_id);


--
-- TOC entry 3550 (class 2606 OID 9310054)
-- Name: plate plate_plate_id_tree_id_key; Type: CONSTRAINT; Schema: vizdb; Owner: sdss
--

ALTER TABLE ONLY vizdb.plate
    ADD CONSTRAINT plate_plate_id_tree_id_key UNIQUE (plate_id, tree_id);


--
-- TOC entry 3556 (class 2606 OID 9310056)
-- Name: specobj specobj_pkey; Type: CONSTRAINT; Schema: vizdb; Owner: sdss
--

ALTER TABLE ONLY vizdb.specobj
    ADD CONSTRAINT specobj_pkey PRIMARY KEY (tree_id, specobj_id);


--
-- TOC entry 3559 (class 2606 OID 9310059)
-- Name: specobj specobj_specobj_id_tree_id_key; Type: CONSTRAINT; Schema: vizdb; Owner: sdss
--

ALTER TABLE ONLY vizdb.specobj
    ADD CONSTRAINT specobj_specobj_id_tree_id_key UNIQUE (specobj_id, tree_id);


--
-- TOC entry 3551 (class 1259 OID 9310061)
-- Name: plate_tree_id_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX plate_tree_id_ix ON vizdb.plate USING btree (tree_id);


--
-- TOC entry 3552 (class 1259 OID 9310062)
-- Name: plate_tree_id_mjd_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX plate_tree_id_mjd_ix ON vizdb.plate USING btree (tree_id, mjd);


--
-- TOC entry 3553 (class 1259 OID 9310063)
-- Name: plate_tree_id_plate_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX plate_tree_id_plate_ix ON vizdb.plate USING btree (tree_id, plate);


--
-- TOC entry 3554 (class 1259 OID 9310064)
-- Name: plate_tree_id_plate_mjd_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX plate_tree_id_plate_mjd_ix ON vizdb.plate USING btree (tree_id, plate, mjd);


--
-- TOC entry 3557 (class 1259 OID 9310065)
-- Name: specobj_plate_mjd_id_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX specobj_plate_mjd_id_ix ON vizdb.specobj USING btree (plate, mjd);


--
-- TOC entry 3560 (class 1259 OID 9310066)
-- Name: specobj_tree_id_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX specobj_tree_id_ix ON vizdb.specobj USING btree (tree_id);


--
-- TOC entry 3561 (class 1259 OID 9310067)
-- Name: specobj_tree_id_mjd_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX specobj_tree_id_mjd_ix ON vizdb.specobj USING btree (tree_id, mjd);


--
-- TOC entry 3562 (class 1259 OID 9310069)
-- Name: specobj_tree_id_plate_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX specobj_tree_id_plate_ix ON vizdb.specobj USING btree (tree_id, plate);


--
-- TOC entry 3563 (class 1259 OID 9310070)
-- Name: specobj_tree_id_plate_mjd_ix; Type: INDEX; Schema: vizdb; Owner: sdss
--

CREATE INDEX specobj_tree_id_plate_mjd_ix ON vizdb.specobj USING btree (tree_id, plate, mjd);

