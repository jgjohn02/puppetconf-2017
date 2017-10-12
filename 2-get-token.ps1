# curl -k -X POST -H 'Content-Type: application/json' -d '{"login": "<YOUR PE USER NAME>", "password": "<YOUR PE PASSWORD>"}' https://$<HOSTNAME>:4433/rbac-api/v1/auth/token`
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$Console_server = "10.211.55.16"

$body = @{

    "login"    = "admin"
    "password" = "puppetlabs"
    "lifetime" = "1h"
    "label"    = "personal workstation token"

}
$headers = @{'Content-Type' = 'application/json'}

$body = $body | ConvertTo-Json

$uri = "https://${Console_server}:4433/rbac-api/v1/auth/token"

$result = Invoke-RestMethod -Uri $uri  -Headers $headers -Body $body -Method POST
$token = $result.token


$list_usrs_uri = "https://${Console_server}:4433/rbac-api/v1/users"
$auth_header = $headers = @{"X-Authentication" = $token}

$users = Invoke-RestMethod -Uri $list_usrs_uri -Headers $auth_header