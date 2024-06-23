#!/bin/sh
set -e
 
# Start SSH service
service ssh start

# Login to Azure using managed identity or service principal
# az login --service-principal -u $DOCKER_LOGIN -p $DOCKER_PASSWORD --tenant $DOCKER_TENANT
az login --service-principal -u c03d7f87-710f-41e6-951e-1b48aebeb8f0 -p $DOCKER_PASSWORD -t 406f6fb2-e087-4d29-9642-817873fddc4c

# Fetch and replace placeholders in appsettings.json
SECRET_DEFAULT=$(az keyvault secret show --name DefaultLogLevel --vault-name $KEYVAULT_NAME --query value -o tsv)
SECRET_MICROSOFT=$(az keyvault secret show --name MicrosoftLogLevel --vault-name $KEYVAULT_NAME --query value -o tsv)

sed -i "s|{__DEFAULT__}|$SECRET_DEFAULT|g" /app/appsettings.json
sed -i "s|{__MICROSOFT__}|$SECRET_MICROSOFT|g" /app/appsettings.json

# Start the application
exec dotnet dotnet-folder.dll
