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
name: containerappname
type: Microsoft.App/containerApps
properties:
  managedEnvironmentId: /subscriptions/8da5ea31-eccb-4d99-8a1a-437ea5504220/resourceGroups/sharnitha-poc/providers/Microsoft.App/managedEnvironments/managedEnvironment-sharnithapoc-9f5c
  configuration:
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
      - passwordSecretRef: reg-pswd-152a211b-bf17
        server: githubcisharni.azurecr.io
        username: githubcisharni
    secrets:
      - name: my-keyvault-secret
        keyVaultUrl: https://keyvaultname0108.vault.azure.net/secrets/KEY01/71cb391771fd45c1a96e84aebb416095
        identity: system
  template:
    containers: 
      - image: $IMAGE_TAG
        name: containerappname
        env:
        - name: LOGLEVELMICROSOFT
          value: Warning
        - name: my
          secretRef: my-keyvault-secret
            
        resources:
          cpu: 2
          memory: 4Gi
          
    scale:
      minReplicas: 1
      maxReplicas: 10
EOF
az containerapp update  -n containerappname -g sharnitha-poc --image $IMAGE_TAG --yaml backend.yaml
