#
# Return IPs for all interfaces
#
function Get-Ips() {
  $ent = [net.dns]::GetHostEntry([net.dns]::GetHostName())
  return $ent.AddressList | ?{ $_.ScopeId -ne 0 } | %{
    [string]$_
  }
}

#
# Get Seconds Since Epoch
#
function Get-UnixSeconds
{
  param(
    [DateTime] $datetime = (Get-Date)
   )

  [int]($datetime.ToUniversalTime() - ((Get-Date '1/1/1970'))).TotalSeconds
}

#
# Get Time from seconds based on Epoch
#
function Get-DateTimeFromUnixSeconds()
{
  param(
    [int] $timestamp
  )

  return ((Get-Date -Date '1/1/1970')).AddSeconds($timestamp);
}

#
# Run command as Administrator
#
function sudo
{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi);
}

#
# Convert From Base-64
#
function Decode-Base64([string] $string) {
  $bytes  = [System.Convert]::FromBase64String($string);
  $decoded = [System.Text.Encoding]::UTF8.GetString($bytes);
  return $decoded;
}

Set-Alias d64 Decode-Base64

#
# Convert To Base-64
#
function Encode-Base64([string] $string) {
  $bytes  = [System.Text.Encoding]::UTF8.GetBytes($string);
  $encoded = [System.Convert]::ToBase64String($bytes);
  return $encoded;
}

Set-Alias e64 Encode-Base64
