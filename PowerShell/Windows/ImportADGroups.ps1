$ADGroups = Import-Csv (Join-Path $PSScriptRoot "ADGroups.csv")
$OrgUnit = @("OU=Fldr,OU=Groups,OU=HALL.LOCAL,DC=HALL,DC=LOCAL", "OU=Special,OU=Fldr,OU=Groups,OU=HALL.LOCAL,DC=HALL,DC=LOCAL")

foreach ($group in $ADGroups) {
    $Name = $group.Name
    $Category = $group.Category
    $Scope = $group.Scope

    if ($Name -like "*Special*") {
        New-ADGroup -Name $Name -SamAccountName $Name -GroupCategory $Category -GroupScope $Scope -Path $OrgUnit[1]
        Write-Host "$($Name) has been created as a $($Category) group under the Fldr\Special directory" -ForegroundColor Yellow
    } else {
        New-ADGroup -Name $Name -SamAccountName $Name -GroupCategory $Category -GroupScope $Scope -Path $OrgUnit[0]
        Write-Host "$($Name) has been created as a $($Category) group under the Fldr directory" -ForegroundColor Yellow
    }
}
