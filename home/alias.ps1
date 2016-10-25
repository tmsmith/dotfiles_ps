function cdst { Set-Location "C:\Projects\Realm\Stratus" }
function cdrel { Set-Location "C:\Projects\Realm" }
function cdpay { Set-Location "C:\Projects\Payments" }
function cdnu { Set-Location "C:\Projects\Nuget" }
function cdle { Set-Location "C:\Projects\Lego" }


function x { exit }

function .. { Set-Location ".." }
function ... { Set-Location "../.." }
function .... { Set-Location "../../.." }
function ..... { Set-Location "../../../.." }
function ...... { Set-Location "../../../../.." }

function touch { Set-Content -Path ($args[0]) -Value ($null) }


function g {  git $args }
function _git_status { git status -sb }

Set-Alias gs _git_status

Set-Alias ll Get-ChildItem
Set-Alias open Invoke-Item
