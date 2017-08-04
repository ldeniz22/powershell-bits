Import-Module ActiveDirectory
$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$date = Get-Date
$exportDirectory = "C:\scripts\Repository\CORP\AD Cleanup\Results\Report-InactiveComputersLastLogon_$timestamp.csv"

$90Days = $date.adddays(-90)
$filterAttributes = {(lastlogondate -le $90days)}

#$ComputerObjects = Get-ADComputer -Filter $filterAttributes -SearchBase "OU=Datacenters,OU=NA,OU=MicroStrategy Enterprise,DC=corp,DC=mycompany,DC=com"
$ComputerObjects = Get-ADComputer -Filter $filterAttributes -SearchBase "OU=Test/Dev,OU=Datacenters,DC=outside_service,DC=com" -Server myserver


$inactiveAccnts = Get-ADComputer -Filter $filterAttributes -Properties mail, Description, Created, LastLogonDate, DistinguishedName | where-object {$_.Description -match $pattern}
$inactiveAccnts  | Select Name,sAMAccountNAme,Enabled, Created, LastLogonDate, DistinguishedName, Description| export-csv $exportDirectory -NoTypeInformation