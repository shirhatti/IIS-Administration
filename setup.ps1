Install-WindowsFeature -Name Web-Server
Install-WindowsFeature -Name Web-Windows-Auth

$tempFile = [System.IO.Path]::GetTempFileName() |
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } -PassThru
Invoke-WebRequest -Uri https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe -OutFile $tempFile

$logFile = [System.IO.Path]::GetTempFileName()

$proc = (Start-Process $tempFile -PassThru "/quiet /install /log $logFile")
$proc | Wait-Process
Get-Content $logFile

$tempFile = [System.IO.Path]::GetTempFileName() |
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } -PassThru
Invoke-WebRequest -Uri https://download.microsoft.com/download/7/8/5/7852163D-1A56-4642-84B6-60A8537343EF/dotnet-win-x64.1.0.5.exe -OutFile $tempFile

$logFile = [System.IO.Path]::GetTempFileName()


$proc = (Start-Process $tempFile -PassThru "/quiet /install /log $logFile")
$proc | Wait-Process
Get-Content $logFile

Restart-Service -Name W3SVC

$tempFile = [System.IO.Path]::GetTempFileName() |
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } -PassThru
Invoke-WebRequest -Uri https://download.microsoft.com/download/A/A/7/AA751AE2-010E-404E-AF5E-67016A2415D3/2.0.0/IISAdministrationSetup.exe -OutFile $tempFile

$logFile = [System.IO.Path]::GetTempFileName()


$proc = (Start-Process $tempFile -PassThru "/quiet /install /log $logFile")
$proc | Wait-Process
Get-Content $logFile

New-NetFirewallRule -DisplayName "IIS.Administration" -Direction Inbound  -Action Allow -Protocol TCP -LocalPort 55539
