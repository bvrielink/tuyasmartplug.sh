#!/bin/bash

#####################################################################
#
# Script      : tuyasmartplug.sh
# Description : Script to turn on or off a Tuya Smartplug from the
#               command line via an API call to the OctoPi plugin
# Arguments   : on|off
# Author      : Barry Vrielink
# Created     : 20201202
# Version     : 0.1
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
#####################################################################

API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"  # Replace with your OctoPrint API key
PLUGIN_LABEL="3D Printer"                   # Replace with your label name from the Tuya Smartplug plugin
SERVER_NAME="octopi.local"                  # Replace with your OctoPrint server name
CURL_EXE="/usr/bin/curl"                    # Change curl path if needed

ACTION=$1

case $ACTION in
    on)
        echo "Turning Tuya Smartplug on..."
        ${CURL_EXE} -s -H "Content-Type: application/json" -H "X-Api-Key: ${API_KEY}" -X POST -d '{ "command":"turnOn", "label":"'"${PLUGIN_LABEL}"'" }' http://${SERVER_NAME}/api/plugin/tuyasmartplug &
        exit $?
        ;;
    off)
        echo "Turning Tuya Smartplug off..."
        ${CURL_EXE} -s -H "Content-Type: application/json" -H "X-Api-Key: ${API_KEY}" -X POST -d '{ "command":"turnOff", "label":"'"${PLUGIN_LABEL}"'" }' http://${SERVER_NAME}/api/plugin/tuyasmartplug &
        exit $?
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
esac
