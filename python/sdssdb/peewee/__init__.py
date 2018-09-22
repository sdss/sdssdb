# flake8: noqa

from peewee import Model


class BaseModel(Model):

    print_fields = []

    def __str__(self):
        """A custom repr for observatory models.

        By default it always prints pk, name, and label, if found. Models can
        define they own ``print_fields`` as a list of field to be output in the
        repr.

        """

        fields = ['pk={0!r}'.format(self.get_id())]

        for extra_field in ['label']:
            if extra_field not in self.print_fields:
                self.print_fields.append(extra_field)

        for ff in self.print_fields:
            if hasattr(self, ff):
                fields.append('{0}={1!r}'.format(ff, getattr(self, ff)))

        return '{0}'.format(', '.join(fields))
