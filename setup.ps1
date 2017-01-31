Install-WindowsFeature -Name Web-Server
Install-WindowsFeature -Name Web-Windows-Auth
Install-WindowsFeature -Name Web-WHC

$tempFile = [System.IO.Path]::GetTempFileName() |        
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } –PassThru
Invoke-WebRequest -Uri http://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/DotNetCore.1.0.0-WindowsHosting.exe -OutFile $tempFile

$logFile = [System.IO.Path]::GetTempFileName()


$proc = (Start-Process $tempFile -PassThru "/quiet /install /log $logFile")
$proc | Wait-Process
Get-Content $logFile

Restart-Service -Name W3SVC
