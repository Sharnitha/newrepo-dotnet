#!/bin/sh
set -e
 
service ssh start

MICRO=$MICROSOFT
# Start SSH service
# sed -i "s|__LOG__|$LOG|g" appsettings.json
sed -i "s|__MICRO__|$MICRO|g" appsettings.json

exec dotnet dotnet-folder.dll
