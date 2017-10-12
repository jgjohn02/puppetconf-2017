
$serverip = "10.211.55.16"

$results = Invoke-WebRequest -Uri http://${serverip}:8123/status/v1/services | ConvertFrom-json
$results_json = Invoke-RestMethod -Uri http://${serverip}:8123/status/v1/services 
#now that we have results lets go crazy with data!



$results.'classifier-service'.status
$results.'classifier-service'.state


if ($results.'classifier-service'.state -eq "running"){

[System.Windows.MessageBox]::Show('classifer is good')
}
else{

Write-Output " something is up"
}
