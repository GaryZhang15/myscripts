function Update-WebConfig
{
    [CmdletBinding()]
    Param
    (
        # Location of iOffice folder
        [Parameter(Mandatory=$true,
                   Position=0)]
        $Location,

        # IP or Hostname
        [string]$WebNode,

        # IP or Hostname
        [string]$DataNode

    )

    Begin
    {
        Set-Location  $Location
        $path = get-ChildItem | % {Get-ChildItem -Path $_.Name -Name web.config} |select PSPath
        $shortpath = ($path | % {($_.pspath).tostring().replace("Microsoft.PowerShell.Core`\FileSystem::","")})
    }
    Process
    {
        foreach ($p in $shortpath)
        {
           $t = cat -Path $p -Verbose
           $t.Replace('10.1.1.4',"$WebNode").Replace('10.1.1.50',"$DataNode") | Out-File -FilePath $p -Force -Verbose -Encoding utf8
        }

        $GDSConfig = cat -Path "$Location\GlobalDirectoryService\ServiceConfiguration.json"
        $GDSConfig.Replace('10.1.1.4',"$WebNode") | Out-File -FilePath "$Location\GlobalDirectoryService\ServiceConfiguration.json" -Force -Verbose -Encoding utf8

    }
    End
    {
        Write-Verbose -Message "Successfully update web config file , and GlobalDirectoryService ServiceConfiguration.json"
    }
} # end of function Update-WebConfig

# Test: Update-WebConfig -Location 'C:\Websites\iOffice' -WebNode 10.1.1.81 -DataNode 10.1.1.83

# The most important thing to improve quality was not getting things right, but getting things consistent.
