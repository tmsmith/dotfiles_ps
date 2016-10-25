$profilePath = $PROFILE.CurrentUserAllHosts
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$rootPath = Resolve-Path (Join-Path $scriptPath "..\home")

Write-Host "Installing to $profilePath"
Write-Host "Setting Profile Path to $rootPath"

$content = '$dotfiles = "' + $rootPath + '"
if (Test-Path $dotfiles) {
  . "$dotfiles\profile.ps1"
} else {
  Write-Host "[Warning]" -foregroundcolor magenta -backgroundcolor yellow -nonewline
  Write-Host " ~/.dotfiles" -foregroundcolor red -nonewline
  Write-Host " not installed. You will need to change the default profile."
  Write-Host ""
}'

if (!(Test-Path $profilePath)) {
  Write-Host "Creating Profile" -foregroundcolor green
  Set-Content $profilePath $content
} else {
  Write-Host "Already installed"  -foregroundcolor red
}
