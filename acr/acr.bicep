@description('Required. The ACR Credential Set id refered by cache rules')
param  credentialSetResourceId string

@description('Required. The ACR name for deployment')
param acrName string


resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: acrName
}

resource cacheRule 'Microsoft.ContainerRegistry/registries/cacheRules@2023-06-01-preview' = {
  name: 'acrcacherule'
  parent: registry
  properties: {
    sourceRepository: 'mcr.microsoft.com/bicep/avm/*'
    targetRepository: 'avm/*'
    credentialSetResourceId: credentialSetResourceId
  }
}
