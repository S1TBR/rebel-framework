#!/usr/bin/env python 
# -*- coding:utf-8 -*-
#
# @name:    Wascan - Web Application Scanner
# @repo:    https://github.com/m4ll0k/Wascan
# @author:  Momo Outaadi (M4ll0k)
# @license: See the file 'LICENSE.txt 

from lib.utils.printer import *
from lib.request.request import *
from plugins.fingerprint.cms.drupal import *
from plugins.fingerprint.cms.joomla import *
from plugins.fingerprint.cms.magento import *
from plugins.fingerprint.cms.plone import *
from plugins.fingerprint.cms.silverstripe import *
from plugins.fingerprint.cms.wordpress import *
from plugins.fingerprint.framework.asp_mvc import *
from plugins.fingerprint.framework.cakephp import *
from plugins.fingerprint.framework.codeigniter import *
from plugins.fingerprint.framework.cherrypy import *
from plugins.fingerprint.framework.dancer import *
from plugins.fingerprint.framework.django import *
from plugins.fingerprint.framework.flask import *
from plugins.fingerprint.framework.fuelphp import *
from plugins.fingerprint.framework.grails import *
from plugins.fingerprint.framework.horde import *
from plugins.fingerprint.framework.karrigell import *
from plugins.fingerprint.framework.larvel import *
from plugins.fingerprint.framework.nette import *
from plugins.fingerprint.framework.phalcon import *
from plugins.fingerprint.framework.play import *
from plugins.fingerprint.framework.rails import *
from plugins.fingerprint.framework.seagull import *
from plugins.fingerprint.framework.spring import *
from plugins.fingerprint.framework.symfony import *
from plugins.fingerprint.framework.web2py import *
from plugins.fingerprint.framework.yii import *
from plugins.fingerprint.framework.zend import *
from plugins.fingerprint.header.cookies import *
from plugins.fingerprint.header.header import *
from plugins.fingerprint.language.asp import *
from plugins.fingerprint.language.aspnet import *
from plugins.fingerprint.language.coldfusion import *
from plugins.fingerprint.language.flash import *
from plugins.fingerprint.language.java import *
from plugins.fingerprint.language.perl import *
from plugins.fingerprint.language.php import *
from plugins.fingerprint.language.python import *
from plugins.fingerprint.language.ruby import *
from plugins.fingerprint.os.bsd import *
from plugins.fingerprint.os.ibm import *
from plugins.fingerprint.os.linux import *
from plugins.fingerprint.os.mac import *
from plugins.fingerprint.os.solaris import *
from plugins.fingerprint.os.unix import *
from plugins.fingerprint.os.windows import *
from plugins.fingerprint.server.server import *
from plugins.fingerprint.waf.airlock import *
from plugins.fingerprint.waf.anquanbao import *
from plugins.fingerprint.waf.armor import *
from plugins.fingerprint.waf.aws import *
from plugins.fingerprint.waf.asm import *
from plugins.fingerprint.waf.baidu import *
from plugins.fingerprint.waf.barracuda import *
from plugins.fingerprint.waf.betterwpsecurity import *
from plugins.fingerprint.waf.bigip import *
from plugins.fingerprint.waf.binarysec import *
from plugins.fingerprint.waf.blockdos import *
from plugins.fingerprint.waf.ciscoacexml import *
from plugins.fingerprint.waf.cloudflare import *
from plugins.fingerprint.waf.cloudfront import *
from plugins.fingerprint.waf.comodo import *
from plugins.fingerprint.waf.datapower import *
from plugins.fingerprint.waf.denyall import *
from plugins.fingerprint.waf.dotdefender import *
from plugins.fingerprint.waf.edgecast import *
from plugins.fingerprint.waf.expressionengine import *
from plugins.fingerprint.waf.fortiweb import *
from plugins.fingerprint.waf.hyperguard import *
from plugins.fingerprint.waf.incapsula import *
from plugins.fingerprint.waf.isaserver import *
from plugins.fingerprint.waf.jiasule import *
from plugins.fingerprint.waf.knownsec import *
from plugins.fingerprint.waf.kona import *
from plugins.fingerprint.waf.modsecurity import *
from plugins.fingerprint.waf.netcontinuum import *
from plugins.fingerprint.waf.netscaler import *
from plugins.fingerprint.waf.newdefend import *
from plugins.fingerprint.waf.nsfocus import *
from plugins.fingerprint.waf.paloalto import *
from plugins.fingerprint.waf.profense import *
from plugins.fingerprint.waf.radware import *
from plugins.fingerprint.waf.requestvalidationmode import *
from plugins.fingerprint.waf.safe3 import *
from plugins.fingerprint.waf.safedog import *
from plugins.fingerprint.waf.secureiis import *
from plugins.fingerprint.waf.senginx import *
from plugins.fingerprint.waf.sitelock import *
from plugins.fingerprint.waf.sonicwall import *
from plugins.fingerprint.waf.sophos import *
from plugins.fingerprint.waf.stingray import *
from plugins.fingerprint.waf.sucuri import *
from plugins.fingerprint.waf.teros import *
from plugins.fingerprint.waf.trafficshield import *
from plugins.fingerprint.waf.urlscan import *
from plugins.fingerprint.waf.uspses import *
from plugins.fingerprint.waf.varnish import *
from plugins.fingerprint.waf.wallarm import *
from plugins.fingerprint.waf.webknight import *
from plugins.fingerprint.waf.yundun import *
from plugins.fingerprint.waf.yunsuo import *


