#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt

from plugins.audit.xst import *
from plugins.audit.apache import *
from plugins.audit.dav import *
from plugins.audit.phpinfo import *
from plugins.audit.robots import *
from lib.utils.printer import *


def Audit(kwargs, url, data):
    info("Starting audit module...")
    xst(kwargs, url, data).run()
    apache(kwargs, url, data).run()
    # dav(kwargs, url, data).run()
    phpinfo(kwargs, url, data).run()
    robots(kwargs, url, data).run()
    null()
