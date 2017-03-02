$ScriptBlock = {
#==========================
#==========================
##backup to local disk G:##
#==========================
#==========================
if (! (Test-Path C:\MonitoringLogs))
{
    mkdir C:\MonitoringLogs
}

#For Prod TaskForce
$time1 = get-date -Format yyyyMMdd-HHmmss
$tfsLogName = 'tfs' + '-' + $time1 + '.txt'
$SourcePath = 'G:\CollaborationCorporation\TaskForceAttachmentStorage'
$DestinPath = '\\192.168.1.224'
robocopy $SourcePath $DestinPath /e /log:C:\MonitoringLogs\$tfsLogName

#For Prod WishWell
$time2 = get-date -Format yyyyMMdd-HHmmss
$wwLogName = 'ww' + '-' + $time2 + '.txt'
$wwSource = 'F:\CollaborationCorporation\WishingWellAttachmentStorage'
$wwDestin = 'G:\CollaborationCorporation\WishingWellAttachmentStorage'
robocopy $wwSource $wwDestin /e /log:C:\MonitoringLogs\$wwLogName

#For Preview WishWell
$time3 = get-date -Format yyyyMMdd-HHmmss
$prewwLogName = 'pre-ww' + '-' + $time3 + '.txt'
$preWWSource = 'F:\CollaborationCorporationPreview\WishingWellAttachmentStorage'
$preWWDestin = 'G:\CollaborationCorporationPreview\WishingWellAttachmentStorage'
robocopy $preWWSource $preWWDestin /e /log:C:\MonitoringLogs\$prewwLogName

#moment garden service
$time4 = get-date -Format yyyyMMdd-HHmmss
$mgsLogName = 'mgs' + '-' + $time4 + '.txt'
$mgsSourcePath = 'D:\CollaborationCorporation\MomentGardenAttachmentStorage'
$mgsDestinPath = 'G:\CollaborationCorporation\MomentGardenAttachmentStorage'
robocopy $mgsSourcePath $mgsDestinPath /e /log:C:\MonitoringLogs\$mgsLogName

#talk time service
$time5 = get-date -Format yyyyMMdd-HHmmss
$ttsLogName = 'tts' + '-' + $time5 + '.txt'
$ttsSourcePath = 'D:\CollaborationCorporation\TalkTimeAttachmentStorage'
$ttsDestinPath = 'G:\CollaborationCorporation\TalkTimeAttachmentStorage'
robocopy $ttsSourcePath $ttsDestinPath /e /log:C:\MonitoringLogs\$ttsLogName

#images
$time6 = get-date -Format yyyyMMdd-HHmmss
$imageLogName = 'img' + '-' + $time6 + '.txt'
$imgSourcePath = 'D:\CollaborationCorporation\Images\Origin'
$imgDestinPath = 'G:\CollaborationCorporation\Images\Origin'
robocopy $imgSourcePath $imgDestinPath /e /log:C:\MonitoringLogs\$imageLogName
}

$backupAttachTrigger = New-JobTrigger -Daily -At "1:00 AM" -DaysInterval 1
Register-ScheduledJob -Name ProdAttachmentBackup -ScriptBlock $ScriptBlock -Trigger $backupAttachTrigger
