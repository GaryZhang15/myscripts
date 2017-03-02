$webapps = @{

            allapps = @(

                @{  
                name = "ns"	
                Physicalpath = "C:\Websites\iOffice\NotificationService"
                ProjectName = "NotificationService"}

                @{  
                name = "ow"	
                Physicalpath = "C:\Websites\iOffice\OfficialWebSite"
                ProjectName = "OfficialWebSite"}

                @{
                name = "sc"
  	            Physicalpath = "C:\Websites\iOffice\SourceCode"
                ProjectName = "SourceCode"}

                @{
                name = "wa"	
                Physicalpath = "C:\Websites\iOffice\WebAdministration"
                ProjectName = "WebAdministration"}

                )

            }

#region DSC Configuration w/Configuration Data Snippet
$DevConfig = @{
    AllNodes = 
    @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
        },
        @{
            NodeName = "yipin820";
            Role     = "WebServer"
        }
    ) 
} 

# Have a seperate configuration for each deployment environment
#$TestConfig = @{}
#$ProductionConfig = @{}

configuration MyConfiguration
{
    Param(
        [string[]]$WebApp

    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node $AllNodes.NodeName
    {

        foreach ($appdata in $WebApp)
        {
            $appD = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $appdata } 
            File $appD.ProjectName
            {
                SourcePath = "\\10.1.1.9\OfficialPublic\Gary\Temp\PublishedSites\$($appD.ProjectName)"
                DestinationPath = "C:\IISWebsite\$($appD.ProjectName)"
                Ensure = 'Present'
                Type = 'Directory'
                Recurse = $true
            
            }
            
        }
    }
}

MyConfiguration -ConfigurationData $DevConfig -WebApp ns,wa
#endregion



Start-DscConfiguration -Path .\MyConfiguration -Wait -Verbose 