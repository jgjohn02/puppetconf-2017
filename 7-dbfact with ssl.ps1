[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$db_server = '10.211.55.16'

$header = @{'Content-Type'= 'application/json'}

$Body = '{}'

$cert = get-pfxCertificate Z:\Desktop\api-pupcert.pfx

$resttest = Invoke-RestMethod -Uri https://${db_server}:8081/pdb/query/v4/facts -Method Post -Certificate $cert -Headers $header -Body $body

$resttest