configuration WebFile
{
    # 用户可以计算表达式，以获取节点列表
    # 例如: $AllNodes.Where("Role -eq Web").NodeName
    Param(
        $SourcePath,
        $SourceCred
    )
    
    Import-DscResource -Module xWebAdministration 
    Import-DSCResource -ModuleName xNetworking

    node $AllNodes.NodeName
    {
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

        File WebsitesFolder
        {
            Ensure = "Present"
            DestinationPath = 'C:\Websites'
            Type = "Directory"
         }

        File WebAppContents
        {
            Ensure = "Present"
            SourcePath = $SourcePath
            DestinationPath = 'C:\Websites\'
            Credential = $SourceCred
            Recurse = $true
            DependsOn = "[File]WebsitesFolder"
         }
        WindowsFeature WebServer
        {
	        Ensure = "Present"
	        Name = "Web-Server"
        }

        WindowsFeature WebWebServer
        {
	        Ensure = "Present"
	        Name = "Web-WebServer"
        }

        WindowsFeature WebCommonHttp
        {
	        Ensure = "Present"
	        Name = "Web-Common-Http"
        }

        WindowsFeature WebDefaultDoc
        {
	        Ensure = "Present"
	        Name = "Web-Default-Doc"
        }

        WindowsFeature WebDirBrowsing
        {
	        Ensure = "Present"
	        Name = "Web-Dir-Browsing"
        }

        WindowsFeature WebHttpErrors
        {
	        Ensure = "Present"
	        Name = "Web-Http-Errors"
        }

        WindowsFeature WebStaticContent
        {
	        Ensure = "Present"
	        Name = "Web-Static-Content"
        }

        WindowsFeature WebHttpRedirect
        {
	        Ensure = "Present"
	        Name = "Web-Http-Redirect"
        }

        WindowsFeature WebHealth
        {
	        Ensure = "Present"
	        Name = "Web-Health"
        }

        WindowsFeature WebHttpLogging
        {
	        Ensure = "Present"
	        Name = "Web-Http-Logging"
        }

        WindowsFeature WebLogLibraries
        {
	        Ensure = "Present"
	        Name = "Web-Log-Libraries"
        }

        WindowsFeature WebRequestMonitor
        {
	        Ensure = "Present"
	        Name = "Web-Request-Monitor"
        }

        WindowsFeature WebPerformance
        {
	        Ensure = "Present"
	        Name = "Web-Performance"
        }

        WindowsFeature WebStatCompression
        {
	        Ensure = "Present"
	        Name = "Web-Stat-Compression"
        }

        WindowsFeature WebDynCompression
        {
	        Ensure = "Present"
	        Name = "Web-Dyn-Compression"
        }

        WindowsFeature WebSecurity
        {
	        Ensure = "Present"
	        Name = "Web-Security"
        }

        WindowsFeature WebFiltering
        {
	        Ensure = "Present"
	        Name = "Web-Filtering"
        }

        WindowsFeature WebBasicAuth
        {
	        Ensure = "Present"
	        Name = "Web-Basic-Auth"
        }

        WindowsFeature WebClientAuth
        {
	        Ensure = "Present"
	        Name = "Web-Client-Auth"
        }

        WindowsFeature WebDigestAuth
        {
	        Ensure = "Present"
	        Name = "Web-Digest-Auth"
        }

        WindowsFeature WebCertAuth
        {
	        Ensure = "Present"
	        Name = "Web-Cert-Auth"
        }

        WindowsFeature WebIPSecurity
        {
	        Ensure = "Present"
	        Name = "Web-IP-Security"
        }

        WindowsFeature WebUrlAuth
        {
	        Ensure = "Present"
	        Name = "Web-Url-Auth"
        }

        WindowsFeature WebWindowsAuth
        {
	        Ensure = "Present"
	        Name = "Web-Windows-Auth"
        }

        WindowsFeature WebAppDev
        {
	        Ensure = "Present"
	        Name = "Web-App-Dev"
        }

        WindowsFeature WebNetExt45
        {
	        Ensure = "Present"
	        Name = "Web-Net-Ext45"
        }

        WindowsFeature WebAspNet45
        {
	        Ensure = "Present"
	        Name = "Web-Asp-Net45"
        }

        WindowsFeature WebISAPIExt
        {
	        Ensure = "Present"
	        Name = "Web-ISAPI-Ext"
        }

        WindowsFeature WebISAPIFilter
        {
	        Ensure = "Present"
	        Name = "Web-ISAPI-Filter"
        }

        WindowsFeature WebWebSockets
        {
	        Ensure = "Present"
	        Name = "Web-WebSockets"
        }

        WindowsFeature WebMgmtTools
        {
	        Ensure = "Present"
	        Name = "Web-Mgmt-Tools"
        }

        WindowsFeature WebMgmtConsole
        {
	        Ensure = "Present"
	        Name = "Web-Mgmt-Console"
        }

        WindowsFeature WebScriptingTools
        {
	        Ensure = "Present"
	        Name = "Web-Scripting-Tools"
        }

        WindowsFeature WebMgmtService
        {
	        Ensure = "Present"
	        Name = "Web-Mgmt-Service"
        }

        # Create a Web Application Pool 
        xWebAppPool NewWebAppPool 
        { 
            Name   = "iOffice" 
            Ensure = "Present" 
            State  = "Started" 
            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
        } 

        #Create a New Website with Port
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

        #Create a new Web Application an
        xWebApplication an 
        { 
            Name = "an"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\AggregatedNotification"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        } 

        #Create a new Web Application bo
        xWebApplication bo 
        { 
            Name = "bo"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\BlueOfficeService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        } 

        #Create a new Web Application cg
        xWebApplication cg
        {
            Name = "cg"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\CalendarGridService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application cs
        xWebApplication cs
        {
            Name = "cs"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\ConchShellService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application dc
        xWebApplication dc
        {
            Name = "dc"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\DataCubeService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application dir
        xWebApplication dir
        {
            Name = "dir"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\DirectoryService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application dirp
        xWebApplication dirp
        {
            Name = "dirp"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\DirectoryPortal"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application fg
        xWebApplication fg
        {
            Name = "fg"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\FootprintGraphService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application gbo
        xWebApplication gbo
        {
            Name = "gbo"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\BlueOfficeGlobalBlueOffice"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application gds
        xWebApplication gds
        {
            Name = "gds"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\GlobalDirectoryService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application ih
        xWebApplication ih
        {
            Name = "ih"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\ImageHub"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application lv
        xWebApplication lv
        {
            Name = "lv"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\LiveVoteService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application mg
        xWebApplication mg
        {
            Name = "mg"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\MomentGardenService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application mgmt
        xWebApplication mgmt
        {
            Name = "mgmt"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\Management"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application mr
        xWebApplication mr
        {
            Name = "mr"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\MindRadarService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application mrp
        xWebApplication mrp
        {
            Name = "mrp"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\MindRadarPortal"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application nb
        xWebApplication nb
        {
            Name = "nb"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\NewsBoardService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application nbp
        xWebApplication nbp
        {
            Name = "nbp"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\NewsBoardPortal"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application name
        xWebApplication op
        {
            Name = "op"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\OperationPortal"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application p
        xWebApplication p
        {
            Name = "p"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\Portal"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application pl
        xWebApplication pl
        {
            Name = "pl"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\PortalLogger"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application tf
        xWebApplication tf
        {
            Name = "tf"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\TaskForceService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application tt
        xWebApplication tt
        {
            Name = "tt"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\TalkTimeService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application website
        xWebApplication website
        {
            Name = "website"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\iOfficeWebsite"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
        }

        #Create a new Web Application ww
        xWebApplication ww
        {
            Name = "ww"
            Website = $Node.WebSiteName 
            WebAppPool =  $Node.WebAppPoolName 
            PhysicalPath = "C:\Websites\iOffice\WishingWellService"
            Ensure = "Present" 
            DependsOn = @("[xWebSite]NewWebSite") 
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
            Role = "Data"
         }
        @{
            NodeName="10.1.1.84"
            Role = "Data"
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
WebFile -ConfigurationData $ConfigurationData -SourcePath $SourcePath -SourceCred $Cred

Get-DscConfiguration -CimSession $cim -Verbose

Start-DscConfiguration -Path .\WebFile -Wait -Verbose -CimSession $webcim

Test-DscConfiguration -CimSession $cim -Verbose

$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic("10.1.1.82", "255.255.255.0")
$wmi.SetGateways("10.1.1.1", 1)
$wmi.SetDNSServerSearchOrder("10.1.1.1")

