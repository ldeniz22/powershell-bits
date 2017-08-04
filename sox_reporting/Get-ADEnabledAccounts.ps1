Import-Module ActiveDirectory
$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$exportDirectory = "C:\path\Report-EnabledADAccounts_$timestamp.csv"


$pattern = "\d+"
$activeAccnts = Get-ADUser -Filter {Enabled -eq $True} -Properties mail, Description, Created, LastLogonDate | where-object {$_.Description -match $pattern}
#$activeAccnts | select-object @{Name="Email_ID";Expression={$_.mail}}, SamAccountName, Description, Created, LastLogonDate  | export-csv $exportDirectory -NoTypeInformation
$activeAccnts  | Select Name,sAMAccountNAme,Enabled, Created, LastLogonDate, DistinguishedName| export-csv $exportDirectory -NoTypeInformation
