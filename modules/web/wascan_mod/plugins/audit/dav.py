#!/usr/bin/env python 
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt'

from re import search,I
from lib.utils.printer import *
from lib.request.request import *

class dav(Request):
	""" dav """
	# methods
	m_search = "SEARCH"
	m_profind = "PROFIND"
	cotent_type = "application/xml; charset=\"utf-8\""
	def __init__(self,kwargs,url,data):
		Request.__init__(self,kwargs)
		self.url = url
		self.data = data

	def run(self):
		"""Run"""
		self.search()
		self.propfind()

	def search(self):
		# headers 
		headers = {
					'Content-Type':self.cotent_type
					}
		# content data
		content =  "<?xml version='1.0'?>\r\n"
		content += "<g:searchrequest xmlns:g='DAV:'>\r\n"
		content += "<g:sql>\r\n"
		content += "Select 'DAV:displayname' from scope()\r\n"
		content += "</g:sql>\r\n"
		content += "</g:searchrequest>\r\n"
		# send request 
		req = self.Send(url=self.url,method=self.m_search,data=content,headers=headers)
		# regenx
		regexp = r"<a:response>|<a:status>|xmlns:a=\"DAV:\""
		if search(regexp,req.content) and req.code == 200:
			plus('A potential DAV directory listing with HTTP search method at: %s'%(req.url))

	def profind(self):
		# headers 
		headers = {
					'Depth' : 1,
					'Content-Type':self.cotent_type
		}
		# content data
		content = "<?xml version='1.0'?>\r\n"
		content += "<a:propfind xmlns:a='DAV:'>\r\n"
		content += "<a:prop>\r\n"
		content += "<a:displayname:/>\r\n"
		content += "</a:prop>\r\n"
		content += "</a:propfind>\r\n"
		# send request 
		req = self.Send(url=self.url,method=self.m_profind,data=content,headers=headers)
		if 'D:href' in req.content and req.code == 200:
			plus('A potential DAV directory listing with HTTP profind method at: %s'%(req.url))