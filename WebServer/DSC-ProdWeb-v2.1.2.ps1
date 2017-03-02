<#
.Synopsis
   This Cmdlet will help deploying your Web app or Website into your desired environment.
.DESCRIPTION
   This Cmdlet will help you automatically configure your Test, Staging, Production environment.
   You should run this Cmdlet after you have successfully built your projects.
   
.EXAMPLE
   Start-Deployment -Environment Prod -BuildDefinition Production -Version 8.0.1 -WebApp Website
   This example will deploy build version 8.0.1 of website into Production environment.
.EXAMPLE
   Start-Deployment -Environment Test -BuildDefinition test -Version 20150908.4  -WebApp allapps -SendEmail
   This example will deploy build version 20150908.4 of all webapps into test environment and send out notification emails.
.EXAMPLE
   Start-Deployment -Environment Prod -BuildDefinition Production -Version 8.0.1 -WebApp ln,ih. -SendEmail 'My build of projects LN and IH'
   This example  will deploy build version 8.0.1 of webapp lh,ih into Prod environment and send out comments with emails.
.INPUTS
   You need to input the required paramaters.
.OUTPUTS
   If Cmdlet by default will not generate OUTPUTS, if you want to send out emails you can use 'SendEmail' switch paramater.
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to is YIPIN-DSC.
.ROLE
   The role this cmdlet belongs to is normal user.
.FUNCTIONALITY
   Automatically deploy your Test, Staging, Production environment.
#>

<# ***update log ***
 9-10-2015 v2.0.3
 1. add env var to send email function 
 2. set param Environment to string type

 9-11-2015 v2.0.5
 1. Make change to copy only the needed  webapp content into IIS server
 2. Web App project name updates, webapp physical path

   ***To do list ***
 1. if powershell not running as admin it will return error, access issue with c:\DSCDeploy\IISWebsite
 2. Send email if error occurs, return envent log as attachment
 3. Make this into a PS profile or Module, and automated copy the needed file and modules
 4. Rollbackable paramater
 5. Make Test and Prod DSC configuration into different config function 
 6. <this seems not possible> make param version to be able to retrieve the version list
 7. modify web.configure file

#>

