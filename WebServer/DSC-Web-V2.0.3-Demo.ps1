<#
.Synopsis
   This Cmdlet will help deploying your Web app or Website into your desired environment.
.DESCRIPTION
   This Cmdlet will help you automatically configure your Test, Staging, Production environment.
   You should run this Cmdlet after you have successfully built your projects.
   
.EXAMPLE
   Start-Deployment -Environment Prod -BuildDefinition Production -Version 8.0.1 -WebApp Website
   This example will deploy build version 8.0.1 of website into Production environment.
.EXAMPLE
   Start-Deployment -Environment Test -BuildDefinition test -Version 20150908.4  -WebApp allapps -SendEmail
   This example will deploy build version 20150908.4 of all webapps into test environment and send out notification emails.
.EXAMPLE
   Start-Deployment -Environment Prod -BuildDefinition Production -Version 8.0.1 -WebApp ln,ih. -SendEmail 'My build of projects LN and IH'
   This example  will deploy build version 8.0.1 of webapp lh,ih into Prod environment and send out comments with emails.
.INPUTS
   You need to input the required paramaters.
.OUTPUTS
   If Cmdlet by default will not generate OUTPUTS, if you want to send out emails you can use 'SendEmail' switch paramater.
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to is YIPIN-DSC.
.ROLE
   The role this cmdlet belongs to is normal user.
.FUNCTIONALITY
   Automatically deploy your Test, Staging, Production environment.
#>

<# ***update log ***
 9-10-2015 v2.0.3
 1. add env var to send email function 
 2. set param Environment to string type

   ***To do list ***
 1. if powershell not running as admin it will return error, access issue with c:\DSCDeploy\IISWebsite
 2. Send email if error occurs, return envent log as attachment
 3. Make this into a PS profile or Module, and automated copy the needed file and modules
 4. Make change to copy only the needed  webapp content into IIS server
 5. Rollbackable paramater
 6. Make Test and Prod DSC configuration into different config function
 7. Web App project name updates, webapp physical path

#>

