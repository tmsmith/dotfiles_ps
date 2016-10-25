function aws_prompt {
  if ($env:AWS_DEFAULT_PROFILE -eq (cat $env:AWS_HOME"\default")) {
    $bgColor = $Host.UI.RawUI.BackgroundColor
    $fgColor = $Host.UI.RawUI.ForegroundColor
  } else {
    $bgColor = "DarkRed"
    $fgColor = "White"
  }

  Write-Host "$env:AWS_DEFAULT_PROFILE " -Back $bgColor -NoNewLine
}

#function global:prompt {
#    $realLASTEXITCODE = $LASTEXITCODE
#    aws_prompt
#    Write-Host $pwd.ProviderPath -nonewline
#    Write-VcsStatus
#
#    $global:LASTEXITCODE = $realLASTEXITCODE
#    return "> "
#}
