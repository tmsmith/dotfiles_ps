$env:AWS_HOME = "~\.aws"

function Set-AwsProfile {
  $env:AWS_DEFAULT_PROFILE = $args[0];
  $env:AWS_PROFILE = $args[0]
}

Set-Alias asp Set-AwsProfile

if (Test-Path $env:AWS_HOME"\default") {
  Set-AwsProfile (cat $env:AWS_HOME"\default")
}