class Fingerprint(Request):
	"""Fingerprint"""
	def __init__(self,kwargs,url):
		Request.__init__(self,kwargs)
		self.kwarg = kwargs
		self.url = url

	def run(self):
		info('Starting fingerprint target...')
		try:
			req = self.Send(url=self.url,method="GET")
			s = server(self.kwarg,self.url).run()
			if s:plus('Server: %s'%(s))
			cms = detectCms(req.headers,req.content)
			for c in cms:
				if c != None and c != "":
					plus('CMS: %s'%(c))
			framework = detectFramework(req.headers,req.content)
			for f in framework:
				if f != None and f != "":
					plus('Framework: %s'%(f))
			lang = detectLanguage(req.content)
			for l in lang:
				if l != None and l != "":
					plus('Language: %s'%(l))
			os = detectOs(req.headers)
			for o in os:
				if o != None and o != "":
					plus('Operating System: %s'%o)
			waf = detectWaf(req.headers,req.content)
			for a in waf:
				if a != None and a != "":
					plus('Web Application Firewall (WAF): %s'%a)
			checkHeaders(req.headers,req.content)
			null()
		except Exception as e:
			print("Exception: {}".format(e))

def detectCms(headers,content):
	return (drupal(headers,content),
			joomla(headers,content),
			magento(headers,content),
			plone(headers,content),
			silverstripe(headers,content),
			wordpress(headers,content),
			)

def detectFramework(headers,content):
	return (
		mvc(headers,content),
		cakephp(headers,content),
		cherrypy(headers,content),
		codeigniter(headers,content),
		dancer(headers,content),
		django(headers,content),
		flask(headers,content),
		fuelphp(headers,content),
		grails(headers,content),
		horde(headers,content),
		karrigell(headers,content),
		larvel(headers,content),
		nette(headers,content),
		phalcon(headers,content),
		play(headers,content),
		rails(headers,content),
		seagull(headers,content),
		spring(headers,content),
		symfony(headers,content),
		web2py(headers,content),
		yii(headers,content),
		zend(headers,content)
		)

def checkHeaders(headers,content):
	if 'cookie' in headers.keys():
		if headers['cookie']:cookies().__run__(headers['cookie'])
	elif 'set-cookie' in headers.keys():
		if headers['set-cookie']:cookies().__run__(headers['set-cookie'])
	header()._run_(headers)

def detectLanguage(content):
	return (
		asp(content),
		aspnet(content),
		coldfusion(content),
		flash(content),
		java(content),
		perl(content),
		php(content),
		python(content),
		ruby(content)
		)

def detectOs(headers):
	return (
		bsd(headers),
		ibm(headers),
		linux(headers),
		mac(headers),
		solaris(headers),
		unix(headers),
		windows(headers)
		)

def detectWaf(headers,content):
	return (
		airlock(headers,content),
		anquanboa(headers,content),
		armor(headers,content),
		asm(headers,content),
		aws(headers,content),
		baidu(headers,content),
		barracuda(headers,content),
		betterwpsecurity(headers,content),
		bigip(headers,content),
		binarysec(headers,content),
		blockdos(headers,content),
		ciscoacexml(headers,content),
		cloudflare(headers,content),
		cloudfront(headers,content),
		comodo(headers,content),
		datapower(headers,content),
		denyall(headers,content),
		dotdefender(headers,content),
		edgecast(headers,content),
		expressionengine(headers,content),
		fortiweb(headers,content),
		hyperguard(headers,content),
		incapsula(headers,content),
		isaserver(headers,content),
		jiasule(headers,content),
		knownsec(headers,content),
		kona(headers,content),
		modsecurity(headers,content),
		netcontinuum(headers,content),
		netscaler(headers,content),
		newdefend(headers,content),
		nsfocus(headers,content),
		paloalto(headers,content),
		profense(headers,content),
		radware(headers,content),
		requestvalidationmode(headers,content),
		safe3(headers,content),
		safedog(headers,content),
		secureiis(headers,content),
		senginx(headers,content),
		sitelock(headers,content),
		sonicwall(headers,content),
		sophos(headers,content),
		stingray(headers,content),
		sucuri(headers,content),
		teros(headers,content),
		trafficshield(headers,content),
		urlscan(headers,content),
		uspses(headers,content),
		varnish(headers,content),
		wallarm(headers,content),
		webknight(headers,content),
		yundun(headers,content),
		yunsuo(headers,content)
		)