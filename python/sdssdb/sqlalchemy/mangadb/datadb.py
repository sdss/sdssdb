# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:08
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-09-23 18:50:54

from __future__ import print_function, division, absolute_import

from sqlalchemy.schema import Column
from sqlalchemy.types import JSON, Float, Integer, String
from sqlalchemy.orm import configure_mappers, deferred, relationship
from sqlalchemy import type_coerce
from sqlalchemy.dialects.postgresql import *

from sdssdb.sqlalchemy.mangadb import db, Base


class ARRAY_D(ARRAY):
    class Comparator(ARRAY.Comparator):
        def __getitem__(self, index):
            super_ = super(ARRAY_D.Comparator, self).__getitem__(index)
            if not isinstance(index, slice) and self.type.dimensions > 1:
                super_ = type_coerce(
                    super_,
                    ARRAY_D(
                        self.type.item_type,
                        dimensions=self.type.dimensions - 1,
                        zero_indexes=self.type.zero_indexes)
                )
            return super_
    comparator_factory = Comparator


class Wavelength(Base):
    __tablename__ = 'wavelength'
    __table_args__ = {'schema': 'mangadatadb'}

    wavelength = deferred(Column(ARRAY_D(Float, zero_indexes=True)))

    def __repr__(self):
        return '<Wavelength (pk={0})>'.format(self.pk)


db.prepare_base(Base)
