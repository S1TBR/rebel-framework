#!/usr/bin/env python 
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt'

from lib.utils.colors import * 
from lib.utils.settings import NAME,VERSION

class usage:
	""" docstring for usage """
	def banner(self):
                print ""

	def basic(self,_exit_=True):
		self.banner() 
		print "Usage: %s [options]\n"%NAME
		print "\t-u --url\tTarget URL (e.g: http://www.site.com)"
		print "\t-s --scan\tScan options (default=5):\n"
		print "\t\t0 :\tFingerprint (server,waf,cms,...)"
		print "\t\t1 :\tAttacks (sql,ldap injection,...)"
		print "\t\t2 :\tAudit (phpinfo,openredirect,...)"
		print "\t\t3 :\tBruteforce (dir,file,backup,...)"
		print "\t\t4 :\tDisclosure (emails,password,...)"
		print "\t\t5 :\tFull scan (audit,attacks,brute,...)\n"
		print "\t-H --headers\tExtra headers (e.g: \"Host:site.com\")"
		print "\t-d --data\tData to be sent via POST method"
		print "\t-m --method\tHTTP method, GET or POST"
		print "\t-h --host\tHTTP Host header value"
		print "\t-R --referer\tHTTP Referer header value"
		print "\t-a --auth\tHTTP Basic Authentication (user:pass)"
		print "\t-A --agent\tHTTP User-agent header value"
		print "\t-r --ragent\tUse random User-agent header value"
		print "\t-c --cookie\tHTTP Cookie header value"
		print "\t-p --proxy\tUse a proxy, (host:port)"
		print "\t-P --proxy-auth\tProxy Authentication, (user:pass)"
		print "\t-t --timeout\tSeconds to wait before timeout connection"
		print "\t-n --redirect\tSet redirect target URL False (default=True)"
		print "\t-v --verbose\tVerbosity, print more informations"
		print "\t-V --version\tShow tool version"
		print "\t-hh --help\tShow this help and exit\n"
		print "Examples:\n"
		print "\t%s --url http://www.site.com/"%NAME
		print "\t%s --url http://www.site.com/ --scan [0,2,4]"%NAME
		print "\t%s --url http://www.site.com/ --auth \"admin:1233\""%NAME
		print "\t%s --url http://www.site.com/index.php?id=1 --scan [1,4]"%NAME
		print "\t%s --url http://www.site.com/index.php --data \"id=1\" --method POST --scan [1,4]"%NAME
		print "\t%s --url http://www.site.com/index.php?id=1 --scan [1,4] --headers \"Host: site.com,...\""%NAME
		print "\t%s --url http://www.site.com/ --scan [0,2,4] --proxy 10.10.10.10:80 --proxy-auth \"root:1234\"\n"%NAME
		if _exit_: exit(0)