function Start-Deployment {

[CmdletBinding()]

    Param(
        # verify if the deployment of website is successful
        [switch]$Verify,
        
        # specify the BuildDefinition, which you have trigger from Build server
        [Parameter(Mandatory=$true)]
        [ValidateSet("OfficialWebSite","GlobalBlueOffice","DocumentsConversion","GlobalDirectoryService")]
        [String]$BuildDefinition,
        
        # specify which version you need to deploy, #[ValidateScript({$_})]
        [Parameter(Mandatory=$true)]
        [String]$Version,

        # specify which environment you need to deploy to, valid environments are "Test", "Dev", "Staging"
        [Parameter(Mandatory=$true)]
        [ValidateSet("Dev", "QA", "PreProdWeb")]
        [Alias("Env")] 
        [String]$Environment,

        # Switch paramater to SendEmail to you and the stakeholders
        # I want to make this into a comment, which will let runner to inputs the notes
        [switch]$SendEmail,

        # specify which web app or site you would like to deploy
        [Parameter(Mandatory=$true)]
        <#[ValidateSet('dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp',
                     'nb','tt','tfp','tf','wwp','ww','an','ah','cg',
                     'cs','dirp','dir','ih','p','pl','dcc','dce',
                     'gbo','mgmt','website','op','gds')]#>
        [ValidateSet('BlueOffice','SaaS','WebSite','dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp',
                     'nb','tt','tfp','tf','wwp','ww','an','ah','cg',
                     'cs','dirp','dir','ih','p','pl','dcc','dce','vh',
                     'gbo','mgmt','op','gds')]
        [String[]]$WebApp

        )

    Begin
        {
            $SourcePath = '\\10.1.1.9\DropFolder\' + $BuildDefinition + '\' + $BuildDefinition  + '_' + $Version + '\_PublishedWebsites'

            if ($Environment -eq 'Dev') {
                $dscEnv = 'dev-web2' # IP 10.1.1.82 
                Write-Verbose -Message "Delpoyment will be targeted on Test Env Server: 10.1.1.82"
            }
            elseif ($Environment -eq 'QA') {
                $dscEnv = 'test-web1' # IP 10.1.1.87 (will add dev-web1 later)
                Write-Verbose -Message "Delpoyment will be targeted on QA(Test) Env Server: 10.1.1.87"
            }
            elseif ($Environment -eq 'PreProd'){
                $dscEnv = 'PreProdWeb' # IP 10.1.1.89
                Write-Verbose -Message "Delpoyment will be targeted on PreProd Env Server: 10.1.1.89"
            }
            else{
                
                Write-Warning -Message 'You need to provide a valid env name!'
            } # set DSCEnv to user desired env

         $ConfigurationData = @{
            AllNodes = @(
       
                @{
                    NodeName="*"
                    PSDscAllowPlainTextPassword=$true
                 }
                @{
                    NodeName= $dscEnv # vm test1
                 }
            )
        }# end of ConfigurationData section

        #Different web apps in different website
        $BlueOfficeApps = @('dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp',
                     'nb','tt','tfp','tf','wwp','ww','an','ah','cg',
                     'cs','dirp','dir','ih','p','pl','dcc','dce','vh') # can pick up individual webapp or mutiple webapps to deploy

        $SaaSApps = @('gbo','mgmt','op','gds') # can not pick up individual webapp/apps to deploy, must depoly in batch 

        $WebSites = @('website')

        $webapps = @{

            allapps = @(
                        @{  #01 
                            name = "an"	
                            Physicalpath = "C:\Websites\iOffice\AggregatedNotification"
                            ProjectName  = "AggregatedNotification"}

                        @{  #02
                            name = "bo"	
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeService"
                            ProjectName  = "BlueOfficeService"}

                        @{  #03
                            name = "cg"
  	                        Physicalpath = "C:\Websites\iOffice\CalendarGridService"
                            ProjectName  = "CalendarGridService"}

                        @{  #04
                            name = "cs"	
                            Physicalpath = "C:\Websites\iOffice\ConchShellService"
                            ProjectName  = "ConchShellService"}

                        @{  #05
                            name = "dc"	
                            Physicalpath = "C:\Websites\iOffice\DataCubeService"
                            ProjectName  = "DataCubeService"}

                        @{  #06
                            name = "dir"	
                            Physicalpath = "C:\Websites\iOffice\DirectoryService"
                            ProjectName  = "DirectoryService"}

                        @{  #07
                            name = "dirp"	
                            Physicalpath = "C:\Websites\iOffice\DirectoryPortal"
                            ProjectName  = "DirectoryPortal"}

                        @{  #08
                            name = "fg"	
                            Physicalpath = "C:\Websites\iOffice\FootprintGraphService"
                            ProjectName  = "FootprintGraphService"}

                        @{  #09
                            name = "gbo"	
                            Physicalpath = "C:\Websites\iOffice\GlobalBlueOfficeService"
                            ProjectName  = "GlobalBlueOfficeService"}

                        @{  #10
                            name = "gds"	
                            Physicalpath = "C:\Websites\iOffice\GlobalDirectoryService"
                            ProjectName  = "GlobalDirectoryService"}

                        @{  #11
                            name = "ih"	
                            Physicalpath = "C:\Websites\iOffice\ImageHub"
                            ProjectName  = "ImageHub"}

                        @{  #12
                            name = "lv"	
                            Physicalpath = "C:\Websites\iOffice\LiveVoteService"
                            ProjectName  = "LiveVoteService"}

                        @{  #13
                            name = "mg"	
                            Physicalpath = "C:\Websites\iOffice\MomentGardenService"
                            ProjectName  = "MomentGardenService"}

                        @{  #14
                            name = "mgmt"	
                            Physicalpath = "C:\Websites\iOffice\Management"
                            ProjectName  = "Management"}

                        @{  #15
                            name = "mr"	
                            Physicalpath = "C:\Websites\iOffice\MindRadarService"
                            ProjectName  = "MindRadarService"}

                        @{  #16
                            name = "mrp"	
                            Physicalpath = "C:\Websites\iOffice\MindRadarPortal"
                            ProjectName  = "MindRadarPortal"}

                        @{  #17
                            name = "nb"	
                            Physicalpath = "C:\Websites\iOffice\NewsBoardService"
                            ProjectName  = "NewsBoardService"}

                        @{  #18
                            name = "nbp"	
                            Physicalpath = "C:\Websites\iOffice\NewsBoardPortal"
                            ProjectName  = "NewsBoardPortal"}

                        @{  #19
                            name = "op"	
                            Physicalpath = "C:\Websites\iOffice\OperationWebSite"
                            ProjectName  = "OperationWebSite"}

                        @{  #20
                            name = "p"	
                            Physicalpath = "C:\Websites\iOffice\Portal"
                            ProjectName  = "Portal"}

                        @{  #21
                            name = "pl"	
                            Physicalpath = "C:\Websites\iOffice\PortalLogger"
                            ProjectName  = "PortalLogger"}

                        @{  #22
                            name = "tf"	
                            Physicalpath = "C:\Websites\iOffice\TaskForceService"
                            ProjectName  = "TaskForceService"}

                        @{  #23
                            name = "tt"	
                            Physicalpath = "C:\Websites\iOffice\TalkTimeService"
                            ProjectName  = "TalkTimeService"}

                        @{  #24
                            name = "website"	
                            Physicalpath = "C:\Websites\iOffice\OfficialWebSite"
                            ProjectName  = "OfficialWebSite"}

                        @{  #25
                            name = "ww"	
                            Physicalpath = "C:\Websites\iOffice\WishingWellService"
                            ProjectName  = "WishingWellService"}
                        @{  #26
                            name = "dsp"	
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeDataStatisticsPortal"
                            ProjectName  = "BlueOfficeDataStatisticsPortal"}
                        @{  #27
                            name = "fgp"	
                            Physicalpath = "C:\Websites\iOffice\FootprintGraphPortal"
                            ProjectName  = "FootprintGraphPortal"}
                        @{  #28
                            name = "tfp"	
                            Physicalpath = "C:\Websites\iOffice\TaskForcePortal"
                            ProjectName  = "TaskForcePortal"}
                        @{  #29
                            name = "wwp"	
                            Physicalpath = "C:\Websites\iOffice\WishingWellPortal"
                            ProjectName  = "WishingWellPortal"}
                        @{  #30
                            name = "ah"	
                            Physicalpath = "C:\Websites\iOffice\AudioHub"
                            ProjectName  = "AudioHub"}
                        @{  #31
                            name = "vh"	
                            Physicalpath = "C:\Websites\iOffice\VideoHub"
                            ProjectName  = "VideoHub"}
                        @{  #32
                            name = "dcc"	
                            Physicalpath = "C:\Websites\iOffice\DocumentsConversionClient"
                            ProjectName  = "DocumentsConversionClient"}
                        @{  #33
                            name = "dce"	
                            Physicalpath = "C:\Websites\iOffice\Engine"
                            ProjectName  = "Engine"}
                        )
                    }
      
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

        # Credential for Source files in the Drop fodler
        $SourceUser = 'uumobile\tfsbuild3'
        $SourcePass = ConvertTo-SecureString -AsPlainText 'Password01!' -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

        #cred for cim session on target node
        $username = "administrator"
        $userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
        $usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

        #new cim session on target node
        $webcim = New-CimSession -ComputerName $dscEnv -Credential $usercred

        Write-Verbose -Message "Opening Cim Session on target Server: $dscEnv"

        } # end of Begin Block

    Process
        {
          # DSC Function 
          Configuration IISWebsite 
            { 
                Param(
                # \\10.1.1.9\DropFolder\BOWebsiteTestBuild\BOWebsiteTestBuild_20150908.1\_PublishedWebsites
                $SourceCred
                )

                # explicitly import the DSC xModules, before this you need to push the modules to the destination nodes (DSC push mode only)
                Import-DscResource -Module xWebAdministration 
                Import-DSCResource -ModuleName xNetworking

                  Node $AllNodes.NodeName
                  { 

                        #create websites folder in C:\
                        File WebsitesFolder
                        {
                            Ensure = "Present"
                            DestinationPath = 'C:\Websites\iOffice\RootWeb'
                            Type = "Directory"
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

                         # if switch for BO, SaaS, Website
                         if ($WebApp -eq 'BlueOffice')
                         {
                            # open inbound 8080 port in firewall for BlueOffice site
                            xFirewall Firewall8080
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

                            #copy web app data
                            foreach ($appdata in $BlueOfficeApps)
                                 {
                                     $appD = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $appdata } 
                                     #copy blue office apps
                                     File $appD.ProjectName
                                     {
                                         SourcePath = "$SourcePath\$($appD.ProjectName)"
                                         Credential = $SourceCred
                                         DestinationPath = "C:\Websites\iOffice\$($appD.ProjectName)"
                                         Ensure = 'Present'
                                         Type = 'Directory'
                                         Recurse = $true
                                         DependsOn = "[File]WebsitesFolder"
            
                                     }
            
                                 }
                            # Create a Web Application Pool 
                            xWebAppPool NewWebAppPool 
                            { 
                                Name   = "BlueOffice" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            #Create a New Website with Port 8080
                            xWebsite NewWebsite 
                            { 
                                Ensure          = "Present" 
                                Name            = "BlueOffice" 
                                State           = "Started" 
                                PhysicalPath    = "c:\Websites\ioffice\webroot" 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8080
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]NewWebAppPool"
                            } 

                            #Create each Web Applications
                            foreach ($app in $BlueOfficeApps)

                            {
                               $webT = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $app } 
                               xWebApplication $webT.name
                                { 
                                    Name = $webT.name
                                    Website = "BlueOffice"
                                    WebAppPool =  "BlueOffice"
                                    PhysicalPath = $webT.Physicalpath
                                    Ensure = "Present" 
                                    DependsOn = @("[xWebSite]NewWebSite") 
                                }  
                            }

                             
                         } # BlueOffice Deploy as a whole
                         elseif($WebApp -eq 'SaaS')
                         {
                            # open inbound 8081 port in firewall for GBO site
                            xFirewall Firewall8081
                            { 
                                Name                  = "WebsiteInbound8081" 
                                DisplayName           = "Firewall Rule for website 8081" 
                                Ensure                = "Present" 
                                Access                = "Allow" 
                                State                 = "Enabled" 
                                Profile               = ("Any") 
                                Direction             = "Inbound" 
                                LocalPort             = ("8081")          
                                Protocol              = "TCP" 
                            } 
                            # open inbound 8082 port in firewall for GDS site
                            xFirewall Firewall8082
                            { 
                                Name                  = "WebsiteInbound8082" 
                                DisplayName           = "Firewall Rule for website 8082" 
                                Ensure                = "Present" 
                                Access                = "Allow" 
                                State                 = "Enabled" 
                                Profile               = ("Any") 
                                Direction             = "Inbound" 
                                LocalPort             = ("8082")          
                                Protocol              = "TCP" 
                            } 
                            # open inbound 8083 port in firewall for management site
                            xFirewall Firewall8083
                            { 
                                Name                  = "WebsiteInbound8083" 
                                DisplayName           = "Firewall Rule for website 8083" 
                                Ensure                = "Present" 
                                Access                = "Allow" 
                                State                 = "Enabled" 
                                Profile               = ("Any") 
                                Direction             = "Inbound" 
                                LocalPort             = ("8083")          
                                Protocol              = "TCP" 
                            } 
                            # open inbound 8084 port in firewall for Operation site
                            xFirewall Firewall8084
                            { 
                                Name                  = "WebsiteInbound8084" 
                                DisplayName           = "Firewall Rule for website 8084" 
                                Ensure                = "Present" 
                                Access                = "Allow" 
                                State                 = "Enabled" 
                                Profile               = ("Any") 
                                Direction             = "Inbound" 
                                LocalPort             = ("8084")          
                                Protocol              = "TCP" 
                            } 

                            
                            #copy web app data
                            foreach ($appdata in $SaaSApps)
                                 {
                                     $appD = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $appdata } 
                                     File $appD.ProjectName
                                     {
                                         SourcePath = "$SourcePath\$($appD.ProjectName)"
                                         Credential = $SourceCred
                                         DestinationPath = "C:\Websites\iOffice\$($appD.ProjectName)"
                                         Ensure = 'Present'
                                         Type = 'Directory'
                                         Recurse = $true
                                         DependsOn = "[File]WebsitesFolder"
            
                                     }
            
                                 }
                            # Create a Web Application Pool GlobalBlueOfficeService
                            xWebAppPool GlobalBlueOfficeService 
                            { 
                                Name   = "GlobalBlueOfficeService" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            # Create a Web Application Pool GlobalDirectoryService
                            xWebAppPool GlobalDirectoryService 
                            { 
                                Name   = "GlobalDirectoryService" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            # Create a Web Application Pool Management
                            xWebAppPool Management 
                            { 
                                Name   = "Management" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 
                            # Create a Web Application Pool OperationWebSite
                            xWebAppPool OperationWebSite 
                            { 
                                Name   = "OperationWebSite" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            #Create a New Website with Port 8081
                            xWebsite GlobalBlueOfficeService 
                            { 
                                Ensure          = "Present" 
                                Name            = "GlobalBlueOfficeService" 
                                State           = "Started" 
                                PhysicalPath    = ($webapps.allapps | ? name -eq gbo).Physicalpath 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8081
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]GlobalBlueOfficeService"
                            } 

                            #Create a New Website with Port 8082
                            xWebsite GlobalDirectoryService 
                            { 
                                Ensure          = "Present" 
                                Name            = "GlobalDirectoryService" 
                                State           = "Started" 
                                PhysicalPath    = ($webapps.allapps | ? name -eq gds).Physicalpath 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8082
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]GlobalDirectoryService"
                            } 

                            #Create a New Website with Port 8083
                            xWebsite Management 
                            { 
                                Ensure          = "Present" 
                                Name            = "Management" 
                                State           = "Started" 
                                PhysicalPath    = ($webapps.allapps | ? name -eq mgmt).Physicalpath 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8083
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]Management"
                            } 
                            #Create a New Website with Port 8084
                            xWebsite OperationWebSite 
                            { 
                                Ensure          = "Present" 
                                Name            = "OperationWebSite" 
                                State           = "Started" 
                                PhysicalPath    = ($webapps.allapps | ? name -eq op).Physicalpath 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8084
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]OperationWebSite"
                            }
                             
                         } # SaaS deploy as a whole
                         elseif($WebApp -eq 'WebSite')
                         {
                            # open inbound 8085 port in firewall for BlueOffice site
                            xFirewall Firewall8085
                            { 
                                Name                  = "WebsiteInbound8085" 
                                DisplayName           = "Firewall Rule for website 8085" 
                                Ensure                = "Present" 
                                Access                = "Allow" 
                                State                 = "Enabled" 
                                Profile               = ("Any") 
                                Direction             = "Inbound" 
                                LocalPort             = ("8085")          
                                Protocol              = "TCP" 
                            }

                            File WebSite
                            {
                                SourcePath = "$SourcePath\OfficialWebSite"
                                Credential = $SourceCred
                                DestinationPath = "C:\Websites\iOffice\OfficialWebSite"
                                Ensure = 'Present'
                                Type = 'Directory'
                                Recurse = $true
                                DependsOn = "[File]WebsitesFolder"
            
                            }
                            # Create a Web Application Pool 
                            xWebAppPool NewWebAppPool 
                            { 
                                Name   = "WebSite" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            #Create a New Website with Port 8085
                            xWebsite NewWebsite 
                            { 
                                Ensure          = "Present" 
                                Name            = "OfficialWebSite" 
                                State           = "Started" 
                                PhysicalPath    = "C:\Websites\iOffice\OfficialWebSite" 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8085
                                                 } 
                                DependsOn       = "[File]WebSite","[xWebAppPool]NewWebAppPool"
                            }
                                                         
                         } # website deployment
                         else
                         {

                            # open inbound 8080 port in firewall for parent BlueOffice site
                            xFirewall Firewall8080
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

                            #copy web app data
                            foreach ($appdata in $WebApp)
                                 {
                                     $appD = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $appdata } 
                                     #copy blue office apps
                                     File $appD.ProjectName
                                     {
                                         SourcePath = "$SourcePath\$($appD.ProjectName)"
                                         Credential = $SourceCred
                                         DestinationPath = "C:\Websites\iOffice\$($appD.ProjectName)"
                                         Ensure = 'Present'
                                         Type = 'Directory'
                                         Recurse = $true
                                         DependsOn = "[File]WebsitesFolder"
            
                                     }
            
                                 }
                            # Create a Web Application Pool 
                            xWebAppPool NewWebAppPool 
                            { 
                                Name   = "BlueOffice" 
                                Ensure = "Present" 
                                State  = "Started" 
                                DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                            } 

                            #Create a New Website with Port 8080
                            xWebsite NewWebsite 
                            { 
                                Ensure          = "Present" 
                                Name            = "BlueOffice" 
                                State           = "Started" 
                                PhysicalPath    = "c:\Websites\ioffice\webroot" 
                                BindingInfo     = MSFT_xWebBindingInformation 
                                                 { 
                                                   Protocol              = "HTTP" 
                                                   Port                  = 8080
                                                 } 
                                DependsOn       = "[File]WebsitesFolder","[xWebAppPool]NewWebAppPool"
                            } 

                            #Create each Web Applications
                            foreach ($app in $WebApp)

                            {
                               $webT = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $app } 
                               xWebApplication $webT.name
                                { 
                                    Name = $webT.name
                                    Website = "BlueOffice"
                                    WebAppPool =  "BlueOffice"
                                    PhysicalPath = $webT.Physicalpath
                                    Ensure = "Present" 
                                    DependsOn = @("[xWebSite]NewWebSite") 
                                }  
                            }
                            
                         }# selected web app/apps deployment

             } #end of node configure
             
           }# end of DSC function  section

             #run the configure to generate mof
             IISWebsite -ConfigurationData $ConfigurationData -SourceCred $Cred -OutputPath c:\DSCDeploy\IISWebsite

             #Run DSC configure
             Start-DscConfiguration -Path c:\DSCDeploy\IISWebsite -Wait -Verbose -CimSession $webcim

        } # end of Process Block

    End
        {
            #sending notification emails
            if ($SendEmail)
            {
                #for demo only, user my credential
                
                $garyname = 'uumobile\garyzhang'
                $garypass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
                $garyzhang = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $garyname,$garypass
                

                Write-Verbose -Message "Now sending notification email..."
                #send out a email message
                Send-MailMessage -From ReleaseManagement@yipinapp.com `
                                 -to "$env:username@yipinapp.com" `
                                 -Cc garyzhang@yipinapp.com `
                                 -Subject "Build Deployment Notification of Project $BuildDefinition" -Body "Test Build on server $dscEnv successfully" -BodyAsHtml `
                                 -SmtpServer mail.yipinapp.com `
                                 -Credential $garyzhang

            }# sending emails

            
            #verify website 
            if ($Verify)
            {  
                Write-Verbose -Message "Now starting website test on server $dscEnv"
                Start-Process iexpolore -FilePath "http://$($dscEnv):8085"
            
            }# Verify website is working

        } # end of End Block

} # end of the function Start-Deployment
#test:  Start-Deployment -Environment Prod -BuildDefinition test -Version 8.0.1

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
