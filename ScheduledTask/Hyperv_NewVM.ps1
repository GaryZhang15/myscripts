<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Create-VM
{
    [CmdletBinding()]

    Param
    (
        # Provide VM name
        [Parameter(Mandatory=$true)]
        [String]$Name,

        # Memory for VM
        #[String]$Memory,

        # number of processors
        [int]$Processor,

        #VHD path
        [Parameter(Mandatory=$true)]
        [String]$VhdPath,

        #VM template
        [Parameter(Mandatory=$true)]
        [ValidateSet("Simple", "W2012F", "IIS")]
        [String]$VMTemplate
    )

    $VMTemplatelist = @{
    
           AllList = @( 
                        @{
                            TemplateName = 'Simple'
                            LocalPath = "D:\VHDs\2012R2-DataCenter-Full-Sample-DONTUSE\Virtual Hard Disks\2012R2-DataCenter-Full-Sample-DONTUSE.vhdx"
                         }
                        @{
                            TemplateName = 'W2012F'
                            LocalPath = "D:\OS-VHDs\2012OS_SAMPLE\2012-Full-Sample-NONOTUSE\Virtual Hard Disks\2012-Full-Sample-NONOTUSE.vhdx"
                         }
                        @{
                            TemplateName = 'IIS'
                            LocalPath = 'D:\VHDs\IIS-OS-Sample.vhdx'
                         }
                       )
    }

    if ($VMTemplate -eq 'Simple')
    {

        $path = $VMTemplatelist.AllList | Where-Object -FilterScript {$_.TemplateName -eq 'Simple' } 
    
    }
    elseif ($VMTemplate -eq 'W2012F')
    {
        $path = $VMTemplatelist.AllList | Where-Object -FilterScript {$_.TemplateName -eq 'W2012F' }
   
    }
    elseif ($VMTemplate -eq 'IIS')
    {
        $path = $VMTemplatelist.AllList | Where-Object -FilterScript {$_.TemplateName -eq 'IIS' }
    }

    Configuration NewVM {
        param (
            [Parameter(Mandatory)]
            [string]$VMName,
            [Parameter(Mandatory)]
            [string]$baseVhdPath,
            [Parameter(Mandatory)]
            [string]$ParentPath,
            [Parameter(Mandatory)]
            [string]$VMSwitchName
        )

        Import-DscResource -module xHyper-V

        xVMSwitch vmswitch {
            Name = $VMSwitchName
            Ensure = 'Present'
            Type = 'External'
            NetAdapterName = 'Ethernet'
        }
        xVHD DiffVHD {
            Ensure = 'Present'
            Name = $VMName
            Path = $baseVhdPath
            ParentPath = $ParentPath
            Generation = 'vhdx'
        }
        xVMHyperV CreateVM {
            Name = $VMName
            SwitchName = $VMSwitchName
            VhdPath = Join-Path -Path $baseVhdPath -ChildPath "$VMName.vhdx"
            ProcessorCount = $Processor
            MaximumMemory = 2GB
            MinimumMemory = 2GB
            RestartIfNeeded = 'True'
            DependsOn = '[xVHD]DiffVHD','[xVMSwitch]vmswitch'
            State = 'Running'
            Generation = 'vhdx'
        }
    }

    $SourceUser = 'uumobile\garyzhang'
    $SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
    $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

    $cim = New-CimSession -ComputerName localhost -Credential $Cred
    
    NewVM -VMName $Name -baseVhdPath $VhdPath -ParentPath $path.LocalPath -VMSwitchName Public -OutputPath C:\DSC\MOFs\NewVM

    Start-DscConfiguration -Wait -Path C:\DSC\MOFs\NewVM -Verbose -CimSession $cim
}

# 'D:\OS-VHDs'  'D:\VHDs\Web-OS-Sample.vhdx'
# Test: Create-VM -Name 'ChanDao' -Processor 2 -VhdPath D:\OS-VHDs -VMTemplate Simple

<#
PS C:\> new-vhd -Path D:\OS-VHDs\SN-DC.vhdx -Differencing "D:\OS-VHDs\2012OS_SAMPLE\2012-Full-Sample-NONOTUSE\Virtual Ha
rd Disks\2012-Full-Sample-NONOTUSE.vhdx" -Verbose


PS C:\> New-VM -Name Delete-SN-DC -SwitchName Public -VHDPath D:\OS-VHDs\Delete-SN-DC.vhdx -MemoryStartupBytes 1024MB -
BootDevice VHD -Generation 1 -Path D:\OS-VHDs -Verbose



#>