#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2020-05-04
# @Filename: update_graphs.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

# This script generates the schema graphs for catalogdb (full and lite)
# and targetdb. It requires graphviz to be installed with support for PDF.
# Accepts a single, optional argument, the name of the profile to use to
# connect to the database.

import os
import sys

from sdssdb.peewee.sdss5db import database
from sdssdb.utils.schemadisplay import create_schema_graph


def create_graphs():

    cwd = os.path.dirname(os.path.realpath(__file__))

    cdb_graph = create_schema_graph(base=catalogdb.CatalogdbModel,
                                    show_columns=True,
                                    skip_tables=['galactic_genesis_big',
                                                 'galactic_genesis'],
                                    graph_options={'rankdir': 'TB'})
    cdb_graph.write_pdf(f'{cwd}/catalogdb/sdss5db.catalogdb.pdf')

    cdb_lite_graph = create_schema_graph(base=catalogdb.CatalogdbModel,
                                         show_columns=False,
                                         skip_tables=['galactic_genesis_big',
                                                      'galactic_genesis'],
                                         graph_options={'rankdir': 'TB',
                                                        'ratio': '0.2',
                                                        'dpi': 72})
    cdb_lite_graph.write_pdf(f'{cwd}/catalogdb/sdss5db.catalogdb_lite.pdf')

    tdb_graph = create_schema_graph(base=targetdb.TargetdbBase,
                                    show_columns=True,
                                    graph_options={'rankdir': 'TB'})
    tdb_graph.write_pdf(f'{cwd}/targetdb/sdss5db.targetdb.pdf')
    tdb_graph.write_png(f'{cwd}/targetdb/sdss5db.targetdb.png')

    ops_graph = create_schema_graph(base=opsdb.OpsdbBase,
                                    show_columns=True,
                                    graph_options={'rankdir': 'TB'})
    ops_graph.write_pdf(f'{cwd}/opsdb/sdss5db.opsdb.pdf')
    ops_graph.write_png(f'{cwd}/opsdb/sdss5db.opsdb.png')


if __name__ == '__main__':

    if len(sys.argv) == 2:
        database.set_profile(sys.argv[1])

    assert database.connected, 'database is not connected'

    # Import modules here to make sure all the relational tables are loaded.
    from sdssdb.peewee.sdss5db import catalogdb, targetdb, opsdb

    create_graphs()
