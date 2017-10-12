[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$console_server = "10.211.55.16"
$target_server = "learning.puppetlabs.vm"


$body = @{

    "login"    = "admin"
    "password" = "puppetlabs"
    "lifetime" = "1h"
    "label"    = "personal workstation token"

}
$headers = @{'Content-Type' = 'application/json'}

$body = $body | ConvertTo-Json

$uri = "https://${console_server}:4433/rbac-api/v1/auth/token"

$result = Invoke-RestMethod -Uri $uri  -Headers $headers -Body $body -Method POST
$token = $result.token



# force run
$run_puppet_body = @{
    "environment" = "production"
    "scope"       = @{
        nodes = @("${target_server}")
    }
}

$run_puppet_body = $run_puppet_body | ConvertTo-Json
$run_puppet_header = @{"X-Authentication" = $token}


$run_url = "https://${console_server}:8143/orchestrator/v1/command/deploy"
 
$result = Invoke-RestMethod -Uri $run_url  -Headers $run_puppet_header -Body $run_puppet_body -Method POST

$result
$jobid = $result.job.name

$check_url = "https://${console_server}:8143/orchestrator/v1/jobs/$jobid"

$check_status = Invoke-RestMethod -Uri $check_url -Headers $run_puppet_header -Method get

$check_status

$check_status.status
