//Script #5 GAO Setup

/*** Create KnowWho Current Relationships ***/

Set<String> kwAccountNames = new Set<String>{
        'Committee on Finance - KW Test Account',
        'Committee on Veterans Health - KW Test Account',
        'Committee on Veterans Benefits - KW Test Account'
};

List<Account> testKWAccounts = [SELECT Id,(SELECT Id FROM Contacts) FROM Account WHERE Name IN :kwAccountNames];

List<kw__KW_Relationship__c> currentRelationships = new List<kw__KW_Relationship__c>();

for (Account kwAccount : testKWAccounts) {
    for (Contact kwContact : kwAccount.Contacts) {
        currentRelationships.add(
                new kw__KW_Relationship__c(kw__Organization__c = kwAccount.Id, kw__Person__c = kwContact.Id)
        );
    }
}

insert currentRelationships;