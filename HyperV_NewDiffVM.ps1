configuration newDiffVM
{
    param
    (
        [Parameter(Mandatory)]
        [string[]]$NodeName,

        [Parameter(Mandatory)]
        [string]$VhdName,

        [Parameter(Mandatory)]
        [string]$VMName,
        
        [Parameter(Mandatory)]
        [string]$VhdPath,
        
        [Parameter(Mandatory)]
        [string]$ParentPath,
        
        [ValidateSet("Vhd","Vhdx")]
        [string]$Generation = "Vhdx",

        [ValidateSet("1","2")]
        [string]$VMGeneration,

        [Parameter(Mandatory)]
        [ValidateSet("External","Internal","NAT")]
        [string]$SwitchName,
        
        [Parameter(Mandatory)]
        [ValidateSet('Ethernet','Wi-Fi')]
        [string]$NetAdapterName, 
        
        [Parameter(Mandatory)]
        [Uint64]$StartupMemory,

        [Parameter(Mandatory)]
        [Uint64]$MinimumMemory,

        [Parameter(Mandatory)]
        [Uint64]$MaximumMemory,

        [Parameter(Mandatory)]
        [string]$VMPath,

        [Parameter(Mandatory)]
        [Uint32]$ProcessorCount,

        [ValidateSet('Off','Paused','Running')]
        [String]$State = 'Off',

        [Switch]$WaitForIP 
    )

    Import-DscResource -module xHyper-V

    Node $NodeName
    {
        xVhd DiffVhd
        {
            Ensure     = 'Present'
            Name       = $VhdName
            Path       = $VhdPath
            ParentPath = $ParentPath
            Generation = $Generation
        }
        
        xVMSwitch ExternalSwitch
        {
            Ensure         = 'Present'
            Name           = $SwitchName
            Type           = 'External'
            BandwidthReservationMode = 'Default'
            NetAdapterName = $NetAdapterName 
        }
        
        xVMHyperV NewVM
        {
            Ensure          = 'Present'
            Name            = $VMName
            VhdPath         = $VhdPath + '\' + $VhdName + '.' + $Generation
            SwitchName      = $SwitchName
            State           = $State
            Path            = $VMPath
            Generation      = $VMGeneration
            StartupMemory   = $StartupMemory
            MinimumMemory   = $MinimumMemory
            MaximumMemory   = $MaximumMemory
            ProcessorCount  = $ProcessorCount
            MACAddress      = $MACAddress
            RestartIfNeeded = $true
            WaitForIP       = $WaitForIP
            DependsOn       = '[xVhd]DiffVhd','[xVMSwitch]ExternalSwitch'
        }
    }
}


newDiffVM -NodeName localhost `
          -VMName BO_WS01 `
          -VhdName BO_WS01 `
          -VhdPath C:\vmfolder\vhd `
          -ParentPath C:\vmfolder\vhd\zGolden_W12R2_GUI.vhdx `
          -Generation vHdx `
          -SwitchName External `
          -NetAdapterName Ethernet `
          -StartupMemory 2GB `
          -MaximumMemory 2GB `
          -MinimumMemory 1GB `
          -ProcessorCount 2 `
          -State Running `
          -OutputPath C:\DSCLabs\Mofs `
          -VMGeneration 2 `
          -VMPath C:\vmfolder\vm `
          -Verbose

Start-DscConfiguration -Wait -Path C:\DSCLabs\Mofs -Force -Verbose
