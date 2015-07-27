param (
[string]$ResourceGroupName,
[string]$Location='northeurope',
[string]$TemplateLocation='https://raw.githubusercontent.com/simongdavies/BedeARM/master/'
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

    New-AzureResourceGroupDeployment -Name 'allnew' -ResourceGroupName $ResourceGroupName -TemplateFile .\MasterTemplate.json -TemplateParameterFile .\azuredeploy-parameters-new-vnet-sqlserver-sqldatabase.json -templateLocation $TemplateLocation

}
catch
{
    Write-Output $_
}