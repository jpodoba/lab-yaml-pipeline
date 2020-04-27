#Requires -PSEdition Core
#Requires -Modules Az
<#
    .SYNOPSIS
        Script for create or delete lab environment.
  
    .DESCRIPTION
        Script for create or delete lab environment.
        The script will create a set of empty resource groups that are needed to deploy resources from Azure DevOps Lab.
        The script will also assign a "Contributor" role for your service principal account used in Azure DevOps service connection to have at least permissions.

    .PARAMETER subscriptionId
        Mandatory. Azure subscription ID.

    .PARAMETER spnObjectId
        Mandatory. The object ID of service principal account used for deployment

    .PARAMETER action
        Mandatory. The action for 'Create' or 'Delete' lab environment.
          
    .EXAMPLE
        .\setEnvironment.ps1 -subscriptionId "91efde41-fc2d-419d-9177-56e242dd4d7f" -spnObjectId "6c67ed7d-576f-42b9-93b0-929ef0c8b51b" -action Create
            
        The script will create a set of empty resource groups in Azure subscription with ID "91efde41-fc2d-419d-9177-56e242dd4d7f" and will assign a "Contributor" role for your service principal account with object ID "6c67ed7d-576f-42b9-93b0-929ef0c8b51b"

    .EXAMPLE
        .\setEnvironment.ps1 -subscriptionId "91efde41-fc2d-419d-9177-56e242dd4d7f" -spnObjectId "6c67ed7d-576f-42b9-93b0-929ef0c8b51b" -action Delete

        The script will remove previously created a set of resource groups in Azure subscription with ID "91efde41-fc2d-419d-9177-56e242dd4d7f".

    .NOTES
        Author:     Jakub Podoba
        Created:    25/04/2020
#>
param(
    [Parameter(Mandatory = $true)]
    [string]
    $subscriptionId,

    [Parameter(Mandatory = $true)]
    [string]
    $spnObjectId,
    
    [Parameter(Mandatory = $true)]
    [ValidateSet('Create', 'Delete')]
    [string]
    $action
)

$envJson = '{
    "environments": [
        {
            "name": "dev",
            "type": "primary",
            "location": "northeurope"
        },
        {
            "name": "qa",
            "type": "primary",
            "location": "northeurope"
        },
        {
            "name": "uat",
            "type": "primary",
            "location": "northeurope"
        },
        {
            "name": "stg",
            "type": "primary",
            "location": "northeurope"
        },
        {
            "name": "prod",
            "type": "primary",
            "location": "northeurope"
        },
        {
            "name": "prod",
            "type": "secondary",
            "location": "westeurope"
        },

    ]
}'

try {
    Get-AzSubscription -subscriptionId $subscriptionId | Select-AzSubscription
}
catch {
    throw "Unable to find Azure subscription with ID: $subscriptionId "    
}
	
$envObject = ConvertFrom-Json –InputObject $envJson

$envObject.environments | ForEach-Object {

    $env = $_
    $resourceGroupName = $_.name + "-hotbee-" + $_.type + "-rg"

    Start-ThreadJob `
        -ArgumentList ($resourceGroupName, $env, $action, $spnObjectId) `
        -ScriptBlock {
        param($resourceGroupName, $env, $action, $spnObjectId)

        $resourceGroup = Get-AzResourceGroup -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue
    
        if ($action -eq "Create") {  
            if ($null -eq $resourceGroup) {
                try {
                    New-AzResourceGroup -Name $resourceGroupName -Location $env.location -Tag @{env = $env.name; project = "demo"; customer = "hotbee" }            
                }
                catch {
                    throw "Unabele to create the resource group: $resourceGroupName, because following error: `n$_"
                }
        
                try {
                    New-AzRoleAssignment -ObjectId $spnObjectId -RoleDefinitionName Contributor  -ResourceGroupName $resourceGroupName
                }
                catch {
                    throw "Unabele to assign 'Contributor' role for SPN: $spnObjectId, because following error: `n$_"
                }
            }
        }
        elseif ($action -eq "Delete") {
            if ($null -ne $resourceGroup) {
                try {
                    Get-AzResourceGroup -ResourceGroupName $resourceGroupName | Remove-AzResourceGroup -Force  
                }
                catch {
                    throw "Unabele to delete resource group: $resourceGroupName"
                }
            }
        }
    }
}

Write-Host "`n[INFO]`tWaiting for results..."
Get-Job | Wait-Job

Write-Host "[INFO]`tResults of jobs:"
Get-Job | Receive-Job -Keep
Get-Job | Remove-Job