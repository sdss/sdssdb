
select
    subq.designation, subq.ra, subq.decl, twomassBrightNeighbor(subq.ra, subq.decl, subq.designation, subq.h_m)
    from
        (
            select * from catalogdb.twomass_psc as tm
            where
                tm.h_m<11 and
                (tm.ph_qual like '_A_' or tm.ph_qual like '_B_') and
                tm.cc_flg like '_0_' and
                tm.gal_contam = '0' and
                (tm.rd_flg like '_1_' or tm.rd_flg like '_2_')
        ) as subq;