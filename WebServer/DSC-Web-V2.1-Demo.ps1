<#
.Synopsis
   This will deploy your Webapp or Website in to the desired environment
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function Start-Deployment {

[CmdletBinding()]

    Param(
        # verify if the deployment of website is successful
        [switch]$Verify,
        
        # specify the BuildDefinition, which you have trigger from Build server
        [Parameter(Mandatory=$true)]
        [String]$BuildDefinition,
        
        # specify which version you need to deploy
        [Parameter(Mandatory=$true)]
        [String]$Version,

        # specify which environment you need to deploy to, valid environments are "Test", "Staging", "Prod"
        [Parameter(Mandatory=$true)]
        [ValidateSet("Test", "Staging", "Prod")]
        [Alias("Env")] 
        $Environment,

        # Switch paramater to SendEmail to you and the stakeholders
        [switch]$SendEmail,

        # specify which web app or site you would like to deploy
        [Parameter(Mandatory=$true)]
        [ValidateSet("an","bo","cg","cs","dc","dir","dirp","fg","gbo","gds","ih","lv",
            "mg","mgmt","mr","mrp","nb","nbp","op","p","pl","tf","tt","website","ww")]
        [String[]]$WebApp
        )

    Begin
        {

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
                Physicalpath = "C:\Websites\iOffice\AggregatedNotification"}

                        @{  
                name = "bo"	
                Physicalpath = "C:\Websites\iOffice\BlueOfficeService"}

                        @{
                name = "cg"
  	            Physicalpath = "C:\Websites\iOffice\CalendarGridService"}

                        @{
                name = "cs"	
                Physicalpath = "C:\Websites\iOffice\ConchShellService"}

                        @{
                name = "dc"	
                Physicalpath = "C:\Websites\iOffice\DataCubeService"}

                        @{
                name = "dir"	
                Physicalpath = "C:\Websites\iOffice\DirectoryService"}

                        @{
                name = "dirp"	
                Physicalpath = "C:\Websites\iOffice\DirectoryPortal"}

                        @{
                name = "fg"	
                Physicalpath = "C:\Websites\iOffice\FootprintGraphService"}

                        @{
                name = "gbo"	
                Physicalpath = "C:\Websites\iOffice\BlueOfficeGlobalBlueOffice"}

                        @{
                name = "gds"	
                Physicalpath = "C:\Websites\iOffice\GlobalDirectoryService"}

                        @{
                name = "ih"	
                Physicalpath = "C:\Websites\iOffice\ImageHub"}

                        @{
                name = "lv"	
                Physicalpath = "C:\Websites\iOffice\LiveVoteService"}

                        @{
                name = "mg"	
                Physicalpath = "C:\Websites\iOffice\MomentGardenService"}

                        @{
                name = "mgmt"	
                Physicalpath = "C:\Websites\iOffice\Management"}

                        @{
                name = "mr"	
                Physicalpath = "C:\Websites\iOffice\MindRadarService"}

                        @{
                name = "mrp"	
                Physicalpath = "C:\Websites\iOffice\MindRadarPortal"}

                        @{
                name = "nb"	
                Physicalpath = "C:\Websites\iOffice\NewsBoardService"}

                        @{
                name = "nbp"	
                Physicalpath = "C:\Websites\iOffice\NewsBoardPortal"}

                        @{
                name = "op"	
                Physicalpath = "C:\Websites\iOffice\OperationPortal"}

                        @{
                name = "p"	
                Physicalpath = "C:\Websites\iOffice\Portal"}

                        @{
                name = "pl"	
                Physicalpath = "C:\Websites\iOffice\PortalLogger"}

                        @{
                name = "tf"	
                Physicalpath = "C:\Websites\iOffice\TaskForceService"}

                        @{
                name = "tt"	
                Physicalpath = "C:\Websites\iOffice\TalkTimeService"}

                        @{
                name = "website"	
                Physicalpath = "C:\Websites\iOffice\iOfficeWebsite"}

                        @{
                    name = "ww"	
                    Physicalpath = "C:\Websites\iOffice\WishingWellService"}

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
                $SourcePath = '\\10.1.1.9\DropFolder\' + $BuildDefinition + '\' + $BuildDefinition  + '_' + $Version + '\_PublishedWebsites',
                # \\10.1.1.9\DropFolder\BOWebsiteTestBuild\BOWebsiteTestBuild_20150908.1\_PublishedWebsites
                $SourceCred = $Cred
                )

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
                            DestinationPath = 'C:\Websites\iOffice'
                            Type = "Directory"
                         }

                        #copy iOffice web app content into C:\websites folder
                        File WebAppContents
                        {
                            Ensure = "Present"
                            SourcePath = $SourcePath
                            DestinationPath = 'C:\Websites\iOffice\'
                            Credential = $SourceCred
                            Recurse = $true
                            DependsOn = "[File]WebsitesFolder"
                         }

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
             IISWebsite -ConfigurationData $ConfigurationData -SourcePath $SourcePath -SourceCred $Cred -OutputPath c:\DSCDeploy\IISWebsite

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
                $garyname = 'uumobile\garyzhang'
                $garypass = ConvertTo-SecureString -AsPlainText 'zl123!@#' -Force
                $garyzhang = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $garyname,$garypass

                Write-Verbose -Message "Now sending notification email..."
                #send out a email message
                Send-MailMessage -From ReleaseManagement@yipinapp.com `
                                 -to garyzhang@yipinapp.com `
                                 -Cc yuhuaqiu@yipinapp.com `
                                 -Subject "Build Deployment Notification " -Body "Test Build on server 10.1.1.87 successfully" -BodyAsHtml `
                                 -SmtpServer mail.yipinapp.com -Credential $garyzhang

            }# sending emails

            if ($Verify)
            {
                Write-Verbose -Message "Now starting website test on server $dscEnv"
                Start-Process iexpolore -FilePath "http://$($dscEnv):8088/website"
            
            }# Verify website is working


        } # end of End Block

} # end of the function Start-Deployment

#test:  Start-Deployment -Environment Prod -BuildDefinition test -Version 8.0.1