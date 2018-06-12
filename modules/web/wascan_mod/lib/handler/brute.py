#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt

from plugins.brute.adminpanel import *
from plugins.brute.backdoor import *
from plugins.brute.backupdir import *
from plugins.brute.backupfile import *
from plugins.brute.commondir import *
from plugins.brute.commonfile import *


def Brute(kwargs, url, data):
    info("Starting brute module...")
    backdoor(kwargs, url, data).run()
    backupdir(kwargs, url, data).run()
    backupfile(kwargs, url, data).run()
    commonfile(kwargs, url, data).run()
    commondir(kwargs, url, data).run()
    adminpanel(kwargs, url, data).run()
    null()
