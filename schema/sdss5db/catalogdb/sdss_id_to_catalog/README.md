# sdss_id_to_catalog

`sdss_id_to_catalog.py` contains code to create a materialised view with a mapping of sdss_id/catalogid to each one of the parent catalogue table unique identifiers.

For each catalogid associated with an sdss_id in `catalogdb.sdss_id_flat`, the catalogid is joined to all the `catalog_to_X` tables and then to the parent catalogue table to get the unique identifier (primary key in the parent catalogue table). The join is always done using `catalog_to_X.best = TRUE` so only the best match is considered.

The list of parent catalogues is generated dynamically from the tables in `catalogdb`. For each catalogue, a column is added to the resulting materialised view with the format `<parent_table>__<unique_identifier>`, for example `gaia_dr3_source__source_id`.

This code must be run either in the `pipelines` or `operations` machine, or in a local computer in which the `pipelines` database server (port 5432) has been forwarded to `localhost:7602`. For example, to create the view in a temporary location prior to renaming it to its final name:

```python
from sdss_id_to_catalog import create_sdss_id_to_catalog_view

create_sdss_id_to_catalog_view("sdss_id_to_catalog_temp", local=False)
```

Here `local=False` means that we are running the code somewhere at Utah that can access `pipelines.sdss.org:5432`. It also assumes that the user running the code has permissions to log in and create a new view. This can be changed by setting `user=`.
