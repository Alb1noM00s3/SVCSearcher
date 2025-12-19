# SVCSearcher
SVCSearcher is a set of powershell scripts designed to find enabled and disabled Service Accounts across your Active Directory Deployment. SVCSearcher uses UserAccountControl flags to find help surface Service Accounts that don't follow a traditional naming convention, or Service Accounts that have broken standard naming convention.

SVCSearcher scripts all contain an export to .csv function, and will create the directory for storage if it does not exist on the host machine. 

These scripts are a great launch point, and the 'Select-Object' field can be modifed to return different values if desired.

Happy Hunting!
-Moosey
