# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:15
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-09-23 18:50:52

from __future__ import print_function, division, absolute_import

from sdssdb.sqlalchemy.mangadb import db, Base

class FileType(Base):
    __tablename__ = 'filetype'
    __table_args__ = {'schema': 'mangadapdb'}

    def __repr__(self):
        return '<Filetype (pk={0})>'.format(self.pk)


db.prepare_base(Base)
