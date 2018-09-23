# flake8: noqa

from peewee import Model, fn
from playhouse.hybrid import hybrid_method


class BaseModel(Model):

    print_fields = []

    def __repr__(self):
        """A custom repr for targetdb models.

        By default it always prints pk, name, and label, if found. Models can
        define they own ``print_fields`` as a list of field to be output in the
        repr.

        """

        reg = re.match('.*\'.*.(.*)\'.', str(self.__class__))

        if reg is not None:

            fields = ['pk={0!r}'.format(self.get_id())]

            for extra_field in ['label']:
                if extra_field not in self.print_fields:
                    self.print_fields.append(extra_field)

            for ff in self.print_fields:
                if hasattr(self, ff):
                    fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

            return '<{0}: {1}>'.format(reg.group(1), ', '.join(fields))

        return super(BaseModel, self).__repr__()

    @hybrid_method
    def cone_search(self, ra, dec, a, b=None, pa=None):
        """Returns a filtered query with the rows inside a region on the sky.

        Defines a sky ellipse and returns the targets within. Assumes that the
        table contains two columns ``ra`` and ``dec``. All units are assumed
        to be degrees.

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

        """

        if b is None:
            return fn.q3c_radial_query(self.ra, self.dec, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return fn.q3c_ellipse_query(self.ra, self.dec, ra, dec, a, ratio, pa)

    @cone_search.expression
    def cone_search(cls, ra, dec, a, b=None, pa=None):
        """SQL expression for cone search"""

        if b is None:
            return fn.q3c_radial_query(cls.ra, cls.dec, ra, dec, a)
        else:
            pa = pa or 0.0
            ratio = b / a
            return fn.q3c_ellipse_query(cls.ra, cls.dec, ra, dec, a, ratio, pa)
