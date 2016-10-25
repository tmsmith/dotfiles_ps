function Set-VisualStudioEnvVars {
  $vscpath = (Get-ChildItem Env: | Where-Object { $_.name -like 'VS***COMNTOOLS' -and (Test-Path $_.value.Replace("\Common7\Tools\", "\VC\vcvarsall.bat"))}).Value
  $vscpath = $vscpath.Replace("\Common7\Tools\", "\VC\")
  if($vscpath -is [system.array]) {
      $vscpath = $vscpath[0]
  }

  pushd $vscpath
  cmd /c "vcvarsall.bat&set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
    }
  }
  popd
}

Write-Host "Visual Studio Command Prompt variables set." -ForegroundColor Yellow
Set-VisualStudioEnvVars
