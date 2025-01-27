#!/bin/sh
set -e
 
 
# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
# sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json  
# sed -i "s|{__LOGDMICROSOFT__}|$LOGLEVELMICROSOFT|g" appsettings.json
# sed -i "s|{__BASEURL__}|$BASEKEYURL|g" appsettings.json 
# sed -i "s|{__APIKEY__}|$APIBASEURL|g" appsettings.json
exec dotnet dotnet-folder.dll
