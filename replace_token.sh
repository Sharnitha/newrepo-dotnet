#!/bin/bash
 
# Variables
appSettingsPath="appsettings.json"  # Path to your appsettings.json file in the root directory
keyVaultName="keyvault11062"     # Name of your Azure Key Vault
 
# Function to get secret from Key Vault
get_keyvault_secret() {
    local secret_name=$1
    az keyvault secret show --vault-name $keyVaultName --name $secret_name --query value -o tsv
}
 
# Read the appsettings.json file
appSettingsContent=$(<"$appSettingsPath")
 
# Replace placeholders
logLevel=$(get_keyvault_secret "DefaultLogLevel")
updatedContent=$(echo "$appSettingsContent" | sed "s/{__LOGLEVEL__}/$logLevel/g")
 
# Write the updated content back to the appsettings.json file
echo "$updatedContent" > "$appSettingsPath"
 
echo "appsettings.json updated successfully"
