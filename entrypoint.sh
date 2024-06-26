#!/bin/sh
set -e
 
# Start SSH service
sed -i "s|{__LOG__}|LOG|g" appsettings.json
sed -i "s|{__MICRO__}|MICROSOFT|g" appsettings.json

# Start the application
exec dotnet dotnet-folder.dll
