#Log console output to log file
Start-Transcript -Path "C:\Logs\LogoffRequest_Log.txt"

#send POST request to /gameLogout
$username = Get-Content C:\Code\logoff\username.txt

if(!$username){
    exit
}

$hash = @{ username = $username.ToString() } #ToString() to only get contents, and not additional data about file

$JSON = $hash | convertto-json 

Write-Host $JSON

$Response = Invoke-WebRequest -uri "https://crispy-space-umbrella-9rgj7xprq56f76jw-3000.app.github.dev/gameLogout" `
            -Method POST -Body $JSON -ContentType "application/json"