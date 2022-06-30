 

String modulePrefix = 'CCM '; 

Set<String> groupNames = new Set<String> { 

     'OCLA-009 Assistant Secretary of Congrega', 

     'OALC-003 Acquisition, Logistics, and Con', 

    'OPIA-002 National Veterans Outreach', 

    'OM-004 the Assistant Secretary for Manag', 

    'OAWP-70 Accountability and Whistleblower' 

}; 

Map<String,String> groupNameToAccountName = new Map<String,String>(); 

for (String groupName : groupNames) { 

    groupNameToAccountName.put(groupName, modulePrefix + groupName); 

} 

List<Account> primaryOfficeAccounts = [Select Id, Name, CF_Group_Name__c, CF_Group_ID__c, CF_Queue_ID__c fROM Account WHERE NAME in : groupNameToAccountName.values()]; 

 

Map<String, Account> accountNameToAccount = new Map<String, Account>(); 

for (Account acc : primaryOfficeAccounts) { 

    accountNameToAccount.put(acc.Name, acc); 

} 

 

List<Group> primaryGroups = [Select Id, Name from group where type = 'Regular' and Name in :groupNames]; 

 

Map<String, Group> groupNameToGroup = new Map<String, Group>(); 

for (Group gr : primaryGroups) { 

    groupNameToGroup.put(gr.Name, gr); 

} 

 

Map<String, Set<Id>> alignedGroupNameToUserIds = new Map<String, Set<Id>>(); 

for (String groupName : groupNameToGroup.keySet()) { 

    Set<Id> newUserIdSet = new Set<Id>(); 

    alignedGroupNameToUserIds.put(groupName, newUserIdSet); 

} 

 

 

Map<String, Group> groupIdsToGroups = new Map<String, Group>(); 

for (Group gr : primaryGroups) { 

    groupIdsToGroups.put(gr.Id, gr); 

} 

 

List<GroupMember> groupMembers = [Select Id, UserOrGroupId FROM GroupMember WHERE GroupId in : groupIdsToGroups.keySet()]; 

Integer groupMembersCount = 0; 

Set<Id> memberSet = new Set<Id>(); 

for (GroupMember member : groupMembers) { 

    if (VIEWS_CaseAccessUtility.isUserType(member.UserOrGroupId)) { 

        groupMembersCount++; 

        memberSet.add(member.UserOrGroupId); 

    } 

} 

 

Set<Id> userIds = new Set<Id>(); 

List<GroupMember> groupMembersToCreatContactsFrom = [Select Id, UserOrGroupId, Group.Name FROM GroupMember WHERE Group.Name IN : groupNameToGroup.keySet() ]; 

 

for (GroupMember member : groupMembersToCreatContactsFrom) { 

    if (VIEWS_CaseAccessUtility.isUserType(member.UserOrGroupId)) { 

        userIds.add(member.UserOrGroupId); 

        alignedGroupNameToUserIds.get(member.Group.Name).add(member.UserOrGroupId); 

    } 

} 

 

List<User> usersToCreateContactsFrom = [Select Id, Name, Email, LastName, FirstName FROM User Where Id in : userIds ]; 

Map<Id, User> userIdToUsers = new Map<Id, User>(); 

for (User u : usersToCreateContactsFrom) { 

    userIdToUsers.put(u.Id, u); 

} 

 

List<Contact> contactsToCreate = new List<Contact>(); 

Id contactViewsrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId(); 

Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Views Congressional Letters']; 

 

Integer emailCount = 0; 

for (String groupName : alignedGroupNameToUserIds.keySet()) { 

    for (Id userMemberId : alignedGroupNameToUserIds.get(groupName)) { 

        User correlatedUser = userIdToUsers.get(userMemberId); 

        if (correlatedUser != NULL) { 

            Contact testContact = new Contact(); 

            testContact.RecordTypeId = contactViewsrecordTypeId; 

            testContact.LastName = correlatedUser.LastName; 

            testContact.FirstName = correlatedUser.FirstName; 

            testContact.User_ID__c = correlatedUser.Id; 

            testContact.AccountId = accountNameToAccount.get(groupNameToAccountName.get(groupName)).Id; 

            testContact.CF_VIEWS_Contact__c = true; 

            testContact.Email = 'test' + emailCount + '@va.com'; 

            contactsToCreate.add(testContact); 

            emailCount++; 

        } 

    } 

} 

 

contactsToCreate.sort(); 

System.debug(LoggingLevel.ERROR, ' contcacts to create: ' + contactsToCreate.size()); 

for (Contact c : contactsToCreate) { 

    System.debug(c.FirstName + ' ' + c.LastName + ' ' + c.Email); 

} 

 

List<Contact> NicholasUchalikResults = [SELECT Id, FirstName, LastName FROM Contact WHERE Name = 'Nicholas Uchalik']; 

 

if(NicholasUchalikResults.size() > 0) { 

    for(Contact NU : NicholasUchalikResults) { 

        NU.LastName = 'Uchalik BVA'; 

    } 

    update NicholasUchalikResults; 

} 

 

insert contactsToCreate; 