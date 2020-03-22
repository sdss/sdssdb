# isort:skip_file
# flake8: noqa

import re
import warnings

from sdssdb import _peewee

if _peewee is False:
    raise ImportError('Peewee must be installed to use this module.')

import peewee
from peewee import Model, ModelBase, fn
from playhouse.hybrid import hybrid_method
from playhouse.reflection import generate_models

from sdssdb import log


class ReflectMeta(ModelBase):
    """A metaclass that supports model reflection on demand.

    This metaclass expands Peewee's ``ModelBase`` to provide a hook for
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

    Foreign keys explicitely defined need to reference fields that exist so the
    referenced columns need to be added manually.

    Caveats:

    - Many-to-many relationships need to be defined explicitely since
    it's not possible to set the through model based on the reflected
    information.

    - When the primary key of a model is also a foreign key, it needs to be
    defined explicitely. Otherwise the field will be added but not marked as
    primary key.

    """

    def __new__(cls, name, bases, attrs):

        Model = super(ReflectMeta, cls).__new__(cls, name, bases, attrs)

        Model._meta.use_reflection = getattr(Model._meta, 'use_reflection', False)

        database = Model._meta.database
        if database and hasattr(database, 'models') and Model not in database.models:
            database.models.append(Model)

        if Model._meta.use_reflection and database and database.connected:
            cls.reflect(Model)

        return Model

    def reflect(self):
        """Adds fields and indexes to the model using reflection."""

        # Don't do anything if this model doesn't want reflection.
        if not hasattr(self._meta, 'use_reflection') or not self._meta.use_reflection:
            return

        # First clear all previously reflected fields and indexes.
        for field in self._meta.fields:
            if hasattr(field, 'reflected') and field.reflected:
                self._meta.remove_field(field)

        for index in self._meta.indexes:
            if hasattr(index, 'reflected') and index.reflected:
                self._meta.indexes.remove(index)

        database = self._meta.database
        if not database.is_connection_usable():
            raise peewee.DatabaseError('database not connected.')

        table_name = self._meta.table_name
        schema = self._meta.schema

        try:
            ReflectedModel = generate_models(database, schema=schema,
                                             table_names=table_name)[table_name]
        except KeyError:
            log.debug('reflection failed for {}'.format(table_name))
            return

        for field_name, field in ReflectedModel._meta.fields.items():

            if field_name in self._meta.fields:
                continue

            if (isinstance(field, peewee.ForeignKeyField) and
                    hasattr(self._meta, 'reflection_options') and
                    self._meta.reflection_options.get('skip_foreign_keys', False)):
                continue

            field.reflected = True

            if field.primary_key:
                self._meta.set_primary_key(field_name, field)
            else:
                self._meta.add_field(field_name, field)

        for index in ReflectedModel._meta.indexes:

            # TODO: this probably can never work. Find a better way of determining
            # if the index has been added manually.
            if index in self._meta.indexes:
                continue

            self._meta.indexes.append(index)


class BaseModel(Model, metaclass=ReflectMeta):
    """A custom peewee `.Model` with enhanced representation and methods.

    By default it always prints ``pk``, ``name``, and ``label``, if found.
    Models can define they own `.print_fields` as a list of field to be output
    in the representation.

    """

    #: A list of fields (as strings) to be included in the ``__repr__``
    print_fields = []

    class Meta:
        primary_key = False
        use_reflection = False

    def __str__(self):
        """A custom str for the model repr."""

        if self._meta.primary_key:
            pk_field = self._meta.primary_key.name
            fields = ['{0}={1!r}'.format(pk_field, self.get_id())]
        else:
            pk_field = None
            fields = []

        for extra_field in ['label', 'name']:
            if extra_field not in self.print_fields:
                self.print_fields.append(extra_field)

        for ff in self.print_fields:
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
