# -------------------------------------------------  Author        :   Laure Kamalandua  ------------------------------------------------- #
# -------------------------------------------------  Contact       :   laure.kamalandua@gmail.com  --------------------------------------- #
# -------------------------------------------------  Website       :   http://www.laurekamalandua.com  ----------------------------------- #
# -------------------------------------------------  Version       :   1 ----------------------------------------------------------------- #
# -------------------------------------------------  Description   :   Fetches a random inspirational quote ------------------------------ #

function Get-Inspired() { 
    $APIurl = 'http://www.forismatic.com/api/1.0/' 
    $remotehost = New-Object System.Net.WebClient 
    $remotehost.Headers.Add("Content-Type", "application/x-www-form-urlencoded") 
    $remotehost.Encoding = [System.Text.Encoding]::UTF8 
    [xml]$quote = $remotehost.UploadString($apiUrl, 'method=getQuote&lang=en&format=xml') 
    $quoteFull = $quote.forismatic.quote.quotetext +"- " + $quote.forismatic.quote.quoteauthor 
    $quoteChars = $quoteFull.Length 
    $quoteArray = $quoteFull.Split() 
    $quoteWords = ($quoteFull | Measure-Object -Word).Words 
    $splitIndex = ($quoteWords/2) 
    $splitWord = $quoteArray[$splitIndex] 
    $splitWordFloor = [math]::floor($splitIndex) 
    $correctIndex = $quoteFull.LastIndexOf($splitWord) 
    if ($quoteChars -gt 66 -AND $quoteChars -lt 180){ 
        $finalQuote = $quoteFull.Insert($correctIndex, "       `r`n" + '       ') 
        "`r`n" + '       ' + '*' * $correctIndex +"`r`n" 
        Write-Host '      ' $finalQuote -ForegroundColor Yellow 
        "`r`n" + '       ' + '*' * $correctIndex + "`r`n" 
    } elseif ($quoteChars -gt 0 -AND $quoteChars -lt 65) { 
        "`r`n" + '       ' + '*' * $quoteChars +"`r`n" 
        Write-Host '      ' $quoteFull -ForegroundColor Yellow 
        "`r`n" + '       ' + '*' * $quoteChars + "`r`n" 
    } else { 
        "`r`n" + '       ' + '*' * $quoteChars +"`r`n" 
        Write-Host '      ' $quoteFull -ForegroundColor Yellow 
        "`r`n" + '       ' + '*' * $quoteChars + "`r`n" 
    } 
} 

function Set-PSProfile {
    $script = $PSScriptRoot + '\get-inspired.ps1'
    $documents = (Get-ChildItem env:).userprofile + '\Documents\' 
    $documentPowershell = $documents + 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    if (((Get-ChildItem $profile -ErrorAction SilentlyContinue | select -Property *).Exists) -eq $True) {
        Write-Host 'The Powershell profile exists and the module will be added.' -ForegroundColor Green 
        $scriptcontent = Get-Content $script -Head 35 -Force | Select-Object -Skip 6 | Add-Content $profile -Force
        Add-Content $profile 'Get-Inspired'
        Write-Host 'The module has been succesfully added to your profile.' -ForegroundColor Green    
    } else {
        Write-Host 'Your Powershell profile does not exist.'`n'It will be created.' -ForegroundColor Red
        New-Item -Path $profile -Type File -Force | Out-Null
        Write-Host 'The profile has been created' -ForegroundColor Yellow
        $scriptcontent = Get-Content $script -Head 35 -Force | Select-Object -Skip 6 | Add-Content $profile -Force
        Add-Content $profile 'Get-Inspired'
        Write-Host 'The module has been succesfully added to your profile.' -ForegroundColor Green
    }
}


