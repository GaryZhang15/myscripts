﻿#import SQL module
Import-Module SQLPS -DisableNameChecking

$instance = hostname #*****>>replace<<*****
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server  -ArgumentList $instance

$loginName = "brand" #*****>>replace<<*****

# drop login if it exists