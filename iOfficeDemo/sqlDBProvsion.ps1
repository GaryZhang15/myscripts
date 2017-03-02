#creat DB and initia DB schema
#import SQL Server moduleImport-Module SQLPS -DisableNameChecking#replace this with your instance name$instanceName = hostname$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#database TestDB with default settings#assumption is that this database does not yet exist$dbName = "GlobalBlueOffice","DocumentConversion","GlobalDirectory","CommonCorporationDB","CommonO365CorporationDB"foreach ($dbN in $dbName)
{
    $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbN)    $db.Create()   
}#to confirm, list databases in your instance$server.Databases |Select Name, Status, Owner, CreateDate


#execute the SampleScript.sql, and display results to screenInvoke-SqlCmd `    -InputFile "C:\Resources\DBprovision\CorporationDBSchema.sql" `    -ServerInstance "$instanceName" `    -Database "CommonCorporationDB" Invoke-SqlCmd `    -InputFile "C:\Resources\DBprovision\CorporationDBSchema.sql" `    -ServerInstance "$instanceName" `    -Database "CommonO365CorporationDB" Invoke-SqlCmd `    -InputFile "C:\Resources\DBprovision\GlobalBlueOffice81.sql" `    -ServerInstance "$instanceName" `    -Database "GlobalBlueOffice" Invoke-SqlCmd `    -InputFile "C:\Resources\DBprovision\GlobalDirectory81.sql" `    -ServerInstance "$instanceName" `    -Database "GlobalDirectory" Invoke-SqlCmd `    -InputFile "C:\Resources\DBprovision\DocumentConversionDBSchema.sql" `    -ServerInstance "$instanceName" `    -Database "DocumentConversion"     #|#Select FirstName, LastName, ModifiedDate |#Format-Table