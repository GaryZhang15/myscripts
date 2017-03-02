Get-BOSubscription
<#
    Output Object
    ============
    TypeName: Selected.System.Management.Automation.PSCustomObject

    Paramenter
    ============
    -CorporationId [<String[]>]
    -Name [<String>]
    -DaysToBeExpired [<DateTime>]
#>

Set-BOSubscription
<#
    Input Object
    ============
    TypeName: Selected.System.Management.Automation.PSCustomObject

    Paramenter
    ============
    -CorporationId [<String[]>]
    -Name [<String>]
    -LicenseCount [<Int32>]
    -LicenseName [<String[]>]
    -ExpirationDate [<DateTime>]
#>

#Example 1
PS C:\> Get-BOSubscription -CorporationId 72F0C87C-AB1B-4F76-0000-000000000000 | Set-BOSubscription -LicenseCount 25

#Example 2
PS C:\> Get-BOSubscription -DaysToBeExpired 2016/2/1 | Where name -EQ 'Default' | Set-BOSubscription -ExpirationDate 2016/5/31