//Script #4 GAO Setup

/*** Create Functional Queues ***/

// Environment postfix. Should be manually changed if not run in REG


Set<String> hierarchyGroupDevNames2 = new Set<String> {
        'GAO_009_OCLA',
        'GAO_009_OCLA'
};

List<Group> hierarchyGroups2 = [SELECT Type,DeveloperName FROM Group WHERE DeveloperName IN :hierarchyGroupDevNames2];

Map<String,Id> queueDevNamesToIds2 = new Map<String, Id>();
Map<String,Id> groupDevNamesToIds2 = new Map<String, Id>();
for (Group g : hierarchyGroups2) {
    if (g.Type == 'Queue') {
        queueDevNamesToIds2.put(g.DeveloperName, g.Id);
    } else if (g.Type == 'Regular') {
        groupDevNamesToIds2.put(g.DeveloperName, g.Id);
    }
}

Functional_Queue__c setupFunctionalQueue(String name, String queueDevName, String groupDevName, Id recordTypeId) {
    return new Functional_Queue__c(
            Name = name,
            RecordTypeId = recordTypeId,
            Associated_Application__c = 'VIEWS',
            Queue_ID__c = queueDevNamesToIds2.get(queueDevName),
            Public_Group_ID__c = groupDevNamesToIds2.get(groupDevName)
    );
}

Id viewsQueueRecordTypeId = Schema.SObjectType.Functional_Queue__c.getRecordTypeInfosByDeveloperName().get('VIEWS_Functional_Queue').getRecordTypeId();

List<Functional_Queue__c> functionalQueues = new List<Functional_Queue__c>();
functionalQueues.add(
        setupFunctionalQueue('GAO_009_OCLA', 'GAO_009_OCLA', 'GAO_009_OCLA', viewsQueueRecordTypeId)
);

insert functionalQueues;


/*** Create Functional Queue Members ***/

Set<String> testUserNames = new Set<String>{
        //'oclauser@libertyits.com'+environment,
        'oclauser2@bah.com'+environment,
        //'vhauser@libertyits.com'+environment,
        'vhauser2@bah.com'+environment,
        //'vbauser@libertyits.com'+environment,
        'vbauser2@bah.com'+environment,
        'oituser@bah.com'+environment
};

List<Contact> contacts = [SELECT FirstName,LastName,Email FROM Contact WHERE User_ID__c IN (SELECT Id FROM User WHERE Username IN :testUserNames)];

Map<String,Id> queueNamesToIds = new Map<String,Id>();
for (Functional_Queue__c fq : functionalQueues) {
    queueNamesToIds.put(fq.Name, fq.Id);
}

Id viewsQueueMemberRecordTypeId = Schema.SObjectType.Functional_Queue_Member__c.getRecordTypeInfosByDeveloperName().get('VIEWS_Functional_Queue_Member').getRecordTypeId();

Functional_Queue_Member__c setupFunctionalQueueMember(Id contactId, String fqName, Id recordTypeId) {
    return new Functional_Queue_Member__c(
            Contact_Member__c = contactId,
            Functional_Queue__c = queueNamesToIds.get(fqName),
            RecordTypeId = recordTypeId
    );
}

List<Functional_Queue_Member__c> fqMembers = new List<Functional_Queue_Member__c>();
for (Contact userContact : contacts) {
    if (userContact.LastName.contains('OCLA')) {
        fqMembers.add(
                setupFunctionalQueueMember(userContact.Id, 'GAO_009_OCLA', viewsQueueMemberRecordTypeId)
        );
    }
}

insert fqMembers;