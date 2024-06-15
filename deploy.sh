#!/bin/bash

# Fetch secrets from Azure Key Vault
DATABASE_CONNECTION_STRING=$(az keyvault secret show --name "DatabaseConnectionString" --vault-name "my-keyvault" --query "value" -o tsv)
API_KEY=$(az keyvault secret show --name "ApiKey" --vault-name "my-keyvault" --query "value" -o tsv)
SERVICE_URL=$(az keyvault secret show --name "ServiceUrl" --vault-name "my-keyvault" --query "value" -o tsv)

# Replace placeholders in appsetting.json with fetched secrets
sed -i "s|#{DatabaseConnectionString}#|$DATABASE_CONNECTION_STRING|g" appsetting.json
sed -i "s|#{ApiKey}#|$API_KEY|g" appsetting.json
sed -i "s|#{ServiceUrl}#|$SERVICE_URL|g" appsetting.json

# Define backend.yaml content dynamically with fetched secrets
cat <<EOF | az containerapp update -n $BACKEND_APP_NAME -g $RESOURCE_GROUP --yaml -
kind: containerapp
location: $LOCATION
name: $BACKEND_APP_NAME
resourceGroup: $RESOURCE_GROUP
type: Microsoft.App/containerApps
properties:
    managedEnvironmentId: /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.App/managedEnvironments/$CONTAINERAPPS_ENVIRONMENT_NAME
    configuration:
        activeRevisionsMode: single  # Ensure only one revision is active
        # Define other configuration settings as needed
    template:
        containers:
        - image: "$REGISTRY"
          name: $BACKEND_APP_NAME
          env:
          - name: DatabaseConnectionString
            value: "$DATABASE_CONNECTION_STRING"
          - name: ApiKey
            value: "$API_KEY"
          - name: ServiceUrl
            value: "$SERVICE_URL"
          # Add other environment variables as needed
          resources:
              cpu: 2  # Adjust as per your application's requirements
              memory: 4Gi  # Adjust as per your application's requirements
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
