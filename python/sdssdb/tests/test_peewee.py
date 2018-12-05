# encoding: utf-8
#
# main.py


from __future__ import division
from __future__ import print_function
from __future__ import absolute_import
from __future__ import unicode_literals

import sdssdb.peewee.sdss5db.targetdb as targetdb


class TestPeewee(object):
    """Tests peewee db utils"""

    def test_connection(self):
        """Tests peewee db connection"""

        nt = targetdb.Target.select().count()
        assert nt > 0
