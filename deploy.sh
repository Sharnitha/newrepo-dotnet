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
