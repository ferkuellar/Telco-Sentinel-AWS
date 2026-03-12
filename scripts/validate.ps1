Write-Host "Running local validation..."
Set-Location "$PSScriptRoot\..\terraform\envs\dev"

terraform fmt -check -recursive
terraform init
terraform validate