#!/bin/sh
set -e 
dotnet run dotnet-folder.dll
# LOG=$LOG
# MICRO=$MICROSOFT
# # Start SSH service
# sed -i "s|__LOG__|$LOG|g" appsettings.json
# sed -i "s|__MICRO__|$MICRO|g" appsettings.json

# Start the application
# dotnet run dotnet-folder.dll
