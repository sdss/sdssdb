# !/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Filename: peewee_factory.py
# Project: pwdbs
# Author: Brian Cherinka
# Created: Monday, 23rd March 2020 4:32:17 pm
# License: BSD 3-clause "New" or "Revised" License
# Copyright (c) 2020 Brian Cherinka
# Last Modified: Monday, 23rd March 2020 5:34:56 pm
# Modified By: Brian Cherinka


from __future__ import print_function, division, absolute_import

import peewee
from factory import base

#
#  This code, copied from https://github.com/cam-stitt/factory_boy-peewee,
#  implements a factory_boy Model Factory for Peewee ORM models since
#  factory_boy does not support the peewee ORM
#


class PeeweeOptions(base.FactoryOptions):
    def _build_default_options(self):
        return super(PeeweeOptions, self)._build_default_options() + [
            base.OptionDefault('database', None, inherit=True),
        ]


class PeeweeModelFactory(base.Factory):
    """Factory for peewee models. """

    _options_class = PeeweeOptions

    class Meta:
        abstract = True

    @classmethod
    def _setup_next_sequence(cls, *args, **kwargs):
        """Compute the next available PK, based on the 'pk' database field."""
        db = cls._meta.database
        model = cls._meta.model
        pk = getattr(model, model._meta.primary_key.name)
        max_pk = (model.select(peewee.fn.Max(pk).alias('maxpk'))
                       .limit(1).order_by().execute())
        max_pk = [mp.maxpk for mp in max_pk][0]
        if isinstance(max_pk, int):
            return max_pk + 1 if max_pk else 1
        else:
            return 1

    @classmethod
    def _create(cls, target_class, *args, **kwargs):
        """Create an instance of the model, and save it to the database."""
        db = cls._meta.database
        obj = target_class.create(**kwargs)
        return obj
