
$Date = Get-Date -Format "yyyyMMdd"
Start-Transcript ftplog_$($Date).txt
& "C:\Program Files (x86)\WinSCP\WinSCP.com" `
   /ini=nul `
  /command `
    "open ftp://username:password@ftp.transvirtual.com.au/" `
    "put -transfer=ascii E:\Apps\INTECH\PROGS\ftpsend\zTEST_ALAN_download_inscon_mascot*.csv" `
    "put -transfer=ascii E:\Apps\INTECH\PROGS\ftpsend\zTEST_ALAN_download_inscon_rosebery*.csv"`
    "exit"

$winscpResult = $LastExitCode
if ($winscpResult -eq 0)
{
  Write-Host "Success"
  cmd.exe /c "sendemail.exe -f intech@instyle.com.au -t micheal.thompson@claratti.com -u "Hunters Consignment Upload Successful" -m "FTP Upload Successful" -s smtp.sendgrid.net:587 -xu apikey -xp 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 -l ftpsendmail.log"
  cmd.exe /c "sendemail.exe -f intech@instyle.com.au -t micheal.thompson@claratti.com -u "Hunters Consignment Upload Successful" -m "FTP Upload Successful" -a "ftplog_$($Date).txt" -s smtp.sendgrid.net:587 -xu apikey -xp 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 -l ftpsendmail.log"
  cmd.exe /c "move download_inscon*.csv ftpsent\"
}
else
{
  Write-Host "Error"
  cmd.exe /c "sendemail.exe -f intech@instyle.com.au -t micheal.thompson@claratti.com -u "Hunters Consignment Upload FAILED" -m "FTP Upload Failed" -s smtp.sendgrid.net:587 -xu apikey -xp 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 -l ftpsendmail.log"
}

Stop-Transcript

Move-Item "ftplog_$($Date).txt" -Destination "ftpsent\ftplog_$($Date).txt"

exit $winscpResult
