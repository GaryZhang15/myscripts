$ScriptBlock = {
#==========================
#==========================
##backup code to local disk 224:##
#==========================
#==========================
if (! (Test-Path C:\MonitoringLogs))
{
    mkdir C:\MonitoringLogs
}
$time1 = get-date -Format yyyyMMdd-HHmmss

#iOffice production code
$CodeLogName = 'code' + '-' + $time1 + '.txt'
$codeSourcePath = 'D:\CollaborationCorporation\'
$codeDestinPath = '\\192.168.1.224\Backup2015\co01\Code\Prod'
robocopy $codeSourcePath $codeDestinPath /e /log:C:\MonitoringLogs\$CodeLogName /XD `
    D:\CollaborationCorporation\MomentGardenAttachmentPreviewStorage `
    D:\CollaborationCorporation\MomentGardenAttachmentStorage `
    D:\CollaborationCorporation\TalkTimeAttachmentPreviewStorage `
    D:\CollaborationCorporation\TalkTimeAttachmentStorage `
    D:\CollaborationCorporation\TaskForceAttachmentPreviewStorage `
    D:\CollaborationCorporation\TaskForceAttachmentStorage `
    D:\CollaborationCorporation\WishingWellAttachmentPreviewStorage `
    D:\CollaborationCorporation\WishingWellAttachmentStorage `
    D:\CollaborationCorporation\WishWellAttachmentPreviewStorage `
    D:\CollaborationCorporation\WishWellAttachmentStorage `
    D:\CollaborationCorporation\Images

#iOffice preview code
$time2 = get-date -Format yyyyMMdd-HHmmss
$preCodeLogName = 'preCode' + '-' + $time2 + '.txt'
$preSourcePath = 'D:\CollaborationCorporationPreview'
$preDestinPath = '\\192.168.1.224\Backup2015\co01\Code\Preview'
robocopy $preSourcePath $preDestinPath /e /log:C:\MonitoringLogs\$preCodeLogName /XD `
    D:\CollaborationCorporationPreview\MomentGardenAttachmentStorage `
    D:\CollaborationCorporationPreview\WishingWellAttachmentStorage

#iOffice Global code
$time3 = get-date -Format yyyyMMdd-HHmmss
$globalCodeLogName = 'globalCode' + '-' + $time3 + '.txt'
$globalSourcePath = 'D:\CollaborationGlobal'
$globalDestinPath = '\\192.168.1.224\Backup2015\co01\Code\GlobalService\CollaborationGlobal'
robocopy $globalSourcePath $globalDestinPath /e /log:C:\MonitoringLogs\$globalCodeLogName

#Corp wiki
$time4 = get-date -Format yyyyMMdd-HHmmss
$wikiContentLogName = 'wiki' + '-' + $time4 + '.txt'
$wikiSourcePath = 'D:\Wiki'
$wikiDestinPath = '\\192.168.1.224\Backup2015\co01\Code\wiki'
robocopy $wikiSourcePath $wikiDestinPath /e /log:C:\MonitoringLogs\$wikiContentLogName

#Other webservice
$time5 = get-date -Format yyyyMMdd-HHmmss
$othersLogName = 'others' + '-' + $time5 + '.txt'
$othersSourcePath = 'D:\Global'
$othersDestinPath = '\\192.168.1.224\Backup2015\co01\Code\OtherSites'
robocopy $othersSourcePath $othersDestinPath /e /log:C:\MonitoringLogs\$othersLogName
}

$backupCodeTrigger = New-JobTrigger -Weekly -At "2:00 AM" -DaysOfWeek Sunday
Register-ScheduledJob -Name CodeBackup -ScriptBlock $ScriptBlock -Trigger $backupCodeTrigger