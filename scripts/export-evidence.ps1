$evd = "$PSScriptRoot\..\evidence\phase-0\txt"
New-Item -ItemType Directory -Path $evd -Force | Out-Null

git status | Out-File "$evd\03-git-status.txt" -Encoding utf8
terraform version | Out-File "$evd\02-tool-versions.txt" -Encoding utf8