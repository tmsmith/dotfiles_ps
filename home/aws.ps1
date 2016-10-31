$env:AWS_HOME = "~\.aws"

function Set-AwsProfile {
  $env:AWS_DEFAULT_PROFILE = $args[0];
  $env:AWS_PROFILE = $args[0]
}

Set-Alias asp Set-AwsProfile

function Is-AwsDefaultProfile {
  $env:AWS_DEFAULT_PROFILE -eq (cat $env:AWS_HOME"\default")
}

function Get-AwsProfiles {
  Get-Content $env:AWS_HOME\credentials | Where-Object { $_ -match '\[*\]' } | Foreach-Object { $_.Trim('[').Trim(']').Trim() }
}

Set-Alias agp Get-AwsProfiles

function Get-AwsCurrentProfile {
  $env:AWS_PROFILE
}

Set-Alias acp Get-AwsCurrentProfile

function Set-AwsShowProfileWhenDefault {
  param(
    [bool]
    $show
  )

  Set-Content "~/.show_aws_profile" $show
  $global:SHOW_AWS_PROFILE = $show
}

function Get-AwsShowProfileWhenDefault {
  if (Test-Path "~/.show_aws_profile") {
    return (Get-Content "~/.show_aws_profile") -eq "True"
  }

  return $true
}

function global:TabExpansion($line, $lastWord) {
	switch -regex ($line) {
		"^(Set-AwsProfile|asp) .*" {
      return Get-AwsProfiles
		}
	}
}

if (Test-Path $env:AWS_HOME"\default") {
  Set-AwsProfile (cat $env:AWS_HOME"\default")
}
