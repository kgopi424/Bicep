param  credentialSetResourceId string

param  userNameSecretURI string

param pwdSecretURI string

param resourceLocation string

param name string = 'proximus'

module registry 'br/public:avm/res/container-registry/registry:0.6.0' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: name
    // Non-required parameters
    acrAdminUserEnabled: false
    acrSku: 'Standard'
    cacheRules: [
      {
        credentialSetResourceId: credentialSetResourceId
        name: 'customRule'
        sourceRepository: 'mcr.microsoft.com/bicep/avm/*'
        targetRepository: 'avm/*'
      }
    ]
    credentialSets: [
      {
        authCredentials: [
          {
            name: 'Credential1'
            usernameSecretIdentifier: userNameSecretURI
            passwordSecretIdentifier: pwdSecretURI
          }
        ]
        loginServer: 'azurecr.io'
        managedIdentities: {
          systemAssigned: true
        }
        name: 'default'
      }
    ]
    location: resourceLocation
  }
}
