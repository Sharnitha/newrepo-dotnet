#!/bin/sh
set -e
 
service ssh start

# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json 
sed -i "s|{__MICRO__}|$SHARNITHAMICROSOFT|g" appsettings.json  
sed -i "s|{__BASE_URL__}|$BASEKEYURL|g" appsettings.json 
sed -i "s|{__API_KEY__}|$APIBASEURL|g" appsettings.json

exec dotnet dotnet-folder.dll
