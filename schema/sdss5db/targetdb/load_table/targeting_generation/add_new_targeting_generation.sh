#!/bin/bash

module load rsconfig  # this sets $RSCONFIG_DIR

SCHEMA=sandbox
SQLFILE="-"
DR="dr20"
TEMP_DIR='.'

usage ()
{
    echo "
Description:
    This script is intended to be run after a new robostrategy run has been 
    ingested into the sdssdb.taregetdb. 
    It will produce sql scripts which:
      1) interpret the rsconfig entry for the given rs_plan 
      2) add a new entry to targetdb.targeting_generation
      3) add a new entry to targetdb.targeting_generation_to_version
      4) add a new set of entries to targetdb.targeting_generation_to_carton

Usage:
    ${0##*/} \\
       [-p|--rsrun RSPLAN   - The name of the robostrategy run (e.g. 'theta-1' )
       [-c|--rsconfig DIR]  - Override the location of the rsconfig product (e.g. $RSCONFIG_DIR )
       [-q|--sqlfile FILE]  - The name of the output loading script ("-" writes to stdout )
       [-s|--schema SCHEMA] - Which DB schema to write to? (e.g. targetdb or sandbox)
       [-d|--dr drxx]       - What is the first data release associated with this targeting_generation?
       [-t|--tempdir DIR]   - Where to write temporary files?
       [-h|--help]          - Print this help and exit"
    # exit 1
}


orig_cmds=$@
while [ "$1" != "" ]; do
    case $1 in
        -p | --rsplan )      shift
                             RSPLAN="$1"
                             ;;
        -c | --rsconfig )    shift
                             RSCONFIG_DIR="$1"
                             ;;
        -q | --sqlfile )     shift
                             SQLFILE="$1"
                             ;;
        -s | --schema  )     shift
                             SCHEMA="$1"
                             ;;
        -d | --dr  )         shift
                             DR="$1"
                             ;;
        -t | --tempdir )     shift
                             TEMP_DIR="$1"
                             ;;
        -h | --help )        usage
                             exit
                             ;;
        * )                  usage
                             exit 1
    esac
    shift
done




# first search for this rsplan within the rsconfig products

RSCONFIG_FILE=${RSCONFIG_DIR}/etc/robostrategy-${RSPLAN}.cfg

# check that input exists
if [ ! -f "${RSCONFIG_FILE}" ]; then
    echo "ERROR: Required input file does not exist: $RSCONFIG_FILE"
    usage
    exit 1
fi

# extract the targeting_generation from the config file
TG=`awk 'flag==1 && $1=="version" {print $NF; exit} $1=="[Cartons]" {flag=1}'  $RSCONFIG_FILE`
TGV="v${TG}"

# check that tg is non-null
if [ "$TG" = "" ]; then
    echo "ERROR: Could not find targeting_generation from ${RSCONFIG_FILE}"
    usage
    exit 1
fi

# search for the carton config within the rsconfig products

RSCARTON_FILE=${RSCONFIG_DIR}/etc/cartons-${TG}.txt
RSCARTONCSV_FILE=${TEMP_DIR}/cartons-${TG}.csv


# check that input exists
if [ ! -f "${RSCARTON_FILE}" ]; then
    echo "ERROR: Required input file does not exist: $RSCARTON_FILE"
    usage
    exit 1
fi

# convert to sql
awk --field-separator='|' '//{for (i=1;i<=NF;i++){gsub(/ /,"",$i);}; printf("%s,%s,%s,%s\n",$2,$3,$5,$6)}' $RSCARTON_FILE > $RSCARTONCSV_FILE

echo "# Working on robostrategy plan=$RSPLAN and targeting_generation=$TGV"
echo "# db schema=$SCHEMA first_release=$DR"
echo "# RSCONFIG_FILE=$RSCONFIG_FILE"
echo "# RSCARTON_FILE=$RSCARTON_FILE"
echo "# RSCARTONCSV_FILE=$RSCARTONCSV_FILE"
echo "# Output written to: $SQLFILE"

# now write the SQL
Q="
ALTER TABLE ${SCHEMA}.targeting_generation DROP CONSTRAINT IF EXISTS targeting_generation_uniq_key;
ALTER TABLE ${SCHEMA}.targeting_generation ADD CONSTRAINT targeting_generation_uniq_key UNIQUE (label);

SELECT setval('${SCHEMA}.targeting_generation_pk_seq', coalesce(max(pk), 0) + 1, false) 
FROM ${SCHEMA}.targeting_generation;

INSERT INTO ${SCHEMA}.targeting_generation (pk, label, first_release)
    VALUES ( DEFAULT,'$TGV','$DR') 
    ON CONFLICT DO NOTHING;

INSERT INTO ${SCHEMA}.targeting_generation_to_version (generation_pk, version_pk)
    SELECT generation_pk,version_pk 
    FROM (select max(tg.pk) as generation_pk from ${SCHEMA}.targeting_generation as tg where tg.label = '$TGV') as a, 
         (select v.pk as version_pk from targetdb.version as v where v.plan = '$RS_PLAN') as b 
    ON CONFLICT DO NOTHING;

CREATE TEMPORARY TABLE IF NOT EXISTS targeting_generation_to_carton_temp (
    carton TEXT,
    plan TEXT,
    rs_stage TEXT,
    rs_active BOOLEAN
);
TRUNCATE targeting_generation_to_carton_temp;

\copy targeting_generation_to_carton_temp FROM '$RSCARTONCSV_FILE' WITH CSV HEADER;

INSERT INTO ${SCHEMA}.targeting_generation_to_carton (generation_pk, carton_pk, rs_stage, rs_active)
SELECT (select max(tg.pk) as generation_pk from ${SCHEMA}.targeting_generation as tg where tg.label = '$TGV') as generation_pk,
        c.pk,t.rs_stage,t.rs_active 
FROM targeting_generation_to_carton_temp as t 
JOIN targetdb.carton as c 
ON t.carton = c.carton 
JOIN targetdb.version as v 
ON c.version_pk = v.pk 
AND t.plan = v.plan 
ON CONFLICT DO NOTHING;

"

if [ "$SQLFILE" = "-"]; then 
    printf "$Q"
else
    echo "Writing SQL commands to $SQLFILE"
    printf "$Q" > $SQLFILE
fi
