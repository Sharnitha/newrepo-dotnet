#!/bin/sh
set -e

service ssh start

# sed -i "s|{__BASE_URL__}|$BASEKEYURLL|g" appsettings.json 
# sed -i "s|{__API_KEY__}|$APIBASEURLL|g" appsettings.json
exec dotnet dotnet-folder.dll
