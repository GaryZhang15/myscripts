#import SQL Server module
Import-Module SQLPS -DisableNameChecking

#replace this with your instance name
$instanceName = "data2"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#specify folder and filename to be produced
$folder = "C:\Temp"
$currdate = Get-Date -Format "yyyy-MM-dd_hmmtt"
$filename = "$($instanceName)_InstanceInventory_$($currdate).csv"
$fullpath = Join-Path $folder $filename

#export all “server” object properties
#note we are using V3 simplified Where-Object syntax

$server | Get-Member | Where-Object Name -ne "SystemMessages" | Where-Object MemberType -eq "Property" |
          Select Name, @{Name="Value";Expression={$server.($_.Name)}} |
          Export-Csv -Path $fullpath -NoTypeInformation

#jobs are also extremely important to monitor, archive
#export all job names + last run date and result
$server.JobServer.Jobs | Select @{Name="Name";Expression={"Job: $($_.Name)"}},
 @{Name="Value";Expression={"Last run: $($_.LastRunDate)
($($_.LastRunOutcome))" }} | Export-Csv -Path $fullpath -NoTypeInformation -Append

#show file in explorer
explorer $folder