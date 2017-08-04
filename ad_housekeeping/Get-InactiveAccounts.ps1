Import-Module ActiveDirectory
$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$date = Get-Date
$exportDirectory = "C:\scripts\Repository\CORP\AD Cleanup\Results\Report-InactiveEmployeeAccounts_$timestamp.csv"

$90Days = $date.adddays(-90)
#Employee accounts have employee number in the description attribute
$pattern = "^\d+$"
$filterAttributes = {(lastlogondate -notlike "*" -OR lastlogondate -le $90days) -AND (passwordlastset -le $90days) -AND (enabled -eq $True)  -AND (whencreated -le $90days)}

$inactiveAccnts = Get-ADUser -Filter $filterAttributes -Properties mail, Description, Created, LastLogonDate, DistinguishedName | where-object {$_.Description -match $pattern}
$inactiveAccnts  | Select Name,sAMAccountNAme,Enabled, Created, LastLogonDate, DistinguishedName, Description| export-csv $exportDirectory -NoTypeInformation