#!/bin/sh
set -e
 
service ssh start

# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json 
sed -i "s|{__MICRO__}|$SHARNITHAMICROSOFT|g" appsettings.json  
sed -i "s|{__BASEURL__}|$BASEKEYURL|g" appsettings.json 
sed -i "s|{__APIKEY__}|12345abcdefg|g" appsettings.json
exec dotnet dotnet-folder.dll
