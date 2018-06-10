#
# shell.py - the weeman main shell
#
# This file if part of weeman project
#
# See 'LICENSE' file for copying
#

import sys
import os
from core.complete import complete
from core.complete import array
from core.config import __version__
from core.config import __codename__
from core.misc import printt
from core.misc import print_help
from core.misc import print_help_option
from core.config import url
from core.config import action_url
from core.config import port
from core.config import user_agent
from core.config import html_file
from core.config import external_js
from core.config import quiet_mode
from core.config import say
from core.httpd import weeman

def print_startup():
    print("")

def profile_getkey(profile_file, key):
    try:
        profile = open(profile_file, "r").readlines()
    except Exception as e:
        return 0
    if profile == None:
        return 0
    for line in profile:
        if line.startswith("\n") or line.startswith("#"):
            pass

        else:
            (skey,value) = line.split(" = ")
            if skey == key:
                return str(value[:-1])

    return 0

def shell_noint(profile_file):
    global url
    global port
    global action_url
    global user_agent
    global html_file
    global external_js

    try:
        url = profile_getkey(profile_file, "url")
        action_url = profile_getkey(profile_file, "action_url")
        port = int(profile_getkey(profile_file, "port"))
        user_agent = profile_getkey(profile_file, "user_agent")
        html_file = profile_getkey(profile_file, "html_file")
        external_js = profile_getkey(profile_file, "external_js")

        print_startup()
        s = weeman(url,port)
        s.clone()
        s.serve()

    except ValueError:
        printt(3, "Error: your profile file looks bad.")
    except KeyboardInterrupt:
        s = weeman(url,port)
        s.cleanup()
        print("\nInterrupt ...")
    except IndexError:
        if prompt[0] == "help" or prompt[0] == "?":
            print_help()
        else:
            printt(3, "Error: please provide option for \'%s\'." %prompt[0])
    except Exception as e:
        printt(3, "Error: (%s)" %(str(e)))

def shell():
    """
        The shell, parse command line args,
        and set variables.
    """
    global url
    global port
    global action_url
    global user_agent
    global html_file
    global external_js

    print_startup()

    if os.path.exists("history.log"):
        if  os.stat("history.log").st_size == 0:
            history = open("history.log", "w")
        else:
            history = open("history.log", "a")
    else:
        history = open("history.log", "w")



    url = str(sys.argv[1])
    port = int(sys.argv[2])

    try:
        if "js" in str(sys.argv[3]):
           external_js = str(sys.argv[3])
        else:
           action_url = str(sys.argv[3])
    except:
        pass    

    try:
        external_js = str(sys.argv[4])
    except:
        pass



    while True:
        try:

            #############################################        
            if not url:
                printt(3, "Error: please set \"url\".")
            elif not action_url:
                printt(3, "Error: please set \"action_url\".")
            else:
                # Here we start the server (:
                s = weeman(url,port)
                s.clone()
                s.serve()

        except KeyboardInterrupt:
            s = weeman(url,port)
            s.cleanup()
            exit()
        except IndexError:
            if prompt[0] == "help" or prompt[0] == "?":
                print_help()
            else:
                printt(3, "Error: please provide option for \'%s\'." %prompt[0])
        except Exception as e:
            printt(3, "Error: (%s)" %(str(e)))
