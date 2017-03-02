#import SQL module
Import-Module SQLPS -DisableNameChecking

$instance = hostname #*****>>replace<<*****
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server  -ArgumentList $instance

$loginName = "brand" #*****>>replace<<*****

# drop login if it existsif ($server.Logins.Contains($loginName)){   $server.Logins[$loginName].Drop()}$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $loginName$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin$login.PasswordExpirationEnabled = $false# prompt for password$pw = ConvertTo-SecureString -String "Abc123!" -AsPlainText -Force$login.Create($pw)#assign server level roles$login = $server.Logins[$loginName]$login.AddToRole("dbcreator")$login.AddToRole("sysadmin")$login.Alter()#grant server level permissions$permissionset = New-Object Microsoft.SqlServer.Management.Smo.ServerPermissionSet([Microsoft.SqlServer.Management.Smo.ServerPermission]::AlterAnyDatabase)$permissionset.Add([Microsoft.SqlServer.Management.Smo.ServerPermission]::AlterSettings)$server.Grant($permissionset, $loginName)#confirm server roles$login.ListMembers()#confirm permissions#$server.EnumServerPermissions($loginName) | Select Grantee, PermissionType, PermissionState | Format-Table -AutoSize#change authentication mode to Mixed$server.settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed$server.Alter()$server.Refresh()