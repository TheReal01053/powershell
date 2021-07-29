<#

    .SYNOPSIS
        This is used to automatically sync sharepoint sites to the users desktop.

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

Start-Transcript -Path (Join-Path $env:LOCALAPPDATA "temp\sharepointsync\Sync_Log.log")
$MachineName = $env:COMPUTERNAME

Write-Host($MachineName)

if ($MachineName -match "XD-ROOT") {

    function Sync-SharepointLocation {
        param(
            [string]$userEmail,
            [string]$siteId,
            [string]$webId,
            [string]$webTitle,
            [string]$webUrl,
            [string]$listId,
            [string]$listTitle
        )

        $uri = New-Object System.UriBuilder
        $uri.Scheme = "odopen"
        $uri.Host = "sync?userEmail=$($userEmail)&siteId=$($siteId)&webId=$($webId)&webTitle=$($webTitle)&webUrl=$($webUrl)&listId=$($listId)&listTitle=$($listTitle)"
        Write-Host $uri.ToString()
        Start-Process -FilePath ($($uri.ToString()))
    }

    $Members = @(Get-ADGroupMember -Identity "SharepointSync" -Recursive | Select -ExpandProperty SamAccountName)

    foreach ($Member in $Members) {

        if ($Member -eq $env:USERNAME) {

            Write-Host $Member

            $UserData = (Join-Path $PSScriptRoot "UserData.json")
            #Get the files contents and convert it from json format
            $File = Get-Content -Raw -Path $UserData | Out-String | ConvertFrom-Json
            $UserEmail = $File | where { $_.Samaccountname -eq $env:USERNAME }
            Write-Host "User workspace login name: hall\$($UserEmail.Samaccountname) | User email address: $($UserEmail.mail)" -ForegroundColor Yellow
            [mailaddress]$userUpn = $UserEmail.mail
            $params = @{
                userEmail = $userUpn
                siteId = "%7B4cb5b456%2D0cea%2D44ec%2D896a%2Dd11bd817be61%7D"
                webId = "%7B26fdea0b%2D4fb0%2D4220%2Da276%2Df313b59daaa9%7D"
                webTitle = "Hall Contracting Team Site"
                webUrl = "https%3A%2F%2Foboxhall%2Esharepoint%2Ecom"
                listId = "%7BDFC58F61%2D4B17%2D4F8C%2DB999%2D909626F24285%7D"
                listTitle = "Documents"
            }

            $params | Format-Table 

            $params.syncPath  = "$(split-path $env:onedrive)\Hall Contracting\$($params.webTitle) - $($Params.listTitle)"
            Write-Host $params.syncPath
            $params | Format-Table
            if (!(Test-Path $($params.syncPath))) {
                Sync-SharepointLocation $params.userEmail $params.siteId $params.webId $params.webTitle $params.webUrl $params.listId $params.listTitle
                Write-Host "Site not found performing sync!" -ForegroundColor Green
            } else {
                Write-Host "Site already synchronized!" -ForegroundColor Red
            }
        }
    }
}
Stop-Transcript
