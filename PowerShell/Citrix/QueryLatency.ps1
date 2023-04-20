<#
    .SYNOPSIS
    Queries VDA servers for user sessions ICA Roundtrip & Network Latency useful when users are experiencing slowness.
    
    ICA RTT latency can increase when system performance is poor - If you determine the system to be running satisfactorily, and applications are having no issues.
    It's safe to say the issue is on the end-user side with poor network connectivity.

    This does exactly what HDX Monitor does - The only difference this will query all user sessions across ALL VDAs and list any users experiencing >65ms ICA RTT.

    https://support.citrix.com/article/CTX135817/hdx-monitor-3x

    Another useful tool for monitoring user performance is below
    
    https://support.citrix.com/article/CTX220774/connection-quality-indicator
  
    Author: Micheal.Thompson@itechnologies.com.au | Intuit Technologies
#>


$Servers = @("SF-VDA01", "SF-VDA02", "SF-VDA03", "SF-VDA04")
$HighLatencyUsers = @()

foreach ($Server in $Servers) {
 
 Get-CimInstance -ComputerName $Server -Namespace root\Citrix\EUEM -ClassName Citrix_Euem_RoundTrip | Select-Object SessionID, NetworkLatency, RoundtripTime, Timestamp, InputBandwidthAvailable, InputBandwidthUsed, PSComputerName | ForEach-Object {
 
    $ica_rtt = $_.RoundtripTime
    $netlat = $_.NetworkLatency
    $session = $_.SessionID
    $vda = $_.PSComputerName

    if ($ica_rtt -gt 65) {
        $quserResult = quser /server:$server 2>&1
	        if ( $quserResult.Count -gt 0 ) {
		        $quserRegex = $quserResult | ForEach-Object -Process { $_ -replace '\s{2,}',',' }
		        $quserObject = $quserRegex | ConvertFrom-Csv
		        $userSession = $quserObject | Where-Object -FilterScript { $_.ID -eq $session }
		        if ($userSession) {

                    $HighLatencyUsers += [PSCustomObject] @{
                    
                        Name = $userSession.USERNAME
                        Session = $session
                        Connected_VDA = $vda
                        ICA_RTT = $ica_rtt
                        NETWORK_LATENCY = $netlat
                    }
		        }
            }
        }
    }
}

$HighLatencyUsers | ForEach-Object {

    if ($_.ICA_RTT -gt 65 -and $_.ICA_RTT -lt 150) {
        Write-Host "$($_.Name) has greater than $($_.ICA_RTT)ms ICA Roundtrip & $($_.NETWORK_LATENCY)ms Network Latency connected to VDA $($_.Connected_VDA) with Session ID $($_.Session)" -ForegroundColor Yellow
    }

    if ($_.ICA_RTT -gt 150) {
        Write-Host "$($_.Name) has greater than $($_.ICA_RTT)ms ICA Roundtrip & $($_.NETWORK_LATENCY)ms Network Latency connected to VDA $($_.Connected_VDA) with Session ID $($_.Session)" -ForegroundColor Red
    }
}
