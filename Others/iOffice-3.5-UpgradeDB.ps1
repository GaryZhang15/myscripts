<#Import-Module -Name SQLPS -DisableNameChecking -Verbose

$SQLScriptPath = "$($env:userprofile)\desktop\35Upgrade"
$ServerName = '10.1.1.84'
$username = 'sa'
$Password = '1qaz!QAZ'
#>

function Upgrade-DB
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$ServerName,
        [String]$SQLScriptPath,
        [String]$username,
        [String]$Password
    )


    {
        Import-Module -Name SQLPS -DisableNameChecking -Verbose

        Write-Verbose "Executing Step 1. 升级GlobalBlueOffice数据库, Using：GlobalBlueOfficeDbUpgradScript.sql"
        Invoke-Sqlcmd -ServerInstance $ServerName -Username $username -Password $Password -InputFile "$SQLScriptPath\GlobalBlueOfficeDbUpgradScript.sql" -Verbose
        
        Write-Verbose "Executing Step 2. 升级GlobalDirectory数据库：GlobalDirectoryDbUpgradScript.sql(包含初始化默认Plan/License)"
        Invoke-Sqlcmd -ServerInstance $ServerName -Username $username -Password $Password -InputFile "$SQLScriptPath\GlobalDirectoryDbUpgradScript.sql" -Verbose
        
        Write-Verbose "Executing step 3. 初始化GlobalDirectory中的ReadableId:InitializeReadableId.sql(包含check运行完后是否有重复的ReadableId)"
        Invoke-Sqlcmd -ServerInstance $ServerName -Username $username -Password $Password -InputFile "$SQLScriptPath\InitializeReadableId.sql" -Verbose -QueryTimeout 0
        
        Write-Verbose "Executing step 4. 升级CorporationDB:ScriptsForAllCorporations.sql"
        Invoke-Sqlcmd -ServerInstance $ServerName -Username $username -Password $Password -InputFile "$SQLScriptPath\ScriptsForAllCorporations.sql" -Verbose
        
        Write-Verbose "Executing step 5. 升级OperationSite的数据库:OperationDBUpgradeScript.sql"
        Invoke-Sqlcmd -ServerInstance $ServerName -Username $username -Password $Password -InputFile "$SQLScriptPath\OperationDBUpgradeScript.sql" -Verbose
        
    }

}