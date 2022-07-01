param($org_alias, $auth_url)

sfdx force:data:bulk:upsert -s Date__c -f "data/Dates_Data.csv" -i ID 
sfdx force:data:bulk:upsert -s AD_Account__c -f "data/AD Stations Facility Upsert With Record.csv" -i ID

#Schedule Batch Jobs
sfdx force:apex:execute -f schedule-batch-jobs.apex

#Deploy Email Alert
sfdx force:source:deploy -m Workflow:Case

#Create Contact Roles
sfdx force:apex:execute -f apex/create-contacts-roles.apex   

#Create Users
Add-Content -Path temp-create-users.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-create-users.apex (Get-Content "apex/create-users.apex")
sfdx force:apex:execute -f temp-create-users.apex

#Create Accounts
sfdx force:apex:execute -f apex/create-accounts.apex

#Create Contacts
Add-Content -Path temp-create-contacts.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-create-contacts.apex (Get-Content "apex/create-contacts.apex")
sfdx force:apex:execute -f temp-create-contacts.apex

#Assign PermSets
Add-Content -Path temp-permset-assign.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-permset-assign.apex (Get-Content "apex/permset-assign.apex")
sfdx force:apex:execute -f temp-permset-assign.apex

#Assign Groups
Add-Content -Path temp-group-assign.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-group-assign.apex (Get-Content "apex/group-assign.apex")
sfdx force:apex:execute -f temp-group-assign.apex

#Create Accounts from Primary Office Groups
sfdx force:apex:execute -f apex/primary-office-accounts.apex

# Create Contacts for Accounts of Primary Office Groups
sfdx force:apex:execute -f apex/primary-office-contacts-1.apex
sfdx force:apex:execute -f apex/primary-office-contacts-2.apex
sfdx force:apex:execute -f apex/primary-office-contacts-3.apex

# Setup Tiger Team FQs
sfdx force:apex:execute -f apex/setup-tiger-team-fq.apex      