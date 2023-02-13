<#
    .SYNOPSIS
       	This will download Sophos installer and install the Antivirus in quiet mode, no user interaction required. And can be deployed to multiple endpoints through NC.

    .PRE-DEPLOY-TASKS
        
        1): Disable any policies that apply N-able AV to workstations or endpoints / and ensure N-able AV is uninstalled or disabled on ALL endpoints before deployment.
        2): Configure a scheduled script through n-central hourly to limit any windows of unprotected windows.

    .EXPLAIN
        This will only download install Sophos AV if it meets 2 conditions N-able AV is NOT installed, and Sophos AV is NOT installed.
    
    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com
#>


$DefenderKey = (Test-Path 'HKLM:\SOFTWARE\MICROSOFT\WINDOWS\CurrentVersion\Uninstall\Endpoint Security')
$SophosKey = (Test-Path 'HKLM:\SOFTWARE\MICROSOFT\WINDOWS\CurrentVersion\Uninstall\Sophos Endpoint Agent')
$SophosURL = 'https://github.com/Claratti/Sophos/raw/main/HALL_SOPHOS.exe'
$OutPath = "$($env:LOCALAPPDATA)\SophosInstall"

#Create Sophos Install directory to download the sophos installer application to. UserProfile\AppData\Local\SophosInstall
if (!(Test-Path $OutPath)) {
    New-Item -Path $OutPath -ItemType Directory
    Write-Host 'Sophos Install Directory Created' -ForegroundColor Green
    Start-Sleep -Seconds 2
}

if (!($DefenderKey)) {

    if ($SophosKey) {
        Write-Host 'Sophos antivirus is already installed... this will try again later! Ensure Sophos antivirus is uninstalled before execution.' -ForegroundColor Red
        return
    }

    Invoke-WebRequest -Uri $SophosURL -OutFile "$($OutPath)\sophos.exe"

    Start-Sleep -Seconds 15

    cmd.exe /c "$($OutPath)\sophos.exe --quiet"
    Write-Host 'Sophos Antivirus is currently being installed in quiet mode and no user interaction is required' -ForegroundColor Green

} else {
    Write-Host 'N-able antivirus is already installed... this will try again later! Ensure N-able antivirus is uninstalled before execution.' -ForegroundColor Red
}

