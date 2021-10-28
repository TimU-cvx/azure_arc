@description('Location of your Azure resources')
param azureLocation string

@description('Name of your log analytics workspace')
param logAnalyticsWorkspace string

var logAnalyticsResource = resourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspace)
var policyDefinitionForLinuxDeployLogAnalytics = '/providers/Microsoft.Authorization/policyDefinitions/9d2b61b4-1d14-4a63-be30-d4498e7ad2cf'
var policyDefinitionForWindowsDeployLogAnalytics = '/providers/Microsoft.Authorization/policyDefinitions/69af7d4a-7b18-4044-93a9-2651498ef203'
var policyDefinitionForAddResourceTag = '/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26'
var policyDefinitionForLinuxDeployDependencyAgent = '/providers/Microsoft.Authorization/policyDefinitions/deacecc0-9f84-44d2-bb82-46f32d766d43'
var policyDefinitionForWindowsDeployDependencyAgent = '/providers/Microsoft.Authorization/policyDefinitions/91cb9edd-cd92-4d2f-b2f2-bdd8d065a3d4'
var policyDefinitionForEnableAzureDefenderKubernetes = '/providers/Microsoft.Authorization/policyDefinitions/708b60a6-d253-4fe0-9114-4be4c00f012c'
var policyNameForLinuxDeployLogAnalytics = '(ArcBox) Deploy Linux Log Analytics agents'
var policyNameForWindowsDeployLogAnalytics = '(ArcBox) Deploy Windows Log Analytics agents'
var policyNameForLinuxDeployDependencyAgent = '(ArcBox) Deploy Linux Dependency Agents'
var policyNameForWindowsDeployDependencyAgent = '(ArcBox) Deploy Windows Dependency Agents'
var policyNameForAddResourceTagName = '(ArcBox) Tag resources'
var policyNameForEnableAzureDefenderKubernetes = '(ArcBox) Enable Azure Defender on Kubernetes clusters'
var logAnalyticsContributorRoleDefinition = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
var tagContributorRoleDefinition = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'

resource policyForLinuxDeployLogAnalytics 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForLinuxDeployLogAnalytics
  location: azureLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyDefinitionForLinuxDeployLogAnalytics
    parameters: {
      logAnalytics: {
        value: logAnalyticsResource
      }
    }
  }
}

resource policyForLinuxDeployLogAnalyticsRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForLinuxDeployLogAnalytics, resourceGroup().id)
  properties: {
    roleDefinitionId: logAnalyticsContributorRoleDefinition
    principalId: reference(policyForLinuxDeployLogAnalytics.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policyForWindowsDeployLogAnalytics 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForWindowsDeployLogAnalytics
  identity: {
    type: 'SystemAssigned'
  }
  location: azureLocation
  properties: {
    policyDefinitionId: policyDefinitionForWindowsDeployLogAnalytics
    parameters: {
      logAnalytics: {
        value: logAnalyticsResource
      }
    }
  }
}

resource policyForWindowsDeployLogAnalyticsRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForWindowsDeployLogAnalytics, resourceGroup().id)
  properties: {
    roleDefinitionId: logAnalyticsContributorRoleDefinition
    principalId: reference(policyForWindowsDeployLogAnalytics.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policyForLinuxDeployDependencyAgent 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForLinuxDeployDependencyAgent
  location: azureLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyDefinitionForLinuxDeployDependencyAgent
    parameters: {}
  }
}

resource policyForLinuxDeployDependencyAgentRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForLinuxDeployDependencyAgent, resourceGroup().id)
  properties: {
    roleDefinitionId: logAnalyticsContributorRoleDefinition
    principalId: reference(policyForLinuxDeployDependencyAgent.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policyForWindowsDeployDependencyAgent 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForWindowsDeployDependencyAgent
  identity: {
    type: 'SystemAssigned'
  }
  location: azureLocation
  properties: {
    policyDefinitionId: policyDefinitionForWindowsDeployDependencyAgent
    parameters: {}
  }
}

resource policyForWindowsDeployDependencyAgentRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForWindowsDeployDependencyAgent, resourceGroup().id)
  properties: {
    roleDefinitionId: logAnalyticsContributorRoleDefinition
    principalId: reference(policyForWindowsDeployDependencyAgent.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policyForAddResourceTag 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForAddResourceTagName
  identity: {
    type: 'SystemAssigned'
  }
  location: azureLocation
  properties: {
    policyDefinitionId: policyDefinitionForAddResourceTag
    parameters: {
      tagName: {
        value: 'Project'
      }
      tagValue: {
        value: 'jumpstart_arcbox'
      }
    }
  }
}

resource policyForAddResourceTagRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForAddResourceTagName, resourceGroup().id)
  properties: {
    roleDefinitionId: tagContributorRoleDefinition
    principalId: reference(policyForAddResourceTag.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource policyForEnableAzureDefenderKubernetes 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyNameForEnableAzureDefenderKubernetes
  identity: {
    type: 'SystemAssigned'
  }
  location: azureLocation
  properties: {
    policyDefinitionId: policyDefinitionForEnableAzureDefenderKubernetes
    parameters: {}
  }
}

resource policyForEnableAzureDefenderKubernetesRoleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyNameForEnableAzureDefenderKubernetes, resourceGroup().id)
  properties: {
    roleDefinitionId: logAnalyticsContributorRoleDefinition
    principalId: reference(policyForEnableAzureDefenderKubernetes.id, '2019-09-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}
