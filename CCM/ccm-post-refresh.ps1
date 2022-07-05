param($auth_url, $username, $org_alias )

sfdx force:data:bulk:upsert -s Date__c -f "../views-post-refresh/CCM/data/Dates_Data.csv" -i ID -u $username
sfdx force:data:bulk:upsert -s AD_Account__c -f "../views-post-refresh/CCM/data/AD Stations Facility Upsert With Record.csv" -i ID -u $username

#Schedule Batch Jobs
sfdx force:apex:execute -f ../views-post-refresh/CCM/schedule-batch-jobs.apex -u $username 

#Deploy Email Alert
sfdx force:source:deploy -m Workflow:Case -u $username 

#Create Contact Roles
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/create-contacts-roles.apex  -u $username 

#Create Users
Add-Content -Path temp-create-users.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-create-users.apex (Get-Content "../views-post-refresh/CCM/apex/create-users.apex")
sfdx force:apex:execute -f temp-create-users.apex -u $username 

#Create Accounts
sfdx force:apex:execute -f apex/create-accounts.apex

#Create Contacts
Add-Content -Path temp-create-contacts.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-create-contacts.apex (Get-Content "../views-post-refresh/CCM/apex/create-contacts.apex")
sfdx force:apex:execute -f temp-create-contacts.apex -u $username 

#Assign PermSets
Add-Content -Path temp-permset-assign.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-permset-assign.apex (Get-Content "../views-post-refresh/CCM/apex/permset-assign.apex")
sfdx force:apex:execute -f temp-permset-assign.apex -u $username 

#Assign Groups
Add-Content -Path temp-group-assign.apex -Value "String environment = '$($org_alias)';" 
Add-Content -Path temp-group-assign.apex (Get-Content "../views-post-refresh/CCM/apex/group-assign.apex")
sfdx force:apex:execute -f temp-group-assign.apex -u $username 

#Create Accounts from Primary Office Groups
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/primary-office-accounts.apex -u $username 

# Create Contacts for Accounts of Primary Office Groups
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/primary-office-contacts-1.apex -u $username 
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/primary-office-contacts-2.apex -u $username 
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/primary-office-contacts-3.apex  -u $username 

# Setup Tiger Team FQs
sfdx force:apex:execute -f ../views-post-refresh/CCM/apex/setup-tiger-team-fq.apex       -u $username 