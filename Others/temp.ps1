(Import-Csv -Path C:\DSC\installedWebFeatures.csv | select -ExpandProperty name) -join "','" | clip
Get-WebApplication | select @{l='p';e={$_.path.replace('/','')}},@{l='path'; e= {"Physicalpath = `"{0}`"" -f $_.Physicalpath}}| 
select @{l='name'; e={"name = `"{0}`"" -f $_.p}},path |
 export-csv C:\webapps.csv -NoTypeInformation -Force


 
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
