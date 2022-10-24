<#
    .SYNOPSIS
        Exports all users and their required info from Active Directory into an excel spreadsheet - Optimized to export required information for soft matching Azure AD
    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com
#>

$Results = @()

$OrgUnit = "OU=Users,OU=SLS,DC=SLS,DC=local"

$ADUsers = Get-ADUser -Filter * -SearchBase $OrgUnit  -Properties Mail, Description, UserPrincipalName, proxyaddresses | ForEach-Object {

    $Login = $_.SamAccountName
    $Name = $_.Name.Split(" ")
    $Mail = $_.Mail
    $Title = $_.Description
    $UPN = $_.UserPrincipalName
    $Proxy = $_.proxyaddresses
    $smtpAddress = ""

    foreach($smtp in $Proxy) {
        $smtpAddress += $smtp + ","
    }

    $userDetails = New-Object -TypeName psobject -Property @{
        Login = $Login
        FirstName = $Name[0]
        LastName = $Name[1]
        Email = $Mail
        Title = $Title
        Proxy = $smtpAddress
        UPN = $UPN
    }

   $Results += $userDetails
}

$Results | export-csv -Path "C:\Windows\Temp\ADDump.csv"
