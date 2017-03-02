$ScriptBlock = {
$srvStatus = Get-Service -Name W32Time

#Check Log path
if (Test-Path "$env:SystemDrive\MonitoringLogs")
    {
        Write-Verbose "Monitoring log folder found!"}
else
    {
        mkdir  "$env:SystemDrive\MonitoringLogs"}

if($srvStatus.Status -eq 'Running'){
    Write-Output "[$(get-date)]Windows Time Service is currently running on $(hostname)" |
    Out-File "$env:SystemDrive\MonitoringLogs\WinTimeSrvMonitor.txt" -Append unicode
}
elseif($srvStatus.Status -ne 'Running'){
    Write-Output "[$(get-date)]Windows Time Service is currently $($srvStatus.Status) on $(hostname)" |
    Out-File "$env:SystemDrive\MonitoringLogs\WinTimeSrvMonitor.txt" -Append unicode

    Start-Service -Name $srvStatus.Name
    Write-Output "[$(get-date)]Starting Windows Time Service on $(hostname) ......" |
    Out-File "$env:SystemDrive\MonitoringLogs\WinTimeSrvMonitor.txt" -Append unicode}
}

$WinTimeSrvMonitor = New-JobTrigger -Daily -At "6:00 AM" -DaysInterval 1
Register-ScheduledJob -Name WinTimeSrvMonitor -ScriptBlock $ScriptBlock -Trigger $WinTimeSrvMonitor