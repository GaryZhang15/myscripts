#deploy SQL server

#create remote session on target server
$username = "administrator"
$password = ConvertTo-SecureString -AsPlainText "zl123!@#" -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password


$web1 = New-PSSession -ComputerName 10.1.1.82 -Credential $credential -Verbose

#install .net 3.5 and 4.5 features 

Invoke-Command -Session $web1 -ScriptBlock {Install-WindowsFeature -Name NET-Framework-Core,NET-Framework-45-Core -Source C:\Source\sxs -Verbose}

#install SQL with ini file (before this you need to mount the iso or copy it and then mount it)

Invoke-Command -Session $web1 -ScriptBlock {Invoke-Expression -Command "D:\Setup.exe /ConfigurationFile=c:\source\ConfigurationFile.ini /SQLSVCPASSWORD=zl123!@# /AGTSVCPASSWORD=zl123!@# /SAPWD=1qaz!QAZ" | Write-Verbose}

