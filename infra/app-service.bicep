param location string
param namePrefix string
param keyVaultName string
param storageAccountName string
param postgresFqdn string
param appSubnetId string

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-plan'
  location: location
  sku: { name: 'P1v3', tier: 'PremiumV3' }
  kind: 'linux'
  properties: { reserved: true }
}

resource site 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-app'
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    virtualNetworkSubnetId: appSubnetId
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      alwaysOn: true
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      http20Enabled: true
      healthCheckPath: '/api/health'
      appSettings: [
        { name: 'WEBSITES_PORT', value: '3000' }
        { name: 'NODE_ENV', value: 'production' }
        { name: 'AZURE_KEY_VAULT_URL', value: 'https://${keyVaultName}.vault.azure.net' }
        { name: 'AZURE_STORAGE_ACCOUNT', value: storageAccountName }
        { name: 'AZURE_STORAGE_CONTAINER_NAME', value: 'medical-records' }
        { name: 'POSTGRES_HOST', value: postgresFqdn }
      ]
    }
  }
}

output appServiceId string = site.id
output appServiceUrl string = 'https://${site.properties.defaultHostName}'
