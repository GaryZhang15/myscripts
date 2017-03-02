$ScriptBlock = {
    if (! (Test-Path C:\MonitoringLogs))
    {
        mkdir C:\MonitoringLogs
    }

    $VMHost = @(
                @{Name = 'WIN-GNRE16FMH2J'
                  IP = '10.1.1.20'}
                @{Name = 'YIPIN-VMHOST01'
                  IP = '10.1.1.24'}
                @{Name = 'YIPINAPP-SERVER'
                  IP = '10.1.1.9'}
    )

    $pssessions =New-PSSession -ComputerName $VMHost.name
    $date = get-date -Format yyyyMMddHHmmss
    foreach($session in $pssessions){
        $vmrep = Invoke-Command -Session $session -ScriptBlock {Get-VMReplication}
        $vmrep | Export-Csv "$env:SystemDrive\MonitoringLogs\VMReplicaMonitor_$date.csv" -Encoding UTF8 -NoTypeInformation -Append
        #if not healthy the send admin email with attachment
        for ($i = 0; $i -lt $vmrep.Count; $i++)
        { 
            if($vmrep[$i].Health -ne 'Normal'){
                Send-MailMessage -From CorpVMReplicaMonitor@yipinapp.com `
                                 -to "garyzhang@yipinapp.com" `
                                 -Cc "nealpan@yipinapp.com"`
                                 -Subject "[CorpEnv], VM:$($vmrep[$i].VMName) has replication issue"  `
                                 -Body "Current Status: $($vmrep[$i].Health)`nPlease check the attachment for more details" `
                                 -BodyAsHtml `
                                 -Attachments "$env:SystemDrive\MonitoringLogs\VMReplicaMonitor_$date.csv" `
                                 -SmtpServer mail.yipinapp.com
            }
        }
    }
    #remove all the ps session
    $pssessions | Remove-PSSession
 }  

$VMReplicaTrigger = New-JobTrigger -Daily -At "08:00 AM" -DaysInterval 1
Register-ScheduledJob -Name VMReplicaMonitor -ScriptBlock $ScriptBlock -Trigger $VMReplicaTrigger -Credential (Get-Credential)