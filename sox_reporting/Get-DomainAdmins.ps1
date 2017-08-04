Import-Module ActiveDirectory
$groupname = "Domain Admins"
$timestamp = Get-date -f MM-dd-yyyy_HH_mm_ss
$exportDirectory = "C:\path\Report-DomainAdmins_$timestamp.csv"

Get-ADGroupMember $groupname -recursive | Select Name,sAMAccountNAme,DistinguishedName | Export-csv $exportDirectory -NoTypeInformation