$webapps = 
    @{
        allapps = 
        @(
            @{  #01 
                name = "an"	
                Physicalpath = "C:\blueoffice\AggregatedNotification"
                ProjectName  = "AggregatedNotification"}
            @{  #02
                name = "bo"	
                Physicalpath = "C:\blueoffice\BlueOfficeService"
                ProjectName  = "BlueOfficeService"}
            @{  #03
                name = "cg"
               Physicalpath = "C:\blueoffice\CalendarGridService"
                ProjectName  = "CalendarGridService"}
            @{  #04
                name = "cs"	
                Physicalpath = "C:\blueoffice\ConchShellService"
                ProjectName  = "ConchShellService"}
            @{  #05
                name = "dir"	
                Physicalpath = "C:\blueoffice\DirectoryService"
                ProjectName  = "DirectoryService"}
            @{  #06
                name = "dirp"	
                Physicalpath = "C:\blueoffice\DirectoryPortal"
                ProjectName  = "DirectoryPortal"}
            @{  #07
                name = "fg"	
                Physicalpath = "C:\blueoffice\FootprintGraphService"
                ProjectName  = "FootprintGraphService"}
            @{  #08
                name = "gbo"	
                Physicalpath = "C:\blueoffice\GlobalBlueOfficeService"
                ProjectName  = "GlobalBlueOfficeService"}
            @{  #09
                name = "gds"	
                Physicalpath = "C:\blueoffice\GlobalDirectoryService"
                ProjectName  = "GlobalDirectoryService"}
            @{  #10
                name = "ih"	
                Physicalpath = "C:\blueoffice\ImageHub"
                ProjectName  = "ImageHub"}
            @{  #11
                name = "lv"	
                Physicalpath = "C:\blueoffice\LiveVoteService"
                ProjectName  = "LiveVoteService"}
            @{  #12
                name = "mg"	
                Physicalpath = "C:\blueoffice\MomentGardenService"
                ProjectName  = "MomentGardenService"}
            @{  #13
                name = "mgmt"	
                Physicalpath = "C:\blueoffice\Management"
                ProjectName  = "Management"}
            @{  #14
                name = "mr"	
                Physicalpath = "C:\blueoffice\MindRadarService"
                ProjectName  = "MindRadarService"}
            @{  #15
                name = "mrp"	
                Physicalpath = "C:\blueoffice\MindRadarPortal"
                ProjectName  = "MindRadarPortal"}
            @{  #16
                name = "nb"	
                Physicalpath = "C:\blueoffice\NewsBoardService"
                ProjectName  = "NewsBoardService"}
            @{  #17
                name = "nbp"	
                Physicalpath = "C:\blueoffice\NewsBoardPortal"
                ProjectName  = "NewsBoardPortal"}
            @{  #18
                name = "op"	
                Physicalpath = "C:\blueoffice\OperationPortal"
                ProjectName  = "OperationPortal"}
            @{  #19
                name = "p"	
                Physicalpath = "C:\blueoffice\Portal"
                ProjectName  = "Portal"}
            @{  #20
                name = "pl"	
                Physicalpath = "C:\blueoffice\PortalLogger"
                ProjectName  = "PortalLogger"}
            @{  #21
                name = "tf"	
                Physicalpath = "C:\blueoffice\TaskForceService"
                ProjectName  = "TaskForceService"}
            @{  #22
                name = "tt"	
                Physicalpath = "C:\blueoffice\TalkTimeService"
                ProjectName  = "TalkTimeService"}
            @{  #23
                name = "ww"	
                Physicalpath = "C:\blueoffice\WishingWellService"
                ProjectName  = "WishingWellService"}
            @{  #24
                name = "fgp"	
                Physicalpath = "C:\blueoffice\FootprintGraphPortal"
                ProjectName  = "FootprintGraphPortal"}
            @{  #25
                name = "tfp"	
                Physicalpath = "C:\blueoffice\TaskForcePortal"
                ProjectName  = "TaskForcePortal"}
            @{  #26
                name = "wwp"	
                Physicalpath = "C:\blueoffice\WishingWellPortal"
                ProjectName  = "WishingWellPortal"}
            @{  #27
                name = "dcc"	
                Physicalpath = "C:\blueoffice\DocumentsConversionClient"
                ProjectName  = "DocumentsConversionClient"}
            @{  #28
                name = "dce"	
                Physicalpath = "C:\blueoffice\Engine"
                ProjectName  = "Engine"}
            @{  #29
                name = "smshub"
                Physicalpath = "C:\blueoffice\SmsHub"
                ProjectName = "SmsHub"}
            @{  #30
                name = "dc"
                Physicalpath = "C:\blueoffice\DataCubeService"
                ProjectName = "DataCubeService"}
            @{  #31
                name = "dcp"
                Physicalpath = "C:\blueoffice\DataCubePortal"
                ProjectName = "DataCubePortal"}
            @{  #32
                name = "lvp"
                Physicalpath = "C:\blueoffice\LiveVotePortal"
                ProjectName = "LiveVotePortal"}
            @{  #33
                name = "O365Bridge"
                Physicalpath = "C:\blueoffice\O365Bridge"
                ProjectName = "o365bridge"}
            @{ #34
                name = "O365Gateway"
                Physicalpath = "C:\blueoffice\O365Gateway"
                ProjectName = "O365Gateway"}
            @{ #35
                name = "website"
                Physicalpath = "C:\blueoffice\OfficialWebSite"
                ProjectName = "OfficialWebSite"}
            @{ #36
                name = "store"
                Physicalpath = "C:\blueOffice\StoreService"
                ProjectName = "StoreService"}
            @{ #37 
                name = "ttp"
                Physicalpath = "C:\blueoffice\TalkTimePortal"
                ProjectName = "TalkTimePortal"}
            @{ #38
                name = "wechat"
                Physicalpath = "C:\blueoffice\WechatGateway"
                ProjectName = "WechatGateway"}
            #@{  #--
            #   name = "vh"	
            #    Physicalpath = "C:\blueoffice\VideoHub"
            #    ProjectName  = "VideoHub"}
        )
}

