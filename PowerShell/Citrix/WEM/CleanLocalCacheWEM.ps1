<#

    .SYNOPSIS
        Clears the local cache for WEM when the machines start up each morning; Occasionally WEM doesn't detect changes and won't update the local cache.
        
        Preferably going to rewrite this when Hall Contracting migration starts.

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$LocalCachePath = 'C:\Program Files (x86)\Citrix\Workspace Environment Management Agent\Local Databases\LocalAgentCache.db'
$AgentPath = 'C:\Program Files (x86)\Citrix\Workspace Environment Management Agent\'
$PathExists = Test-Path $LocalCachePath
$Service = Get-Service -Name "Citrix WEM Agent Host Service" -ErrorAction SilentlyContinue
$Process = Get-Process -Name "VUEMUIAgent" -ErrorAction SilentlyContinue


if ($Service.Status -eq "Running") {
    net stop $Service.Name /y
}

Stop-Process -Name $Process.Name -Force -ErrorAction SilentlyContinue

if ($PathExists -eq 'True') {
    Remove-Item -Path $LocalCachePath
    Write-Host("WEM Local Cache has been cleaned")
}

net start "Citrix WEM Agent Host Service"
net start "Netlogon"

Start-Sleep -Seconds 10

Start-Process $AgentPath'AgentCacheUtility.exe' -ArgumentList -refreshcache
Write-Host('Re-syncing Cache With WEM Broker')

Start-Sleep -Seconds 30

Start-Process $AgentPath'VUEMUIAgent.exe'
Write-Host('Starting Agent')
