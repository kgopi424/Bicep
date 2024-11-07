targetScope = 'subscription'

metadata description = 'ACR deployment with a credential set and a cache rule.'

// ========== //
// Parameters //
// ========== //

@description('Optional. rootName')
param client string = 'Pxs'

@description('Optional. deploymentPrefix')
param cloudnative string = 'cn'

@description('Optional. deploymentPrefix')
param env string = 's'

@description('Optional. deploymentPrefix')
param platform string = 'ccoe'

@description('Optional. deploymentPrefix')
param resourcename string = 'acr'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = '${client}-${cloudnative}-${env}-${platform}-${resourcename}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    keyVaultName: '${client}-${cloudnative}-${env}-${platform}-${resourcename}-kvt03'
    acrName: '${client}${cloudnative}${env}${platform}${resourcename}02'
  }
}

module acr 'acr.bicep' = {
  scope: resourceGroup
  name: 'Procontainer'
  params: {
    credentialSetResourceId : nestedDependencies.outputs.acrCredentialSetResourceId
    acrName: '${client}${cloudnative}${env}${platform}${resourcename}02'
  }
}
