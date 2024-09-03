#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @Author: José Sánchez-Gallego (gallegoj@uw.edu)
# @Date: 2024-09-02
# @Filename: __init__.py
# @License: BSD 3-clause (http://www.opensource.org/licenses/BSD-3-Clause)

from __future__ import annotations

import warnings

from sqlalchemy.exc import MovedIn20Warning


warnings.filterwarnings("ignore", category=MovedIn20Warning)
