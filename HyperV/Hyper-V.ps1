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
        ProcessorCount = 2
        MaximumMemory = 2GB
        MinimumMemory = 1024MB
        RestartIfNeeded = 'True'
        DependsOn = '[xVHD]DiffVHD','[xVMSwitch]vmswitch'
        State = 'Running'
        Generation = 'vhdx'
    }
}

$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

$cim = New-CimSession -ComputerName 10.1.1.20 -Credential $Cred

$PSSession = New-PSSession -ComputerName 10.1.1.20 -Credential $cred

Enter-PSSession $PSSession

NewVM -VMName Test02 -baseVhdPath 'E:\OS-VHDs' -ParentPath 'D:\VHDs\Web-OS-Sample.vhdx' -VMSwitchName Public

Start-DscConfiguration -Wait -Path .\NewVM -Verbose
