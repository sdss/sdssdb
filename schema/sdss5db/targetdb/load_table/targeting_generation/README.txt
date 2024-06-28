Notes by T. Dwelly (dwelly@mpe.mpg.de)

This is some background about how we reverse engineered the target_generation
tables in preparation for DR19


# get the robostrategy versions from targetdb.version

sdss5db=> select * from targetdb.version where robostrategy;
 pk  |          plan          |                     tag                      | target_selection | robostrategy
-----+------------------------+----------------------------------------------+------------------+--------------
  61 | test-newfield          | test                                         | f                | t
  90 | epsilon-2-core-1       | test                                         | f                | t
 105 | epsilon-7-core-0       | epsilon-7-core-0 simulation for commisioning | f                | t
 118 | zeta-0                 | zeta-0_2022_02_24                            | f                | t
 124 | zeta-3                 | zeta-3                                       | f                | t
 125 | zeta-4-commissioning-0 | zeta-4-commissioning-0                       | f                | t
 192 | eta-6                  | eta-6                                        | f                | t
 193 | eta-7                  | eta-7                                        | f                | t
 188 | eta-3                  | eta-3                                        | f                | t
 189 | eta-4                  | eta-4                                        | f                | t
 190 | eta-5                  | eta-5                                        | f                | t
 194 | eta-8                  | eta-8                                        | f                | t
 197 | eta-9                  | eta-9                                        | f                | t
(13 rows)



These are the subset of robostrategy runs I think were included in BOSS/IPL-3 i.e. DR19:

# robostrategy plan version_pk  targeting_generation    date range
 n/a                       n/a 'v0_plates'*            MJD 59146-59392
zeta-0                     118 'v0.5.2'                MJD 59640-59801
zeta-3                     124 'v0.5.5'                MJD 59803-60130
epsilon-7-core-0**         105 ***                     MJD 59586-59731  (purely commissioning?)
'manual'                   n/a TBD                     MJD 59564-60106

This was derived by joining the list of designids in ipl-3/fieldlist-v6_1_3.fits
to a list of confSummary metadata (which gives the robostrategy plan that was in place when the configuration was observed).

Note that 'v0.5.3' targeting generation was associated with zeta-1 which was never loaded into targetdb (and so has no version_pk)

we'll create a separeate targeting_generation v0.5.epsilon-7-core-0 to handle epsilon-7-core-0

But we'll keep it in the database because we released it in DR18

For completeness we will also want to include eta-3 to eta-9 and zeta-4-commissioning-0

This is the content of targeting_generation.csv:
pk,label,first_release
1,v0.plates,dr19
2,v0.5.epsilon-7-core-0,dr19
3,v0.5.2,dr19
4,v0.5.3,dr18
5,v0.5.5,dr19
6,v1.0.2,dr20
7,v1.0.3,dr20
8,v1.0.4,dr20



The mapping of targeting_generation to version_pk can be extracted from rsconfig:

gawk '$1~/\[Cartons\]/ {flag=1} $1=="version" && flag==1 {printf("%-30s %8s\n",FILENAME,$3); flag=0} ' etc/robostrategy-eta-?.cfg etc/robostrategy-zeta-?.cfg 

etc/robostrategy-eta-3.cfg        1.0.2
etc/robostrategy-eta-4.cfg        1.0.2
etc/robostrategy-eta-5.cfg        1.0.2
etc/robostrategy-eta-6.cfg        1.0.3
etc/robostrategy-eta-7.cfg        1.0.4
etc/robostrategy-eta-8.cfg        1.0.4
etc/robostrategy-zeta-0.cfg       0.5.2
etc/robostrategy-zeta-1.cfg       0.5.3
etc/robostrategy-zeta-2.cfg       0.5.4
etc/robostrategy-zeta-3.cfg       0.5.5
etc/robostrategy-zeta-4.cfg       0.5.5
# note that zeta-4 is same as zeta-4-commissioning-0

Combining this info, then targeting_generation_to_version.csv contains:

generation_pk,version_pk  | notes
2,105                     (epsilon-7-core-0, v0.5.epsilon-7-core-0)
3,118                     (zeta-0, v0.5.2)
5,124                     (zeta-3, v0.5.5)
5,125                     (zeta-4-commissioning-0, v0.5.5)
6,188                      (eta-3, v1.0.2)
6,189                      (eta-4, v1.0.2)
6,190                      (eta-5, v1.0.2)
7,192                      (eta-6, v1.0.3)
8,193                      (eta-7, v1.0.4)
8,194                      (eta-8, v1.0.4)
8,197                      (eta-9, v1.0.4???????)


