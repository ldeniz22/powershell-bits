# Created  Luis de Niz 5/4/2016

Import-Module ActiveDirectory

$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$today = Get-Date
$oldObjects = @()
$usedObjects = @()
$exportDirectory = "C:\path\All-WindowsServers_$timestamp.csv"
$filterAttribute = {OperatingSystem -Like '*Windows Server*'}

$allComputerObjects = Get-ADComputer -filter $filterAttribute -SearchBase "DC=corp,DC=mycompany,DC=com" -Properties Name, OperatingSystem, DistinguishedName | Where {($_.DistinguishedName -like "*Datacenters*") -or ($_.DistinguishedName -like "*Domain Controllers*")} | Select Name, OperatingSystem, DistinguishedName
$allComputerObjects | Export-Csv $exportDirectory -NoTypeInformation
