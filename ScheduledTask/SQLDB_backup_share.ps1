#SQL DB and Log backup plan
$ScriptBlock = {
    #==========================
    #==========================
    ##backup(Mirror) SQL DB bak to \\192.168.1.224\Backup2015\PRODDB##
    #==========================
    #==========================
    if (! (Test-Path C:\MonitoringLogs))
    {
        mkdir C:\MonitoringLogs
    }
    #DB BAKS
    $time1 = get-date -Format yyyyMMdd-HHmmss
    $DBLogName = 'PRODDB' + '-' + $time1 + '.txt'
    $DBSourcePath = 'D:\Backup'
    $DBDestinPath = '\\192.168.1.224\Backup2015\PRODDB'
    robocopy $DBSourcePath $DBDestinPath /mir /log:C:\MonitoringLogs\$DBLogName
}

$backupDBTrigger = New-JobTrigger -Daily -At "1:00 AM" -DaysInterval 1
Register-ScheduledJob -Name DB_Bak_Backup -ScriptBlock $ScriptBlock -Trigger $backupDBTrigger