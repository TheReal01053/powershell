<#Get-BrokerMachine | ForEach-Object {

    if ($_.MachineName -like "*CLAR-TECH*") {
    
    
        Write-Host $_.MachineName

        #Remove-BrokerMachine -MachineName $_.MachineName


    }
}

Get-AcctADAccount | ForEach-Object {

    if ($_.ADAccountName -like "*CLAR-TECH*") {
    
    
        #Write-Host $_.ADAccountName

        #Remove-AcctADAccount -ADAccountSid $_.ADAccountSid -IdentityPoolName "Clar-Tech-S2" -Force

        #Remove-BrokerMachine -MachineName $_.MachineName

    }

}

Get-AcctADAccount | ForEach-Object {

    if ($_.ADAccountName -like "*CLAR-TECH*") {
    
    
        #Write-Host $_.ADAccountName

        #Remove-AcctADAccount -ADAccountSid $_.ADAccountSid -IdentityPoolName "Clar-Tech-S2" -Force

        #Remove-BrokerMachine -MachineName $_.MachineName

    }

}#>
