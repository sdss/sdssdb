#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: John Donor (j.donor@tcu.edu)
# @Date: 2023-01-27
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from sdssdb.connection import PeeweeDatabaseConnection


class LVMdbDatabaseConnection(PeeweeDatabaseConnection):

    dbname = 'lvmdb'
    auto_reflect = False


database = LVMdbDatabaseConnection()  # noqa
