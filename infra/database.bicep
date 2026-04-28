param location string
param namePrefix string
param administratorLogin string
@secure()
param administratorPassword string
param subnetId string

resource pg 'Microsoft.DBforPostgreSQL/flexibleServers@2023-12-01-preview' = {
  name: '${namePrefix}-pg'
  location: location
  sku: { name: 'Standard_D2s_v3', tier: 'GeneralPurpose' }
  properties: {
    version: '16'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    storage: {
      storageSizeGB: 32
      autoGrow: 'Enabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Enabled'
    }
    network: {
      delegatedSubnetResourceId: subnetId
    }
    highAvailability: { mode: 'Disabled' }
  }
}

resource db 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2023-12-01-preview' = {
  parent: pg
  name: 'medical_wallet'
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}

output postgresFqdn string = pg.properties.fullyQualifiedDomainName
