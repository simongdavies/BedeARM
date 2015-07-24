param (
[string]$ResourceGroupName,
[string]$Location='northeurope'
)
Switch-AzureMode AzureResourceManager
if (!(Get-AzureAccount))
{ 
        Add-AzureAccount
}
try
{
    New-AzureResourceGroup -Name $ResourceGroupName -Location $Location

    # Deploy a new VNet, DB Server and DB 

    New-AzureResourceGroupDeployment -Name 'allnew' -ResourceGroupName $ResourceGroupName -TemplateFile .\MasterTemplate.json -TemplateParameterFile .\azuredeploy-parameters-minimal-new-vnet-sqlserver-sqldatabase.json

}
catch
{
    Write-Output $_
}