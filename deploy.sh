#!/bin/bash

GITHUB_RUN_ID=$1

# Fetch secrets from Azure Key Vault
# SHARNILOGKEYVAULT=$(az keyvault secret show --name "KEYVAULTSHARNITHALOG" --vault-name "dockeyvault280824" --query "value" -o tsv)
# echo $SHARNILOGKEYVAULT
# API_KEY=$(az keyvault secret show --name "micro" --vault-name "keyvaulttest1506" --query "value" -o tsv)

# Replace placeholders in appsetting.json with fetched secrets
# sed -i "s|#{__logLevel__}#|$DATABASE_CONNECTION_STRING|g" appsettings.json
# sed -i "s|#{__microsoft__}#|$API_KEY|g" appsettings.json

IMAGE_TAG=githubcisharni.azurecr.io/demoenv:${GITHUB_RUN_ID}

# Define backend.yaml content dynamically with fetched secrets 
cat <<EOF > backend.yaml
kind: containerapp
location: East US
name: contaiinerapps13
type: Microsoft.App/containerApps
properties:
  managedEnvironmentId: /subscriptions/80/resourceGroups/sharnitha-poc/providers/Microsoft.App/managedEnvironments/managedEnvironment-sharnithapoc-beb7
  configuration:
    secrets:
      - name: 'SHARNILO'
        keyVaultUrl: '@Microsoft.KeyVault(VaultName=dockeyvault280824;SecretName=KEYVAULTSHARNITHALOG)'
        identity: 'system'
    activeRevisionsMode: Single
    ingress:
      external: true
      allowInsecure: false
      targetPort: 80
      traffic:
        - latestRevision: true
          weight: 100
      transport: Http
    registries:
      - passwordSecretRef: reg-pswd-7fd98047-a315
        server: githubcisharni.azurecr.io
        username: githubcisharni
  template:
    containers: 
      - image: $IMAGE_TAG
        name: githubcisharni
        env:
          - name: SHARNILOG
            secretRef: SHARNILO
        resources:
          cpu: 2
          memory: 4Gi
