$ScriptBlock = {
[array]$diskmonitor =  Get-CimInstance win32_logicaldisk
for ($i = 0 ; $i -lt $diskmonitor.Count ; $i++)
{ 
    $props = [ordered]@{ 'DeviceID'    = $diskmonitor[$i].DeviceID;
                'DriveType'   = $diskmonitor[$i].DriveType;
                'Description' = $diskmonitor[$i].Description;
                'Size (GB)'        = "{0:N2}" -f ($diskmonitor[$i].size/ 1GB);
                'FreeSpace (GB)'   = "{0:N2}" -f ($diskmonitor[$i].freespace / 1GB);
                'UsageRate (%)'    = "{0:p}" -f (($diskmonitor[$i].size - $diskmonitor[$i].freespace) / $diskmonitor[$i].size)
                }
    $obj = New-Object -TypeName psobject -Property $props
    
    if ($diskmonitor[$i].DriveType -ne 3)
    {
        Write-Warning "dirver $($diskmonitor[$i].DeviceID) is a $($diskmonitor[$i].Description), which is not a local disk"
    }
    else
    {
            if ( ($diskmonitor[$i].size - $diskmonitor[$i].freespace) / $diskmonitor[$i].size -ge .9 )
                {
                    Write-Warning "low disk space on dirver $($diskmonitor[$i].DeviceID), current used percentage: $($obj.'UsageRate (%)')"
                    $html = ($obj | ConvertTo-Html) -replace '<table>','<table  border="1">'
                    #send warning email
                    Send-MailMessage -From DiskSpaceMonitor@yipinapp.com `
                                     -to "garyzhang@yipinapp.com" `
                                     -Cc "junminghuang@yipinapp.com","tonyxia@yipinapp.com","paulzhang@yipinapp.com" `
                                     -Subject "Disk Space Warning on $(hostname), $($diskmonitor[$i].DeviceID) drive ,current used percentage: $($obj.'UsageRate (%)')"  `
                                     -Body "$html" `
                                     -BodyAsHtml `
                                     -SmtpServer mail.yipinapp.com
                }
        
    }
}
}

$diskMonitorTrigger = New-JobTrigger -Daily -At "15:00 PM" -DaysInterval 1
Register-ScheduledJob -Name DiskSpaceCheck -ScriptBlock $ScriptBlock -Trigger $diskMonitorTrigger