#!/bin/sh
set -e
 
service ssh start

# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json 
exec dotnet dotnet-folder.dll
