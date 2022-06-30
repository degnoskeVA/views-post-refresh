 

String modulePrefix = 'CCM '; 

Set<String> groupNames = new Set<String> {  

        'OGC-02 Office of General Counsel',  

        //'VHA-10B1 Executive Correspondence',    Seems to be missing after 2/24/2021 refresh  

        'VEO-30 Veterans Experience Office',  

        'NCA-40 National Cemetery Administration',  

        'OIG-50 Inspector General',  

        'OIT-005 Office of Information and Techno',  

        'HRA-006 Human Resources and Administrati',  

        'HRA/OSP-007 Office of the Chief Security',  

        'OEI-008 Enterprise Integration',  

        'VBA-20 Veterans Benefits Administration',  

        'OSVA-001B Executive Secretariat',  

        'BVA-01 Board of Veterans Appeals',  

        'OCLA-009 Assistant Secretary of Congrega',  

        'OALC-003 Acquisition, Logistics, and Con',  

        'OPIA-002 National Veterans Outreach',  

        'OM-004 Office of Management',  

        'OAWP-70 Accountability and Whistleblower'  

}; 

 

Map<String,String> groupNameToAccountName = new Map<String,String>(); 

for (String groupName : groupNames) { 

    groupNameToAccountName.put(groupName, modulePrefix + groupName); 

} 

 

// if accounts already exist in org 

List<String> accountsNotToCreate = new List<String>(); 

List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN :groupNameToAccountName.values()]; 

System.debug(LoggingLevel.ERROR, ' size of found accounts: ' + accounts.size()); 

for (Account a : accounts) { 

    System.debug(LoggingLevel.ERROR, 'name: ' + a.Name); 

    for (String name : groupNames) { 

        if (groupNameToAccountName.get(name) == a.Name) { 

            accountsNotToCreate.add(groupNameToAccountName.get(name)); 

        } 

    } 

} 

 

// get queues and groups for account reference fields  

List<Group> primaryQueues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name IN :groupNames]; 

Map<String, Group> queueNameToGroup = new Map<String, Group>(); 

for (Group qu : primaryQueues) { 

    System.debug(LoggingLevel.ERROR, ' quenamemaepping: ' + qu.Name); 

    queueNameToGroup.put(qu.Name, qu); 

} 

 

List<Group> primaryGroups = [SELECT Id, Name FROM Group WHERE Type = 'Regular' AND Name IN :groupNames]; 

Map<String, Group> groupNameToGroup = new Map<String, Group>(); 

for (Group gr : primaryGroups) { 

    System.debug(LoggingLevel.ERROR, ' mapping groups: ' + gr.Name); 

    groupNameToGroup.put(gr.Name, gr); 

} 

// end queue and groups for account logic 

 

Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId(); 

 

List<Account> accountsToCreate = new List<Account>(); 

System.debug(LoggingLevel.ERROR, ' accuotnsnot tocreate size: ' + accountsNotToCreate.size()); 

 

for (String groupName : groupNames) { 

 

    String accName = groupNameToAccountName.get(groupName); 

 

    if (accountsNotToCreate != NULL && !accountsNotToCreate.contains(accName)) { 

 

        Account acc = new Account(); 

        acc.Name = accName; 

        acc.CF_VIEWS_Account__c = true; 

        acc.VIEWS_Primary_Office_for_Organization__c = true; 

        acc.RecordTypeId = recordTypeId; 

 

        acc.CF_Group_ID__c = groupNameToGroup.get(groupName).Id; 

        acc.CF_Queue_ID__c = queueNameToGroup.get(groupName).Id; 

 

        accountsToCreate.add(acc); 

    } 

 

} 

 

System.debug(LoggingLevel.ERROR, ' accounts to create size: ' + accountsToCreate.size()); 

 

insert accountsToCreate; 

 