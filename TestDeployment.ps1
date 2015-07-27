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
    $ResourceGroup=Get-AzureResourceGroup -Name $ResourceGroupName

    if ($ResourceGroup) 
    {
        if ($ResourceGroup.Location -ne ($Location.ToLowerInvariant().Replace(' ','')))
        {
            Throw "Resource Group $ResourceGroupName already exists in Location$ResourceGroup.Location"
        }
    }
    else
    {
        New-AzureResourceGroup -Name $ResourceGroupName -Location $Location
    }

    # Deploy a new VNet, DB Server and DB 

    New-AzureResourceGroupDeployment -Name 'allnew' -ResourceGroupName $ResourceGroupName -TemplateFile .\MasterTemplate.json -TemplateParameterFile .\azuredeploy-parameters-new-vnet-sqlserver-sqldatabase.json -templateLocation $TemplateLocation
    
    # Deploy to existing VNet with a new DBServer and DB
    
    New-AzureResourceGroupDeployment -Name 'existingvnetnewServerandDB' -ResourceGroupName $ResourceGroupName -TemplateFile .\MasterTemplate.json -TemplateParameterFile .\azuredeploy-parameters-existing-vnet-new-sqlserver-sqldatabase.json -templateLocation $TemplateLocation
    
    # Deploy an existing VNet with a new DBServer and DB
    
    New-AzureResourceGroupDeployment -Name 'existingvnetServernewDB' -ResourceGroupName $ResourceGroupName -TemplateFile .\MasterTemplate.json -TemplateParameterFile .\azuredeploy-parameters-existing-vnet-sqlserver-new-sqldatabase.json -templateLocation $TemplateLocation

}
catch
{
    Write-Output $_
}