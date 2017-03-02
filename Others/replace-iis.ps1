
       <# WindowsFeature FriendlyName
        {
           Ensure = "Present"
           Name = "Feature Name"
        }
        #>

$iis = Import-Csv C:\DSC\installedWebFeatures.csv

#New-Item -ItemType file -Path C:\DSC\iis-dsc.txt -Force



foreach($i in $iis){
    $nameshort = $i.Name.Replace("-","")
    $c = (Get-Content -Path C:\DSC\temp.txt).Replace( "FriendlyName","$nameshort").Replace("Feature Name","$($i.Name)")
    #$newC = $c  -replace "Feature Name","$($i.Name)" 
    Add-Content -Value $c -Path C:\dsc\iis-dsc.txt -Force
    }



