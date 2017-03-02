$ScriptBlock = {
if (Test-Path "$env:SystemDrive\MonitoringLogs")
{
   Write-Verbose "Monitoring log folder found!"  
}
else
{
   mkdir  "$env:SystemDrive\MonitoringLogs"
}

Invoke-WebRequest -Uri http://g.ioffice100.net/smshub/smsproviders/refreshbalance -Method Post

$webResponse = Invoke-WebRequest -Uri http://g.ioffice100.net/smshub/smsproviders -Method Get

$webResponse.Content | ConvertFrom-Json | 
                       Select-Object -ExpandProperty SmsProviderInfos |
                       Where-Object IsAvailable -eq True |
                       Select-Object Id,
                                     @{l= 'Providers';e={$_.ClassName -replace 'Collaboration.SmsHub.Providers.','' }},
                                     Cost,
                                     Speed,
                                     Balance,
                                     @{l='CheckTime';e={get-date -Format yyyy'-'MM'-'dd}} |
                        Export-Csv "$env:SystemDrive\MonitoringLogs\SmsBalanceLog.csv" `
                                    -NoTypeInformation -Append -Encoding UTF8
[array]$json = $webResponse.Content | ConvertFrom-Json | Select-Object -ExpandProperty SmsProviderInfos

for ($i = 0; $i -lt $json.Count; $i++)
{ 
    #check you logic
    if ($json[$i].IsAvailable -and $json[$i].Balance -lt 500)
    {
       $html=( $json[$i] | Select-Object Id,
                      @{l= 'Providers';e={$_.ClassName -replace 'Collaboration.SmsHub.Providers.','' }},
                      Cost,
                      Speed,
                      @{l='Balance';e={"{0:N0}" -f $_.Balance}},
                      @{l='CheckTime';e={get-date -Format yyyy'-'MM'-'dd}} | ConvertTo-Html) -replace '<table>','<table  border="1">'
        Send-MailMessage -From SmsBalanceMonitor@yipinapp.com `
                                     -to "garyzhang@yipinapp.com" `
                                     -Subject "Sms Balance Warning, Less than 500 SMSs!"  `
                                     -Body "$html" `
                                     -BodyAsHtml `
                                     -SmtpServer mail.yipinapp.com
    }
    else
    {
        Write-Verbose "Balance are above 500!"
    }
    
}
}

$smsBalanceCheckTrigger = New-JobTrigger -Daily -At "9:00 AM" -DaysInterval 1
Register-ScheduledJob -Name SmsBalanceCheck -ScriptBlock $ScriptBlock -Trigger $smsBalanceCheckTrigger

