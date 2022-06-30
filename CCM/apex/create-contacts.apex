Account seanAccount = new Account(  

    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KW_Account_Member').getRecordTypeId(),  

    Name = 'Office of Sean Senator'  

);  

  

Account GALAccount = new Account(  

    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId(),  

    Name = 'GAL Contacts 1',  

    VA_Organization_Acronym__c = 'GAL'  

);  

  

insert new List<Account>{seanAccount, GALAccount};  

  

Contact seanContact = new Contact(  

    RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('KW_Member_Record').getRecordTypeId(),  

    FirstName = 'Sean',  

    LastName = 'Senator',  

    AccountId = seanAccount.Id  

); 

  

Contact externalContact = new Contact(  

    RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId(),  

    FirstName = 'Eddie',  

    LastName = 'External User',  

    AccountId = GALAccount.Id,  

    email = 'lin.chen@va.gov'  

);  

  

Contact folderContact = new Contact(  

    RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId(),  

    FirstName = 'Folder',  

    LastName = 'Handler User',  

    AccountId = GALAccount.Id  

);  

  

insert new List<Contact>{seanContact, externalContact, folderContact};  

  

VIEWS_Contact_Roles__c vcr = new VIEWS_Contact_Roles__c(  

    Contact_Name__c = folderContact.Id,  

    Name = 'Folder Handler Contact',  

    Role__c = 'Folder Handler'  

);  

  

insert vcr; 