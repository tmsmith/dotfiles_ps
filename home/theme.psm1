#requires -Version 2 -Modules posh-git

$VCS_GIT_ICON = [char]::ConvertFromUtf32(0xE20E)
$VCS_UNTRACKED_ICON = [char]::ConvertFromUtf32(0xE16C)
$VCS_OUTGOING_CHANGES_ICON = [char]::ConvertFromUtf32(0xE131)
$VCS_INCOMING_CHANGES_ICON = [char]::ConvertFromUtf32(0xE132)
$VCS_UNTRACKED_ICON = [char]::ConvertFromUtf32(0xE16C)
$VCS_UNSTAGED_ICON = [char]::ConvertFromUtf32(0xE17C)
$VCS_STAGED_ICON = [char]::ConvertFromUtf32(0xE168)
$VCS_STASH_ICON = [char]::ConvertFromUtf32(0xE133)
$AWS_ICON = [char]::ConvertFromUtf32(0xE895)

$global:SHOW_AWS_PROFILE = Get-AwsShowProfileWhenDefault

function Write-Theme
{
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.PromptBackgroundColor
    $aws = Get-AwsPromptInfo
    if ($aws) {
      Write-Prompt -Object $AWS_ICON -Back $aws.BackgroundColor -Fore $aws.ForegroundColor
      Write-Prompt " $env:AWS_DEFAULT_PROFILE" -Back $aws.BackgroundColor -Fore $aws.ForegroundColor
      Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $aws.BackgroundColor -BackgroundColor $lastColor
    }

    Write-Prompt -Object (Get-FullPath -dir $pwd) -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    Write-Prompt -Object ' ' -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

    $status = Get-VcsStatus
    if ($status)
    {
        $themeInfo = Get-VcsInfo -status ($status)
        $lastColor = $themeInfo.BackgroundColor
        Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
        Write-Prompt -Object " $VCS_GIT_ICON" -ForegroundColor $sl.Colors.GitForegroundColor -BackgroundColor $lastColor
        Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
    }

    Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor
}

function Get-AwsPromptInfo {
  if (Is-AwsDefaultProfile) {
    $bgColor = 'DarkCyan'
    $fgColor = "Gray"
    if (!($SHOW_AWS_PROFILE) -and (Is-AwsDefaultProfile)) {
      return
    }
  } else {
    $bgColor = "DarkRed"
    $fgColor = "White"
  }

  return New-Object PSObject -Property @{
      BackgroundColor = $bgColor
      ForegroundColor = $fgColor
  }
}

