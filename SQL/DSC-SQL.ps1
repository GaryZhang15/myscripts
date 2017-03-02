$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
         }
        @{
            NodeName="localhost"
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
 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WinSources,
        $credential
    )

    Import-DscResource -Module xSqlPs

    node $AllNodes.NodeName 
    {

       WindowsFeature NetFramework35Core
        {
            Name = "NET-Framework-Core"
            Ensure = "Present"
            Source = $WinSources
        }
 
        WindowsFeature NetFramework45Core
        {
            Name = "NET-Framework-45-Core"
            Ensure = "Present"
            Source = $WinSources
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

InstallSQLServer -ConfigurationData $configurationData  -credential (Get-Credential -UserName "sa" -Message "Enter password for SqlAdministrator sa") -WinSources C:\Source\sxs -PackagePath D:\

Start-DscConfiguration -Path .\InstallSQLServer -Wait -Verbose