# now - populating the 'targeting_generation_to_carton.csv' file

# work from teh relevant robostrategy config files:
# first get a list of all possible cartons+versions

\copy (select c.pk,c.carton,v.plan from carton as c join targetdb.version as v on c.version_pk = v.pk) TO '/home/tdwelly/scratch/carton_versions.psv' with CSV header DELIMITER '|'
 

declare -A TG_PK

TG_PK["0.5.2"]="3"
TG_PK["0.5.3"]="4"
TG_PK["0.5.5"]="5"
TG_PK["1.0.2"]="6"
TG_PK["1.0.3"]="7"
TG_PK["1.0.4"]="8"
TG_PK["epsilon-7-core-0"]="2"
TG_PK["0.plates"]="1"

rm ~/scratch/targeting_generation_to_carton.csv
echo "generation_pk,carton_pk" >  ~/scratch/targeting_generation_to_carton.csv
for TG in "0.5.2" "0.5.3" "0.5.5" "1.0.2" "1.0.3" "1.0.4"; do
    gawk -v tg_pk="${TG_PK[${TG}]}" --field-separator='|' '\
    ARGIND==1 {c_p=sprintf("%s#%s", $2, $3);pk[c_p]=$1;} \
    ARGIND>=2 && $2!~/carton/ {\
        gsub(/ /,"",$2);gsub(/ /,"",$3); \
        c_p=sprintf("%s#%s", $2, $3); \
        printf("%s,%s\n",tg_pk,pk[c_p])\
    }' ~/scratch/carton_versions.psv etc/cartons-${TG}.txt >> ~/scratch/targeting_generation_to_carton.csv
done


# now deal with epsilon-7-core-0
# go straight to the rs config file

TG=epsilon-7-core-0
gawk -v tg_pk="${TG_PK[${TG}]}" '\
ARGIND==1 {FS="|"; c_p=sprintf("%s#%s", $2, $3);pk[c_p]=$1;} \
ARGIND>=2 {FS=" ";} \
ARGIND>=2 && $1~/\[CartonsExtra\]/ {flag=0} \
ARGIND>=2 && flag==1 && NF == 3 {\
    c_p=sprintf("%s#%s", $1, $3); \
    printf("%s,%s\n",tg_pk,pk[c_p]);} \
ARGIND>=2 && $1~/\[Cartons\]/ {flag=1} \
' ~/scratch/carton_versions.psv etc/robostrategy-${TG}.cfg >> ~/scratch/targeting_generation_to_carton.csv
    

# now deal with v0.plates
# look at manual files generated by Nathan and Me:

~/SDSSV/dr19/minidb/bhm_cartons_v0.txt
~/SDSSV/dr19/minidb/mwm_cartons_v0.txt

REMEMBER THAT WE NEED TO ADD OPS CARTONS

# just extract info manually:

# these are thecarton-versions we need:

 carton_pk |                  carton                   | version_pk | plan  |  tag
