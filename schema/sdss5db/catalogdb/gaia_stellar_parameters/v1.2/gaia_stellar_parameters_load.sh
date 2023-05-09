#!/bin/bash

ls $CATALOGDB_DIR/gaia_stellar_parameters/v1.2/*.csv | xargs -I {} sh -c "echo {} && psql -U sdss sdss5db -c \"\copy catalogdb.gaia_stellar_parameters FROM {} WITH HEADER DELIMITER ',' NULL '\N' CSV;\""
