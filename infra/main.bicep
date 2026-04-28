// Medical Wallet — top-level deployment.
// Subscribes networking, database, storage, key-vault, app-service,
// monitoring modules. Region pinned to Central India for DPDPA compliance.

targetScope = 'resourceGroup'

@description('Environment name (e.g. dev, staging, prod).')
param environment string = 'prod'

@description('Azure region. Central India (Pune) for DPDPA data residency.')
param location string = 'centralindia'

@description('Postgres administrator login.')
param dbAdmin string

@description('Postgres administrator password.')
@secure()
param dbAdminPassword string

@description('Project shortcode used as a name prefix.')
param projectCode string = 'mw'

var namePrefix = '${projectCode}-${environment}'

module networking 'networking.bicep' = {
  name: 'networking'
  params: {
    location: location
    namePrefix: namePrefix
  }
}

module keyVault 'key-vault.bicep' = {
  name: 'keyVault'
  params: {
    location: location
    namePrefix: namePrefix
    subnetId: networking.outputs.appSubnetId
  }
}

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    namePrefix: namePrefix
    subnetId: networking.outputs.storageSubnetId
  }
}

module database 'database.bicep' = {
  name: 'database'
  params: {
    location: location
    namePrefix: namePrefix
    administratorLogin: dbAdmin
    administratorPassword: dbAdminPassword
    subnetId: networking.outputs.dbSubnetId
  }
}

module appService 'app-service.bicep' = {
  name: 'appService'
  params: {
    location: location
    namePrefix: namePrefix
    keyVaultName: keyVault.outputs.keyVaultName
    storageAccountName: storage.outputs.storageAccountName
    postgresFqdn: database.outputs.postgresFqdn
    appSubnetId: networking.outputs.appSubnetId
  }
}

module monitoring 'monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    namePrefix: namePrefix
    appServiceId: appService.outputs.appServiceId
  }
}

output appServiceUrl string = appService.outputs.appServiceUrl
output keyVaultName string = keyVault.outputs.keyVaultName
