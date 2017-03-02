
if (Get-ScheduledTask -TaskName MochaRunner) {
    #check if task has been Disabled
    if ((Get-ScheduledTask -TaskName MochaRunner).State -eq "Disabled") {
        Enable-ScheduledTask -TaskName MochaRunner -TaskPath \Microsoft\Windows\PowerShell\ScheduledJobs\ 
        Start-ScheduledTask -TaskName MochaRunner -TaskPath \Microsoft\Windows\PowerShell\ScheduledJobs\ 
    }
    #invoke task
    else {
        Start-ScheduledTask -TaskName MochaRunner -TaskPath \Microsoft\Windows\PowerShell\ScheduledJobs\ 
    }
}
else {
    #create the task
    $scriptblock = {
            cd C:\TFS2015AgentWorkfolder\ecd9b4b4c\CI_BlueOffice_AutoTest\drop\BlueOfficeAutoTest
    
            typings install 
            sleep -Seconds 20
    
            tsc
            sleep -Seconds 10
    
            mocha -R mochawesome AllTests.js
    }
    $t = New-JobTrigger -Once -At ((Get-Date).AddHours(1))
    Register-ScheduledJob -Name MochaRunner -ScriptBlock $scriptblock -Trigger $t
    Start-ScheduledTask -TaskName MochaRunner -TaskPath \Microsoft\Windows\PowerShell\ScheduledJobs\ 
}

# wait for mocha test finish
$starttime = Get-Date
$path ="C:\TFS2015AgentWorkfolder\ecd9b4b4c\CI_BlueOffice_AutoTest\drop\BlueOfficeAutoTest\mochawesome-reports\mochawesome.html"
while ((Test-Path -Path $path) -eq $false)
{
    Write-Verbose -Message "[$(Get-Date)]:Mocha test still running..." -Verbose
    sleep -Seconds 5
}
$endtime = Get-Date
Write-Verbose -Message "Mocha test finished running! Time lapsed: $(($endtime - $starttime).TotalSeconds) seconds" -Verbose

cd "C:\TFS2015AgentWorkfolder\ecd9b4b4c\CI_BlueOffice_AutoTest\drop\BlueOfficeAutoTest\mochawesome-reports"
Rename-Item .\mochawesome.html index.html

Disable-ScheduledTask -TaskName MochaRunner -TaskPath \Microsoft\Windows\PowerShell\ScheduledJobs\