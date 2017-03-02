#=====================================================
#[Setup a New Container Host in a New Virtual Machine]
#=====================================================

# win10 or server 2016

#check if external swith exists
Get-VMSwitch | where {$_.SwitchType –eq “External”}

#Download the config scripts
wget -uri https://aka.ms/tp4/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

#create and configure the container host
.\New-ContainerHost.ps1 –VmName ConHost01 -WindowsImage NanoServer -HyperV

#=====================================================
#[Setup a New Nano Server Container Hosts VM]
#=====================================================

New-Item -ItemType Directory c:\nano

$WindowsMedia = "C:\Users\Administrator\Desktop\TP4 Release Media"
Copy-Item $WindowsMedia\NanoServer\Convert-WindowsImage.ps1 c:\nano
Copy-Item $WindowsMedia\NanoServer\NanoServerImageGenerator.psm1 c:\nano

Import-Module C:\nano\NanoServerImageGenerator.psm1

#you must run regular PowerShell Command Prompt (on you Hyper-v 2016 TP4 host) and not from PowerShell ISE. 
#If you are running it from PowerShell ISE, for a reason that I didn’t figure it out yet, you risk to receive 
#the following error message:ERROR  : Cannot find type [WIM2VHD.WimFile]: verify that the assembly containing this type is loaded.

New-NanoServerImage -MediaPath $WindowsMedia -BasePath c:\nano `
                    -TargetPath C:\nano\NanoContainer.vhdx -MaxSize 10GB `
                    -GuestDrivers -ReverseForwarders -Compute -Containers -Packages "Microsoft-NanoServer-IIS-Package"
#When completed, create a virtual machine from the NanoContainer.vhdx file. 
#This virtual machine will be running the Nano Server OS, with optional packages.
$switch = Get-VMSwitch -SwitchType External
New-VM -Name NanoCTNHost01 -MemoryStartupBytes 1073741824 -SwitchName $switch.Name -VHDPath C:\nano\NanoCTNHost01.vhdx -Generation 2
Start-VM -Name NanoCTNHost01

#Configure Nested Virtualization (If the container host itself will be running on a Hyper-V virtual machine, and will also be hosting Hyper-V Containers,)
Set-VMProcessor -VMName NanoCTNHost01 -ExposeVirtualizationExtensions $true

#Configure Virtual Processors (If the container host itself will be running on a Hyper-V virtual machine, 
#and will also be hosting Hyper-V Containers, the virtual machine will require at least two processors. )
Set-VMProcessor –VMName NanoCTNHost01 -Count 2

#Disable Dynamic Memory
Set-VMMemory NanoCTNHost01 -DynamicMemoryEnabled $false

#Enable Hyper-V Role, only needed if Hyper-V Containers will be deployed
Install-WindowsFeature hyper-v

#create virtual switch
New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress 172.16.0.0/12

#configure NAT
New-NetNat -Name ContainerNat -InternalIPInterfaceAddressPrefix "172.16.0.0/12"

#[on host of NanoCTNHost01 ]If the container host is virtualized, MAC spoofing will need to be enabled.
Get-VMNetworkAdapter -VMName NanoCTNHost01 | Set-VMNetworkAdapter -MacAddressSpoofing On

#Install OS Images
Install-PackageProvider ContainerProvider -Force
Install-ContainerImage -Name NanoServer -Version 10.0.10586.0