
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds -1800

$vm_list = Read-Host "Enter full path of CSV file (with quotes if spaces)"
$csv = Import-Csv $vm_list -UseCulture

foreach($item in $csv){
	Connect-viserver $item.vCenter
	
    $spec = Get-OSCustomizationSpec $item.Customization
    Get-OSCustomizationSpec $item.Customization | Get-OSCustomizationNicMapping | Where-Object {$_.position -eq 1} | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $item.IPAddress1 -SubnetMask $item.Subnetmask1 -DefaultGateway $item.DefaultGateway1 #-Dns $item.dns
    Get-OSCustomizationSpec $item.Customization | Get-OSCustomizationNicMapping | Where-Object {$_.position -eq 2} | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $item.IPAddress2 -SubnetMask $item.Subnetmask2 -DefaultGateway $item.DefaultGateway2 #-Dns $item.dns
    Get-OSCustomizationSpec $item.Customization | Get-OSCustomizationNicMapping | Where-Object {$_.position -eq 3} | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $item.IPAddress3 -SubnetMask $item.Subnetmask3 -DefaultGateway $item.DefaultGateway3 #-Dns $item.dns
	Get-OSCustomizationSpec $item.Customization | Get-OSCustomizationNicMapping | Where-Object {$_.position -eq 4} | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $item.IPAddress4 -SubnetMask $item.Subnetmask4 -DefaultGateway $item.DefaultGateway4 #-Dns $item.dns
    New-VM -Name $item.VMName -Template $item.Template -Host $item.VMHost -Location $item.Folder -Datastore $item.Datastore -DiskStorageFormat Thin -Confirm:$false -OSCustomizationSpec $spec 

	Start-VM $item.VMName -Confirm:$false
	
	$myNetworkAdapters1 = Get-VM $item.VMName | Get-NetworkAdapter -Name "Network adapter 1" 
	$myVDPortGroup1 = Get-VDPortgroup -Name $item.NetworkName1
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters1 -Portgroup $myVDPortGroup1  -Confirm:$false
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters1 -StartConnected:$true -Connected:$true  -Confirm:$false
	
	$myNetworkAdapters2 = Get-VM $item.VMName | Get-NetworkAdapter -Name "Network adapter 2" 
	$myVDPortGroup2 = Get-VDPortgroup -Name $item.NetworkName2
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters2 -Portgroup $myVDPortGroup2  -Confirm:$false
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters2 -StartConnected:$true -Connected:$true  -Confirm:$false

	$myNetworkAdapters3 = Get-VM $item.VMName | Get-NetworkAdapter -Name "Network adapter 3" 
	$myVDPortGroup3 = Get-VDPortgroup -Name $item.NetworkName3
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters3 -Portgroup $myVDPortGroup3  -Confirm:$false
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters3 -StartConnected:$true -Connected:$true  -Confirm:$false

	$myNetworkAdapters4 = Get-VM $item.VMName | Get-NetworkAdapter -Name "Network adapter 4" 
	$myVDPortGroup4 = Get-VDPortgroup -Name $item.NetworkName4
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters4 -Portgroup $myVDPortGroup4  -Confirm:$false
	Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters4 -StartConnected:$true -Connected:$true  -Confirm:$false

	Disconnect-VIServer -Confirm:$false
}
