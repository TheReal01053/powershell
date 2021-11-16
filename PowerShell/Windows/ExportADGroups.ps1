$Results = @()

$OrgUnit = "OU=Folder,OU=Security Groups,OU=hall,DC=hall,DC=local"

$ADGroup = Get-ADGroup -Filter * -SearchBase $OrgUnit | ForEach-Object {

    $Name = $_.Name
    $Category = $_.GroupCategory
    $Scope = $_.GroupScope

    Write-Host $Name

    $Groups = New-Object -TypeName psobject -Property @{
        Name = $Name
        Category = $Category
        Scope = $Scope
    }

   $Results += $Groups
}

$Results | export-csv -Path "C:\Windows\Temp\ADGroups.csv"
