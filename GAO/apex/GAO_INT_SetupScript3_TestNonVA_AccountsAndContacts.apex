//Script #3 GAO Setup

/*** Setup Non VA Accounts and Contacts ***/

Id organization_RT_Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId();
Id government_RT_Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
Id kw_Committee_RT_Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KW_Account_Committee').getRecordTypeId();

Map<String,Account> testAccounts = new Map<String,Account>();

void setupAccount(String name, String mailCode, String acronym, String vaAcronym, Id recordTypeId, Boolean isViews) {
    testAccounts.put(
            name,
            new Account(Name = name, RecordTypeId = recordTypeId, CF_Mail_Code__c = mailCode, VA_Organization_Acronym__c = vaAcronym, CF_VIEWS_Account__c = isViews, kw__StateOfCoverage__c = 'AK - Alaska')
    );
}

setupAccount('GAO Government Office', '', '', '', government_RT_Id, false);
setupAccount('GAO VA Organization Office', '', '', '', organization_RT_Id, false);

setupAccount('Committee on Finance - KW Test Account', '', '', '', kw_Committee_RT_Id, false);
setupAccount('Committee on Veterans Health - KW Test Account', '', '', '', kw_Committee_RT_Id, false);
setupAccount('Committee on Veterans Benefits - KW Test Account', '', '', '', kw_Committee_RT_Id, false);

insert testAccounts.values();

Id unverifiedNonVaNonEmployeeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VIEWS_Tier_1_Call_Center').getRecordTypeId();
Id kwFormerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('KW_Member_Former').getRecordTypeId();

List<Contact> allContacts = new List<Contact>();
List<Contact> nonVaContacts = new List<Contact>();
List<Contact> kwFormerContacts = new List<Contact>();

Contact setupContact(String firstName, String lastName, String email, Id userId, Id recordTypeId, Boolean isViewsContact, String accountName) {
    return new Contact(FirstName = firstName, LastName = lastName, Email = email, User_ID__c = userId, RecordTypeId = recordTypeId, CF_VIEWS_Contact__c = isViewsContact, AccountId = testAccounts.get(accountName).Id, kw__Political_Party__c = 'Independent', MailingCity = 'Happy City', MailingState = 'Alaska', MailingStreet = '1 Happy Street', MailingPostalCode = '12345', MailingCountry = 'United States');
}

nonVaContacts.addAll(
        new List<Contact>{
                setupContact('GAO Jane', 'Doe', 'gaojane@gao.gov.test', null, unverifiedNonVaNonEmployeeRecordTypeId, false, 'GAO Government Office'),
                setupContact('GAO John', 'Doe', 'gaojohn@gao.gov.test', null, unverifiedNonVaNonEmployeeRecordTypeId, false, 'GAO Government Office'),
                setupContact('GAO Sam', 'Smith', 'gaosam@gao.gov.test', null, unverifiedNonVaNonEmployeeRecordTypeId, false, 'GAO VA Organization Office')
        }
);

kwFormerContacts.addAll(
        new List<Contact>{
                setupContact('Senator Andrew', 'Barker', null, null, kwFormerRecordTypeId, false, 'Committee on Finance - KW Test Account'),
                setupContact('Senator Barbara', 'Thomas', null, null, kwFormerRecordTypeId, false, 'Committee on Finance - KW Test Account'),
                setupContact('Senator Jackson', 'Parker', null, null, kwFormerRecordTypeId, false, 'Committee on Finance - KW Test Account'),
                setupContact('Senator Julie', 'Smith', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Health - KW Test Account'),
                setupContact('Senator Kyle', 'Carson', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Health - KW Test Account'),
                setupContact('Senator Aimee', 'Blue', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Health - KW Test Account'),
                setupContact('Senator Chris', 'Johnson', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Benefits - KW Test Account'),
                setupContact( 'Senator Katie', 'Oscar', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Benefits - KW Test Account'),
                setupContact('Senator London', 'Wilson', null, null, kwFormerRecordTypeId, false, 'Committee on Veterans Benefits - KW Test Account')
        }
);

allContacts.addAll(nonVaContacts);
allContacts.addAll(kwFormerContacts);
insert allContacts;