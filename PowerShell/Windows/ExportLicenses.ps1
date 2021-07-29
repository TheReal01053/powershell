<#

    .SYNOPSIS
        Will export license account for users assigned to specified groups; and will leave out any account tagged as a "Service Account"

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>

$Groups = "App_Project", "App_Visio"
$ServiceAccounts = @{}
$ProjectCount = 0
$VisioCount = 0

foreach ($Group in $Groups) {
    $Result = @(Get-ADGroupMember -Identity $Group)

    $Result | ForEach-Object {
    $Description = Get-AdUser -Identity $_.SID -Properties Description | Select-Object -ExpandProperty Description
        if ($Description -eq "Service Account") {
            if ($Group -eq "App_Project") {
                $ProjectCount = $Result.Count
                if (-not $ServiceAccounts.ContainsKey($Group)) { 
                    $ServiceAccounts.Add($Group, 0) 
                }
                $ServiceAccounts["App_Project"]++;
            }

            if ($Group -eq "App_Visio") {
                $VisioCount = $Result.Count
                if (-not $ServiceAccounts.ContainsKey($Group)) { 
                    $ServiceAccounts.Add($Group, 0) 
                }
                $ServiceAccounts["App_Visio"]++;
            }
        }
   }
}


Write-Host "App_Project has $($ProjectCount - $ServiceAccounts["App_Project"]) users assigned" -ForegroundColor Green
Write-Host "App_Visio has $($VisioCount - $ServiceAccounts["App_Visio"]) users assigned" -ForegroundColor Yellow
