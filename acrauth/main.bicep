targetScope = 'subscription'

metadata name = 'Using cache rules'
metadata description = 'This instance deploys the module with a credential set and a cache rule.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'Proximus_PlayGround'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'prox'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = 'test'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    location: resourceLocation
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    acrName: '${namePrefix}${serviceShort}001'
  }
}

module acr 'acr.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    credentialSetResourceId : nestedDependencies.outputs.acrCredentialSetResourceId
    userNameSecretURI : nestedDependencies.outputs.userNameSecretURI
    pwdSecretURI : nestedDependencies.outputs.pwdSecretURI
    location: resourceLocation
  }
}