-----------+-------------------------------------------+------------+-------+-------
       278 | bhm_aqmes_med                             |         49 | 0.1.0 | 0.1.0
       280 | bhm_aqmes_med-faint                       |         49 | 0.1.0 | 0.1.0
       286 | bhm_aqmes_wide3                           |         49 | 0.1.0 | 0.1.0
       287 | bhm_aqmes_wide3-faint                     |         49 | 0.1.0 | 0.1.0
       288 | bhm_aqmes_wide2                           |         49 | 0.1.0 | 0.1.0
       289 | bhm_aqmes_wide2-faint                     |         49 | 0.1.0 | 0.1.0
       290 | bhm_aqmes_bonus-dark                      |         49 | 0.1.0 | 0.1.0
       291 | bhm_aqmes_bonus-bright                    |         49 | 0.1.0 | 0.1.0
       307 | bhm_csc_boss-dark                         |         49 | 0.1.0 | 0.1.0
       308 | bhm_csc_boss-bright                       |         49 | 0.1.0 | 0.1.0
       309 | bhm_csc_apogee                            |         49 | 0.1.0 | 0.1.0
       310 | bhm_gua_dark                              |         49 | 0.1.0 | 0.1.0
       311 | bhm_gua_bright                            |         49 | 0.1.0 | 0.1.0
       340 | bhm_rm_core                               |         49 | 0.1.0 | 0.1.0
       341 | bhm_rm_known-spec                         |         49 | 0.1.0 | 0.1.0
       342 | bhm_rm_var                                |         49 | 0.1.0 | 0.1.0
       343 | bhm_rm_ancillary                          |         49 | 0.1.0 | 0.1.0
       356 | bhm_spiders_agn-efeds                     |         49 | 0.1.0 | 0.1.0
       357 | bhm_spiders_clusters-efeds-sdss-redmapper |         49 | 0.1.0 | 0.1.0
       358 | bhm_spiders_clusters-efeds-hsc-redmapper  |         49 | 0.1.0 | 0.1.0
       359 | bhm_spiders_clusters-efeds-ls-redmapper   |         49 | 0.1.0 | 0.1.0
       360 | bhm_spiders_clusters-efeds-erosita        |         49 | 0.1.0 | 0.1.0

"carton_pk"|"carton"|"version_pk"|"plan"|"tag"
126|"mwm_snc_100pc"       |49|"0.1.0"|"0.1.0"
127|"mwm_snc_250pc"       |49|"0.1.0"|"0.1.0"
128|"mwm_cb_300pc"        |49|"0.1.0"|"0.1.0"
134|"mwm_cb_cvcandidates" |49|"0.1.0"|"0.1.0"
140|"mwm_halo_sm"	  |49|"0.1.0"|"0.1.0"
143|"mwm_halo_bb"	  |49|"0.1.0"|"0.1.0"
144|"mwm_yso_s1"	  |49|"0.1.0"|"0.1.0"
145|"mwm_yso_s2"	  |49|"0.1.0"|"0.1.0"
146|"mwm_yso_s2-5"	  |49|"0.1.0"|"0.1.0"
147|"mwm_yso_s3"	  |49|"0.1.0"|"0.1.0"
148|"mwm_yso_ob"	  |49|"0.1.0"|"0.1.0"
149|"mwm_yso_cmz"	  |49|"0.1.0"|"0.1.0"
150|"mwm_yso_cluster"	  |49|"0.1.0"|"0.1.0"
158|"mwm_rv_long-fps"	  |49|"0.1.0"|"0.1.0"
160|"mwm_rv_long-bplates" |49|"0.1.0"|"0.1.0"
163|"mwm_ob_cepheids"	  |49|"0.1.0"|"0.1.0"
164|"mwm_rv_short-fps"	  |49|"0.1.0"|"0.1.0"
165|"mwm_rv_short-bplates"|49|"0.1.0"|"0.1.0"
236|"mwm_ob_core"	  |49|"0.1.0"|"0.1.0"
241|"mwm_rv_short-rm"     |49|"0.1.0"|"0.1.0"
242|"mwm_rv_long-rm"      |49|"0.1.0"|"0.1.0"
259|"mwm_wd_core"         |49|"0.1.0"|"0.1.0"
273|"mwm_gg_core"         |49|"0.1.0"|"0.1.0"
274|"mwm_planet_tess"     |49|"0.1.0"|"0.1.0"
279|"mwm_cb_gaiagalex"    |49|"0.1.0"|"0.1.0"
281|"mwm_tessrgb_core"    |49|"0.1.0"|"0.1.0"
361|"mwm_cb_uvex1"        |49|"0.1.0"|"0.1.0"
362|"mwm_cb_uvex2"        |49|"0.1.0"|"0.1.0"
363|"mwm_dust_core"       |49|"0.1.0"|"0.1.0"
364|"mwm_cb_uvex3"        |49|"0.1.0"|"0.1.0"
366|"mwm_cb_uvex4"        |49|"0.1.0"|"0.1.0"
367|"mwm_cb_uvex5"        |49|"0.1.0"|"0.1.0"
375|"mwm_legacy_ir2opt"   |54|"0.1.1"|"0.1.1"
378|"mwm_rv_long_bplates" |62|"0.1.4"|"0.1.5"
### 769|"mwm_erosita_stars"|81|"0.0.0-test"|NULL  - this has been dropped

# get the ops cartons via a simple search of targetdb - NEEDS CHECKING

