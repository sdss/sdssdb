#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2018-09-22
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)
# flake8: noqa

import keyword
import warnings

import peewee
from peewee import Model, ModelBase, fn
from playhouse.hybrid import hybrid_method

from sdssdb.exceptions import SdssdbUserWarning
from sdssdb.utils.internals import is_table_locked


class ReflectMeta(ModelBase):
    """A metaclass that supports model reflection on demand.

    This metaclass expands PeeWee's ``ModelBase`` to provide a hook for
    declaring/expanding fields and indexes using the
    :ref:`introspection system <peewee:reflection>`. The feature is enabled
    by a new attribute in :class:`peewee:Metadata` called ``use_reflection``
    (which is set to `False` by default). When set to `True` the metaclass
    extends the model using the fields and indexes discovered
    using reflection. It is possible to mix explicitely defined fields
    with discovered ones; the latter never override the former.

    Normally `.ReflectMeta` is implemented by creating a base model that
    is then used to defined the table models ::

        class ReflectBaseModel(peewee.Model, metaclass=ReflectMeta):

            class Meta:
                primary_key = False
                use_reflection = False
                database = database

        class Tycho2(ReflectBaseModel):

            class Meta:
                use_reflection = True
                schema = 'catalogdb'
                table_name = 'tycho2'

    Note that ``use_reflection`` is inheritable so if set to `True` in the base
    class that will affect to all subclasses, except if it's overridden there.
    It's also a good idea to set ``primary_key=False`` to prevent Peewee from
    creating an ``id`` column automatically.

    If the database connection changes it's possible to call `.reflect` to
    rediscover the reflected fields for the new connection. This will remove
    all reflected fields (but not those explicitely added) and add the newly
    discovered ones.

    If the database class is `.PeeweeDatabaseConnection`, the database will
    call `.reflect` for each model bound to the database each time it connects.
    This ensures that if the connection changes the reflected fields are
    updated. Note that this will not work if using Peewee's
    :class:`peewee:PostgresqlDatabase`.

    By default, `.ReflectMeta` will add all the fields from the reflected
    models, including foreign keys. Sometimes that is not desirable and it's
    preferable to define the foreign keys explicitely. In that case it's
    possible to disable the reflection of foreign keys by doing ::

        class ReflectBaseModel(peewee.Model, metaclass=ReflectMeta):

                class Meta:
                    primary_key = False
                    use_reflection = False
                    reflection_options = {'skip_foreign_keys': True}
                    database = database

    Foreign keys explicitely defined need to reference existing fields,
    so the referenced columns need to be added manually. In practice, this
    means that if you add a `peewee:ForeignKeyField`, the referenced field
    (usually the primary key) needs to be defined explicitely.

    The default Peewee reflection process requires multiple queries against
    the database for each table. This can become quite slow if the schema
    contains many tables or if the connection has significant overhead, for
    example when connected over an SSH tunnel. In these cases one can set
    ``Meta`` with ``reflection_options = {'use_peewee_reflection': False}``.
    This will use a reflection system that is designed to minimise the
    number of queries needed for schema introspection. Note that this system
    is experimental and doesn't reflect foreign keys or constraints.

    Caveats:

    - Due to a bug in PeeWee primary keys are not discovered correctly if the
      user connected to the database does not have write access. In that case
      a composite key encompassing all the fields in the model is created.
      To avoid this, explicitely define the primary key in the model.

    - Many-to-many relationships need to be defined explicitely since
      it's not possible to set the through model based on the reflected
      information.

    - When the primary key of a model is also a foreign key and
      ``reflection_options = {'skip_foreign_keys': True}``, both the primary
      key and the foreign key need to be defined explicitely. Otherwise neither
      will be added.

    - Reflection will fail if a table is locked with ``AccessExclusiveLock``.
      In that case reflection will be skipped and a warning issued. Note that
      if the table is locked with an exclusive lock you won't be able to access
      the data in any case.

    - In this version, indexes discovered by reflection are not propagated to
      the model class. This should not have any impact in performance.

    """

    def __new__(cls, name, bases, attrs):

        Model = super(ReflectMeta, cls).__new__(cls, name, bases, attrs)
        meta = Model._meta

        database = meta.database
        if database and hasattr(database, 'models'):
            if Model not in database.models.values():
                schema = meta.schema
                table_name = meta.table_name
                fpath = schema + '.' + table_name if schema else table_name
                database.models[fpath] = Model

        # Don't do anything if this model doesn't want reflection.
        if getattr(meta, 'use_reflection', True):
            cls.reflect(Model)

        return Model

    def reflect(self):
        """Adds fields and indexes to the model using reflection."""

        meta = self._meta
        database = meta.database
        table_name = meta.table_name
        schema = meta.schema

        if not database or not database.connected:
            return

        # Lists tables in the schema. This is a bit of a hack but
        # faster than using database.table_exists because it's cached.
        database.get_fields(table_name, schema)
        schema_tables = database._metadata[schema].keys()

        if table_name not in schema_tables:
            # Give it another try without caching. This is sometimes necessary
            # for tables things like catalog_to_X table that are created
            # dynamically.
            database.get_fields(table_name, schema, cache=False)
            schema_tables = database._metadata[schema].keys()
            if table_name not in schema_tables:
                return

        for index in meta.indexes:
            if hasattr(index, 'reflected') and index.reflected:
                meta.indexes.remove(index)

        if not database.is_connection_usable():
            raise peewee.DatabaseError('database not connected.')

        if hasattr(meta, 'reflection_options'):
            opts = meta.reflection_options
            skip_fks = opts.get('skip_foreign_keys', False)
            use_peewee_reflection = opts.get('use_peewee_reflection', True)
        else:
            skip_fks = False
            use_peewee_reflection = True

        try:

            if use_peewee_reflection:

                # Check for locks. We only need to do this if using the Peewee
                # reflection because one of the queries it does can be blocked
                # by a AccessExclusiveLock lock.
                locks = is_table_locked(database, table_name)
                if locks and 'AccessExclusiveLock' in locks:
                    warnings.warn(f'table {schema}.{table_name} is locked and '
                                  'will not be reflected.', SdssdbUserWarning)
                    return

                introspector = database.get_introspector(schema)
                reflected_model = introspector.generate_models(
                    table_names=[table_name])[table_name]
                fields = reflected_model._meta.fields

            else:
                fields = database.get_fields(table_name, schema)
                fields = {field.column_name: field for field in fields}

        except KeyError as ee:
            warnings.warn(f'reflection failed for {table_name}: '
                          f'table or column {ee} not found.',
                          SdssdbUserWarning)
            return

        except Exception as ee:
            warnings.warn(f'reflection failed for {table_name}: {ee}',
                          SdssdbUserWarning)
            return

        for field_name, field in fields.items():

            if field_name in keyword.kwlist:
                field_name += '_'

            if field_name in meta.fields:
                meta_field = meta.fields[field_name]
                if not getattr(meta_field, 'reflected', False):
                    continue

            if isinstance(field, peewee.ForeignKeyField) and skip_fks:
                continue

            if field.primary_key:
                meta.set_primary_key(field_name, field)
            else:
                meta.add_field(field_name, field)

            meta.fields[field_name].reflected = True

        # Composite keys are not a normal column so if the pk has not been
        # set already, check if it exists in the reflected model. We avoid
        # adding pks that are foreign keys.
        if not meta.primary_key:
            if use_peewee_reflection and reflected_model._meta.primary_key:
                pk = reflected_model._meta.primary_key
                if not isinstance(pk, peewee.ForeignKeyField) or not skip_fks:
                    meta.set_primary_key(pk.name, pk)
            elif not use_peewee_reflection:
                pk = database.get_primary_keys(table_name, schema)
                if len(pk) > 1:
                    pk = peewee.CompositeKey(*pk)
                    meta.set_primary_key('__composite_key__', pk)


