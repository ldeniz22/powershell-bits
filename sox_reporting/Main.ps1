#Prepping
$Date = (Get-Date -f "M-d-yyyy").ToString()
$fileName = "SOX-AD-Groups-$Date.zip"
$sourceFolder = ".\Results"
$OutputFileWithPath = ".\HistoricResults\$fileName"

#Run Scripts
Write-Host "Running script Get-ADAllAccounts.ps1"
C:\scripts\Repository\CORP\SOX\Get-ADAllAccounts.ps1
Write-Host "Running script Get-ADEnabledAccounts.ps1"
C:\scripts\Repository\CORP\SOX\Get-ADEnabledAccounts.ps1
Write-Host "Running script Get-DomainAdmins.ps1"
C:\scripts\Repository\CORP\SOX\Get-DomainAdmins.ps1
Write-Host "Get-LocalAdministrators-Groups.ps1"
C:\scripts\Repository\CORP\SOX\Get-LocalAdministrators-Groups.ps1

#Prepare zip file
Get-ChildItem -Recurse $sourceFolder | Write-Zip -OutputPath $OutputFileWithPath -IncludeEmptyDirectories -EntryPathRoot $sourceFolder -confirm:$false

#Clean up!
Remove-Item "$sourcefolder\*" -Recurse -Force

#Communicate script completed
Write-Host "Done!"
