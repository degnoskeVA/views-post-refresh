sfdx force:data:bulk:upsert -s Date__c -f "data/Dates_Data.csv" -i ID 
sfdx force:data:bulk:upsert -s AD_Account__c -f "data/AD Stations Facility Upsert With Record.csv" -i ID
sfdx force:apex:execute -f schedule-batch-jobs.apex
sfdx force:source:deploy -m Workflow:Case
sfdx force:apex:execute -f apex/create-contacts.apex   
sfdx force:apex:execute -f apex/create-users-viewsdeval.apex
sfdx force:apex:execute -f apex/create-accounts.apex
sfdx force:apex:execute -f apex/create-contacts-viewsdeval.apex
sfdx force:apex:execute -f apex/group-assign-viewsdeval.apex
sfdx force:apex:execute -f apex/primary-office-accounts.apex
sfdx force:apex:execute -f apex/primary-office-contacts-1.apex
sfdx force:apex:execute -f apex/primary-office-contacts-2.apex
sfdx force:apex:execute -f apex/primary-office-contacts-3.apex
sfdx force:apex:execute -f apex/setup-tiger-team-fq.apex      