sdss5db=> select
    c.pk as carton_pk,
    c.carton,v.pk as version_pk,
    v.plan,v.tag
from carton as c
join targetdb.version as v
    on c.version_pk = v.pk
where carton ~ 'ops' and
      v.plan < '0.3.0'
order by c.pk;
 carton_pk |       carton       | version_pk |    plan    |  tag
-----------+--------------------+------------+------------+-------
       257 | ops_std_boss       |         49 | 0.1.0      | 0.1.0
       319 | ops_std_eboss      |         49 | 0.1.0      | 0.1.0
       325 | ops_sky_apogee     |         49 | 0.1.0      | 0.1.0
       351 | ops_std_boss-red   |         49 | 0.1.0      | 0.1.0
       368 | ops_sky_boss       |         49 | 0.1.0      | 0.1.0
       376 | ops_apogee_stds    |         55 | 0.1.2      | 0.1.2
       377 | ops_std_boss_tic   |         56 | 0.1.3      | 0.1.4
       522 | ops_std_boss_lsdr8 |         81 | 0.0.0-test |
       526 | ops_std_boss_tic   |         81 | 0.0.0-test |
(9 rows)

echo "1,278
1,280
1,286
1,287
1,288
1,289
1,290
1,291
1,307
1,308
1,309
1,310
1,311
1,340
1,341
1,342
1,343
1,356
1,357
1,358
1,359
1,360
1,126
1,127
1,128
1,134
1,140
1,143
1,144
1,145
1,146
1,147
1,148
1,149
1,150
1,158
1,160
1,163
1,164
1,165
1,236
1,241
1,242
1,259
1,273
1,274
1,279
1,281
1,361
1,362
1,363
1,364
1,366
1,367
1,375
1,378
1,257
1,319
1,325
1,351
1,368
1,376
1,377" >> ~/scratch/targeting_generation_to_carton.csv


cp ~/scratch/targeting_generation_to_carton.csv ~/SDSSV/gitwork/sdssdb/schema/sdss5db/targetdb/load_table/targeting_generation
 

\cd /home/dwelly/SDSSV/gitwork/sdssdb/schema/sdss5db/targetdb/load_table/targeting_generation

# now do a test load into sandbox (replace targetdb with sandbox)

CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_temp (
    pk INTEGER,
    label TEXT,
    first_release TEXT
);

\copy targeting_generation_temp FROM 'targeting_generation.csv' WITH CSV HEADER;

CREATE TABLE IF NOT EXISTS sandbox.targeting_generation (
    pk INTEGER,
    label TEXT,
    first_release TEXT
);

INSERT INTO sandbox.targeting_generation (pk, label, first_release)
    SELECT * FROM targeting_generation_temp ON CONFLICT DO NOTHING;



CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    generation_pk INTEGER,
    carton_pk INTEGER
);

\copy targeting_generation_to_carton_temp FROM 'targeting_generation_to_carton.csv' WITH CSV HEADER;

CREATE TABLE IF NOT EXISTS sandbox.targeting_generation_to_carton (
    generation_pk INTEGER,
    carton_pk INTEGER
);

INSERT INTO sandbox.targeting_generation_to_carton (generation_pk, carton_pk)
    SELECT * FROM targeting_generation_to_carton_temp ON CONFLICT DO NOTHING;


CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_version_temp (
    generation_pk INTEGER,
    version_pk INTEGER
);

\copy targeting_generation_to_version_temp FROM 'targeting_generation_to_version.csv' WITH CSV HEADER;

CREATE TABLE IF NOT EXISTS sandbox.targeting_generation_to_version (
    generation_pk INTEGER,
    version_pk INTEGER
);

INSERT INTO sandbox.targeting_generation_to_version (generation_pk, version_pk)
    SELECT * FROM targeting_generation_to_version_temp ON CONFLICT DO NOTHING;



# do some test queries:

sdss5db=> select c.pk,c.carton,v.plan,count(*),array_agg(tg.label),min(tg.first_release) from sandbox.targeting_generation_to_carton as tg2c join carton as c on tg2c.carton_pk = c.pk join targetdb.version as v on c.version_pk = v.pk join sandbox.targeting_generation as tg on tg2c.generation_pk = tg.pk where tg.first_release <= 'dr19' group by c.pk,c.carton,v.plan;

etc etc
