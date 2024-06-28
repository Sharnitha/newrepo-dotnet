#!/bin/sh
set -e
 
service ssh start

MICRO=$MICROSOFT
# Start SSH service
sed -i "s|__LOGDEF__|$LOG|g" appsettings.json
sed -i "s|__MICRO__|$MICROSOFT|g" appsettings.json 

exec dotnet dotnet-folder.dll
