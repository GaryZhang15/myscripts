workflow test-workflow {

Param(
    [string]$path
)

    Get-ChildItem -Path path -Recurse -File |
    Measure-Object -Property Length -Sum -Average |
    Add-Member -MemberType NoteProperty -Name Path -Value path -PassThru
    # this is a test line for git repository usage! will remove later!

    # this is the second line test for git

}