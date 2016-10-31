$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition

. "$scriptPath\path.ps1"

ls "$scriptPath\*.ps1" -exclude profile.*,path.* | %{
  . (Resolve-Path $_)
}

Import-Module "$scriptPath\jump-location\Jump.Location.psd1"

Set-PSReadlineOption -TokenKind Command -ForegroundColor Gray
Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Yellow
