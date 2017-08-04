Import-Module ActiveDirectory
$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$exportDirectory = "C:\path\Report-AllADAccounts_$timestamp.csv"


$pattern = "\d+"
$activeAccnts = Get-ADUser -Filter * -Properties mail, Description, Created, LastLogonDate | where-object {$_.Description -match $pattern}
$activeAccnts  | Select Name,sAMAccountNAme,Enabled, Created, LastLogonDate, DistinguishedName| export-csv $exportDirectory -NoTypeInformation
