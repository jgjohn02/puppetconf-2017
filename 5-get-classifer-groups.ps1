
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$pe_console_server = '10.211.55.16'
$cred = Get-Credential 

$login = $cred.UserName
$password = $cred.GetNetworkCredential().password

$body = @{

    "login"    = $login
    "password" = $password
    "lifetime" = "1h"
    "label"    = "personal token"

}
$headers = @{'Content-Type' = 'application/json'}

$body = $body | ConvertTo-Json

$uri = "https://${pe_console_server}:4433/rbac-api/v1/auth/token"

$result = Invoke-RestMethod -Uri $uri -Headers $headers -Body $body -Method POST
$token = $result.token


$auth_header = $headers = @{"X-Authentication" = $token}
$uri = "https://${pe_console_server}:4433/classifier-api/v1/groups"

$a = Invoke-RestMethod -Uri $uri -method Get -Headers $auth_header 

$a

#filter examples


$a | where environment -eq "production" | select name
$a | where environment -eq "production" | where name -NotLike "PE*" | select name