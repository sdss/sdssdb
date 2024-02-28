# !/usr/bin/env python
# -*- coding: utf-8 -*-
#
import ast
from collections import ChainMap

def fix_list(df, col):
    """ fix columns with list values """
    nn = df[col].notnull()
    df.loc[nn, col] = df[nn][col].apply(lambda x: ','.join(map(str, ast.literal_eval(x))) if '[' in x else x)
    return df

def create_df() -> list[dict]:
    """ Create the releases dataframe

    Creates a list of table rows of release
    information, with software version tags,
    from the SDSS datamodel.

    Returns
    -------
    list[dict]
        a list of table rows to insert
    """

    import pandas as pd
    from datamodel.products import SDSSDataModel

    # get the release and software tag information
    dm = SDSSDataModel()
    rels = dm.tags.group_by('release')
    collapsed = {k: dict(ChainMap(*rels[k].values())) for k in rels}
    dd = [{**{'release': k}, **v} for k, v in collapsed.items()]

    # create initial dataframe
    cols = ['release', 'run2d', 'run1d', 'apred_vers', 'v_astra', 'v_speccomp', 'v_targ',
            'drpver', 'dapver', 'apstar_vers', 'aspcap_vers', 'results_vers', 'mprocver',
            'public', 'mjd_cutoff_apo', 'mjd_cutoff_lco']
    # alternate - get unique cols from datamodel, preserving order
    # cols = ['release', 'public', 'mjd_cutoff_apo', 'mjd_cutoff_lco'] + list(dict.fromkeys([i.version.name for i in dm.tags]))

    df = pd.DataFrame.from_records(dd, columns=cols)

    # adjust multi-valued keys to comma-separated strings
    df = fix_list(df, 'run2d')
    df = fix_list(df, 'run1d')
    df = fix_list(df, 'apred_vers')

    # drop legacy rows
    df = df.set_index('release', drop=False)
    sub = df.loc['DR7':'EDR']
    df = df.drop(sub.index)

    # add mjd cutoffs
    # todo - move this to the datamodel
    df.loc['DR18', 'mjd_cutoff_apo'] = 59392
    df.loc['DR19', 'mjd_cutoff_apo'] = 60280
    df.loc['DR19', 'mjd_cutoff_lco'] = 60280
    df.loc['IPL3', 'mjd_cutoff_apo'] = 60130
    df.loc['IPL1', 'mjd_cutoff_apo'] = 59765

    # reset index
    df = df.reset_index(drop=True)

    # # add legacy rows
    # df = pd.concat([df,
    #                 pd.DataFrame([('legacy', 26),
    #                             ('legacy', 103),
    #                             ('legacy', 104)],
    #                             columns=['release', 'run2d'])])

    # add a null work release
    df = pd.concat([df, pd.DataFrame([('WORK')], columns=['release'])])

    # fill nans
    #df = df.fillna('None')
    df = df.fillna('None').replace('None', None)

    # create the public column
    df['public'] = df['release'].apply(lambda x: 'DR' in x)

    return df.to_dict(orient='records')


def load_to_db(rows: list):
    """ load into the vizdb.releases table """
    from sdssdb.peewee.sdss5db import database, vizdb

    data = [vizdb.Releases(**row) for row in rows]

    with database.atomic():
        vizdb.Releases.bulk_create(data)
