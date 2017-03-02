Function Remove-LabVM{
    param([string]$VMname)
    Get-VM -VMName $Vmname | Get-VMHardDiskDrive | Foreach { Stop-VM -VMName $_.VMname; Remove-Item -Path $_.Path; Remove-VM -VMName $_.Vmname}
}