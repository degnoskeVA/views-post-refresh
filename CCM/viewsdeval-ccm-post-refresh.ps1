sfdx force:data:bulk:upsert -s Date__c -f "Dates_Data.csv" -i ID 
sfdx force:data:bulk:upsert -s AD_Account__c -f "AD Stations Facility Upsert With Record.csv" -i ID
sfdx force:apex:execute -f schedule-batch-jobs.apex
sfdx force:source:deploy -m Workflow:Case
sfdx force:apex:execute -f create-contacts.apex   
sfdx force:apex:execute -f create-users-viewsdeval.apex
sfdx force:apex:execute -f create-accounts.apex
sfdx force:apex:execute -f create-contacts-viewsdeval.apex
sfdx force:apex:execute -f group-assign-viewsdeval.apex
sfdx force:apex:execute -f primary-office-accounts.apex
sfdx force:apex:execute -f primary-office-contacts-1.apex
sfdx force:apex:execute -f primary-office-contacts-2.apex
sfdx force:apex:execute -f primary-office-contacts-3.apex
sfdx force:apex:execute -f setup-tiger-team-fq.apex      