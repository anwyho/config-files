#!/bin/sh

#       _                  _                              __  _  _       
#      | |                | |                            / _|(_)| |      
#      | |__    __ _  ___ | |__       _ __   _ __  ___  | |_  _ | |  ___ 
#      | '_ \  / _` |/ __|| '_ \     | '_ \ | '__|/ _ \ |  _|| || | / _ \
#    _ | |_) || (_| |\__ \| | | |    | |_) || |  | (_) || |  | || ||  __/
#   (_)|_.__/  \__,_||___/|_| |_|    | .__/ |_|   \___/ |_|  |_||_| \___|
#                             ______ | |                                 
#                            |______||_|                                 
# This file loads .profile. Not much to see here! .profile loads .bashrc.

# Loads .profile which loads .bashrc
if [ -r ~/.profile ]; then . ~/.profile; fi