$winfeatures = 
    @(
        'Web-Server','Web-WebServer','Web-Common-Http',
        'Web-Default-Doc','Web-Dir-Browsing','Web-Http-Errors',
        'Web-Static-Content','Web-Http-Redirect','Web-Health',
        'Web-Http-Logging','Web-Log-Libraries','Web-Request-Monitor',
        'Web-Performance','Web-Stat-Compression','Web-Dyn-Compression','Web-Security',
        'Web-Filtering','Web-Basic-Auth','Web-Client-Auth','Web-Digest-Auth',
        'Web-Cert-Auth','Web-IP-Security','Web-Url-Auth','Web-Windows-Auth',
        'Web-App-Dev','Web-Net-Ext45','Web-Asp-Net45','Web-ISAPI-Ext',
        'Web-ISAPI-Filter','Web-WebSockets','Web-Mgmt-Tools',
        'Web-Mgmt-Console','Web-Scripting-Tools','Web-Mgmt-Service'
    )

Configuration BoFullServiceProvision {
    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName cFirewall
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node localhost{
        foreach ($feature in $winfeatures) {
            WindowsFeature $feature.Replace('-',''){
                Ensure = "Present"
                Name = "$feature"
            }
        }
        xWebsite StopDefaultSite{
            Ensure = "Present"
            Name = "Default Web Site"
            State = "Stopped"
            PhysicalPath = "C:\inetpub\wwwroot"
            BindingInfo = MSFT_xWebBindingInformation{
                Protocol = "http"
                Port = 80
            }
            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
        }
        xWebAppPool blueoffice{
            Name = "blueoffice"
            Ensure = "Present"
            State = "Started"
            DependsOn = "[WindowsFeature]WebServer"
        }
        File BORoot{
            Ensure = 'Present'
            Type = 'Directory'
            DestinationPath = 'C:\blueoffice\RootWeb'
        }
        xWebsite blueoffice{
            Ensure = "Present"
            Name = "blueoffice"
            State = "Started"
            PhysicalPath = "C:\blueoffice\RootWeb"
            BindingInfo = MSFT_xWebBindingInformation{
                Protocol = "http"
                Port = 80
            }
            DependsOn = "[xWebAppPool]blueoffice","[File]boroot"
        }
        foreach ($app in $webapps.allapps) {
            xWebApplication $app.name {
                Name = $app.name
                Website = "blueoffice"
                WebAppPool = "blueoffice"
                PhysicalPath = $app.Physicalpath
                Ensure = "Present"
                DependsOn = "[xWebsite]blueoffice"
            }
        }
        xWebVirtualDirectory BOResource{
            Name = 'res'
            PhysicalPath = 'c:\blueoffice\Localizations'
            WebApplication = ''
            Website = 'blueoffice'
            Ensure = 'Present'
        }
        File Mocha{
            Ensure = 'Present'
            DestinationPath = 'c:\blueoffice\Mocha'
            Type = 'Directory'
        }
        xWebVirtualDirectory Mocha{
            Name = 'mocha'
            PhysicalPath = 'c:\blueoffice\Mocha'
            WebApplication = ''
            Website = 'blueoffice'
            Ensure = 'Present'
            DependsOn = '[File]Mocha'
        }
        cFirewallRule Web80 {
            Action = 'Allow'
            Direction = 'Inbound'
            Enabled = 'True'
            Ensure = 'Present'
            Profile = 'All'
            Protocol = 'TCP'
            LocalPort = '80'
            Name = 'Web 80 inbound rule'
        }
        cFirewallRule NotificationHub5660 {
            Action = 'Allow'
            Direction = 'Inbound'
            Enabled = 'True'
            Ensure = 'Present'
            Profile = 'All'
            Protocol = 'TCP'
            LocalPort = '5660'
            Name = 'NotificationHub5660 inbound rule'
        }
        File BOAttachment{
            DestinationPath = 'C:\BOAttachments'
            Ensure = 'Present'
            Type = 'Directory'
        }
        File BOLog{
            DestinationPath = 'C:\log'
            Ensure = 'Present'
            Type = 'Directory'
        }
        File ImageHubOrgin{
            DestinationPath = 'c:\BOAttachments\Images\Origin'
            Ensure = 'Present'
            Type = 'Directory'
        }
    }
}

BoFullServiceProvision -OutputPath C:\DSC
Start-DscConfiguration -Path C:\DSC -Wait -Force -Verbose