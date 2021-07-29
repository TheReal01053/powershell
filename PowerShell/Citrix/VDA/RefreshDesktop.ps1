<#

    .SYNOPSIS
        Only required if the customer is using Citrix WEM; we refresh the desktop removing citrix apps before WEM runs and adds the applications back.
        So that if we remove the user from a specific application we can verify that the application is removed from their desktop.

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$DesktopFldr = Get-ChildItem -Recurse "H:\Desktop\*lnk"
$MachineName = $env:COMPUTERNAME

$Shell = New-Object -ComObject WScript.Shell

Write-Host($MachineName)

if ($MachineName -match "XD-ROOT") {

    foreach($item in $DesktopFldr) {

        $target = $Shell.CreateShortcut($item).TargetPath

        if ($target -match "Citrix") {
            Write-Host("Removing Citrix Item From Desktop: " + [System.String]::Join("", $item).substring(11))
            Remove-Item $item
        }
    }
}
