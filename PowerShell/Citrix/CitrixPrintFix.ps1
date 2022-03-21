$Servers = @("HALL-XD-11", "HALL-XD-13", "HALL-XD-17", "HALL-XD-15", "HALL-XD-16", "XAHALL001A", "XACDCRA003", "XAHALL001B", "HALL-GPUSRV01", "HALL-GPUSRV02")


Foreach($Server in $Servers) {
    Get-service -ComputerName $Server | Where-Object { $_.DisplayName -match "Citrix Print Manager Service" } | ForEach-Object { 

        $Connection = (Test-Path \\$Server\c$)

        if ($Connection) {
            If ($_.Status -ne 'Running') {

                Get-service -ComputerName $Server | Where-Object { $_.DisplayName -match "Citrix Print Manager Service" } | Set-Service -Status Running

            } else { Write-Host $_.DisplayName is running on server $Server -ForegroundColor Yellow }
        }
    }
}
