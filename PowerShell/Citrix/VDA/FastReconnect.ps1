<#

    .SYNOPSIS
        FastReconnect
            This will disable the Fast Reconnect feature as it is bugged in Windows Server 2019.
            Source: https://www.mycugc.org/blogs/brandon-mitchell1/2019/09/22/not-so-fast-reconnect

        DisableGPCalculation
            This will disable recalcualting the WMI GPO filters when a user reconnects, disabled as per article.
            Source: https://support.citrix.com/article/CTX212610

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$Citrix = "HKLM:\SOFTWARE\Citrix\Reconnect"
$DeviceOS = Get-ComputerInfo | Select-Object OSName


if ($DeviceOS -like "*Server 2019*") {
    Write-Host "Windows Server 2019 detected; apply fix"
    if (!(Test-Path ($Citrix))) {
        Write-Host "Creating registry key to disable fastreconnect and disablegpcalculation" -ForegroundColor Green
        New-Item -Path $Citrix
        New-ItemProperty -Path $Citrix -Name "FastReconnect" -Value "0" -PropertyType "DWord"
        New-ItemProperty -Path $Citrix -Name "DisableGPCalculation" -Value "1" -PropertyType "DWord"
    }
} else {
    Write-Host "Windows Server 2019 is not detected."
}
