$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
         }
        @{
            NodeName="10.1.1.83"
            Role = "SQL"
         }
        @{
            NodeName="10.1.1.84"
            Role = "SQL"
         }
    )
}

configuration InstallSQLServer
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackagePath,
        $SourcePath,
        $SourceCred,
        $credential
    )

    Import-DscResource -Module xSqlPs

    node $AllNodes.NodeName 
    {
       File sxsFolder
       {
            Ensure = "Present"
            DestinationPath = 'C:\sources'
            Type = "Directory"
       }

       File sxsFiles
       {
            Ensure = "Present"
            SourcePath = $SourcePath
            DestinationPath = 'C:\sources\'
            Credential = $SourceCred
            Recurse = $true
            DependsOn = "[File]sxsFolder"
       }

       WindowsFeature NetFramework35Core
        {
            Name = "NET-Framework-Core"
            Ensure = "Present"
            Source = "C:\sources\sxs"
            DependsOn = "[File]sxsFiles"
        }
 
        WindowsFeature NetFramework45Core
        {
            Name = "NET-Framework-45-Core"
            Ensure = "Present"
            Source = "C:\sources\sxs"
            DependsOn = "[File]sxsFiles"
        }
        xSqlServerInstall installSqlServer 
        { 
            InstanceName = "MSSQLSERVER" 
            SourcePath = $PackagePath
            # you will get a list of SQL feature here https://msdn.microsoft.com/en-us/library/ms144259.aspx
            Features= "SQLEngine,ADV_SSMS,FullText" 
            SqlAdministratorCredential = $credential  
        } 
     
    }
}

$SourcePath = "\\10.1.1.20\DSCResources\sources"
$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass



#cred for cim session on target node
$username = "web2\chen"
$userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
$usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

#new cim session on target node
$datacim = New-CimSession -ComputerName 10.1.1.83,10.1.1.84 -Credential $usercred

# Mount-DiskImage -ImagePath \\10.1.1.9\Software\Server\en_sql_server_2012_enterprise_edition_with_sp1_x64_dvd_1227976.iso -CimSession $datacim



InstallSQLServer -ConfigurationData $configurationData  -credential (Get-Credential -UserName "sa" -Message "pw sa") -SourcePath $SourcePath -PackagePath D:\ -SourceCred $Cred

Start-DscConfiguration -CimSession $datacim -Path .\InstallSQLServer -Wait -Verbose



