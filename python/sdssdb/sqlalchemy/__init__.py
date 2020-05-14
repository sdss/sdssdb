# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:02:19
# @Last modified by: José Sánchez-Gallego (gallegoj@uw.edu)
# @Last Modified time: 2018-10-10 16:38:45

from __future__ import absolute_import, division, print_function

from sqlalchemy.ext.hybrid import hybrid_method
from sqlalchemy.sql.expression import func


def get_field(parent, child):
    ''' Recursively get a field name from a parent

    Allows addition of fields from relationships into
    parent repr. E.g. 'bintype.name' or 'pipeline.version.version'

    Parameters:
        parent (obj):
            the instance object to check attributes on
        child (str):
            The child string attribute name

    Returns:
        A tuple of string base parameter name and value
    '''

    if hasattr(parent, child):
        return child, getattr(parent, child)
    elif '.' in child:
        base, value = child.split('.', 1)
        if hasattr(parent, base):
            base_obj = getattr(parent, base)
            return get_field(base_obj, value)
    else:
        return None, None


class BaseModel(object):
    ''' A custom sqlalchemy declarative Base

    By default it always prints ``pk``, ``name``, and ``label``, if found.
    Models can define they own `.print_fields` as a list of field to be output
    in the representation.  Works with field names nested inside other models as well.

    '''

    #: A list of fields (as strings) to be included in the ``__repr__``
    print_fields = []

    def __repr__(self):
        """A custom repr for models."""

        reg = str(self.__class__.__name__)
        if reg is not None:

            pk_field = self.__class__.__mapper__.primary_key[0].name
            pk_value = getattr(self, pk_field)
            fields = ['{0}={1!r}'.format(pk_field, pk_value)]

            for extra_field in ['label', 'name']:
                if extra_field not in self.print_fields:
                    self.print_fields.append(extra_field)

            for ff in self.print_fields:
                if ff == pk_field:
                    continue
                base, value = get_field(self, ff)
                if base:
                    fields.append('{0}={1!r}'.format(base, value))

            return '<{0} ({1})>'.format(reg, ', '.join(fields))

        return super(BaseModel, self).__repr__()

    def get_id(self):
        ''' get the pk '''
        return self.pk if hasattr(self, 'pk') else None

    @hybrid_method
    def cone_search(self, ra, dec, a, b=None, pa=None, ra_col='ra', dec_col='dec'):
        """Returns a query with the rows inside a region on the sky."""

        assert hasattr(self, ra_col) and hasattr(self, dec_col), \
            'this model class does not have ra/dec columns.'

        ra_attr = getattr(self, ra_col)
        dec_attr = getattr(self, dec_col)

        if b is None:
            return func.q3c_radial_query(ra_attr, dec_attr, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return func.q3c_ellipse_query(ra_attr, dec_attr, ra, dec, a, ratio, pa)

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
            return func.q3c_radial_query(ra_attr, dec_attr, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return func.q3c_ellipse_query(ra_attr, dec_attr, ra, dec, a, ratio, pa)
