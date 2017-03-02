$ScriptBlock = {
    Import-Module -Name sqlps -DisableNameChecking
    $instancename = 'YPDB01'
    $corpSubscriptions = Invoke-SqlCmd -Query "
                          SELECT Id,Name,ContractState,ContractNumber,OPContacts,OPPhoneNumber,RemainDays,CorpCreatedTime
                          FROM GlobalOperationDB.dbo.Corporations
                          WHERE ContractState = N'确认收款' AND RemainDays <= 45" `
                          -ServerInstance $instancename -Username 'blueoffice' -Password 'blueoffice'
    for ($i = 0; $i -lt $corpSubscriptions.Count; $i++){
        $SalesId = Invoke-SqlCmd -Query "
                    SELECT [UserId]
                    FROM [GlobalOperationDB].[dbo].[UserCorporations]
                    WHERE CorporationId = N'$($corpSubscriptions[$i].Id.Guid)'"`
                -Username 'blueoffice' -Password 'blueoffice'`
                -ServerInstance $instancename
        $SalesName = Invoke-SqlCmd -Query "
                    SELECT Name
                    FROM CorporationYipinapp.dbo.DIR_Accounts
                    WHERE UserId = N'$($SalesId.UserId.Guid)'" `
                -Username 'blueoffice' -Password 'blueoffice'`
                -ServerInstance $instancename
        
        $props = [ordered]@{ 'CorpName'= $corpSubscriptions[$i].Name;
                             'ContractState'= $corpSubscriptions[$i].ContractState;
                             'Contact' = $corpSubscriptions[$i].OPContacts;
                             'PhoneNumber' = $corpSubscriptions[$i].OPPhoneNumber;
                             'CreatedDate' = $corpSubscriptions[$i].CorpCreatedTime;
                             'RemainDays' = $corpSubscriptions[$i].RemainDays;
                             'SalesName' = $SalesName.Name
                        }
        $obj = New-Object -TypeName psobject -Property $props
        
        $obj | Export-Csv "c:\MonitoringLogs\checkPaidSubscription-$(Get-Date -Format yyyy'-'MM'-'dd).csv" -NoTypeInformation -Append -Encoding UTF8 
    } 
    Send-MailMessage -From subscriptioncheck@yipinapp.com `
                 -To "kellyjiang@yipinapp.com" `
                 -Cc "tonyxia@yipinapp.com","owenyu@yipinapp.com","garyzhang@yipinapp.com"`
                 -Subject "Paid Subscriptions that will be expired in the next 45 days"  `
                 -Body "Please check the attachment for more details" `
                 -BodyAsHtml `
                 -Attachments "c:\MonitoringLogs\checkPaidSubscription-$(Get-Date -Format yyyy'-'MM'-'dd).csv" `
                 -SmtpServer mail.ioffice100.com                                               
}

$subsCheckTrigger = New-JobTrigger -Weekly -At "08:00 AM" -DaysOfWeek Thursday
Register-ScheduledJob -Name PaidSubscriptionCheck -ScriptBlock $ScriptBlock -Trigger $subsCheckTrigger