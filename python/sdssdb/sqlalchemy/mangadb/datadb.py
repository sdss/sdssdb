# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:07:08
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-09-22 14:23:29

from __future__ import print_function, division, absolute_import

from sqlalchemy.schema import Column
from sqlalchemy.types import JSON, Float, Integer, String
from sqlalchemy.orm import configure_mappers, deferred, relationship
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import type_coerce
from sqlalchemy.dialects.postgresql import *

import six

#from sdssdb import config
#Base = config['db'].Base

Base = declarative_base()

class MetaBase(type):
    ''' MetaClass to construct a new DataModelList class '''
    def __call__(cls, *args, **kwargs):
        #from sdssdb import config
        #cls = config['db'].Base
        print('call metabase')
        return super(MetaBase, cls).__call__(cls, *args, **kwargs)

    def __new__(cls, *args, **kwargs):
        from sdssdb import config
        print(cls)
        cls = config['db'].Base
        stuff=5
        print('new metabase')
        #return super(MetaBase, cls).__new__(cls, *args, **kwargs)



# # class DataModelList(six.with_metaclass(MetaDataModel, OrderedDict)):
# #     ''' Base Class for a list of DataModels '''

# class Base(six.with_metaclass(MetaBase)):
#     def __new__(cls, *args, **kwargs):
#         print('new base')
#         #from sdssdb import config
#         #cls = config['db'].Base
#         #return declarative_base(metadata=cls.metadata)
#         return super(Base, cls).__new__(cls, *args, **kwargs)


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
    #__table_args__ = {'autoload': True, 'schema': 'mangadatadb', 'extend_existing': True}

    print('new wavelength')
    wavelength = deferred(Column(ARRAY_D(Float, zero_indexes=True)))

    def __repr__(self):
        return '<Wavelength (pk={0})>'.format(self.pk)

