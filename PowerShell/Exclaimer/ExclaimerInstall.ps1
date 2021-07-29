function Get-MsiDatabaseVersion {
    param (
        [string] $fn
    )

    try {
        $FullPath = (Resolve-Path $fn).Path
        $windowsInstaller = New-Object -com WindowsInstaller.Installer

        $database = $windowsInstaller.GetType().InvokeMember(
                "OpenDatabase", "InvokeMethod", $Null, 
                $windowsInstaller, @($FullPath, 0)
            )

        $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
        $View = $database.GetType().InvokeMember(
                "OpenView", "InvokeMethod", $Null, $database, ($q)
            )

        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)

        $record = $View.GetType().InvokeMember(
                "Fetch", "InvokeMethod", $Null, $View, $Null
            )

        $productVersion = $record.GetType().InvokeMember(
                "StringData", "GetProperty", $Null, $record, 1
            )

        $View.GetType().InvokeMember("Close", "InvokeMethod", $Null, $View, $Null)

        return $productVersion

    } catch {
        throw "Failed to get MSI file version the error was: {0}." -f $_
    }
}

$ExclaimerExists = Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where {$_.DisplayName -like "Exclaimer Cloud Signature Update Agent*"} -ErrorAction SilentlyContinue
$ExclaimerVersion = Get-WmiObject Win32_Product | where { $_.Vendor -eq "Exclaimer Ltd" }
$Installdir = "\\lawmac-fs01\utilities$\Exclaimer" 
$nl = [Environment]::NewLine 

Start-Transcript (Join-Path $env:LOCALAPPDATA "temp\exclaimer\exclaimer.log")

Function Get-Download {
    Write-Host "Downloading"
    New-Item -Path $Installdir -ItemType directory -ErrorAction SilentlyContinue
   
    $source = "https://outlookclient.exclaimer.net/csua/Exclaimer.CloudSignatureUpdateAgent.Install.msi"  
    $destination = "$Installdir\Exclaimer.CloudSignatureUpdateAgent.Install.msi"  
    Invoke-WebRequest $source -OutFile $destination -ErrorAction SilentlyContinue
   
    Start-Sleep -s 10 # sleeps for 60 seconds to allow for time for the software to download ... 
  
    $Version = Get-MsiDatabaseVersion "$($Installdir)\Exclaimer.CloudSignatureUpdateAgent.Install.msi" -ErrorAction SilentlyContinue
	
	Write-Host "Current Version Installed: $($ExclaimerVersion.Version)"
	Write-Host "Current Version Released: $($Version)"

    $FormattedVersion = @("$($Version)".Replace(".", ""), "$($ExclaimerVersion.Version)".Replace(".", ""))

    if ([int]$FormattedVersion[1] -ne [int]$FormattedVersion[0]) {
        Write-Host "New Version Found Installing..."
        #Start-Process -FilePath "$Installdir\Exclaimer.CloudSignatureUpdateAgent.Install.msi" -ErrorAction SilentlyContinue
    } else {
        Write-Host "Latest Version Installed"
    }

    Stop-Transcript
}

Get-Download
