#backup arts folder
$ScriptBlock1 = {
    $artsSource = 'D:\Arts'
    $artsDestin = 'F:\ShareFolder\Arts'
    Robocopy.exe $artsSource $artsDestin /e /copyall
}
$artsJT = New-JobTrigger -Once -At "07/08/2016 10pm" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name ArtsFolderBackup -ScriptBlock $ScriptBlock1 -Trigger $artsJT

#backup business development folder
$ScriptBlock2 = {
    $bdSource = 'D:\BusinessDevelopment'
    $bdDestin = 'F:\ShareFolder\BusinessDevelopment'
    Robocopy.exe $bdSource $bdDestin /e /copyall
}
$bdJT = New-JobTrigger -Once -At "07/08/2016 11pm" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name BusinessDevelopmentFolderBackup -ScriptBlock $ScriptBlock2 -Trigger $bdJT

#backup Marketing folder
$ScriptBlock3 = {
    $mktSource = 'D:\Marketing'
    $mktDestin = 'F:\ShareFolder\Marketing'
    Robocopy.exe $mktSource $mktDestin /e /copyall
}
$mktJT = New-JobTrigger -Once -At "07/09/2016 0am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name MarketingFolderBackup -ScriptBlock $ScriptBlock3 -Trigger $mktJT

#backup OfficialPublic folder
$ScriptBlock4 = {
    $opSource = 'D:\OfficialPublic'
    $opDestin = 'F:\ShareFolder\OfficialPublic'
    Robocopy.exe $opSource $opDestin /e /copyall
}
$opJT = New-JobTrigger -Once -At "07/09/2016 1am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name OfficialPublicFolderBackup -ScriptBlock $ScriptBlock4 -Trigger $opJT

#backup Products folder
$ScriptBlock5 = {
    $prodSource = 'D:\Products'
    $prodDestin = 'F:\ShareFolder\Products'
    Robocopy.exe $prodSource $prodDestin /e /copyall
}
$prodJT = New-JobTrigger -Once -At "07/09/2016 2am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name ProductsFolderBackup -ScriptBlock $ScriptBlock5 -Trigger $prodJT

#backup RDProjects folder
$ScriptBlock6 = {
    $rdprojSource = 'D:\RDProjects'
    $rdprojDestin = 'F:\ShareFolder\RDProjects'
    Robocopy.exe $rdprojSource $rdprojDestin /e /copyall
}
$rdprojJT = New-JobTrigger -Once -At "07/09/2016 3am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name RDProjectsFolderBackup -ScriptBlock $ScriptBlock6 -Trigger $rdprojJT

#backup SalesProjects folder
$ScriptBlock7 = {
    $salesSource = 'D:\SalesProjects'
    $salesDestin = 'F:\ShareFolder\SalesProjects'
    Robocopy.exe $salesSource $salesDestin /e /copyall
}
$salesJT = New-JobTrigger -Once -At "07/09/2016 4am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name SalesProjectsFolderBackup -ScriptBlock $ScriptBlock7 -Trigger $salesJT

#backup TestPackages
$ScriptBlock8 = {
    $testpkgSource = 'D:\TestPackages'
    $testpkgDestin = 'F:\ShareFolder\TestPackages'
    Robocopy.exe $testpkgSource $testpkgDestin /e /copyall
}
$testpkgJT = New-JobTrigger -Once -At "07/09/2016 5am" -RepetitionInterval (New-TimeSpan -Hour 12) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name TestPackagesFolderBackup -ScriptBlock $ScriptBlock8 -Trigger $testpkgJT
