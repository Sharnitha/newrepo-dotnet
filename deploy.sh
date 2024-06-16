#!/bin/bash

GITHUB_RUN_ID=$1

LOG_DEFA=Information
echo $LOG_DEFA

sed -i "s|#{LOG_DEFAULT}#|$LOG_DEFA|g" appsettings.json

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
resourceGroup: sharnitha-poc
type: Microsoft.App/containerApps
properties:
    managedEnvironmentId: /subscriptions/8da5ea31-eccb-4d99-8a1a-437ea5504220/resourceGroups/sharnitha-poc/providers/Microsoft.App/managedEnvironments/managedEnvironment-sharnithapoc-b20f
    configuration:
        activeRevisionsMode: single
       
    template:
        containers:
        - image: $IMAGE_TAG
          name: githubcisharni
          env:
          - name: LOG_DEFAULT
            value: "$LOG_DEFA"
          resources:
              cpu: 2  
              memory: 4Gi  
          probes:
          - type: liveness
            tcpSocket:
              path: "/"
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 3
          - type: readiness
            tcpSocket:
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 3
        scale:
          minReplicas: 1
          maxReplicas: 10
EOF
az containerapp update  -n containerapps -g sharnitha-poc --image $IMAGE_TAG --yaml backend.yaml
