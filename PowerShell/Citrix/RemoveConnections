$Path = "xdhyp:\HostingUnits\"

#Remove bulk connections by name
$ConnNames @(
    "TPC Finance",
    "TPC Finance - vCenter NEW"
    "TPC Fin - vCenter"
    "Lawmac - vCenter"
    "Lawamc - S2"
    "Hall Contracting SubA"
    "Hall Contracting SubB"
    "DiamondTEST"
    "Claratti Workspace Old"
    "ClarattiDesktopSUBA",
    "ClarattiDesktopSUBB",
    "AmbroseSubA"
    
)

$ConstConnName = @("Claratti - vCenter", "Claratti - vCenter NEW", "Claratti-10gb")

#Use this if wanting to delete any connection that isn't equal to the ones apart of $ConstConnName array
#Useful for deleting all connections expect for specific ones you wish to keep
foreach($constConn in $ConstConnName) {
    $Name = Get-ChildItem -Path $Path -Name
    if ($Name -ne $ConstConnName) { 
        Remove-Item -Path (Join-Path ($Path, $constConn))
    }

}

#Use this if wanting to remove/delete bulk connections that are described in the $ConnNames array
<#foreach($conn in $ConnNames) {

    Remove-Item -Path (Join-Path ($Path, $conn))
    
}#>
