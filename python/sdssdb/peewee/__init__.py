# flake8: noqa

import re

from peewee import Model, fn
from playhouse.hybrid import hybrid_method


class BaseModel(Model):
    """A custom peewee `.Model` with enhanced representation and methods.

    By default it always prints ``pk``, ``name``, and ``label``, if found.
    Models can define they own `.print_fields` as a list of field to be output
    in the representation.

    """

    #: A list of fields (as strings) to be included in the ``__repr__``
    print_fields = []

    def __str__(self):
        """A custom str for the model repr."""

        pk_field = self._meta.primary_key.name
        fields = ['{0}={1!r}'.format(pk_field, self.get_id())]

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
    def cone_search(cls, ra, dec, a, b=None, pa=None, ra_col='ra', dec_col='dec'):
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
