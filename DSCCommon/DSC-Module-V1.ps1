configuration modulefile
{
    Param(
        $SourceCred
    )

    node $AllNodes.NodeName
    {
        File xModule
        {
        Ensure = "Present"
        SourcePath = "\\10.1.1.20\DSCResources\Modules"
        DestinationPath = "C:\Program Files\WindowsPowerShell\Modules" 
        Credential = $SourceCred
        Recurse = $true       
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
         }
        @{
            NodeName="10.1.1.81"
         }
        @{
            NodeName="10.1.1.82"
         }
        @{
            NodeName="10.1.1.83"
         }
        @{
            NodeName="10.1.1.84"
         }
    )
}


# fill the params in configuration
$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

#cred for cim session on target node
$username = "administrator"
$userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
$usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

#new cim session on target node
$cim = New-CimSession -ComputerName 10.1.1.81,10.1.1.82,10.1.1.83,10.1.1.84 -Credential $usercred

#run the configure to generate mof
modulefile -ConfigurationData $ConfigurationData  -SourceCred $Cred

Get-DscConfiguration -CimSession $cim -Verbose

Start-DscConfiguration -Path .\modulefile -Wait -Verbose -CimSession $cim

Test-DscConfiguration -CimSession $cim -Verbose