#!/usr/bin/env python 
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt


from plugins.disclosure.creditcards import *
from plugins.disclosure.emails import *
from plugins.disclosure.privateip import *
from plugins.disclosure.ssn import *
from lib.request.request import *
from plugins.disclosure.errors import *
from lib.utils.printer import *

class Disclosure(Request):
	""" Disclosure """
	def __init__(self,kwargs,url,data):
		Request.__init__(self,kwargs)
		self.url = url

	def run(self):
		info('Starting disclosure module...')
		req = self.Send(url=self.url,method="GET")
		creditcards(req.content)
		emails(req.content)
		privateip(req.content)
		ssn(req.content)
		errors(req.content,req.url)
		null()