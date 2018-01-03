# azure-function-posh
Turn virtual machine on or off by calling an azure function

Replace {APIName} in function.json with the name of your function:

"route": "{APIName}/{user}/{pass}/{sub}/{rgroup}/{VM}/{action}",

# Usage

You can generate the URL from Azure Function page and then simply replace parameters in the URL with the actual values. Possible values for action parameter are Start or Stop.

{user} -> Username that has relevant permissions on the VM.
{pass} -> Password for the user
{sub} -> Subscription name
{rgroup} -> Resource group name
{VM} -> Name of the virtual machine object
{Action} -> Start or Stop
