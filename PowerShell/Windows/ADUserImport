<#
    .SYNOPSIS
        Imports active directory users from excel spreadsheet - Optimized for Azure AD connected DCs
    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com
#>

$ADUsers = Import-Csv (Join-Path $PSScriptRoot "ADDump.csv")
$OrgUnit = "OU=Shared,OU=Users,OU=Citrix,OU=SLSACCOUNTING,DC=slsaccounting,DC=local"

foreach ($user in $ADusers) {
    $Email = $user.Email
    $FirstName = $user.FirstName
    $LastName = $user.LastName
    $LoginName = $user.Login
    $Description = $user.Title
    $UPN = $user.UPN
    $proxyAddress = $user.Proxy
    $Password = $user.Password

    Write-Host $LoginName
    New-ADUser -SamAccountName $LoginName -UserPrincipalName $UPN -Name "$($FirstName) $($LastName)" -GivenName $FirstName -Surname $LastName -Path $OrgUnit -EmailAddress $Email -Title $Description -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $True
    Set-ADUser -Identity $LoginName -add @{ProxyAddresses="$($proxyAddress)" -split ","}
}
