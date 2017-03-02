break

$username = "administrator"
$password = ConvertTo-SecureString -AsPlainText "zl123!@#" -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password


$web1 = New-PSSession -ComputerName 10.1.1.83 -Credential $credential -Verbose

# create folders in webserver named websites
Invoke-Command -Session $web1 -ScriptBlock {mkdir c:\Websites}

#create webshare on the web server

Invoke-Command -Session $web1 -ScriptBlock {New-SmbShare –Name Websites –Path C:\Websites -FullAccess Administrator}

# copy all the web content into the folder

Copy-Item -Path "C:\DSC\iOffice" -Destination "\\10.1.1.83\Websites" -Recurse 

# install web server features
Invoke-Command -Session $web1 -ScriptBlock {
    Install-WindowsFeature `
    -Name Web-Server,Web-WebServer,Web-Common-Http,Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-Static-Content,Web-Http-Redirect,Web-Health,Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Performance,Web-Stat-Compression,Web-Dyn-Compression,Web-Security,Web-Filtering,Web-Basic-Auth,Web-Client-Auth,Web-Digest-Auth,Web-Cert-Auth,Web-IP-Security,Web-Url-Auth,Web-Windows-Auth,Web-App-Dev,Web-Net-Ext45,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-WebSockets,Web-Mgmt-Tools,Web-Mgmt-Console,Web-Scripting-Tools,Web-Mgmt-Service -Verbose}

# import web admin module
Import-PSSession -Session $web1 -Module WebAdministration

#create web pool
New-WebAppPool -Name iOffice

#create web site
New-Website -Name iOffice -PhysicalPath c:\websites\ioffice\webroot -ApplicationPool iOffice -Port 8088 -Verbose

# (1) install webapp: AggregatedNotification
New-WebApplication -Name an -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\AggregatedNotification -ApplicationPool iOffice -Verbose

# (2) install webapp: BlueOfficeService
New-WebApplication -Name bo -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\BlueOfficeService -ApplicationPool iOffice -Verbose

# (3) install webapp: CalendarGridService
New-WebApplication -Name cg -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\CalendarGridService -ApplicationPool iOffice -Verbose

# (4) install webapp: ConchShellService
New-WebApplication -Name cs -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\ConchShellService -ApplicationPool iOffice -Verbose

# (5) install webapp: DataCubeService
New-WebApplication -Name dc -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\DataCubeService -ApplicationPool iOffice -Verbose

# (6) install webapp: DirectoryService
New-WebApplication -Name dir -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\DirectoryService -ApplicationPool iOffice -Verbose

# (7) install webapp: DirectoryPortal
New-WebApplication -Name dirp -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\DirectoryPortal -ApplicationPool iOffice -Verbose

# (8) install webapp: FootprintGraphService
New-WebApplication -Name fg -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\FootprintGraphService -ApplicationPool iOffice -Verbose

# (9) install webapp: BlueOfficeGlobalBlueOffice
New-WebApplication -Name gbo -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\BlueOfficeGlobalBlueOffice -ApplicationPool iOffice -Verbose

# (10) install webapp: GlobalDirectoryService
New-WebApplication -Name gds -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\GlobalDirectoryService -ApplicationPool iOffice -Verbose

# (11) install webapp: ImageHub
New-WebApplication -Name ih -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\ImageHub -ApplicationPool iOffice -Verbose

# (12) install webapp: LiveVoteService
New-WebApplication -Name lv -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\LiveVoteService -ApplicationPool iOffice -Verbose

# (13) install webapp: MomentGardenService
New-WebApplication -Name mg -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\MomentGardenService -ApplicationPool iOffice -Verbose

# (14) install webapp: Management
New-WebApplication -Name mgmt -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\Management -ApplicationPool iOffice -Verbose

# (15) install webapp: MindRadarService
New-WebApplication -Name mr -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\MindRadarService -ApplicationPool iOffice -Verbose

# (16) install webapp: MindRadarPortal
New-WebApplication -Name mrp -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\MindRadarPortal -ApplicationPool iOffice -Verbose

# (17) install webapp: NewsBoardService
New-WebApplication -Name nb -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\NewsBoardService -ApplicationPool iOffice -Verbose

# (18) install webapp: NewsBoardPortal
New-WebApplication -Name nbp -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\NewsBoardPortal -ApplicationPool iOffice -Verbose

# (19) install webapp: OperationPortal
New-WebApplication -Name op -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\OperationPortal -ApplicationPool iOffice -Verbose

# (20) install webapp: Portal
New-WebApplication -Name p -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\Portal -ApplicationPool iOffice -Verbose

# (21) install webapp: PortalLogger
New-WebApplication -Name pl -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\PortalLogger -ApplicationPool iOffice -Verbose

# (22) install webapp: TaskForceService
New-WebApplication -Name tf -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\TaskForceService -ApplicationPool iOffice -Verbose

# (23) install webapp: TalkTimeService
New-WebApplication -Name tt -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\TalkTimeService -ApplicationPool iOffice -Verbose

# (24) install webapp: iOfficeWebsites
New-WebApplication -Name Website -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\iOfficeWebsite -ApplicationPool iOffice -Verbose

# (25) install webapp: WishingWellService
New-WebApplication -Name ww -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\WishingWellService -ApplicationPool iOffice -Verbose

#ask if need to create the folders
mkdir C:\Websites\iOffice\Images

mkdir C:\Websites\iOffice\Images\Origin

mkdir C:\Websites\iOffice\Images\Cache

mkdir C:\Websites\iOffice\MomentGardenAttachmentStorage

mkdir C:\Websites\iOffice\MomentGardenAttachmentPreviewStorage

mkdir C:\Websites\iOffice\TaskForceAttachmentStorage

mkdir C:\Websites\iOffice\TaskForceAttachmentPreviewStorage

mkdir C:\Websites\iOffice\TalkTimeAttachmentStorage

mkdir C:\Websites\iOffice\TalkTimeAttachmentPreviewStorage




