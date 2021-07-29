<#

    .SYNOPSIS
        EnableADAL
            This is to enable modern authentication for Outlook for all users deployed through NCentral

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$Path = "HKCU:\Software\Microsoft\Office\"

$Office = @("15.0\Common\Identity\", "16.0\Common\Identity\") 

foreach ($Version in $Office) {
    Write-Host (Join-Path $Path $Version)
    $Item = Get-ItemProperty -Path (Join-Path $Path $Version) -Name "EnableADAL" -ErrorAction SilentlyContinue
    $Exists = Test-Path (Join-Path $Path $Version)

    if ($Exists) {
        if ($Item) {
            Set-ItemProperty -Path (Join-Path $Path $Version) -Name "EnableADAL" -Value "1" -ErrorAction SilentlyContinue
            Write-Host "$($Path)$($Version)EnableADAL has been set to value: 1" -ForegroundColor Yellow
        } else {
            New-ItemProperty -Path (Join-Path $Path $Version) -Name "EnableADAL" -PropertyType DWord -Value "1" -ErrorAction SilentlyContinue
            Write-Host "Registry key not found, creating key { EnableADAL } with value 1 at location $($Path)$($Version)" -ForegroundColor Yellow
        }
    }   
}