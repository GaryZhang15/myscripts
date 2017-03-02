break
$username = "administrator"
$password = ConvertTo-SecureString -AsPlainText "zl123!@#" -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$username_AD = "uumobile\garyzhang"
$password_AD = ConvertTo-SecureString -AsPlainText "zl123!@#" -Force
$credential_AD = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

$yipin = New-PSSession -ComputerName 10.1.1.161 -Credential $credential

# Enter-PSSession -Session $yptest

Import-PSSession -Session $yipin -Module WebAdministration

# Invoke-Command -Session $yptest -ScriptBlock {get-webapppool}

New-WebAppPool -Name iOffice

# make directory to put your webcontent content there(web have some issue here)

Invoke-Command -Session $yipin -ScriptBlock {mkdir c:\Websites\iOffice}
Invoke-Command -Session $yipin -ScriptBlock {copy '\\10.1.1.4\D$\Websits\iOffice\webroot' -Destination 'C:\Websites' -Credential $credential_AD }

copy '\\10.1.1.4\D$\Websits\iOffice\webroot' -Destination 'C:\Websites' 


# create you Websites

New-Websites -Name iOffice -PhysicalPath c:\Websites\ioffice\webroot -ApplicationPool iOffice

Cd IIS:\

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
New-WebApplication -Name Websites -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\iOfficeWebsites -ApplicationPool iOffice -Verbose

# (25) install webapp: WishingWellService
New-WebApplication -Name ww -Site 'iOffice' -PhysicalPath C:\Websites\iOffice\WishingWellService -ApplicationPool iOffice -Verbose

mkdir C:\Websites\iOffice\Images

mkdir C:\Websites\iOffice\Origin

mkdir C:\Websites\iOffice\Cache

mkdir C:\Websites\iOffice\MomentGardenAttachmentStorage

mkdir C:\Websites\iOffice\MomentGardenAttachmentPreviewStorage

mkdir C:\Websites\iOffice\TaskForceAttachmentStorage

mkdir C:\Websites\iOffice\TaskForceAttachmentPreviewStorage

mkdir C:\Websites\iOffice\TalkTimeAttachmentStorage

mkdir C:\Websites\iOffice\TalkTimeAttachmentPreviewStorage











