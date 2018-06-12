#!/usr/bin/env python 
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt

from plugins.attacks.bashi import *
from plugins.attacks.blindsqli import *
from plugins.attacks.bufferoverflow import *
from plugins.attacks.htmli import *
from plugins.attacks.ssi import *
from plugins.attacks.headerxss import *
from plugins.attacks.headersqli import *
from plugins.attacks.ldapi import *
from plugins.attacks.lfi import *
from plugins.attacks.oscommand import *
from plugins.attacks.phpi import *
from plugins.attacks.sqli import *
from plugins.attacks.xpathi import *
from plugins.attacks.xss import *
from lib.utils.printer import *

def Attacks(kwargs,url,data):
	info('Starting attack module...')
	headersqli(kwargs,url,data).run()
	headerxss(kwargs,url,data).run()
	bashi(kwargs,url,data).run()
	blindsqli(kwargs,url,data).run()
	bufferoverflow(kwargs,url,data).run()
	htmli(kwargs,url,data).run()
	ldapi(kwargs,url,data).run()
	lfi(kwargs,url,data).run()
	oscommand(kwargs,url,data).run()
	phpi(kwargs,url,data).run()
	sqli(kwargs,url,data).run()
	xpathi(kwargs,url,data).run()
	xss(kwargs,url,data).run()
	null()