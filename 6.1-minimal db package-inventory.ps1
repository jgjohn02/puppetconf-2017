
$db_server = "10.211.55.16"

$header = @{'Content-Type'= 'application/json'}
$cert = Get-PfxCertificate Z:\Desktop\api-pupcert.pfx
$a = Invoke-RestMethod -Uri http://${db_server}:8080/pdb/query/v4/package-inventory -method get
$a



$a | where package_name -Like "*jso*"

$a | where provider -eq "gem"