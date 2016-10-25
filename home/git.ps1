Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Import-Module .\posh-git\posh-git
Start-SshAgent -Quiet
Pop-Location
