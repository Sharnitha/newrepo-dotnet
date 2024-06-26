#!/bin/sh
set -e 
LOG=$LOG
MICRO=$MICROSOFT
# Start SSH service
sed -i "s|__LOG__|$LOG|g" appsettings.json
sed -i "s|__MICRO__|$MICROSOFT|g" appsettings.json

# Start the application
dotnet run dotnet-folder.dll
