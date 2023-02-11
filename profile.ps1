Function New-File {New-Item -ItemType file @args}
New-Alias -Name "touch" -Value New-File

New-Alias -Name "cl" -Value Clear-Host

Function Git-Fetch {git fetch}
Function Git-Pull {git pull}
Function Git-Status {git status}
Function Git-Log {git log --graph --decorate --oneline}
Function Git-Branch {git branch @args}
Function Git-Merge {git merge @args}
Function Git-Commit {git commit @args}
Function Git-Checkout {git checkout @args}
New-Alias -Name "ggf" -Value Git-Fetch
New-Alias -Name "ggp" -Value Git-Pull
New-Alias -Name "ggs" -Value Git-Status
New-Alias -Name "ggl" -Value Git-Log
New-Alias -Name "ggb" -Value Git-Branch
New-Alias -Name "ggm" -Value Git-Merge
New-Alias -Name "ggc" -Value Git-Commit
New-Alias -Name "ggco" -Value Git-Checkout

Invoke-Expression (&starship init powershell)
