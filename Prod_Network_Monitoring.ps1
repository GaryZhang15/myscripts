# remove script block code block if you want to run the job manually in ISE
$ScriptBlock = {
# IP and Url list
[array]$domainlist = @(
    'bocorp.yipinapp.net',
	'bocorp.ioffice100.net',
	'bonotification.yipinapp.net',
	'p.ioffice100.com',
	'qr.ioffice100.com',
	'qr.ioffice100.net',
	'global.ioffice100.net',
	'boglobal.yipinapp.net',
	'globalbo.ioffice100.net',
	'g.ioffice100.net',
	'www.baidu.com'
    #'nosuchthing.lab'
    #'103.36.132.178', #co01
    #'103.20.251.10', #co01
    #'103.20.251.45', #exchange
    #'103.20.251.48', #co02
    #'103.36.132.177' #co02
    )

#ping echo request for baidu to test local network connectivity
$localnetwork = Test-NetConnection -ComputerName www.baidu.com

#test connectivity
$results = @()
[bool]$sendmail = $false

if($localnetwork.PingSucceeded){
    $results = $domainlist | Test-NetConnection
}
else{
    Write-Verbose 'Local Internet Connectivity Issue'
}

#make sure local folder path exists and if formal ProdNetworkMonitor_Failed.csv exist then rename and remove it
if(Test-Path C:\PSLabs){
    Write-Verbose 'C:\PSLabs folder path exists' 
    if (Test-Path C:\PSLabs\ProdNetworkMonitor_Failed.csv)
    {
        $formalFileCreateDate = Get-ItemProperty C:\PSLabs\ProdNetworkMonitor_Failed.csv | select CreationTime
        $newFileName = Join-Path 'C:\PSLabs' -ChildPath "ProdNetworkMonitor_Failed_$($formalFileCreateDate.CreationTime.ToFileTime()).csv"
        Copy-Item 'C:\PSLabs\ProdNetworkMonitor_Failed.csv' -Destination $newFileName
        Remove-Item 'C:\PSLabs\ProdNetworkMonitor_Failed.csv' -Force -Verbose
    }
}
else{
    mkdir C:\PSLabs
}

#collect ping result and append to 'C:\PSLabs\ProdNetworkMonitor.csv'
foreach ($r in $results)
{
    $r | select Computername,
                RemoteAddress,
                InterfaceAlias,
                @{l = 'SourceAddress'; e= {$_.SourceAddress}},
                PingSucceeded,
                @{l = 'TTR (ms)'; e = {$_.PingReplyDetails.RoundtripTime}},
                @{l = 'Date'; e = {Get-Date -Format yyyy'/'MM'/'dd' 'HH':'mm':'ss}}|
                Export-Csv -Encoding UTF8 -Append -Path C:\PSLabs\ProdNetworkMonitor.csv -NoTypeInformation
    #if ping failed the create 'C:\PSLabs\ProdNetworkMonitor_Failed.csv' to collect the details
    if ($r.PingSucceeded -ne $true)
    {
        $r | select Computername,
                RemoteAddress,
                InterfaceAlias,
                @{l = 'SourceAddress'; e= {$_.SourceAddress}},
                PingSucceeded,
                @{l = 'TTR (ms)'; e = {$_.PingReplyDetails.RoundtripTime}},
                @{l = 'Date'; e = {Get-Date -Format yyyy'/'MM'/'dd' 'HH':'mm':'ss}} |
                Export-Csv -Encoding UTF8 -Append -Path C:\PSLabs\ProdNetworkMonitor_Failed.csv -NoTypeInformation
        $sendmail = $true
    }
    else
    {
        Out-Null
    }
}

#send mail to live.cn and yipinapp.com mailbox
if($sendmail){
    $cred = New-Object -TypeName System.Management.Automation.PSCredential `
        -ArgumentList ('noreply@m2.suibanapp.com'),(ConvertTo-SecureString -AsPlainText 'q1w2e3Q!W@E#' -Force) 

    Send-MailMessage -Attachments C:\PSLabs\ProdNetworkMonitor_Failed.csv -SmtpServer smtp.partner.outlook.cn `
    -UseSsl -From 'noreply@m2.suibanapp.com' -To 'lionzhang@live.cn' -Cc 'garyzhang@yipinapp.com' `
    -Body 'One or more service are not responding ping request! Please check attachement for details' `
    -Port 587 -BodyAsHtml -Subject 'iOffice Production Possible Network Issue' -Credential $cred
}
}
$trigger = New-JobTrigger -Once -At "07/22/2016 4pm" -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name ProdNetworkMonitor -ScriptBlock $ScriptBlock -Trigger $trigger