<#

    .SYNOPSIS
        We used to schedule all machines to pause during the evening as we could never set a specific machine to stay online during the night.
        So, because of that it would send false alerts saying machines are offline.

        I have developed a script that will periodically check if a machine is ONLINE, if it is not reachable the sensor will be paused as that means Citrix
        has turned the machine off.

    .AUTHOR
        Name: Micheal Thompson
        Company: Claratti Workspace : Claratti.com

#>


Start-Transcript -Path "C:\Windows\Temp\PRTG\prtglog.log"

Function Test-Server {
        [CmdletBinding()]
                
        # Parameters used in this function
        param
        ( 
            [Parameter(Position=0, Mandatory = $true, HelpMessage="Provide server names", ValueFromPipeline = $false)] 
            $ComputerName
        ) 
 
        $Array = @()
 
        ForEach($Server in $ComputerName) {
            $Server = $Server.Trim()
 
            Write-Verbose "Checking $Server"
 
            $SMB = $null
            $Object = $null
            $Status = $null
 
            $SMB = Test-Path "\\$server\c$"
 
            If($SMB -eq "True") {
                Write-Verbose "$Server is up"
                $Status = "True"
                $Object = New-Object PSObject -Property ([ordered]@{ 
                    Server            = $Server
                    IsOnline          = $Status
                })
    
                $Array += $Object

            } Else {

            Write-Verbose "$Server is down"
                $Status = "False"
                $Object = New-Object PSObject -Property ([ordered]@{ 
                      
                    Server            = $Server
                    IsOnline          = $Status
  
                })
    
                $Array += $Object
            }
        }
 
    If($Array) {
        return $Array
    }
}

$Auth = Connect-PrtgServer monitoring.claratti.com (New-Credential username password) -Force

# Iterate over Probe "Ambrose Building", get all devices where the devices name contains XD-ROOT

$Customer = "Ambrose Building"
$ServerNames = "XD-ROOT"

Get-Device *$($ServerNames)* | Where-Object probe -eq $Customer | ForEach-Object {

    $Device = $_
    $Server = Test-Server $Device.Name

    if ($Server.IsOnline -eq "True") {
        $Device | Resume-Object
        Write-Host "$($Device.Name) is running, resume the devices sensors." -ForegroundColor Green

    } else {

        $Device | Pause-Object -Forever -Message "The machine has been turned off, by Citrix autoscaling."
        Write-Host "$($Device.Name) is not currently turned on, pausing the devices sensors." -ForegroundColor Red
    }
}

Stop-Transcript