function Start-Deployment {

[CmdletBinding()]

    Param(
        # verify if the deployment of website is successful
        [switch]$Verify,
        
        # specify the BuildDefinition, which you have trigger from Build server
        [Parameter(Mandatory=$true)]
        [ValidateSet("OfficialWebSite","GlobalBlueOffice","DocumentsConversion","GlobalDirectory")]
        [String]$BuildDefinition,
        
        # specify which version you need to deploy
        [Parameter(Mandatory=$true)]
        [String]$Version,

        # specify which environment you need to deploy to, valid environments are "Test", "Staging", "Prod"
        [Parameter(Mandatory=$true)]
        [ValidateSet("Test", "Staging", "Prod")]
        [Alias("Env")] 
        [String]$Environment,

        # Switch paramater to SendEmail to you and the stakeholders
        # I want to make this into a comment, which will let runner to inputs the notes
        [switch]$SendEmail,

        # specify which web app or site you would like to deploy
        [Parameter(Mandatory=$true)]
        [ValidateSet('dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp',
                     'nb','tt','tfp','tf','wwp','ww','an','ah','cg','cs','dirp','dir','ih','p','pl','dcc','dce')]

        #newlist
        <#
            'bo','dcp','dc','fgp','fg','gbo','lvp','lv','mgmt','mrp','mr','mg','nbp','nb','website','ttp',            'tt','tfp','tf','wwp','ww','an','ah','cg','cs','dirp','dir','gds','ih','p','pl','vh','dsp','diag','cpp','cp','op','vap','va'
        #>

        # in production
        <#
            'dsp','bo','fgp','fg','lv','mrp','mr','mg','nbp','nb','tt','tfp','tf','wwp','ww','an','ah','cg','cs','dirp','dir','ih','p','pl','dcc','dce'
        
        #>

        # orginal list
        <#
            "an","bo","cg","cs","dc","dir","dirp","fg","gbo","gds","ih","lv",
            "mg","mgmt","mr","mrp","nb","nbp","op","p","pl","tf","tt","website","ww"
        #>
        [String[]]$WebApp

        )

    Begin
        {
            $SourcePath = '\\10.1.1.9\DropFolder\' + $BuildDefinition + '\' + $BuildDefinition  + '_' + $Version + '\_PublishedWebsites'

            if ($Environment -eq 'Test') {
                $dscEnv = '10.1.1.87'
                Write-Verbose -Message "Delpoyment will be targeted on Test Env Server: 10.1.1.87"
            }
            elseif ($Environment -eq 'Staging') {
                $dscEnv = '10.1.1.88'
                Write-Verbose -Message "Delpoyment will be targeted on Staging Env Server: 10.1.1.88"
            }
            elseif ($Environment -eq 'Prod'){
                $dscEnv = '10.1.1.89'
                Write-Verbose -Message "Delpoyment will be targeted on Test Env Server: 10.1.1.89"
            }
            else{
                
                Write-Warning -Message 'You need to provide a valid env name!'
            } # set DSCEnv to user desired env

         $ConfigurationData = @{
            AllNodes = @(
       
                @{
                    NodeName="*"
                    PSDscAllowPlainTextPassword=$true
                    WebsiteName = "iOffice"
                    WebAppPoolName = "iOffice"
                 }
                @{
                    NodeName= $dscEnv # vm test1
                 }
            )
        }# end of ConfigurationData section

        $webapps = @{

            allapps = @(
                        @{  
                            name = "an"	
                            Physicalpath = "C:\Websites\iOffice\AggregatedNotification"
                            ProjectName  = "AggregatedNotification"}

                        @{  
                            name = "bo"	
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeService"
                            ProjectName  = "BlueOfficeService"}

                        @{
                            name = "cg"
  	                        Physicalpath = "C:\Websites\iOffice\CalendarGridService"
                            ProjectName  = "CalendarGridService"}

                        @{
                            name = "cs"	
                            Physicalpath = "C:\Websites\iOffice\ConchShellService"
                            ProjectName  = "ConchShellService"}

                        @{
                            name = "dc"	
                            Physicalpath = "C:\Websites\iOffice\DataCubeService"
                            ProjectName  = "DataCubeService"}

                        @{
                            name = "dir"	
                            Physicalpath = "C:\Websites\iOffice\DirectoryService"
                            ProjectName  = "DirectoryService"}

                        @{
                            name = "dirp"	
                            Physicalpath = "C:\Websites\iOffice\DirectoryPortal"
                            ProjectName  = "DirectoryPortal"}

                        @{
                            name = "fg"	
                            Physicalpath = "C:\Websites\iOffice\FootprintGraphService"
                            ProjectName  = "FootprintGraphService"}

                        @{
                            name = "gbo"	
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeGlobalBlueOffice"
                            ProjectName  = "BlueOfficeGlobalBlueOffice"}

                        @{
                            name = "gds"	
                            Physicalpath = "C:\Websites\iOffice\GlobalDirectoryService"
                            ProjectName  = "GlobalDirectoryService"}

                        @{
                            name = "ih"	
                            Physicalpath = "C:\Websites\iOffice\ImageHub"
                            ProjectName  = "ImageHub"}

                        @{
                            name = "lv"	
                            Physicalpath = "C:\Websites\iOffice\LiveVoteService"
                            ProjectName  = "LiveVoteService"}

                        @{
                            name = "mg"	
                            Physicalpath = "C:\Websites\iOffice\MomentGardenService"
                            ProjectName  = "MomentGardenService"}

                        @{
                            name = "mgmt"	
                            Physicalpath = "C:\Websites\iOffice\Management"
                            ProjectName  = "Management"}

                        @{
                            name = "mr"	
                            Physicalpath = "C:\Websites\iOffice\MindRadarService"
                            ProjectName  = "MindRadarService"}

                        @{
                            name = "mrp"	
                            Physicalpath = "C:\Websites\iOffice\MindRadarPortal"
                            ProjectName  = "MindRadarPortal"}

                        @{
                            name = "nb"	
                            Physicalpath = "C:\Websites\iOffice\NewsBoardService"
                            ProjectName  = "NewsBoardService"}

                        @{
                            name = "nbp"	
                            Physicalpath = "C:\Websites\iOffice\NewsBoardPortal"
                            ProjectName  = "NewsBoardPortal"}

                        @{
                            name = "op"	
                            Physicalpath = "C:\Websites\iOffice\OperationPortal"
                            ProjectName  = "OperationPortal"}

                        @{
                            name = "p"	
                            Physicalpath = "C:\Websites\iOffice\Portal"
                            ProjectName  = "Portal"}

                        @{
                            name = "pl"	
                            Physicalpath = "C:\Websites\iOffice\PortalLogger"
                            ProjectName  = "PortalLogger"}

                        @{
                            name = "tf"	
                            Physicalpath = "C:\Websites\iOffice\TaskForceService"
                            ProjectName  = "TaskForceService"}

                        @{
                            name = "tt"	
                            Physicalpath = "C:\Websites\iOffice\TalkTimeService"
                            ProjectName  = "TalkTimeService"}

                        @{
                            name = "website"	
                            Physicalpath = "C:\Websites\iOffice\OfficialWebSite"
                            ProjectName  = "OfficialWebSite"}

                        @{
                            name = "ww"	
                            Physicalpath = "C:\Websites\iOffice\WishingWellService"
                            ProjectName  = "WishingWellService"}
                        @{
                            name = "dsp"	
                            Physicalpath = "C:\Websites\iOffice\BlueOfficeDataStatisticsPortal"
                            ProjectName  = "BlueOfficeDataStatisticsPortal"}
                        @{
                            name = "fgp"	
                            Physicalpath = "C:\Websites\iOffice\FootprintGraphPortal"
                            ProjectName  = "FootprintGraphPortal"}
                        @{
                            name = "tfp"	
                            Physicalpath = "C:\Websites\iOffice\TaskForcePortal"
                            ProjectName  = "TaskForcePortal"}
                        @{
                            name = "wwp"	
                            Physicalpath = "C:\Websites\iOffice\WishingWellPortal"
                            ProjectName  = "WishingWellPortal"}
                        @{
                            name = "ah"	
                            Physicalpath = "C:\Websites\iOffice\AudioHub"
                            ProjectName  = "AudioHub"}
                        @{
                            name = "vh"	
                            Physicalpath = "C:\Websites\iOffice\VideoHub"
                            ProjectName  = "VideoHub"}
                        @{
                            name = "dcc"	
                            Physicalpath = "C:\Websites\iOffice\DocumentConverionClient"
                            ProjectName  = "DocumentConverionClient"}
                        @{
                            name = "dce"	
                            Physicalpath = "C:\Websites\iOffice\Engine"
                            ProjectName  = "Engine"}
                        )
                    }
      
        # windows features that need to be installed
        $winfeatures = @('Web-Server','Web-WebServer','Web-Common-Http',
                        'Web-Default-Doc','Web-Dir-Browsing','Web-Http-Errors',
                        'Web-Static-Content','Web-Http-Redirect','Web-Health',
                        'Web-Http-Logging','Web-Log-Libraries','Web-Request-Monitor',
                        'Web-Performance','Web-Stat-Compression','Web-Dyn-Compression','Web-Security',
                        'Web-Filtering','Web-Basic-Auth','Web-Client-Auth','Web-Digest-Auth',
                        'Web-Cert-Auth','Web-IP-Security','Web-Url-Auth','Web-Windows-Auth',
                        'Web-App-Dev','Web-Net-Ext45','Web-Asp-Net45','Web-ISAPI-Ext',
                        'Web-ISAPI-Filter','Web-WebSockets','Web-Mgmt-Tools',
                        'Web-Mgmt-Console','Web-Scripting-Tools','Web-Mgmt-Service')

        # Credential for Source files in the Drop fodler
        $SourceUser = 'uumobile\tfsbuild3'
        $SourcePass = ConvertTo-SecureString -AsPlainText 'Password01!' -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SourceUser,$SourcePass

        #cred for cim session on target node
        $username = "administrator"
        $userpass = ConvertTo-SecureString -AsPlainText zl123!@# -Force
        $usercred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$userpass

        #new cim session on target node
        $webcim = New-CimSession -ComputerName $dscEnv -Credential $usercred
        Write-Verbose -Message "Opening Cim Session on target Server: $dscEnv"

        } # end of Begin Block

    Process
        {
          # DSC Function 
          Configuration IISWebsite 
            { 
                Param(
                # \\10.1.1.9\DropFolder\BOWebsiteTestBuild\BOWebsiteTestBuild_20150908.1\_PublishedWebsites
                $SourceCred
                )

                # explicitly import the DSC xModules, before this you need to push the modules to the destination nodes (DSC push mode only)
                Import-DscResource -Module xWebAdministration 
                Import-DSCResource -ModuleName xNetworking

                  Node $AllNodes.NodeName
                  { 
                        # open inbound 8088 port in firewall for website
                        xFirewall Firewall
                        { 
                            Name                  = "WebsiteInbound8088" 
                            DisplayName           = "Firewall Rule for website 8088" 
                            Ensure                = "Present" 
                            Access                = "Allow" 
                            State                 = "Enabled" 
                            Profile               = ("Any") 
                            Direction             = "Inbound" 
                            LocalPort             = ("8088")          
                            Protocol              = "TCP" 
                        } 

                        #create websites folder in C:\
                        File WebsitesFolder
                        {
                            Ensure = "Present"
                            DestinationPath = 'C:\Websites\iOffice\webroot'
                            Type = "Directory"
                         }

                         # if allapps is specified in WebApp paramater, then copy all contents to the destination, else copy only the specific apps
                        if ($WebApp -eq "allapps")
                         {
                            File AllWebAppContents
                                 {
                                    Ensure = "Present"
                                    SourcePath = $SourcePath
                                    DestinationPath = 'C:\Websites\iOffice'
                                    Credential = $SourceCred
                                    Recurse = $true
                                    DependsOn = "[File]WebsitesFolder"
                                 }
                             
                         }
                         else
                         { 
                             foreach ($appdata in $WebApp)
                                 {
                                     $appD = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $appdata } 
                                     File $appD.ProjectName
                                     {
                                         SourcePath = "$SourcePath\$($appD.ProjectName)"
                                         Credential = $SourceCred
                                         DestinationPath = "C:\Websites\iOffice\$($appD.ProjectName)"
                                         Ensure = 'Present'
                                         Type = 'Directory'
                                         Recurse = $true
                                         DependsOn = "[File]WebsitesFolder"
            
                                     }
            
                                 }    
                         } #copy selected file to destinition folder

                        <#
                            # copy iOffice web app content into C:\websites folder
                            File WebAppContents
                            {
                                Ensure = "Present"
                                SourcePath = $SourcePath
                                DestinationPath = 'C:\Websites\iOffice'
                                Credential = $SourceCred
                                Recurse = $true
                                DependsOn = "[File]WebsitesFolder"
                             }
                         #>

                         #install all the needed windows features
                         foreach ($feature in $winfeatures)
                         {
                            WindowsFeature $feature.Replace('-','')
                            {
	                            Ensure = "Present"
	                            Name = "$feature"
                            }
             
                         }

                        # Create a Web Application Pool 
                        xWebAppPool NewWebAppPool 
                        { 
                            Name   = "iOffice" 
                            Ensure = "Present" 
                            State  = "Started" 
                            DependsOn = "[WindowsFeature]WebServer","[WindowsFeature]WebWebServer"
                        } 

                        #Create a New Website with Port 8088
                        xWebsite NewWebsite 
                        { 
                            Ensure          = "Present" 
                            Name            = "iOffice" 
                            State           = "Started" 
                            PhysicalPath    = "c:\Websites\ioffice\webroot" 
                            BindingInfo     = MSFT_xWebBindingInformation 
                                             { 
                                               Protocol              = "HTTP" 
                                               Port                  = 8088
                                             } 
                            DependsOn       = "[File]WebAppContents","[WindowsFeature]WebServer","[WindowsFeature]WebWebServer" 
                        } 

                        #Create each Web Applications
                        foreach ($app in $WebApp)

                        {
                           $webT = $webapps.allapps | Where-Object -FilterScript {$_.name -eq $app } 
                           xWebApplication $webT.name
                            { 
                                Name = $webT.name
                                Website = $Node.WebSiteName
                                WebAppPool =  $Node.WebAppPoolName
                                PhysicalPath = $webT.Physicalpath
                                Ensure = "Present" 
                                DependsOn = @("[xWebSite]NewWebSite") 
                            }  
                        }
                  } # end of Nodes DSC configuration section
              
              #Write-host "Env is $Environment, Path is $SourcePath, node name is $dscEnv , cred name is $($SourceCred.Username)" 
              # test code, will be removed later

             } # end of DSC function  section

             #run the configure to generate mof
             IISWebsite -ConfigurationData $ConfigurationData -SourceCred $Cred -OutputPath c:\DSCDeploy\IISWebsite

             #Run DSC configure
             Start-DscConfiguration -Path c:\DSCDeploy\IISWebsite -Wait -Verbose -CimSession $webcim

        #IISWebsite # test code, will be removed

        } # end of Process Block

    End
        {
            #sending notification emails
            if ($SendEmail)
            {
                #for demo only, user my credential
                <#
                $garyname = 'uumobile\garyzhang'
                $garypass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
                $garyzhang = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $garyname,$garypass
                #>

                Write-Verbose -Message "Now sending notification email..."
                #send out a email message
                Send-MailMessage -From ReleaseManagement@yipinapp.com `
                                 -to "$env:username@yipinapp.com" `
                                 -Cc yuhuaqiu@yipinapp.com `
                                 -Subject "Build Deployment Notification of Project $BuildDefinition" -Body "Test Build on server $dscEnv successfully" -BodyAsHtml `
                                 -SmtpServer mail.yipinapp.com

            }# sending emails

            
            #verify website 
            if ($Verify)
            {  
                Write-Verbose -Message "Now starting website test on server $dscEnv"
                Start-Process iexpolore -FilePath "http://$($dscEnv):8088/website"
            
            }# Verify website is working

        } # end of End Block

} # end of the function Start-Deployment

#test:  Start-Deployment -Environment Prod -BuildDefinition test -Version 8.0.1

# The most important thing to improve quality was not getting things right, but getting things consistent.