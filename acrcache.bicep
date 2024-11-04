metadata description = 'Deployment of ACR with cache rules.'

@description('Location to deploy ACR')
param location string = 'east us'

@description('Optional. deploymentPrefix')
param deploymentPrefix string = 'pxs'

// declaration of ACR
var acr = {
  deployment: {
    name: concat('${deploymentPrefix}-acr')
    // name: deploymentPrefix
  }
  registry: {
    name: concat('${deploymentPrefix}registry')
  }
  cacherule: {
    name: concat('${deploymentPrefix}-rule01')
  }
}

module registry 'br/public:avm/res/container-registry/registry:0.6.0' = {
  name: acr.deployment.name
  params: {
    // Required parameters
    name: acr.registry.name
    acrAdminUserEnabled: false
    acrSku: 'Standard'
    cacheRules: [
      {
        name: acr.cacherule.name
        credentialSetResourceId: [] 
        sourceRepository: 'mcr.microsoft.com/bicep/avm/*'
        targetRepository: 'avm/*'
      }
    ]
    location: location
  }
}
