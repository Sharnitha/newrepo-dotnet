#!/bin/bash

GITHUB_RUN_ID=$1


# Fetch secrets from Azure Key Vault
# DATABASE_CONNECTION_STRING=$(az keyvault secret show --name "logLevel-default" --vault-name "keyvaulttest1506" --query "value" -o tsv)
# API_KEY=$(az keyvault secret show --name "micro" --vault-name "keyvaulttest1506" --query "value" -o tsv)

# Replace placeholders in appsetting.json with fetched secrets
# sed -i "s|#{__logLevel__}#|$DATABASE_CONNECTION_STRING|g" appsettings.json
# sed -i "s|#{__microsoft__}#|$API_KEY|g" appsettings.json

IMAGE_TAG=githubcisharni.azurecr.io/demoenv:${GITHUB_RUN_ID}

# Define backend.yaml content dynamically with fetched secrets 
cat <<EOF > backend.yaml
kind: containerapp
location: East US
name: containerapps
type: Microsoft.App/containerApps
properties:
    managedEnvironmentId: /subscriptions/8da5ea31-eccb-4d99-8a1a-437ea5504220/resourceGroups/sharnitha-poc/providers/Microsoft.App/managedEnvironments/managedEnvironment-sharnithapoc-b20f
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
          - passwordSecretRef: reg-pswd-39d6d968-bcc8
            server: githubcisharni.azurecr.io
            username: githubcisharni
    template:
        containers:
        - image: $IMAGE_TAG
          name: githubcisharni
          env:
          - name: SHARNILOG
            value: @Microsoft.KeyVault(VaultName=dockeyvault280824;SecretName=KEYVAULTSHARNITHALOG)
          resources:
              cpu: 2
              memory: 4Gi
EOF
az containerapp update  -n contaiinerapps13 -g sharnitha-poc --image $IMAGE_TAG --yaml backend.yaml
