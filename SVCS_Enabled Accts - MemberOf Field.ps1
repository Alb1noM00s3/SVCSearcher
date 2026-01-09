$path = "C:\SVC_Searcher\"

#Create Path for Storage of Output

If (!(test-path $path))
    {
        md $path
    }

Write-Host "  _____________   _____________     _________                           .__                  
 /   _____/\   \ /   /\_   ___ \   /   _____/ ____ _____ _______   ____ |  |__   ___________ 
 \_____  \  \   Y   / /    \  \/   \_____  \_/ __ \\__  \\_  __ \_/ ___\|  |  \_/ __ \_  __ \
 /        \  \     /  \     \____  /        \  ___/ / __ \|  | \/\  \___|   Y  \  ___/|  | \/
/_______  /   \___/    \______  / /_______  /\___  >____  /__|    \___  >___|  /\___  >__|   
        \/                    \/          \/     \/     \/            \/     \/     \/       "

#Modify the Select-Object fields as needed. All Selectable Objects can be viewed by using 'get-aduser -Filter 'UserAccountControl -eq "66048"' -properties *' in a Powershell window. 

get-aduser -Filter 'UserAccountControl -eq "66048"' -properties * | Select-object DisplayName, SamAccountName, CanonicalName, Created, Description, userAccountControl | Export-csv -Path 'C:\SVC_Searcher\Enabled_Accounts.csv'

Write-Host "Pulling Enabled Accounts from AD to Enabled_Accounts.csv"

$users = Import-CSV -Path "C:\SVC_Searcher\Enabled_Accounts.csv"

Write-Host "Enabled Accounts pulled. Creating MemberOf List"

$results = @()

foreach ($user in $users) {
    $sam = $user.SamAccountName
    if ($sam) {
        try {
            $groups = Get-ADPrincipalGroupMembership -Identity $sam | Select-Object -ExpandProperty Name
            $results += [PSCustomObject]@{
                SamAccountName = $sam
                Groups         = $groups -join '; '
            }
        } catch {
            Write-Host "Failed to get groups for $sam"
            $results += [PSCustomObject]@{
                SamAccountName = $sam
                Groups         = "Error retrieving groups"
            }
        }
    } else {
        Write-Host "SamAccountName is missing in one of the rows."
    }
}

$results | Export-Csv -Path "C:\SVC_Searcher\ENABLED_ServiceAccountMemberOf.csv" -NoTypeInformation

Write-Host "Service Account list generated to ENABLED_ServiceAccountMemberOf.csv"
Read-Host "Press Enter to Exit. Happy Trails!"
