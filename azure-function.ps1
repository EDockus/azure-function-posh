# GET method: $REQ_QUERY_#
$name = $REQ_PARAMS_USER
$password = $REQ_PARAMS_PASS
$subscription = $REQ_PARAMS_SUB
$resourceGroup = $REQ_PARAMS_RGROUP
$virtualMachine = $REQ_PARAMS_VM

$secpwd=ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($name, $secpwd)

Login-AzureRMAccount -Credential $cred
Select-AzureRMSubscription -SubscriptionName $subscription #"Visual Studio Premium with MSDN"

try {
    $state=$($(Get-AzureRmVM -Name $virtualMachine -ResourceGroupName $resourceGroup -Status -ErrorAction Stop).Statuses | Where-Object {$_.Code -like "PowerState/*"}).DisplayStatus
}
catch {
    Out-File -Encoding Ascii -FilePath $res -inputObject "Unable to get status of $virtualMachine. Exceptions details: $_.Exception"
}


if ($state -like "VM deallocated")
{
    
    try
    {
        Get-AzureRmVM -Name WinPizza -ResourceGroupName ULTRATECH -ErrorAction Stop | Start-AzureRMVM -ErrorAction Stop
    }
    catch
    {
        Out-File -Encoding Ascii -FilePath $res -inputObject "Unableto power on $virtualMachine. Exceptions details: $_.Exception"
    }

    Out-File -Encoding Ascii -FilePath $res -inputObject "$virtualMachine has been turned on"
}
else
{
    Out-File -Encoding Ascii -FilePath $res -inputObject "Server is not offline. Current state: $state"
}


