#!/bin/sh
set -e
 
service ssh start
 
# MICRO=$MICROSOFT  
# echo $MICROSOFT
# Start SSH service
# sed -i "s|{__LOGDEF__}|$SHARNILOG|g" appsettings.json  
sed -i "s|{__LOGDMICROSOFT__}|$LOGLEVELMICROSOFT|g" appsettings.json
sed -i "s|{__BASEURL__}|@Microsoft.KeyVault(SecretUri=https://keyvaultname0108.vault.azure.net/secrets/KEY01/71cb391771fd45c1a96e84aebb416095)|g" appsettings.json 
# sed -i "s|{__APIKEY__}|$APIBASEURL|g" appsettings.json
exec dotnet dotnet-folder.dll
