# ****modify the instance name and folder name before run the script****

#import SQL Server module
Import-Module SQLPS -DisableNameChecking

#replace this with your instance name
$instanceName = "Data2"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#specify folder and filename to be produced 
$folder = "C:\Temp"
$currdate = Get-Date -Format "yyyy-MM-dd_hmmtt"
$filename = "$($instanceName)_DatabaseInventory_$($currdate).csv"
$fullpath = Join-Path $folder $filename
$result = @()

#get properties of all databases in instance
foreach ($db in $server.Databases)
{
     $item = $null
     #capture info you want to capture into a hash
     #the hash will make it easier to export to CSV
     $hash = @{
                 "DatabaseName" = $db.Name
                 "CreateDate" = $db.CreateDate
                 "Owner" = $db.Owner
                 "RecoveryModel" = $db.RecoveryModel
                 "SizeMB" = $db.Size
                 "DataSpaceUsage" = ($db.DataSpaceUsage/1MB).ToString("0.00")
                 "IndexSpaceUsage" = ($db.IndexSpaceUsage/1MB).ToString("0.00")
                 "Collation" = $db.Collation
                 "Users" = (($db.Users | Foreach {$_.Name}) -join ",")
                 "UserCount" = $db.Users.Count
                 "TableCount" = $db.Tables.Count
                 "SPCount" = $db.StoredProcedures.Count
                 "UDFCount" = $db.UserDefinedFunctions.Count
                 "ViewCount" = $db.Views.Count
                 "TriggerCount" = $db.Triggers.Count
                 "LastBackupDate" = $db.LastBackupDate
                 "LastDiffBackupDate" = $db.LastDifferentialBackupDate
                 "LastLogBackupDate" = $db.LastBackupDate
               }
     #create a new "row" and add to the results array
     $item = New-Object PSObject -Property $hash
     $result += $item
}

#export result to CSV
#note CSV can be opened in Excel, which is handy
$result | Select DatabaseName, CreateDate, Owner, RecoveryModel,SizeMB, DataSpaceUsage, IndexSpaceUsage, Collation, UserCount,
                 TableCount, SPCount, ViewCount, TriggerCount, LastBackupDate,
                 LastDiffBackupDate, LastLogBackupDate, Users |
          Export-Csv -Path $fullpath -NoTypeInformation

#view folder
explorer $folder