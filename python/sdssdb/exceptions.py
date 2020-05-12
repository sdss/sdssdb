# !usr/bin/env python
# -*- coding: utf-8 -*-
#
# Licensed under a 3-clause BSD license.
#
# @Author: Brian Cherinka
# @Date:   2017-12-05 12:01:21
# @Last modified by:   Brian Cherinka
# @Last Modified time: 2017-12-05 12:19:32

from . import log


class SdssdbError(Exception):
    """A custom core Sdssdb exception"""

    def __init__(self, message=None):

        message = 'There has been an error' \
            if not message else message

        super(SdssdbError, self).__init__(message)


class SdssdbNotImplemented(SdssdbError):
    """A custom exception for not yet implemented features."""

    def __init__(self, message=None):

        message = 'This feature is not implemented yet.' \
            if not message else message

        super(SdssdbNotImplemented, self).__init__(message)


class SdssdbAPIError(SdssdbError):
    """A custom exception for API errors"""

    def __init__(self, message=None):
        if not message:
            message = 'Error with Http Response from Sdssdb API'
        else:
            message = 'Http response error from Sdssdb API. {0}'.format(message)

        super(SdssdbAPIError, self).__init__(message)


class SdssdbApiAuthError(SdssdbAPIError):
    """A custom exception for API authentication errors"""
    pass


class SdssdbMissingDependency(SdssdbError):
    """A custom exception for missing dependencies."""
    pass


class SdssdbWarning(Warning):
    """Base warning for Sdssdb."""

    logger = log


class SdssdbUserWarning(UserWarning, SdssdbWarning):
    """The primary warning class."""
    pass


class SdssdbSkippedTestWarning(SdssdbUserWarning):
    """A warning for when a test is skipped."""
    pass


class SdssdbDeprecationWarning(SdssdbUserWarning):
    """A warning for deprecated features."""
    pass
