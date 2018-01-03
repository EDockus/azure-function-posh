# GET method: $REQ_QUERY_#
$name = $REQ_PARAMS_USER
$password = $REQ_PARAMS_PASS
$subscription = $REQ_PARAMS_SUB
$resourceGroup = $REQ_PARAMS_RGROUP
$virtualMachine = $REQ_PARAMS_VM
$action = $REQ_PARAMS_ACTION

if(($action -notlike "Start") -and ($action -notlike "Stop"))
{
    Out-File -Encoding Ascii -FilePath $res -inputObject "Invalid values for action parameter. Use Start or Stop"
    Exit -1
}

$secpwd=ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($name, $secpwd)

try {
    Login-AzureRMAccount -Credential $cred -ErrorAction Stop
    Select-AzureRMSubscription -SubscriptionName $subscription -ErrorAction Stop
}
catch {
    Out-File -Encoding Ascii -FilePath $res -inputObject "Unable to login to Azure subscription $subscription. Exception details $_.Exception"
    Exit -1
}


try {
    $state=$($(Get-AzureRmVM -Name $virtualMachine -ResourceGroupName $resourceGroup -Status -ErrorAction Stop).Statuses | Where-Object {$_.Code -like "PowerState/*"}).DisplayStatus
}
catch {
    Out-File -Encoding Ascii -FilePath $res -inputObject "Unable to get status of $virtualMachine. Exceptions details: $_.Exception"
    Exit -1
}


if (($state -like "VM deallocated") -and $action -like "Start")
{    
    try
    {
        Get-AzureRmVM -Name WinPizza -ResourceGroupName ULTRATECH -ErrorAction Stop | Start-AzureRMVM -ErrorAction Stop
        Out-File -Encoding Ascii -FilePath $res -inputObject "$virtualMachine has been turned on"
    }
    catch
    {
        Out-File -Encoding Ascii -FilePath $res -inputObject "Unableto power on $virtualMachine. Exceptions details: $_.Exception"
    }
}
elseif (($state -like "VM running") -and $action -like "Stop")
{
    try
    {
        Get-AzureRmVM -Name WinPizza -ResourceGroupName ULTRATECH -ErrorAction Stop | Stop-AzureRMVM -ErrorAction Stop
        Out-File -Encoding Ascii -FilePath $res -inputObject "$virtualMachine has been turned off"
    }
    catch
    {
        Out-File -Encoding Ascii -FilePath $res -inputObject "Unableto power off $virtualMachine. Exceptions details: $_.Exception"
    }
}
else
{
    Out-File -Encoding Ascii -FilePath $res -inputObject "Current $virtualMachine status is $state"
}


