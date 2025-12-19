Write-Host "Hello, This script is designed to fetch Disabled service accounts - and then iterate through the names found to return their MemberOf fields."

#Modify the Select-Object fields as needed. All Selectable Objects can be viewed by using 'get-aduser -Filter 'UserAccountControl -eq "66050"' -properties *' in a Powershell window. 

get-aduser -Filter 'UserAccountControl -eq "66050"' -properties * | Select-object DisplayName, SamAccountName, CanonicalName, Created, Description, userAccountControl | Export-csv -Path 'C:\Scripts\AD Export Scripts\Disabled_Accounts.csv'

Write-Host "Pulling Disabled Accounts from AD to Disabled_Accounts.csv"

$users = Import-CSV -Path "C:\Scripts\AD Export Scripts\Disabled_Accounts.csv"

Write-Host "Disabled Counts pulled. Creating MemberOf List"

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

$results | Export-Csv -Path "C:\Scripts\AD Export Scripts\DISABLED_ServiceAccountMemberOf.csv" -NoTypeInformation

Write-Host "Service Account list generated to DISABLED_ServiceAccountMemberOf.csv"
Read-Host "Press Enter to Exit. Happy Trails!"
