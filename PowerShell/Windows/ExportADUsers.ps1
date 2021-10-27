<#

    .SYNOPSIS
        Exports all users and their required info from Active Directory into an excel spreadsheet

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$Results = @()

$ADUsers = Get-ADUser -Filter * -Properties Mail, Description  | ForEach-Object {

    $Login = $_.SamAccountName
    $Name = $_.Name.Split(" ")
    $Mail = $_.Mail
    $Title = $_.Description

    $userDetails = New-Object -TypeName psobject -Property @{
        Login = $Login
        FirstName = $Name[0]
        LastName = $Name[1]
        Email = $Mail
        Title = $Title
    }

   $Results += $userDetails
}

$Results | export-csv -Path "C:\Windows\Temp\ADDump.csv"
