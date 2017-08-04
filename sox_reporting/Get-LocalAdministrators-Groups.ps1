# Purpose: This script retrieves the list of local administrators from the servers contained in the specified sourcefile and creates a csv report with the local administrators.
# This script also generates a second report with the members of each domain group found.

$timestamp = Get-Date -format  MM-dd-yyyy_HH_mm_ss
$sourcefile = "C:\path\SOXServers.csv"
$resultfile = "C:\path\Report-ADGroups_$timestamp.csv"

$list = Import-Csv $sourcefile 
$objreport = $accountType = $groupReport = $null
$groups = @()

foreach ($server in $list){
$computername = $server.name.Trim()
    $application = $server.KeyApplication
    $computername = $computername.toupper()
    
    $computername
    
    $admins = get-wmiobject -computername $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='administrators'""" | % {$_.partcomponent}
    foreach ($admin in $admins) {
        #Write-Host "$ADMIN"
        if ($admin -match 'Win32_UserAccount'){
                #Account is user
                $accountType = "User Account"
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_UserAccount.Domain=","") 
                $admin = $admin.replace('",Name="',"\")
                $admin = $admin.replace('"',"")

        }elseif ($admin -match 'Win32_Group'){
                #Account is group
                $accountType = "Domain Group"
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('",Name="',"\")
                $admin = $admin.replace('"',"")
                if ($groups -notcontains $admin){
                    #$admin
                    #$groupname = $admin.split("\")[1]
                    #$members = Get-ADGroupMember -recursive $groupname
                    $groups += $admin
                }
        }else{
                $accountType = $null
        }
      
       # Write-Host "--$admin is a $accountType"
        $objOutput = New-Object PSObject -Property @{
            KeyApplication = $application
            Machinename = $computername
            DomainName = $admin.split("\")[0]
            UserName = $admin.split("\")[1]
            AccountType =  $accountType
        }
    $objreport+=@($objoutput)
    }#end for#>
} #end foreach 

$objreport | Select Username, AccountType, DomainName, MachineName, KeyApplication | Export-Csv $resultfile -NoTypeInformation 



foreach ($group in $groups){

    $domainName = $group.split("\")[0]
    $groupName = $group.split("\")[1]

    #Get PDC of the group domain
    $pdc = (nltest /dcname:$domainName) -join " "
    $pdc =  $pdc.split("\\")[2]  
    $pdc = $pdc.split(" ")[0]
    $members = Get-ADGroupMember -recursive $groupname -server $pdc 

    foreach ($member in $members){
         $objOutput = New-Object PSObject -Property @{
            Group = $group
            SamAccountName = $member.SamAccountName
            Fullname =  $member.name
        }
        $groupReport+=@($objoutput)

    }

}

$groupReport | Export-Csv $groupsfile -NoTypeInformation 

