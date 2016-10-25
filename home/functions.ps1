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


function sudo
{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi);
}
