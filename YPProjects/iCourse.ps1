configuration iCourseWebFile
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
                name = "ws"	
                Physicalpath = "C:\Websites\ICourseIPadAppWS"}
                )
}

    # filter the nodes which has role as web server
    node $AllNodes.NodeName
    {
        # open inbound 8080 port in firewall for website
        xFirewall Firewall
        { 
            Name                  = "WebsiteInbound8080" 
            DisplayName           = "Firewall Rule for website 8080" 
            Ensure                = "Present" 
            Access                = "Allow" 
            State                 = "Enabled" 
            Profile               = ("Any") 
            Direction             = "Inbound" 
            LocalPort             = ("8080")          
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
            Name   = "iCourse" 
            Ensure = "Present" 
            State  = "Started" 
            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
        } 

        #Create a New Website with Port 8080
        xWebsite NewWebsite 
        { 
            Ensure          = "Present" 
            Name            = "iCourse" 
            State           = "Started" 
            PhysicalPath    = "c:\Websites\ICourseIPadAppWS" 
            BindingInfo     = MSFT_xWebBindingInformation 
                             { 
                               Protocol              = "HTTP" 
                               Port                  = 8080
                             } 
            DependsOn       = "[File]WebAppContents","[WindowsFeature]WebServer","[WindowsFeature]WebWebServer" 
        } 
      
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
            WebsiteName = "iCourse"
            WebAppPoolName = "iCourse"
         }
        @{
            NodeName="10.1.1.86"
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
$SourcePath = "\\10.1.1.9\DropFolder\iCourse\iCourse_20150911.3\_PublishedWebsites"

$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

#cred for cim session on target node
$username = "administrator"
$userpass = ConvertTo-SecureString -AsPlainText 'Password01!' -Force
$usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

#new cim session on target node
$webcim = New-CimSession -ComputerName 10.1.1.86 -Credential $usercred

#run the configure to generate mof
iCourseWebFile -ConfigurationData $ConfigurationData -SourcePath $SourcePath -SourceCred $Cred 

Get-DscConfiguration -CimSession $cim -Verbose

Start-DscConfiguration -Path .\iCourseWebFile -Wait -Verbose -CimSession $webcim

Test-DscConfiguration -CimSession $cim -Verbose

$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic("10.1.1.82", "255.255.255.0")
$wmi.SetGateways("10.1.1.1", 1)
$wmi.SetDNSServerSearchOrder("10.1.1.1")

