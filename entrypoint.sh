#!/bin/bash

/usr/local/bin/add_hosts_entry.sh   # Update hosts file
exec "$@"   # Execute command passed as arguments (e.g., dotnet dotnet-folder.dll)
