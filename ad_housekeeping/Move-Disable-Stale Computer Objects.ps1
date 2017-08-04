Import-Module ActiveDirectory

$todaysDateTime = get-date 
$todaysShortDate = $todaysDateTime.ToShortDateString() 
$todaysTime = $todaysDateTime.ToShortTimeString() 
$targetpath = "OU=OldComputerObjects,DC=subdoman,DC=microstrategy,DC=com"
$dc = 'mydomaincontroller.com'
$todaysModdedShortDate = $todaysShortDate.Replace("/", "-") 
$Date = [DateTime]::Today


#Sets the deadline for when computers should have last changed their password by.
$Deadline = $Date.AddDays(-160)   
#Path to output file
$csvFilePath = ".\Results"

#Generates a list of computer accounts that are enabled and aren't in the OldComputerObjects OU, but haven't set their password since $Deadline (120 days)
#Excludes any objects in OldComputerObjects OU, creates a log with list of computer objects  
$Computers = Get-ADComputer -Server labs-dc4-was -Filter {(PasswordLastSet -le $Deadline) -and (Enabled -eq $TRUE)} -Properties PasswordLastSet, ObjectGUID,Description, DistinguishedName  -ResultSetSize $NULL |
Where {$_.DistinguishedName -notlike "*OldComputerObjects*"} | Sort-Object -property Name | select Name,PasswordLastSet,ObjectGUID, DistinguishedName, Enabled $Computers | export-csv "$csvFilePath\Staled_Computers_$todaysModdedShortDate.csv" -NoTypeInformation

#Moves the object to 'OldComputerObjects' OU then disables
#Adds comment in the Description line of Time & Date it was disabled
ForEach ($Computer in $Computers)
{
Move-ADObject -Server labs-dc4-was $Computer.ObjectGUID -TargetPath $targetpath
Add-Content "$csvFilePath\Staled_Computers_$todaysModdedShortDate.csv" -Value "Found $Computer, disabling"

Disable-ADAccount -Server $dc -Identity $computer.ObjectGUID
Set-ADComputer -Server $dc $Computer.name -Description "Disabled on $($todaystime), $($todaysModdedShortDate)" -Enabled $false 
}
