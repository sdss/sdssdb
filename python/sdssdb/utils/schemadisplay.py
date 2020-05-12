#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-12-14
# @Filename: peewee_schemadisplay.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

# The following functions are adapted from the sqlalchemy_schemadisplay by
# Florian Schulze (https://github.com/fschulze/sqlalchemy_schemadisplay).

import re

from peewee import ForeignKeyField, IndexMetadata


try:
    import pydot
except ImportError:
    pydot = None


__all__ = ['create_schema_graph', 'show_schema_graph']


field_type_psql = {'AUTO': 'SERIAL',
                   'BIGAUTO': 'BIGSERIAL',
                   'BIGINT': 'BIGINT',
                   'BLOB': 'BYTEA',
                   'BOOL': 'BOOLEAN',
                   'CHAR': 'CHAR',
                   'DATE': 'DATE',
                   'DATETIME': 'TIMESTAMP',
                   'DECIMAL': 'NUMERIC',
                   'DEFAULT': '',
                   'DOUBLE': 'DOUBLE PRECISION',
                   'FLOAT': 'REAL',
                   'INT': 'INTEGER',
                   'SMALLINT': 'SMALLINT',
                   'TEXT': 'TEXT',
                   'TIME': 'TIME',
                   'UUID': 'UUID',
                   'UUIDB': 'BYTEA',
                   'VARCHAR': 'VARCHAR'}


def _render_table_html(model, show_columns=True, show_pks=True,
                       show_indices=True, show_datatypes=True):
    """Creates the HTML tags for a table, including PKs, FKs, and indices.

    Parameters
    ----------
    model : `peewee.Model`
        The Peewee model for which to create the table.
    show_columns : bool
        Whether to show the column names.
    show_pks : bool
        Whether to show the primary key. Supersedes ``show_columns``.
    show_indices : `bool`
        Whether to show the indices from the table as separate rows.
    show_datatypes : `bool`
        Whether to show the data type of each column.

    """

    table_name = model._meta.table_name
    fields = model._meta.fields

    # pk_col_names = set([fields[field_name].column_name for field_name in fields
    #                     if fields[field_name].primary_key])

    # fk_col_names = set([fields[field_name].column_name for field_name in fields
    #                     if isinstance(fields[field_name], ForeignKeyField)])

    def format_field_str(field):
        """Add in (PK) OR (FK) suffixes to column names."""

        suffixes = []

        column_name = field.column_name
        if column_name == '__composite_key__':
            column_name = '(' + ', '.join(pk.field_names) + ')'
            suffixes.append('PK')  # Composite keys get .primary_key == False

        if field.primary_key:
            suffixes.append('PK')
        if isinstance(field, ForeignKeyField):
            suffixes.append('FK')

        suffix = ' (' + ', '.join(suffixes) + ')' if len(suffixes) > 0 else ''

        if show_datatypes and field.column_name != '__composite_key__':
            field_type = field.field_type
            if field_type in field_type_psql:
                field_type = field_type_psql[field_type]
            return f'- {column_name}{suffix} : {field_type}'
        else:
            return f'- {column_name}{suffix}'

    html = (f'<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0">'
            f'<TR><TD ALIGN="CENTER"><font face="Lucida Sans Demibold Roman">'
            f'{table_name}</font><BR/>({model.__name__})</TD></TR>')

    added_col_name = []
    fields_html = []

    pk = model._meta.primary_key
    if show_pks and pk:
        if model._meta.composite_key:
            column_name = '(' + ', '.join(pk.field_names) + ')'
        else:
            column_name = pk.column_name
        fields_html.append(
            '<TR><TD ALIGN="LEFT" PORT="{}">{}</TD></TR>'.format(
                column_name, format_field_str(pk)))

    # Add a row for each column in the table.
    if show_columns:
        for field in fields.values():

            if field.primary_key:
                continue

            column_name = field.column_name

            # Avoids repeating columns. This can happen if there are multiple
            # FKs pointing to the same column.
            if column_name in added_col_name:
                continue

            fields_html.append(
                '<TR><TD ALIGN="LEFT" PORT="{}">{}</TD></TR>'.format(
                    column_name, format_field_str(field)))

            added_col_name.append(column_name)

    if len(fields_html) > 0:
        html += '<TR><TD BORDER="1" CELLPADDING="0"></TD></TR>'
        html += ''.join(fields_html)

    # Add indexes and unique constraints
    if show_indices:

        if model._meta.database.connected:
            indexes = model._meta.database.get_indexes(model._meta.table_name,
                                                       schema=model._meta.schema)
        else:
            indexes = [index._expressions[0] for index in model._meta.fields_to_index()
                       if not isinstance(index._expressions[0], ForeignKeyField)]

        if len(indexes) > 0:
            first = True

            for index in indexes:
                if not isinstance(index, IndexMetadata):
                    continue

                column_names = index.columns
                ilabel = 'INDEX'

                if len(column_names) == 1:
                    column_name = column_names[0]
                    if column_name == '':
                        match = re.match(r'.+q3c_ang2ipix\("*(\w+)"*, "*(\w+)"*\).+',
                                         index.sql)
                        if match:
                            column_name = '(' + ', '.join(match.groups()) + ')'
                            ilabel = 'Q3C'
                        else:
                            continue
                else:
                    column_name = '(' + ', '.join(column_names) + ')'

                if index.unique:
                    if pk and column_name == pk.column_name:
                        continue
                    ilabel = 'UNIQUE'

                if first:
                    html += '<TR><TD BORDER="1" CELLPADDING="0"></TD></TR>'
                    first = False

                html += f'<TR><TD ALIGN="LEFT">{ilabel} {column_name}</TD></TR>'

    html += '</TABLE>>'

    return html


