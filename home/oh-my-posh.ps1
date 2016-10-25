Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Import-Module ..\oh-my-posh\oh-my-posh
$ThemeSettings.MyThemesLocation = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Theme theme
Pop-Location