class BaseModel(Model, metaclass=ReflectMeta):
    """A custom peewee `.Model` with enhanced representation and methods.

    By default it always prints ``pk``, ``name``, and ``label``, if found.
    Models can define they own ``print_fields`` in ``Meta`` as a list of field
    names to be output in the representation.

    """

    class Meta:
        primary_key = False
        use_reflection = False
        print_fields = []

    def __str__(self):
        """A custom str for the model repr."""

        if self._meta.primary_key:
            if self._meta.composite_key:
                pk_field = '(' + ', '.join(self._meta.primary_key.field_names) + ')'
            else:
                pk_field = self._meta.primary_key.name
            fields = ['{0}={1!r}'.format(pk_field, self.get_id())]
        else:
            pk_field = None
            fields = []

        for extra_field in ['label', 'name']:
            if extra_field not in self._meta.print_fields:
                self._meta.print_fields.append(extra_field)

        for ff in self._meta.print_fields:
            if ff == pk_field:
                continue
            if hasattr(self, ff):
                fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

        return ', '.join(fields)

    @hybrid_method
    def cone_search(self, ra, dec, a, b=None, pa=None, ra_col='ra', dec_col='dec'):
        """Returns a query with the rows inside a region on the sky."""

        assert hasattr(self, ra_col) and hasattr(self, dec_col), \
            'this model class does not have ra/dec columns.'

        ra_attr = getattr(self, ra_col)
        dec_attr = getattr(self, dec_col)

        if b is None:
            return fn.q3c_radial_query(ra_attr, dec_attr, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return fn.q3c_ellipse_query(ra_attr, dec_attr, ra, dec, a, ratio, pa)

    @cone_search.expression
    def cone_search(cls, ra, dec, a, b=None, pa=None, ra_col='ra', dec_col='dec'):  # noqa
        """Returns a query with the rows inside a region on the sky.

        Defines a sky ellipse and returns the targets within. By default it
        assumes that the table contains two columns ``ra`` and ``dec``. All
        units are expected to be in degrees.

        Parameters
        ----------
        ra : float
            The R.A. of the centre of the ellipse.
        dec : float
            The declination of the centre of the ellipse.
        a : float
            Defines the semi-major axis of the ellipse for the cone search. If
            ``b=None``, a circular search will be done with ``a`` as the
            radius.
        b : `float` or `None`
            The semi-minor axis of the ellipse. If `None`, a circular cone
            search will be run. In that case, ``pa`` is ignored.
        pa : `float` or `None`
            The parallactic angle of the ellipse.
        ra_col : str
            The name of the column with the RA value.
        dec_col : str
            The name of the column with the Dec value.

        """

        assert hasattr(cls, ra_col) and hasattr(cls, dec_col), \
            'this model class does not have ra/dec columns.'

        ra_attr = getattr(cls, ra_col)
        dec_attr = getattr(cls, dec_col)

        if b is None:
            return fn.q3c_radial_query(ra_attr, dec_attr, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return fn.q3c_ellipse_query(ra_attr, dec_attr, ra, dec, a, ratio, pa)
