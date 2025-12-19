Write-Host "Hello, This script is designed to fetch Enabled service accounts - and then iterate through the names found to return their MemberOf fields."

#Modify the Select-Object fields as needed. All Selectable Objects can be viewed by using 'get-aduser -Filter 'UserAccountControl -eq "66048"' -properties *' in a Powershell window. 

get-aduser -Filter 'UserAccountControl -eq "66048"' -properties * | Select-object DisplayName, SamAccountName, CanonicalName, Created, Description, userAccountControl, PasswordLastSet, Enabled | Export-csv -Path 'C:\Scripts\AD Export Scripts\Enabled_Accounts.csv'


Write-Host "Pulling Enabled Accounts from AD to Enabled_Accounts.csv"

$users = Import-CSV -Path "C:\Scripts\AD Export Scripts\Enabled_Accounts.csv"

Write-Host "Enabled Accounts pulled. Creating MemberOf List"

Read-Host "Press Enter to Exit. Happy Trails!"
