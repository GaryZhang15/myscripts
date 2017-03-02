$ScriptBlock = {
#Check Log path
if (Test-Path "$env:SystemDrive\MonitoringLogs")
    {
        Write-Verbose "Monitoring log folder found!"}
else
    {
        mkdir  "$env:SystemDrive\MonitoringLogs"}

#O365 API DNS Names
$domain1 = 'api.office.com'
$domain2 = 'graph.windows.net'
$domain3 = 'login.windows.net'
$domain4 = 'login.chinacloudapi.cn'

#Get content of current hosts file and select lines that contain the domain name
$catHost = cat $env:SystemRoot\System32\drivers\etc\hosts
$line1 = $catHost | Select-String -SimpleMatch $domain1
$line2 = $catHost | Select-String -SimpleMatch $domain2
$line3 = $catHost | Select-String -SimpleMatch $domain3
$line4 = $catHost | Select-String -SimpleMatch $domain4

#if any of the domain name not exists in the hosts file, write error and stop processing
if($line1 -eq $null -or $line2 -eq $null -or $line3 -eq $null -or $line4 -eq $null)
    {
        Write-Output "[$(get-date)]One of the domain names could not be found in the original host file!" | 
        Out-File C:\MonitoringLogs\O365DNSMonitor.txt -Append unicode}
else{
        #Get new A records for the DNS name
        $add1 = Resolve-DnsName -Name api.office.com -Type A -NoHostsFile -Server 114.114.114.114 -DnsOnly -ErrorAction Stop |
                Select-Object -Last 1 | Select-Object IPAddress
        $add2 = Resolve-DnsName -Name graph.windows.net -Type A -NoHostsFile -Server 114.114.114.114 -DnsOnly -ErrorAction Stop | 
                Select-Object -Last 1 | Select-Object -Property IPAddress
        $add3 = Resolve-DnsName -Name login.windows.net -Type A -NoHostsFile -Server 114.114.114.114 -DnsOnly -ErrorAction Stop | 
                Select-Object -Last 1 | Select-Object -Property IPAddress
        $add4 = Resolve-DnsName -Name login.chinacloudapi.cn -Type A -NoHostsFile -Server 114.114.114.114 -DnsOnly -ErrorAction Stop | 
                Select-Object -Last 1 | Select-Object -Property IPAddress
        
        #compose new line to replace the hosts file
        $newline1 = $add1.IPAddress + '  ' + $domain1
        $newline2 = $add2.IPAddress + '  ' + $domain2
        $newline3 = $add3.IPAddress + '  ' + $domain3
        $newline4 = $add4.IPAddress + '  ' + $domain4
        
        $newhost =$catHost.Replace($line1.ToString(),$newline1).
                           Replace($line2.ToString(),$newline2).
                           Replace($line3.ToString(),$newline3).
                           Replace($line4.ToString(),$newline4)
        
        #Out put the new content to hosts file location
        $newhost | Out-File $env:SystemRoot\System32\drivers\etc\hosts -Encoding unicode
        Write-Output "[$(get-date)]Successfully updated O365 DNS A records into hosts file!" |
        Out-File C:\MonitoringLogs\O365DNSMonitor.txt -Append unicode}
}

$o365DNSMonitorTrigger = New-JobTrigger -Daily -At "1:00 AM" -DaysInterval 1
Register-ScheduledJob -Name O365DNSMonitor -ScriptBlock $ScriptBlock -Trigger $o365DNSMonitorTrigger