$ScriptBlock = {

    if (Test-Path "$env:SystemDrive\MonitoringLogs")
        {
           Write-Verbose "Monitoring log folder found!"  
        }
    else
        {
           mkdir  "$env:SystemDrive\MonitoringLogs"
        }

    $phoneList = @(
        @{
            Short = '13774352755'
            Long = '24206861771469171'
            Carrier = 'China Mobile'
            Owner = 'Tony'
        },
        @{
            Short = '18602166477'
            Long = '24206866599282893'
            Carrier = 'China Unicom'
            Owner = 'Gary'
        },
        @{
            Short = '18650107956'
            Long = '24206866647224372'
            Carrier = 'China Unicom'
            Owner = 'Yuhua'
        }        
        )
    
    $json = 
    '{
        "AppId":"00000000000000000000000000000000",
        "CorporationId":"00000000000000000000000000000000",
        "UserId":"00000000000000000000000000000000",
        "PhoneNumber":"longNumber",
        "Text":"iOffice SMS availability test message, Please ignore.",
        "DeliveryStrategy":258
     }'

    for ($i = 0; $i -lt $phoneList.Count; $i++)
    { 
        $postJson = $json.replace('longNumber',"$($phoneList[$i].Long)")
        $response = Invoke-WebRequest -Uri http://g.ioffice100.net/smshub/textmessages/create -ContentType application/json -Body $postJson -Method Post
        $response.Content | ConvertFrom-Json | select -ExpandProperty smstextmessage | 
             Export-Csv "$env:SystemDrive\MonitoringLogs\SmsTestLog.csv" `
                   -NoTypeInformation -Append -Encoding UTF8
    }

}

$smsAvailableCheckTrigger = New-JobTrigger -Daily -At "10:00 AM" -DaysInterval 2
Register-ScheduledJob -Name SmsAvailableCheck -ScriptBlock $ScriptBlock -Trigger $smsAvailableCheckTrigger