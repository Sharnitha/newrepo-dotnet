#!/bin/sh
set -e
service ssh start
exec dotnet dotnet-folder.dll
