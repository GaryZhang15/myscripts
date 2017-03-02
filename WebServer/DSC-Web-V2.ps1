configuration WebFile
{
    # example: $AllNodes.Where{$_.Role -eq "Web"}.NodeName
    Param(
        $SourcePath,
        $SourceCred
    )
    
    Import-DscResource -Module xWebAdministration 
    Import-DSCResource -ModuleName xNetworking

    # windows features that need to be installed
    $winfeatures = @('Web-Server','Web-WebServer','Web-Common-Http',
                    'Web-Default-Doc','Web-Dir-Browsing','Web-Http-Errors',
                    'Web-Static-Content','Web-Http-Redirect','Web-Health',
                    'Web-Http-Logging','Web-Log-Libraries','Web-Request-Monitor',
                    'Web-Performance','Web-Stat-Compression','Web-Dyn-Compression','Web-Security',
                    'Web-Filtering','Web-Basic-Auth','Web-Client-Auth','Web-Digest-Auth',
                    'Web-Cert-Auth','Web-IP-Security','Web-Url-Auth','Web-Windows-Auth',
                    'Web-App-Dev','Web-Net-Ext45','Web-Asp-Net45','Web-ISAPI-Ext',
                    'Web-ISAPI-Filter','Web-WebSockets','Web-Mgmt-Tools',
                    'Web-Mgmt-Console','Web-Scripting-Tools','Web-Mgmt-Service')

    # web apps and its physical location
    $webapps = @{

    allapps = @(
            @{  
                name = "an"	
                Physicalpath = "C:\Websites\iOffice\AggregatedNotification"}

            @{  
                name = "bo"	
                Physicalpath = "C:\Websites\iOffice\BlueOfficeService"}

            @{
                name = "cg"
  	            Physicalpath = "C:\Websites\iOffice\CalendarGridService"}

            @{
                name = "cs"	
                Physicalpath = "C:\Websites\iOffice\ConchShellService"}

            @{
                name = "dc"	
                Physicalpath = "C:\Websites\iOffice\DataCubeService"}

            @{
                name = "dir"	
                Physicalpath = "C:\Websites\iOffice\DirectoryService"}

            @{
                name = "dirp"	
                Physicalpath = "C:\Websites\iOffice\DirectoryPortal"}

            @{
                name = "fg"	
                Physicalpath = "C:\Websites\iOffice\FootprintGraphService"}

            @{
                name = "gbo"	
                Physicalpath = "C:\Websites\iOffice\BlueOfficeGlobalBlueOffice"}

            @{
                name = "gds"	
                Physicalpath = "C:\Websites\iOffice\GlobalDirectoryService"}

            @{
                name = "ih"	
                Physicalpath = "C:\Websites\iOffice\ImageHub"}

            @{
                name = "lv"	
                Physicalpath = "C:\Websites\iOffice\LiveVoteService"}

            @{
                name = "mg"	
                Physicalpath = "C:\Websites\iOffice\MomentGardenService"}

            @{
                name = "mgmt"	
                Physicalpath = "C:\Websites\iOffice\Management"}

            @{
                name = "mr"	
                Physicalpath = "C:\Websites\iOffice\MindRadarService"}

            @{
                name = "mrp"	
                Physicalpath = "C:\Websites\iOffice\MindRadarPortal"}

            @{
                name = "nb"	
                Physicalpath = "C:\Websites\iOffice\NewsBoardService"}

            @{
                name = "nbp"	
                Physicalpath = "C:\Websites\iOffice\NewsBoardPortal"}

            @{
                name = "op"	
                Physicalpath = "C:\Websites\iOffice\OperationPortal"}

            @{
                name = "p"	
                Physicalpath = "C:\Websites\iOffice\Portal"}

            @{
                name = "pl"	
                Physicalpath = "C:\Websites\iOffice\PortalLogger"}

            @{
                name = "tf"	
                Physicalpath = "C:\Websites\iOffice\TaskForceService"}

            @{
                name = "tt"	
                Physicalpath = "C:\Websites\iOffice\TalkTimeService"}

            @{
                name = "website"	
                Physicalpath = "C:\Websites\iOffice\iOfficeWebsite"}

            @{
                name = "ww"	
                Physicalpath = "C:\Websites\iOffice\WishingWellService"}

                )
}

    # filter the nodes which has role as web server
    node $AllNodes.Where{$_.Role -eq "Web"}.NodeName
    {
        # open inbound 8088 port in firewall for website
        xFirewall Firewall
        { 
            Name                  = "WebsiteInbound8088" 
            DisplayName           = "Firewall Rule for website 8088" 
            Ensure                = "Present" 
            Access                = "Allow" 
            State                 = "Enabled" 
            Profile               = ("Any") 
            Direction             = "Inbound" 
            LocalPort             = ("8088")          
            Protocol              = "TCP" 
        } 

        #create websites folder in C:\
        File WebsitesFolder
        {
            Ensure = "Present"
            DestinationPath = 'C:\Websites'
            Type = "Directory"
         }

        #copy iOffice web app content into C:\websites folder
        File WebAppContents
        {
            Ensure = "Present"
            SourcePath = $SourcePath
            DestinationPath = 'C:\Websites\'
            Credential = $SourceCred
            Recurse = $true
            DependsOn = "[File]WebsitesFolder"
         }

         #install all the needed windows features
         foreach ($feature in $winfeatures)
         {
            WindowsFeature $feature.Replace('-','')
            {
	            Ensure = "Present"
	            Name = "$feature"
            }
             
         }

        # Create a Web Application Pool 
        xWebAppPool NewWebAppPool 
        { 
            Name   = "iOffice" 
            Ensure = "Present" 
            State  = "Started" 
            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
        } 

        #Create a New Website with Port 8088
        xWebsite NewWebsite 
        { 
            Ensure          = "Present" 
            Name            = "iOffice" 
            State           = "Started" 
            PhysicalPath    = "c:\Websites\ioffice\webroot" 
            BindingInfo     = MSFT_xWebBindingInformation 
                             { 
                               Protocol              = "HTTP" 
                               Port                  = 8088
                             } 
            DependsOn       = "[File]WebAppContents","[WindowsFeature]WebServer","[WindowsFeature]WebWebServer" 
        } 

        #Create each Web Applications
        foreach ($app in $webapps.allapps)
        {
          xWebApplication $app.name
            { 
                Name = $app.name
                Website = $Node.WebSiteName
                WebAppPool =  $Node.WebAppPoolName
                PhysicalPath = $app.Physicalpath
                Ensure = "Present" 
                DependsOn = @("[xWebSite]NewWebSite") 
            } 
            
        }
        
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
            WebsiteName = "iOffice"
            WebAppPoolName = "iOffice"
         }
        @{
            NodeName="10.1.1.81"
            Role = "Web"
         }
        @{
            NodeName="10.1.1.82"
            Role = "Web"
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


# fill the params in configuration
$SourcePath = "\\10.1.1.20\DSCResources\Websites"

$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

#cred for cim session on target node
$username = "administrator"
$userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
$usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

#new cim session on target node
$webcim = New-CimSession -ComputerName 10.1.1.81,10.1.1.82 -Credential $usercred

#run the configure to generate mof
WebFile -ConfigurationData $ConfigurationData -SourcePath $SourcePath -SourceCred $Cred -OutputPath c:\DSCTestOnly

Get-DscConfiguration -CimSession $cim -Verbose

Start-DscConfiguration -Path .\WebFile -Wait -Verbose -CimSession $webcim

Test-DscConfiguration -CimSession $cim -Verbose

$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic("10.1.1.82", "255.255.255.0")
$wmi.SetGateways("10.1.1.1", 1)
$wmi.SetDNSServerSearchOrder("10.1.1.1")