#
#function Get-VcsInfo2 {
#  param
#  (
#      [Object]
#      $status
#  )
#
#  if (!($status)) {
#    return New-Object PSObject -Property @{
#      BackgroundColor = 'DarkRed'
#      VcInfo          = "NA"
#    }
#  }
#
#
#  $branchStatusBackgroundColor = $sl.Colors.GitDefaultColor
#
#  # Determine Colors
#  $localChanges = ($status.HasIndex -or $status.HasUntracked -or $status.HasWorking)
#  #Git flags
#  $localChanges = $localChanges -or (($status.Untracked -gt 0) -or ($status.Added -gt 0) -or ($status.Modified -gt 0) -or ($status.Deleted -gt 0) -or ($status.Renamed -gt 0))
#
#  if($localChanges)
#  {
#      $branchStatusBackgroundColor = $sl.Colors.GitLocalChangesColor
#  }
#  if(-not ($localChanges) -and ($status.AheadBy -gt 0))
#  {
#      $branchStatusBackgroundColor = $sl.Colors.GitNoLocalChangesAndAheadColor
#  }
#
#  $vcInfo = $sl.GitSymbols.BranchSymbol;
#  if (!$status.Upstream)
#  {
#      $branchStatusSymbol = $sl.GitSymbols.BranchUntrackedSymbol
#  }
#  elseif ($status.BehindBy -eq 0 -and $status.AheadBy -eq 0)
#  {
#      # We are aligned with remote
#      $branchStatusSymbol = $sl.GitSymbols.BranchIdenticalStatusToSymbol
#  }
#  elseif ($status.BehindBy -ge 1 -and $status.AheadBy -ge 1)
#  {
#      # We are both behind and ahead of remote
#      $branchStatusSymbol = "$($sl.GitSymbols.BranchAheadStatusSymbol)$($status.AheadBy) $($sl.GitSymbols.BranchBehindStatusSymbol)$($status.BehindBy)"
#  }
#  elseif ($status.BehindBy -ge 1)
#  {
#      # We are behind remote
#      $branchStatusSymbol = "$($sl.GitSymbols.BranchBehindStatusSymbol)$($status.BehindBy)"
#  }
#  elseif ($status.AheadBy -ge 1)
#  {
#      # We are ahead of remote
#      $branchStatusSymbol = "$($sl.GitSymbols.BranchAheadStatusSymbol)$($status.AheadBy)"
#  }
#  else
#  {
#      # This condition should not be possible but defaulting the variables to be safe
#      $branchStatusSymbol = '?'
#  }
#
#  # $vcInfo = "$vcInfo $($status.Branch) "
#  $vcInfo = $vcInfo +  (Format-BranchName -branchName ($status.Branch))
#
#  if ($branchStatusSymbol)
#  {
#      $vcInfo = $vcInfo +  ('{0} ' -f $branchStatusSymbol)
#  }
#
#  if($spg.EnableFileStatus -and $status.HasIndex)
#  {
#      $vcInfo = $vcInfo +  $sl.BeforeIndexSymbol
#
#      if($spg.ShowStatusWhenZero -or $status.Index.Added)
#      {
#          $vcInfo = $vcInfo +  "+$($status.Index.Added.Count) "
#      }
#      if($spg.ShowStatusWhenZero -or $status.Index.Modified)
#      {
#          $vcInfo = $vcInfo +  "~$($status.Index.Modified.Count) "
#      }
#      if($spg.ShowStatusWhenZero -or $status.Index.Deleted)
#      {
#          $vcInfo = $vcInfo +  "-$($status.Index.Deleted.Count) "
#      }
#
#      if ($status.Index.Unmerged)
#      {
#          $vcInfo = $vcInfo +  "!$($status.Index.Unmerged.Count) "
#      }
#
#      if($status.HasWorking)
#      {
#          $vcInfo = $vcInfo +  "$($sl.GitSymbols.DelimSymbol) "
#      }
#  }
#
#  if($spg.EnableFileStatus -and $status.HasWorking)
#  {
#      if($showStatusWhenZero -or $status.Working.Added)
#      {
#          $vcInfo = $vcInfo +  "+$($status.Working.Added.Count) "
#      }
#      if($spg.ShowStatusWhenZero -or $status.Working.Modified)
#      {
#          $vcInfo = $vcInfo +  "~$($status.Working.Modified.Count) "
#      }
#      if($spg.ShowStatusWhenZero -or $status.Working.Deleted)
#      {
#          $vcInfo = $vcInfo +  "-$($status.Working.Deleted.Count) "
#      }
#      if ($status.Working.Unmerged)
#      {
#          $vcInfo = $vcInfo +  "!$($status.Working.Unmerged.Count) "
#      }
#  }
#
#  if ($status.HasWorking)
#  {
#      # We have un-staged files in the working tree
#      $localStatusSymbol = $sl.GitSymbols.LocalWorkingStatusSymbol
#  }
#  elseif ($status.HasIndex)
#  {
#      # We have staged but uncommited files
#      $localStatusSymbol = $sl.GitSymbols.LocalStagedStatusSymbol
#  }
#  else
#  {
#      # No uncommited changes
#      $localStatusSymbol = $sl.GitSymbols.LocalDefaultStatusSymbol
#  }
#
#  if ($localStatusSymbol)
#  {
#      $vcInfo = $vcInfo +  ('{0} ' -f $localStatusSymbol)
#  }
#
#  if ($status.StashCount -gt 0)
#  {
#      $vcInfo = $vcInfo +  "$($sl.GitSymbols.BeforeStashSymbol)$($status.StashCount)$($sl.GitSymbols.AfterStashSymbol) "
#  }
#
#
#  return New-Object PSObject -Property @{
#      BackgroundColor = $branchStatusBackgroundColor
#      VcInfo          = $vcInfo.Trim()
#  }
#}

$spg = $global:GitPromptSettings #Posh-Git settings
$spg.EnableFileStatus = $true

$sl = $global:ThemeSettings #local settings
$sl.Colors.GitDefaultColor = [ConsoleColor]::DarkYellow
#$sl.Colors.GitForegroundColor = [ConsoleColor]::White

$sl.Colors.SessionInfoBackgroundColor = [ConsoleColor]::Blue
$sl.Colors.SessionInfoForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptBackgroundColor = [ConsoleColor]::Blue
$sl.GitSymbols.BranchIdenticalStatusToSymbol = $null
$sl.GitSymbols.BranchUntrackedSymbol = $null #$VCS_UNTRACKED_ICON
#$sl.GitSymbols.BranchBehindStatusSymbol = $VCS_OUTGOING_CHANGES_ICON
#$sl.GitSymbols.BranchAheadStatusSymbol = $VCS_INCOMING_CHANGES_ICON
#$sl.GitSymbols.Branc
#$sl.GitSymbols.
#$sl.GitSymbols.
