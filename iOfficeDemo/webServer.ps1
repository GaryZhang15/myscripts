function Start-Deployment {

[CmdletBinding()]
    Param(
        # #GlobalBlueOffice (19 apps) = 'dsp','bo','fgp','fg','gbo','lv','mgmt','mrp','mr','mg','nbp','nb','website','op','tt','tfp','tf','wwp','ww'
        # #SaaS (11 apps)= 'an','ah','cg','cs','dirp','dir','gds','ih','p','pl','vh'
        # #DocumentsConversion = 'dcc','dce'
        # #OfficialWebSite (also in GBO list) = 'website'
        # specify which web app or site you would like to deploy

        #[Parameter(Mandatory=$true)]
        #[String]$SourcePath
        )

    Begin
        {          

        $AllApps = 'WebSite','dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp',
                     'nb','tt','tfp','tf','wwp','ww','an','ah','cg',
                     'cs','dirp','dir','ih','p','pl','dcc','dce','vh',
                     'gbo','mgmt','op','gds','qr' # 33 apps in totall


        $webapps = @{

            allapps = @( # 33 apps, 34 included one app that has been commented out
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

                        #@{  #05 seems not in use any more, need check
                        #    name = "dc"	
                        #    Physicalpath = "C:\Websites\iOffice\DataCubeService"
                        #    ProjectName  = "DataCubeService"}

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
                            Physicalpath = "C:\Websites\iOffice\OperationPortal"
                            ProjectName  = "OperationPortal"} # changed name from OperationWebSite

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
                        @{  #34
                            name = "qr"
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeQR"
                            ProjectName  = "BlueOfficeQR"}
                        )
                    }
      
        # windows features that need to be installed (need to know which feature are no longer need in the future on the server core)
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
        } # end of Begin Block

    Process
        {
         $ConfigurationData = @{
         AllNodes = @(
                        @{
                            NodeName="*"
                            PSDscAllowPlainTextPassword=$true
                         }
                        @{
                            NodeName= hostname # localhost
                         }
                )
            }# end of ConfigurationData section
          Configuration IISWebsite 
            { 
                # explicitly import the DSC xModules, before this you need to push the modules to the destination nodes (DSC push mode only)
                Import-DscResource -ModuleName xWebAdministration 
                Import-DSCResource -ModuleName xNetworking
                Import-DscResource –ModuleName PSDesiredStateConfiguration

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

                        # Unzipped WebData
                        File webData
                        {
                            Ensure = "Present"
                            SourcePath = "C:\resources\webData" #may need to change this to a param
                            DestinationPath = "C:\Websites\iOffice"
                            DependsOn = "[File]WebsitesFolder"
                            Type = "Directory"
                            Recurse = $true
                        }  
                        # Create a Web Application Pool 
                        xWebAppPool NewWebAppPool 
                        { 
                            Name   = "iOffice" 
                            Ensure = "Present" 
                            State  = "Started" 
                            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                        } 

                        # remove default web site
                        xWebsite defaultsite
                        {
                            Name   = 'Default Web Site'
                            Ensure = 'Absent' # remove the default website
                            State = "Started"
                            PhysicalPath = "C:\inetpub\wwwroot"
                            BindingInfo     = MSFT_xWebBindingInformation 
                                              { 
                                                Protocol              = "HTTP" 
                                                Port                  = 80
                                              } 
                            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                        }

                        #Create a New Website with Port 8080
                        xWebsite NewWebsite 
                        { 
                            Ensure          = "Present" 
                            Name            = "iOffice" 
                            State           = "Started" 
                            PhysicalPath    = "c:\Websites\ioffice\RootWeb" 
                            BindingInfo     = MSFT_xWebBindingInformation 
                                             { 
                                               Protocol              = "HTTP" 
                                               Port                  = 80
                                             } 
                            DependsOn       = "[File]WebsitesFolder","[xWebAppPool]NewWebAppPool","[xWebsite]defaultsite"
                        } 

                        #Create each Web Applications
                        foreach ($app in $AllApps)
                        {
                           $webT = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $app } 
                           xWebApplication $webT.name
                            { 
                                Name = $webT.name
                                Website = "iOffice"
                                WebAppPool =  "iOffice"
                                PhysicalPath = $webT.Physicalpath
                                Ensure = "Present" 
                                DependsOn = @("[xWebSite]NewWebSite") 
                            }  
                        }
             } #end of node configure
             
           }# end of DSC function  section

             #run the configure to generate mof
             IISWebsite -ConfigurationData $ConfigurationData -OutputPath c:\DSCDeploy\IISWebsite

             #Run DSC configure
             Start-DscConfiguration -Path c:\DSCDeploy\IISWebsite -Wait -Verbose

        } # end of Process Block

    End
        {          
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
                    mkdir 'C:\\Collaboration\\AudioHub\\OriginAudio'
                    mkdir 'C:\\Collaboration\\AudioHub\\CacheAudio'
                    mkdir 'C:\\Collaboration\\AudioHub\\AudioTemp'
                    mkdir 'C:\\Collaboration\\ImageHub\\OriginImages'
                    mkdir 'C:\\Collaboration\\ImageHub\\CacheImages'
                    mkdir 'C:\\Collaboration\\TalkTimeAttachmentStorage'
                    mkdir 'C:\\Collaboration\\TalkTimeAttachmentPreviewStorage'
                    mkdir 'C:\\Collaboration\\TaskForceAttachmentStorage'
                    mkdir 'C:\\Collaboration\\TaskForceAttachmentPreviewStorage'
                    mkdir 'C:\\Collaboration\\VideoHub\\OriginVideo'
                    mkdir 'C:\\Collaboration\\VideoHub\\CacheVideo'
                    mkdir 'C:\\BlueOfficeManagementTestData\\OriginImages'
                    mkdir 'C:\BlueOfficeManagementTestData\TaskForceAttachments'
                    mkdir 'C:\BlueOfficeManagementTestData\WishWellAttachments'
                    mkdir 'C:\BlueOfficeManagementTestData\TalkTimeAttachments'
                    mkdir 'C:\BlueOfficeManagementTestData\MomentGardenAttachmentsDirectory'
                }
                Process
                {
                    foreach ($p in $shortpath)
                    {
                       $t = cat -Path $p -Verbose
                       $t.Replace('10.1.1.4:8088',"$WebNode").
                       Replace('10.1.1.50',"$DataNode").
                       Replace('10.1.1.83',"$DataNode").
                       Replace('bocorp-test.ioffice100.com',"$WebNode").
                       Replace('boglobal.yipinapp.net',"$WebNode").
                       Replace('global.ioffice100.net',"$WebNode").
                       Replace('globalbo.ioffice100.net',"$WebNode").
                       Replace('10.1.1.81:8082',"$WebNode").
                       Replace('10.1.1.81:8081',"$WebNode").
                       Replace('D:\\YPTfs\\YPWare\\Dev\\Server\\Collaboration\\AudioHub\\OriginAudio','C:\\Collaboration\\AudioHub\\OriginAudio').
                       Replace('D:\\YPTfs\\YPWare\\Dev\\Server\\Collaboration\\AudioHub\\CacheAudio','C:\\Collaboration\\AudioHub\\CacheAudio').
                       Replace('D:\\YPTfs\\YPWare\\Dev\\Server\\Collaboration\\AudioHub\\AudioTemp','C:\\Collaboration\\AudioHub\\AudioTemp').
                       Replace('D:\\YPTfs\\YPWare\\Dev\\Server\\Collaboration\\ImageHub\\OriginImages','C:\\Collaboration\\ImageHub\\OriginImages').
                       Replace('D:\\YPTfs\\YPWare\\Dev\\Server\\Collaboration\\ImageHub\\CacheImages','C:\\Collaboration\\ImageHub\\CacheImages').
                       replace('D:\\TalkTimeAttachmentStorage','C:\\Collaboration\\TalkTimeAttachmentStorage').
                       Replace('D:\\TalkTimeAttachmentPreviewStorage','C:\\Collaboration\\TalkTimeAttachmentPreviewStorage').
                       Replace('D:\\TaskForceAttachmentStorage','C:\\Collaboration\\TaskForceAttachmentStorage').
                       Replace('D:\\TaskForceAttachmentPreviewStorage','C:\\Collaboration\\TaskForceAttachmentPreviewStorage').
                       Replace('D:\YPTfs\YPWare\Dev\Server\Collaboration\VideoHub\OriginVideo','C:\\Collaboration\\VideoHub\\OriginVideo').
                       Replace('D:\YPTfs\YPWare\Dev\Server\Collaboration\VideoHub\CacheVideo','C:\\Collaboration\\VideoHub\\CacheVideo').
                       Replace('E:\BlueOfficeManagementTestData\OriginImages','C:\\BlueOfficeManagementTestData\\OriginImages').
                       Replace('E:\BlueOfficeManagementTestData\TaskForceAttachments','C:\BlueOfficeManagementTestData\TaskForceAttachments').
                       Replace('E:\BlueOfficeManagementTestData\WishWellAttachments','C:\BlueOfficeManagementTestData\WishWellAttachments').
                       replace('E:\BlueOfficeManagementTestData\TalkTimeAttachments','C:\BlueOfficeManagementTestData\TalkTimeAttachments').
                       Replace('E:\BlueOfficeManagementTestData\MomentGardenAttachmentsDirectory','C:\BlueOfficeManagementTestData\MomentGardenAttachmentsDirectory').
                       replace('D:\YPTfs\YPWare\Dev\Server\Collaboration\VideoHub\VideoTemp','C:\\Collaboration\\VideoHub\\VideoTemp') |
                        Out-File -FilePath $p -Force -Verbose -Encoding utf8
                    }

                    $GDSConfig = cat -Path "$Location\GlobalDirectoryService\ServiceConfiguration.json"
                    $GDSConfig.Replace('10.1.1.4:8088',"$WebNode").Replace('10.1.1.4:9005/',$WebNode+'/ih') | Out-File -FilePath "$Location\GlobalDirectoryService\ServiceConfiguration.json" -Force -Verbose -Encoding utf8

                }
                End
                {
                    Write-Verbose -Message "Successfully update web config file , and GlobalDirectoryService ServiceConfiguration.json"
                }
            } # end of function Update-WebConfig

        } # end of End Block

} # end of the function Start-Deployment
#test:  Start-Deployment -Environment Prod -BuildDefinition test -Version 8.0.1

# Test: Update-WebConfig -Location 'C:\Websites\iOffice' -WebNode 10.1.1.81 -DataNode 10.1.1.83

# The most important thing to improve quality was not getting things right, but getting things consistent.
