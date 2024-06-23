#!/bin/sh
set -e
 
# Start SSH service
service ssh start

# Start the application
exec dotnet dotnet-folder.dll
