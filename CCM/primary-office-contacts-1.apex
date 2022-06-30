String modulePrefix = 'CCM '; 

Set<String> groupNames = new Set<String> { 

 

'OGC-02 General Counsel', 

//'VHA-10B1 Executive Correspondence',    Seems to be missing after 2/24/2021 refresh 

'VEO-30 Veterans Experience', 

'NCA-40 Under Secretary of Memorial Affai', 

'OIG-50 Inspector General', 

'OI&T-005 Information Technology' 

}; 

Map<String,String> groupNameToAccountName = new Map<String,String>(); 

for (String groupName : groupNames) { 

    groupNameToAccountName.put(groupName, modulePrefix + groupName); 

} 

List<Account> primaryOfficeAccounts = [SELECT Id, Name, CF_Group_Name__c, CF_Group_ID__c, CF_Queue_ID__c FROM Account WHERE Name IN :groupNameToAccountName.values()]; 

 

Map<String, Account> accountNameToAccount = new Map<String, Account>(); 

for (Account acc : primaryOfficeAccounts) { 

    accountNameToAccount.put(acc.Name, acc); 

} 

 

List<Group> primaryGroups = [SELECT Id, Name FROM Group WHERE type = 'Regular' AND Name IN :groupNames]; 

 

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

 

List<GroupMember> groupMembers = [Select Id, UserOrGroupId FROM GroupMember WHERE GroupId in :groupIdsToGroups.keySet()]; 

Integer groupMembersCount = 0; 

Set<Id> memberSet = new Set<Id>(); 

for (GroupMember member : groupMembers) { 

 

    if (VIEWS_CaseAccessUtility.isUserType(member.UserOrGroupId)) { 

        groupMembersCount++; 

        memberSet.add(member.UserOrGroupId); 

    } 

} 

 

Set<Id> userIds = new Set<Id>(); 

List<GroupMember> groupMembersToCreatContactsFrom = [Select Id, UserOrGroupId, Group.Name FROM GroupMember WHERE Group.Name IN :groupNameToGroup.keySet() ]; 

 

for (GroupMember member : groupMembersToCreatContactsFrom) { 

 

    if (VIEWS_CaseAccessUtility.isUserType(member.UserOrGroupId)) { 

 

        userIds.add(member.UserOrGroupId); 

        alignedGroupNameToUserIds.get(member.Group.Name).add(member.UserOrGroupId); 

 

    } 

 

} 

 

List<User> usersToCreateContactsFrom = [Select Id, Name, Email, LastName, FirstName FROM User Where Id in :userIds ]; 

Map<Id, User> userIdToUsers = new Map<Id, User>(); 

for (User u : usersToCreateContactsFrom) { 

    userIdToUsers.put(u.Id, u); 

} 

 

 

List<Contact> contactsToCreate = new List<Contact>(); 

Id contactViewsrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId(); 

Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Views Congressional Letters']; 

 

 

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

            testContact.Email = 'test@va.com'; 

 

            contactsToCreate.add(testContact); 

        } 

 

    } 

 

} 

System.debug(LoggingLevel.ERROR, ' contacts to create: ' + contactsToCreate.size()); 

 

insert contactsToCreate;