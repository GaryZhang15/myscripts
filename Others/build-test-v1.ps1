#start powershell logging
# initialize variables

    $date = get-date -Format yyyy'-'MM'-'dd
    $pathtest = Test-Path C:\PS_transcript
    $filetest = Test-Path C:\PS_transcript\ps-$date.txt

function pstranscript
{
    New-Item -Path C:\PS_transcript -Name ps-$date.txt -ItemType file 
}

if ($filetest -eq $true)
{
    # Write-Host "You have some old transcript log files do you wish to delete them ?"
    # Remove-Item C:\PS_transcript\*.* -Confirm
    Start-Transcript -Path C:\PS_transcript\ps-$date.txt -Append -NoClobber
}
elseif($pathtest -eq $true -and $filetest -eq $false)
{
    pstranscript
    Start-Transcript -Path C:\PS_transcript\ps-$date.txt -Append -NoClobber
}
else
{
    mkdir   C:\PS_transcript
    pstranscript
    Start-Transcript -Path C:\PS_transcript\ps-$date.txt -Append -NoClobber
}

#call the function
pstranscript

#region DSC Configuration w/Configuration Data Snippet
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword=$true
            WebsiteName = "iOffice"
            WebAppPoolName = "iOffice"
         }

        @{
            NodeName="10.1.1.82"
            Role = "Web"
         }
    )
}

# Have a seperate configuration for each deployment environment
#$TestConfig = @{}
#$ProductionConfig = @{}

configuration MyConfiguration
{
    Param(
        $SourcePath,
        $SourceCred
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration 
    node $AllNodes.NodeName
    {
        File WebsitesFolder
        {
            Ensure = "Present"
            DestinationPath = 'C:\BuildWebSiteTest'
            Type = "Directory"
         }

        #copy iOffice web app content into C:\BuildWebSiteTest folder
        File WebAppContents
        {
            Ensure = "Present"
            SourcePath = $SourcePath
            DestinationPath = 'C:\BuildWebSiteTest\'
            Credential = $SourceCred
            Recurse = $true
            DependsOn = "[File]WebsitesFolder"
         }
    }
}

#MyConfiguration -ConfigurationData $DevConfig
#endregion

# fill the params in configuration
$SourcePath = "\\10.1.1.20\Gary\Build\BOTestBuild\BOTestBuild_20150907.7\_PublishedWebsites\OfficialWebSite"

#cred for cim session on target node
$username = "administrator"
$userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
$usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

#sourece credential
$SourceUser = 'uumobile\garyzhang'
$SourcePass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

#new cim session on target node
$webcim = New-CimSession -ComputerName 10.1.1.82 -Credential $usercred

#run the configure to generate mof
WebFile -ConfigurationData $ConfigurationData -SourcePath $SourcePath -SourceCred $Cred -OutputPath c:\DSCTestOnly

#start-dscconfigure
Start-DscConfiguration -Path c:\DSCTestOnly\WebFile -Wait -Verbose -CimSession $webcim