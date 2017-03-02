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
        [ValidateSet("Simple", "SQL", "IIS")]
        [String]$VMTemplate
    )

    $VMTemplatelist = @{
    
           AllList = @( 
                        @{
                            TemplateName = 'Simple'
                            LocalPath = 'D:\VHDs\Web-OS-Sample.vhdx'
                         }
                        @{
                            TemplateName = 'SQL'
                            LocalPath = 'D:\VHDs\SQL-OS-Sample.vhdx'
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
    elseif ($VMTemplate -eq 'SQL')
    {
        $path = $VMTemplatelist.AllList | Where-Object -FilterScript {$_.TemplateName -eq 'SQL' }
   
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
            MaximumMemory = 1GB
            MinimumMemory = 1GB
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
# Test: Create-VM -Name S1 -Processor 2 -VhdPath D:\OS-VHDs -VMTemplate Simple