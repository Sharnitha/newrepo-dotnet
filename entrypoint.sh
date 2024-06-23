#!/bin/sh
set -e

# Start SSH service
service ssh start

# Login to Azure using managed identity or service principal
az login --service-principal -u ${{ secrets.DOCKER_LOGIN }} -p ${{ secrets.DOCKER_PASSWORD }} --tenant ${{secrets.DOCKER_TENANT}}

# Fetch and replace placeholders in appsettings.json
SECRET_DEFAULT=$(az keyvault secret show --name DefaultLogLevel --vault-name $KEYVAULT_NAME --query value -o tsv)
SECRET_MICROSOFT=$(az keyvault secret show --name MicrosoftLogLevel --vault-name $KEYVAULT_NAME --query value -o tsv)

sed -i "s|{__DEFAULT__}|$SECRET_DEFAULT|g" /app/appsettings.json
sed -i "s|{__MICROSOFT__}|$SECRET_MICROSOFT|g" /app/appsettings.json

# Start the application
exec dotnet dotnet-folder.dll
