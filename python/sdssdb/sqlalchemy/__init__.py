# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2018-09-22 09:02:19
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2018-10-09 12:48:00

from __future__ import print_function, division, absolute_import

from sqlalchemy.ext.declarative import declared_attr

#SCHEMA = None


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
    ''' A custom sqlalchemy declarative Base '''
    _schema = None
    #: A list of fields (as strings) to be included in the ``__repr__```
    print_fields = []

    # def __new__(cls, *args, **kwargs):
    #     global SCHEMA
    #     print('new', args, kwargs, SCHEMA, cls._schema)
    #     return super(BaseModel, cls).__new__(cls, *args, **kwargs)

    def __repr__(self):
        """A custom repr for models."""

        reg = str(self.__class__.__name__)
        if reg is not None:

            fields = ['pk={0!r}'.format(self.get_id())]

            for extra_field in ['label', 'name']:
                if extra_field not in self.print_fields:
                    self.print_fields.append(extra_field)

            for ff in self.print_fields:
                base, value = get_field(self, ff)
                if base:
                    fields.append('{0}={1!r}'.format(base, value))

            return '<{0} ({1})>'.format(reg, ', '.join(fields))

        return super(BaseModel, self).__repr__()

    def get_id(self):
        ''' get the pk '''
        return self.pk if hasattr(self, 'pk') else None

    # @declared_attr
    # def __table_args__(cls):
    #     return {'schema': SCHEMA}

    # @classmethod
    # def update_schema(cls, schema=None):
    #     cls._schema = schema or SCHEMA

    # @classmethod
    # def _set_schema(cls, schema):
    #     cls._schema = schema
    #     # ta = cls.__table_args__.copy()
    #     # ta.update({'schema': schema})
    #     cls.__table_args__ = ta
    #

# class Schema(object):
#     #_schema = SCHEMA
#     global SCHEMA

#     @declared_attr
#     def __table_args__(cls):
#         return {'schema': SCHEMA}





