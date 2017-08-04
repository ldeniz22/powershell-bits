

Import-Module ActiveDirectory
$old = 120 #how many days is old
$TargetOU = "OU=OldComputerObjects,DC=corp,DC=mycompany,DC=com"
$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$today = Get-Date
$oldObjects = @()
$usedObjects = @()
$filters = {(OperatingSystem -like '*Windows 10*')}
$allComputerObjects = Get-ADComputer -filter $filters -SearchBase "OU=DC=corp,DC=mycompany,DC=com" -properties pwdLastSet, OperatingSystem `
| select-object Name, OperatingSystem, @{n="PwdLastSet";e={[datetime]::FromFileTime($_.PwdLastSet)}}, DistinguishedName
$exportDirectory = "C:\scripts\Repository\CORP\AD Cleanup\Results\Inactive-Windows10_$timestamp.csv"

foreach ($computerObject in $allComputerObjects){
    if (($today - $computerObject.PwdLastSet).Days -ge $old){
        $oldObjects += $computerObject
        $obj = Get-ADComputer $computerObject.Name
        #Move-ADObject $obj.ObjectGUID -TargetPath $TargetOU
        #Disable-ADAccount $obj.ObjectGUID
    }
}

$oldObjects | Export-Csv $exportDirectory -NoTypeInformation



<#
#$oldObjects = Import-Csv "C:\scripts\Repository\CORP\AD Cleanup\Revised - Old.csv"
#foreach ($oldObject in $oldObjects){
#    $name = $oldObject.Name
#    $object = Get-ADComputer $name
#    #Move-ADObject $object -TargetPath $TargetOU
#  
#    Write-Host "Object $name has been moved"
#
}
#>

