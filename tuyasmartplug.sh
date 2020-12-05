#!/bin/bash

######################################################################
#
# Script      : tuyasmartplug.sh
# Description : Script to turn on or off a Tuya Smartplug from the
#               command line via an API call to the OctoPrint plugin.
#               For the status option to work you need to enable
#               debug logging in the Tuya Smartplug plugin.
# Arguments   : on|off|status
# Author      : Barry Vrielink
# Created     : 20201202
# Version     : 0.2
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
######################################################################

API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"                            # Replace with your OctoPrint API key
PLUGIN_LABEL="3D Printer"                                             # Replace with your label name from the Tuya Smartplug plugin
SERVER_NAME="octopi.local"                                            # Replace with your OctoPrint server name
CURL_EXE="/usr/bin/curl"                                              # Change curl path if needed
DEBUG_FILE="/home/pi/.octoprint/logs/plugin_tuyasmartplug_debug.log"  # Change OctoPrint log path if needed

ACTION=$1

case $ACTION in
    on)
        echo "Turning Tuya Smartplug on..."
        ${CURL_EXE} -s -H "Content-Type: application/json" -H "X-Api-Key: ${API_KEY}" -X POST -d '{ "command":"turnOn", "label":"'"${PLUGIN_LABEL}"'" }' http://${SERVER_NAME}/api/plugin/tuyasmartplug &
        exit
        ;;
    off)
        echo "Turning Tuya Smartplug off..."
        ${CURL_EXE} -s -H "Content-Type: application/json" -H "X-Api-Key: ${API_KEY}" -X POST -d '{ "command":"turnOff", "label":"'"${PLUGIN_LABEL}"'" }' http://${SERVER_NAME}/api/plugin/tuyasmartplug &
        exit
        ;;
    status)
        echo "Checking status Tuya Smartplug..."
        ${CURL_EXE} -s -H "Content-Type: application/json" -H "X-Api-Key: ${API_KEY}" -X POST -d '{ "command":"checkStatus", "label":"'"${PLUGIN_LABEL}"'" }' http://${SERVER_NAME}/api/plugin/tuyasmartplug &
        sleep 5
        if [ ! -f ${DEBUG_FILE} ]; then
            echo "Debug file not found! Enable debug logging in the plugin."
            exit 1
        fi
        STATUS=`grep "DEBUG: Status:" ${DEBUG_FILE} | tail -1`
        case $STATUS in
            *True*)
                echo "Tuya Smartplug is turned ON."
                ;;
            *False*)
                echo "Tuya Smartplug is turned OFF."
                ;;
            *)
                echo "Tuya Smartplug status is UNKNOWN."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 {on|off|status}"
        exit 1
esac
