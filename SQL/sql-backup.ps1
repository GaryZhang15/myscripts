#import sql module
Import-Module -Name SQLPS -DisableNameChecking

$instanceName = "MSSQLSERVER"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databasename = "GlobalBlueOffice"
$database = $server.Databases[$databasename]

#possible values for recovrty model are Full, Simple and BulkLogged

$database.DatabaseOptions.RecoveryModel = [Microsoft.SqlServer.Management.Smo.RecoveryModel]::Simple
$database.Alter()
$database.Refresh()

