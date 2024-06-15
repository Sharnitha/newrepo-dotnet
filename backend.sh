#!/bin/bash

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
