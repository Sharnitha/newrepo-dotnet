#!/bin/bash

# Fetch secrets from Azure Key Vault
DATABASE_CONNECTION_STRING=$(az keyvault secret show --name "logLevel-default" --vault-name "keyvaulttest1506" --query "value" -o tsv)
API_KEY=$(az keyvault secret show --name "micro" --vault-name "keyvaulttest1506" --query "value" -o tsv)

# Replace placeholders in appsetting.json with fetched secrets
sed -i "s|#{__logLevel__}#|$DATABASE_CONNECTION_STRING|g" appsettings.json
sed -i "s|#{__microsoft__}#|$API_KEY|g" appsettings.json

# Define backend.yaml content dynamically with fetched secrets
cat <<EOF > backend.yaml
kind: containerapp
location: East US
name: Containerappsdemo
resourceGroup: sharnitha-poc
type: Microsoft.App/containerApps
properties:
    managedEnvironmentId: /subscriptions/8da5ea31-eccb-4d99-8a1a-437ea5504220/resourceGroups/sharnitha-poc/providers/Microsoft.App/managedEnvironments/managedEnvironment-sharnithapoc-aa5a
    configuration:
        activeRevisionsMode: single
       
    template:
        containers:
        - image: githubcisharni.azurecr.io/demoenv:${{ github.run_id }}
          name: githubcisharni
          env:
          - name: DatabaseConnectionString
            value: "$DATABASE_CONNECTION_STRING"
          - name: ApiKey
            value: "$API_KEY"
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
