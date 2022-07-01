

Id vaEmployeeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId(); 

String modulePrefix = 'CCM '; 

Set<String> accountNames = new Set<String> { 

        modulePrefix + 'OSVA-001B Executive Secretariat', 

        modulePrefix + 'OCLA-009 Assistant Secretary of Congrega', 

        modulePrefix + 'VBA-20 Under Secretary for Benefits', 

        modulePrefix + 'VBA-201 the Principal Deputy Under Secretary for Benefits', 

        modulePrefix + 'VBA-20A1 the Deputy Chief of Staff', 

        modulePrefix + 'OI&T-005 Assistant Secretary for Information and Technology and Chief Information Officer', 

        modulePrefix + 'VHA-10P DUSH for Policy and Services' 

}; 

Set<String> usernames2 = new Set<String> { 

        'Edna.ExecSec@example.com.' + environment, 

        'Oscar.OCLA@example.com.' + environment, 

        'Elise.Executive@example.com.' + environment, 

        'Susan.Superuser@example.com.' + environment, 

        'Tracy.Trusteduser@example.com.' + environment, 

        'Larry.Liaison@example.com.' + environment, 

        'Samantha.SME@example.com.' + environment, 

        'Tim.Trusteduser@example.com.' + environment 

}; 

List<Account> relevantAccounts = [SELECT Id, Name FROM Account WHERE Name IN :accountNames AND CF_VIEWS_Account__c = true]; 

List<User> relevantUsers = [SELECT Id, FirstName, LastName FROM User WHERE Username IN :usernames2]; 

List<Contact> contactsToCreate = new List<Contact>(); 

for(User u : relevantUsers) { 

    Contact c = new Contact(); 

    c.RecordTypeId = vaEmployeeRecordTypeId; 

    c.FirstName = u.FirstName; 

    c.LastName = u.LastName; 

    c.Email = u.FirstName + '.' + u.LastName + '@va.gov.test'; 

    c.CF_VIEWS_Contact__c = true; 

    c.User_ID__c = u.Id; 

    c.MailingCity = 'Happy City'; 

    c.MailingState = 'Alaska'; 

    c.MailingStreet = '1 Happy Street'; 

    c.MailingPostalCode = '12345'; 

    c.MailingCountry = 'United States'; 

    for(Account a : relevantAccounts) { 

        if(u.FirstName == 'Edna' || u.FirstName == 'Tracy') { 

            if(a.Name == modulePrefix+'OSVA-001B Executive Secretariat') { 

                c.AccountId = a.Id; 

            } 

        } 

        else if(u.FirstName == 'Oscar' || u.FirstName == 'Elise' || u.FirstName == 'Susan' || u.FirstName == 'Tim') { 

            if(a.Name == modulePrefix+'OCLA-009 Assistant Secretary of Congrega') { 

                c.AccountId = a.Id; 

            } 

        } 

        else if(u.FirstName == 'Larry') { 

            if(a.Name == modulePrefix+'VBA-20 Under Secretary for Benefits') { 

                c.AccountId = a.Id; 

            } 

        } 

        else if(u.FirstName == 'Samantha') { 

            if(a.Name == modulePrefix+'VBA-201 the Principal Deputy Under Secretary for Benefits') { 

                c.AccountId = a.Id; 

            } 

        } 

    } 

    contactsToCreate.add(c); 

} 

insert contactsToCreate; 

DTC_Application__c app = new DTC_Application__c( 

        Name = System.Label.VIEWS_CCM_App_Name, 

        Product_Owner__c = UserInfo.getUserId(), 

        Live_Status__c = 'Live' 

); 

insert app; 

List<CF_Module_Usage__c> usages = new List<CF_Module_Usage__c>(); 

for (Contact c : contactsToCreate) { 

    usages.add(new CF_Module_Usage__c(CF_DTC_Application__c = app.Id, CF_Contact_Name__c = c.Id)); 

} 

insert usages; 