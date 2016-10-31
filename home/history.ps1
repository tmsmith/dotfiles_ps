$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history

Register-EngineEvent PowerShell.Exiting -Action { Get-History | Where-Object { -not $_.CommandLine.StartsWith(" ") } | Export-Csv $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) {
  Import-Csv $HistoryFilePath | Add-History
}

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
