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
 216 | theta-1                | theta-1                                      | f                | t
 (14 rows)



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

we'll create a separate targeting_generation v0.5.epsilon-7-core-0 to handle epsilon-7-core-0

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
9,v1.0.5,dr20



The mapping of targeting_generation to version_pk can be extracted from rsconfig:

gawk '$1~/\[Cartons\]/
    {flag=1}
$1=="version" && flag==1
    {printf("%-30s %8s\n",FILENAME,$3);
     flag=0;}
     ' ~/SDSSV/gitwork/rsconfig/etc/robostrategy-eta-?.cfg ~/SDSSV/gitwork/rsconfig/etc/robostrategy-zeta-?.cfg 

etc/robostrategy-eta-3.cfg        1.0.2
etc/robostrategy-eta-4.cfg        1.0.2
etc/robostrategy-eta-5.cfg        1.0.2
etc/robostrategy-eta-6.cfg        1.0.3
etc/robostrategy-eta-7.cfg        1.0.4
etc/robostrategy-eta-8.cfg        1.0.4
etc/robostrategy-eta-9.cfg        1.0.4
etc/robostrategy-theta-1.cfg      1.0.5
etc/robostrategy-zeta-0.cfg       0.5.2
etc/robostrategy-zeta-1.cfg       0.5.3
etc/robostrategy-zeta-2.cfg       0.5.4
etc/robostrategy-zeta-3.cfg       0.5.5
etc/robostrategy-zeta-4.cfg       0.5.5
# note that zeta-4 is same as zeta-4-commissioning-0

Combining this info, then targeting_generation_to_version.csv contains:

generation_pk,version_pk  | notes (not added to csv)
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
8,197                      (eta-9, v1.0.4)
9,216                    (theta-1, v1.0.5)

# now - populating the 'targeting_generation_to_carton.csv' file

# work from the relevant robostrategy config files:
# first get a list of all possible cartons+versions

\copy (select c.pk,c.carton,v.plan from carton as c join targetdb.version as v on c.version_pk = v.pk) TO '/home/tdwelly/SDSSV/dr19/minidb/carton_versions.psv' with CSV header DELIMITER '|'
 

# here's the mapping from category to category_pk
sdss5db=> select * from category;
 pk |        label         
----+----------------------
  0 | science
  1 | standard_apogee
  2 | standard_boss
  3 | guide
  4 | sky_apogee
  5 | sky_boss
  8 | open_fiber
  6 | standard
  7 | sky
  9 | veto_location_boss
 10 | veto_location_apogee
 11 | ops_sky
(12 rows)

\copy (select pk,label from category) TO '/home/tdwelly/SDSSV/dr19/minidb/category.psv' with CSV header DELIMITER '|'

# we can actually ignore the category because the carton_pk is already linked to a category_pk in targetdb!!

declare -A TG_PK

#TG_LIST="0.5.2 0.5.3 0.5.5 1.0.2 1.0.3 1.0.4 1.0.5"
TG_LIST="1.0.5"
TG_PK["0.5.2"]="3"
TG_PK["0.5.3"]="4"
TG_PK["0.5.5"]="5"
TG_PK["1.0.2"]="6"
TG_PK["1.0.3"]="7"
TG_PK["1.0.4"]="8"
TG_PK["1.0.5"]="9"
TG_PK["epsilon-7-core-0"]="2"
TG_PK["0.plates"]="1"

OUTFILE=~/SDSSV/dr19/minidb/targeting_generation_to_carton.csv
RSCONFIG=~/SDSSV/gitwork/rsconfig

echo "generation_pk,carton_pk,rs_stage,rs_active" > $OUTFILE

