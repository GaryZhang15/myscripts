﻿#creat DB and initia DB schema
#import SQL Server module

#database TestDB with default settings
{
    $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbN)
}


#execute the SampleScript.sql, and display results to screen