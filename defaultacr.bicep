module registry 'br/public:avm/res/container-registry/registry:0.6.0' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'Pro001'
    // Non-required parameters
    acrSku: 'Standard'
    location: 'uksouth'
  }
}