def create_schema_graph(models=None, base=None, schema=None, show_columns=True,
                        show_pks=True, show_indices=True, show_datatypes=True,
                        skip_tables=[], font='Bitstream-Vera Sans',
                        graph_options={}, relation_options={}):
    """Creates a graph visualisation from a series of Peewee models.

    Produces a `pydot <https://pypi.org/project/pydot/>`__ graph including the
    tables and relationships from a series of models or from a base model
    class.

    Parameters
    ----------
    models : list
        A list of Peewee `models <peewee:Model>` to be graphed.
    base : peewee:Model
        A base model class. If passed, all the model classes that were created
        by subclassing from the base model will be used.
    schema : str
        A schema name. If passed, will be used to limit the list of models or
        ``base`` subclasses to only the models that match the schema name.
    show_columns : bool
        Whether to show the column names.
    show_pks : bool
        Whether to show the primary key. Supersedes ``show_columns``.
    show_indices : bool
        Whether to show the indices from the table as separate rows.
    show_datatypes : bool
        Whether to show the data type of each column.
    skip_tables : list
        List of table names to skip.
    font : str
        The name of the font to use.
    graph_options : dict
        Options for creating the graph. Any valid Graphviz option.
    relation_options : dict
        Additional parameters to be passed to ``pydot.Edge`` when creating the
        relationships.

    Returns
    -------
    graph : `pydot.Dot`
        A ``pydot.Dot`` object with the graph representation of the schema.

    Example
    -------
    ::

        >>> graph = create_schema_graph([User, Tweet])
        >>> graph.write_pdf('tweetdb.pdf')

    """

    assert models or base, 'either model or base must be passed.'
    assert pydot, ('pydot is required for create_schema_graph. '
                   'Try running "pip install sdssdb[all]"')

    relation_kwargs = {'fontsize': '7.0'}
    relation_kwargs.update(relation_options)

    if base and not models:
        models = set(base.__subclasses__())
        while True:
            old_models = models.copy()
            for model in old_models:
                models |= set(model.__subclasses__())
            if models == old_models:
                break

    if schema:
        models = [model for model in models if model._meta.schema == schema]

    default_graph_options = dict(program='dot',
                                 rankdir='TB',
                                 sep='0.01',
                                 mode='ipsep',
                                 overlap='ipsep')
    default_graph_options.update(graph_options)

    graph = pydot.Dot(prog='dot', **graph_options)

    for model in models:

        if model._meta.table_name in skip_tables:
            continue

        if model._meta.database.connected and not model.table_exists():
            continue

        graph.add_node(
            pydot.Node(str(model._meta.table_name),
                       shape='plaintext',
                       label=_render_table_html(model,
                                                show_columns=show_columns,
                                                show_pks=show_pks,
                                                show_indices=show_indices,
                                                show_datatypes=show_datatypes),
                       fontname=font,
                       fontsize='7.0')
        )

        for field in model._meta.fields.values():

            if (not isinstance(field, ForeignKeyField) or
                    field.rel_model not in models):
                continue

            from_col_name = '+ ' + field.column_name

            to_col_name = field.rel_field.column_name
            if field.rel_field.primary_key:
                to_col_name = ''
            else:
                to_col_name = '+ ' + to_col_name

            edge = [model._meta.table_name, field.rel_model._meta.table_name]

            # is_inheritance = from_field.primary_key and to_field.primary_key
            # if is_inheritance:
            #     edge = edge[::-1]

            # is_index = from_field.primary_key or from_field.unique

            graph_edge = pydot.Edge(
                dir='both',
                headlabel=to_col_name,
                taillabel=from_col_name,
                arrowhead='none',
                arrowtail='none',
                # arrowhead=is_inheritance and 'none' or 'odot',
                # arrowtail=is_index and 'empty' or 'crow',
                fontname=font,
                *edge,
                **relation_kwargs
            )
            graph.add_edge(graph_edge)

    return graph


def show_schema_graph(*args, **kwargs):
    """Creates and displays a schema graph."""

    from io import StringIO
    from PIL import Image

    iostream = StringIO(create_schema_graph(*args, **kwargs).create_png())
    Image.open(iostream).show(command=kwargs.get('command', 'gwenview'))
