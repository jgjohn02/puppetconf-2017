# curl -k -X POST -H 'Content-Type: application/json' -d '{"login": "<YOUR PE USER NAME>", "password": "<YOUR PE PASSWORD>"}' https://$<HOSTNAME>:4433/rbac-api/v1/auth/token`
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

$classifer_api_endpoint = "https://${Console_server}:4433/classifier-api/v1/groups"

$groups = Invoke-RestMethod -Uri $classifer_api_endpoint -Headers $auth_header -Method get

$allnode_id = ($groups | where name -eq "All Nodes").id

$group_to_add = @{
    "name"        = "2humana_clasgroups+22"
    "description" = "group to hold roles and profiles2"
    "parent"      = $allnode_id
    "classes"     = @{}
}

$header_for_groupadd = @{
    "X-Authentication" = $token
    'Content-Type'     = 'application/json'
}


$group_to_add = $group_to_add | ConvertTo-Json


$add_group = Invoke-RestMethod -Uri $classifer_api_endpoint -Headers $header_for_groupadd -Body $group_to_add -Method Post