param location string
param namePrefix string
param subnetId string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${namePrefix}-kv'
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 90
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        { id: subnetId, ignoreMissingVnetServiceEndpoint: false }
      ]
    }
  }
}

output keyVaultName string = kv.name
output keyVaultId string = kv.id