for TG in $TG_LIST; do
    gawk -v tg_pk="${TG_PK[${TG}]}" \
    --field-separator='|' '\
    ARGIND==1 {c_p=sprintf("%s#%s", $2, $3);pk[c_p]=$1;} \
    ARGIND>=2 && $2!~/carton/ {\
        for(i=1;i<=NF;i++){gsub(/ /,"",$i);} \
        c_p=sprintf("%s#%s", $2, $3); \
        printf("%s,%s,%s,%s\n",tg_pk,pk[c_p],$5,($6=="y"?"true":"false"))\
    }' ~/SDSSV/dr19/minidb/carton_versions.psv ${RSCONFIG}/etc/cartons-${TG}.txt >> $OUTFILE
done


# now deal with epsilon-7-core-0
# go straight to the rs config file
# have to make up the stage,active flags

TG=epsilon-7-core-0
gawk -v tg_pk="${TG_PK[${TG}]}" '\
BEGIN {stage = "0"} \
ARGIND==1 {FS="|"; c_p=sprintf("%s#%s", $2, $3);pk[c_p]=$1;} \
ARGIND>=2 {FS=" ";} \
ARGIND>=2 && ($1~/\[CartonsExtra\]/ || $1~/\[CartonsOpenPriorityAdjust\]/) {stage="0"} \
ARGIND>=2 && stage!="0" && NF == 3 {\
    c_p=sprintf("%s#%s", $1, $3); \
    printf("%s,%s,%s,%s\n",tg_pk,pk[c_p],stage,"true");} \
ARGIND>=2 && $1~/\[Cartons\]/ {stage="srd"} \
ARGIND>=2 && $1~/\[CartonsOpen\]/ {stage="open"} \
' ~/SDSSV/dr19/minidb/carton_versions.psv ${RSCONFIG}/etc/robostrategy-${TG}.cfg >> ${OUTFILE}
    

# now deal with v0.plates
# look at manual files generated by Nathan and Me:

~/SDSSV/dr19/minidb/bhm_cartons_v0.txt
~/SDSSV/dr19/minidb/mwm_cartons_v0.txt

REMEMBER THAT WE ALSO NEED TO ADD OPS CARTONS


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
      and not plan = '0.0.0-test'
order by c.pk;

 carton_pk |      carton      | version_pk | plan  |  tag
-----------+------------------+------------+-------+-------
       257 | ops_std_boss     |         49 | 0.1.0 | 0.1.0
       319 | ops_std_eboss    |         49 | 0.1.0 | 0.1.0
       325 | ops_sky_apogee   |         49 | 0.1.0 | 0.1.0
       351 | ops_std_boss-red |         49 | 0.1.0 | 0.1.0
       368 | ops_sky_boss     |         49 | 0.1.0 | 0.1.0
       376 | ops_apogee_stds  |         55 | 0.1.2 | 0.1.2
       377 | ops_std_boss_tic |         56 | 0.1.3 | 0.1.4
(7 rows)

# So, easiest to go back and make a clean db query following the rules above - these are the carton-versions we need:

\copy (select c.pk as carton_pk,c.carton,c.version_pk,v.plan from carton as c join targetdb.version as v on c.version_pk = v.pk where (carton ~ 'bhm' or carton ~ 'mwm' or carton ~ 'ops') and v.plan < '0.3.0' and not plan = '0.0.0-test' order by c.pk) TO '/home/tdwelly/SDSSV/dr19/minidb/targeting_generation_0.plates.psv' with CSV header DELIMITER '|'

# format into desired shape:

TG="0.plates"
gawk -v tg_pk="${TG_PK[${TG}]}" \
    --field-separator='|' '// {n++; \
if(n>1) { \
stage="plates"; \
printf("%s,%s,%s,%s\n",tg_pk,$1,stage,"true");} \
}' ~/SDSSV/dr19/minidb/targeting_generation_0.plates.psv >> ${OUTFILE}


cp $OUTFILE ~/SDSSV/gitwork/sdssdb/schema/sdss5db/targetdb/load_table/targeting_generation/
 
# psql -h localhost -p 7502 -U sdss_user -d sdss5db
\cd /home/dwelly/SDSSV/gitwork/sdssdb/schema/sdss5db/targetdb/load_table/targeting_generation

# now do a test load into sandbox (replacing targetdb with sandbox)

CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_temp (
    pk INTEGER,
    label TEXT,
    first_release TEXT
);
TRUNCATE targeting_generation_temp;

\copy targeting_generation_temp FROM 'targeting_generation.csv' WITH CSV HEADER;

CREATE TABLE IF NOT EXISTS sandbox.targeting_generation (
    pk SERIAL PRIMARY KEY NOT NULL,
    label TEXT,
    first_release TEXT
);

ALTER TABLE sandbox.targeting_generation DROP CONSTRAINT IF EXISTS targeting_generation_uniq_key;
ALTER TABLE sandbox.targeting_generation ADD CONSTRAINT targeting_generation_uniq_key UNIQUE (label);

INSERT INTO sandbox.targeting_generation (pk, label, first_release)
    SELECT * FROM targeting_generation_temp ON CONFLICT DO NOTHING;

# reset the sequence
SELECT setval('sandbox.targeting_generation_pk_seq', coalesce(max(pk), 0) + 1, false) 
FROM sandbox.targeting_generation;


CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    generation_pk INTEGER,
    carton_pk INTEGER,
    rs_stage TEXT,
    rs_active BOOLEAN
);
TRUNCATE targeting_generation_to_carton_temp;

\copy targeting_generation_to_carton_temp FROM 'targeting_generation_to_carton.csv' WITH CSV HEADER;


CREATE TABLE IF NOT EXISTS sandbox.targeting_generation_to_carton (
    generation_pk INTEGER,
    carton_pk INTEGER,
    rs_stage TEXT,
    rs_active BOOLEAN
);
ALTER TABLE sandbox.targeting_generation_to_carton DROP CONSTRAINT IF EXISTS targeting_generation_to_carton_pk_key;
ALTER TABLE sandbox.targeting_generation_to_carton ADD CONSTRAINT targeting_generation_to_carton_pk_key UNIQUE (generation_pk,carton_pk);
# TRUNCATE sandbox.targeting_generation_to_carton;
 
INSERT INTO sandbox.targeting_generation_to_carton (generation_pk, carton_pk, rs_stage, rs_active)
    SELECT * FROM targeting_generation_to_carton_temp ON CONFLICT DO NOTHING;


CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_version_temp (
    generation_pk INTEGER,
    version_pk INTEGER
);
TRUNCATE targeting_generation_to_version_temp;

\copy targeting_generation_to_version_temp FROM 'targeting_generation_to_version.csv' WITH CSV HEADER;

CREATE TABLE IF NOT EXISTS sandbox.targeting_generation_to_version (
    pk SERIAL PRIMARY KEY NOT NULL,
    generation_pk INTEGER,
    version_pk INTEGER
);

ALTER TABLE sandbox.targeting_generation_to_version DROP CONSTRAINT IF EXISTS targeting_generation_to_version_uniq_key;
ALTER TABLE sandbox.targeting_generation_to_version ADD CONSTRAINT targeting_generation_to_version_uniq_key UNIQUE (generation_pk,version_pk);
# TRUNCATE sandbox.targeting_generation_to_version;

INSERT INTO sandbox.targeting_generation_to_version (generation_pk, version_pk)
    SELECT * FROM targeting_generation_to_version_temp ON CONFLICT DO NOTHING;



# do some test queries:

sdss5db=> select c.pk,c.carton,v.plan,count(*),
array_agg(distinct tg.label),
array_agg(distinct tgv.plan),
min(tg.first_release)
from sandbox.targeting_generation_to_carton as tg2c
join carton as c
  on tg2c.carton_pk = c.pk
join targetdb.version as v
  on c.version_pk = v.pk
join sandbox.targeting_generation as tg
  on tg2c.generation_pk = tg.pk
left outer join sandbox.targeting_generation_to_version as tg2v
  on tg2c.generation_pk = tg2v.generation_pk
left outer join targetdb.version as tgv
  on tg2v.version_pk = tgv.pk
where tg.first_release >= 'dr20'
group by c.pk,c.carton,v.plan
order by c.pk;

etc etc
