$path = "C:\SVC_Searcher\"

Write-Host "SVC Searcher initiating, Pulling Service Accounts Now"

#Create Path for Storage of Output

If (!(test-path $path))
    {
        md $path
    }

# Grab Enabled, Password Never Expires accounts, and export to CSV.

get-aduser -Filter 'UserAccountControl -eq "66048"' -properties * | Select-object DisplayName, SamAccountName, CanonicalName, Created, Description, userAccountControl | Export-csv -Path 'C:\SVC_Searcher\Enabled_Accounts.csv'

# Grab Disabled, Password Never Expires Accounts, and export to CSV.

get-aduser -Filter 'UserAccountControl -eq "66050"' -properties * | Select-object DisplayName, SamAccountName, CanonicalName, Created, Description, userAccountControl | Export-csv -Path 'C:\SVC_Searcher\Disabled_Accounts.csv'

Write-Host "Service Account list generated. CSV files located at C:\SVC_Searcher"
Read-Host "Press Enter to Exit. Happy Trails!"
