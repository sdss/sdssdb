# flake8: noqa

from sdssdb.connection import PeeweeDatabaseConnection
from sdssdb.peewee import BaseModel


class SDSS5dbDatabaseConnection(PeeweeDatabaseConnection):
    DATABASE_NAME = 'sdss5db'


database = SDSS5dbDatabaseConnection(autoconnect=True)


# Create a new base model class for the observatory and bind the database
class SDSS5dbModel(BaseModel):

    print_fields = []

    class Meta:
        database = database

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
