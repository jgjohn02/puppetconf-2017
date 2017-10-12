add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy



$Console_server = "10.211.55.16"
$cred = Get-Credential 

$login = $cred.UserName
$password = $cred.GetNetworkCredential().password
$puppetenv = "production"

$body = @{

    "login"    = $login
    "password" = $password
    "lifetime" = "1h"
    "label"    = "personal token"

}
$headers = @{'Content-Type' = 'application/json'}

$body = $body | ConvertTo-Json

$uri = "https://${Console_server}:4433/rbac-api/v1/auth/token"

$result = Invoke-RestMethod -Uri $uri  -Headers $headers -Body $body -Method POST
$token = $result.token


#$list_usrs_uri = "https://${Console_server}:4433/rbac-api/v1/users"

$force_sync_url = "https://${Console_server}:8170/code-manager/v1/deploys?token=${token}"



$force_sync_body = @{

    environments =@("$puppetenv")
    wait = "true"

}
$force_sync_body = $force_sync_body | Convertto-Json  

$force_sync = Invoke-RestMethod -Uri $force_sync_url -Headers $headers -Body $force_sync_body -Method Post


$force_sync  

