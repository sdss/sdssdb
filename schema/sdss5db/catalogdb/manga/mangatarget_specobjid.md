# Adding `specobjid` column to `catalogdb.mangatarget`

Most `mangatarget` entries were selected from the NASA-Sloan Atlas catalogue, which in turn was compiled from SDSS spectroscopic observations. This means that most entries can be linked to a `sdss_dr17_specobj.specobjid` row.

Doing this is not totally trivial and the bottom line is that the file `mangaid_to_specobjid_dr17.csv` contains the matching between `mangaid` and `specobjid`. To create this table we downloaded the NSA v1_0_1 table from [here](). `mangatarget` can be matched to the NSA table via the `nsa_nsaid` column. The resulting join can be matched to `sdss_dr17_specobj` by joining the columns `(plate, fiberid, mjd)`. Since all the tables are small this was done using Polars, but it could also be done in SQL.

Note that `specobjid` is a string column and that the values are padded with leading spaces, which need to be conserved in the CSV, so quotes are needed.

Once `mangaid_to_specobjid_dr17.csv` exists, the relationship can be added to the original `mangatarget` table with

```postgresql
CREATE TEMP TABLE mangaid_specobjid (mangaid TEXT, specobjid TEXT);
\copy mangaid_specobjid FROM 'mangaid_to_specobjid_dr17.csv' CSV HEADER;

ALTER TABLE mangatarget ADD COLUMN specobjid TEXT;
UPDATE catalogdb.mangatarget m set specobjid = ms.specobjid
    FROM mangaid_specobjid ms
    WHERE ms.mangaid = m.mangaid;
```

And then we add a foreign key on that column

```postgresql
ALTER TABLE catalogdb.mangatarget
    ADD CONSTRAINT mangatarget_specobjid_fk FOREIGN KEY (specobjid)
    REFERENCES catalogdb.sdss_dr17_specobj(specobjid);
```
