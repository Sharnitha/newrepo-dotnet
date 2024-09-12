#!/bin/sh
set -e
 
service ssh start

# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
# sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json 
# sed -i "s|{__MICRO__}|$SHARNITHAMICROSOFT|g" appsettings.json  
# sed -i "s|{__BASE_URL__}|$BASEKEYURLL|g" appsettings.json 
# sed -i "s|{__API_KEY__}|$APIBASEURLL|g" appsettings.json
# chmod 777 repla.sh
# ./repla.sh
exec dotnet dotnet-folder.dll
