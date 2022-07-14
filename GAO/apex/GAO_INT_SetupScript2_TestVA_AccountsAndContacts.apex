//Script #2 GAO Setup

/*** Create VA Accounts and Contacts ***/

// Environment postfix. Should be manually changed if not run in REG


// Should have a value if being setup in a shared environment (e.g. ENTSD, REG, etc.)
String accountPrefix = 'GAO ';

Set<String> hierarchyGroupDevNames = new Set<String> {
        'VHA_10EG_GAO_OIG_Accountability_Liaison','VHA_10EG_GAO_OIG_Accountability_Liaison','VHA_10P_DUSH_for_Policy_and_Services','VHA_10P_DUSH_for_Policy_and_Services1','VBA_20A13_PI_ICS','VBA_20A13_PI_ICS1','OI_T_005X_the_Executive_Director_Privac','OI_T_005X_the_Executive_Director_Privac1','VBA_20_Under_Secretary_for_Benefits','VBA_20_Under_Secretary_for_Benefits1','VHA_10D_DUSH_for_Community_Care','VHA_10D_DUSH_for_Community_Care1','OI_T_005_Information_Technology','OI_T_005_Information_Technology1','VHA_10A_the_Principal_Deputy_Under_Secre','VHA_10A_the_Principal_Deputy_Under_Secre1','VHA_10NC_ADUSH_for_Clinical_Operations','VHA_10NC_ADUSH_for_Clinical_Operations1','OCLA_009_Assistant_Secretary_of_Congrega','OCLA_009_Assistant_Secretary_of_Congrega','BVA_01_Board_of_Veteran_s_Appeals','BVA_01_Board_of_Veteran_s_Appeals1','OEI_008_Enterprise_Integration','OEI_008_Enterprise_Integration1','Views_ExecSec','VIEWS_ExecSec_Team1'
};


List<Group> hierarchyGroups = [
        SELECT Type,DeveloperName
        FROM Group
        WHERE DeveloperName IN :hierarchyGroupDevNames
];

Map<String,Id> queueDevNamesToIds = new Map<String, Id>();
Map<String,Id> groupDevNamesToIds = new Map<String, Id>();
for (Group g : hierarchyGroups) {
    if (g.Type == 'Queue') {
        queueDevNamesToIds.put(g.DeveloperName, g.Id);
    } else if (g.Type == 'Regular') {
        groupDevNamesToIds.put(g.DeveloperName, g.Id);
    }
}

Id organization_RT_Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId();

Map<String,Account> testAccounts = new Map<String,Account>();

void setupAccount(String name, String mailCode, String acronym, String vaAcronym, String queueDevName, String groupDevName, Id recordTypeId, Boolean isViews) {
    testAccounts.put(
            name,
            new Account(Name = name, RecordTypeId = recordTypeId, CF_Mail_Code__c = mailCode, VA_Organization_Acronym__c = vaAcronym, CF_VIEWS_Account__c = isViews, CF_Queue_ID__c = queueDevNamesToIds.get(queueDevName), CF_Group_ID__c = groupDevNamesToIds.get(groupDevName))
    );
}

setupAccount(accountPrefix + 'VHA-10EG GAO/OIG Accountability Liaison Office', '10EG', 'GOAL', 'VHA', 'VHA_10EG_GAO_OIG_Accountability_Liaison', 'VHA_10EG_GAO_OIG_Accountability_Liaison', organization_RT_Id, true);
setupAccount(accountPrefix + 'VHA-10P DUSH for Policy and Services', '10P', 'VHA', 'VHA', 'VHA_10P_DUSH_for_Policy_and_Services', 'VHA_10P_DUSH_for_Policy_and_Services1', organization_RT_Id, true);
setupAccount(accountPrefix + 'VBA-20A13 PI&ICS', '20A13', 'VBA', 'VBA', 'VBA_20A13_PI_ICS', 'VBA_20A13_PI_ICS1', organization_RT_Id, true);
setupAccount(accountPrefix + 'OI&T-005X the Executive Director, Privacy', '005X', 'OI&T', 'OI&T', 'OI_T_005X_the_Executive_Director_Privac', 'OI_T_005X_the_Executive_Director_Privac1', organization_RT_Id, true);
setupAccount(accountPrefix + 'VBA-20 Under Secretary for Benefits', '20', 'VBA', 'VBA', 'VBA_20_Under_Secretary_for_Benefits', 'VBA_20_Under_Secretary_for_Benefits1', organization_RT_Id, true);
setupAccount(accountPrefix + 'VHA-10D DUSH for Community Care', '10D', 'VHA', 'VHA', 'VHA_10D_DUSH_for_Community_Care', 'VHA_10D_DUSH_for_Community_Care1', organization_RT_Id, true);
setupAccount(accountPrefix + 'OI&T-005 Information Technology', '5', 'OI&T', 'OI&T', 'OI_T_005_Information_Technology', 'OI_T_005_Information_Technology', organization_RT_Id, true);
setupAccount(accountPrefix + 'VHA-10A the Principal Deputy Under Secretary for Health', '10A', 'VHA', 'VHA', 'VHA_10A_the_Principal_Deputy_Under_Secre', 'VHA_10A_the_Principal_Deputy_Under_Secre1', organization_RT_Id, true);
setupAccount(accountPrefix + 'VHA-10NC ADUSH for Clinical Operations', '10NC', 'VHA', 'VHA', 'VHA_10NC_ADUSH_for_Clinical_Operations', 'VHA_10NC_ADUSH_for_Clinical_Operations1', organization_RT_Id, true);
setupAccount(accountPrefix + 'OCLA-009 Assistant Secretary of Congressional and Legislative Affairs', '9', 'OCLA', 'OCLA', 'OCLA_009_Assistant_Secretary_of_Congrega', 'OCLA_009_Assistant_Secretary_of_Congrega', organization_RT_Id, true);
setupAccount(accountPrefix + 'BVA-01 Board of Veteran\'s Appeals', '1', 'BVA', 'BVA', 'BVA_01_Board_of_Veteran_s_Appeals', 'BVA_01_Board_of_Veteran_s_Appeals1', organization_RT_Id, true);
setupAccount(accountPrefix + 'OEI-008 Office of Enterprise Integration', '8', 'OEI', 'OEI', 'OEI_008_Enterprise_Integration', 'OEI_008_Enterprise_Integration1', organization_RT_Id, true);
setupAccount(accountPrefix + 'OSVA-001B Executive Secretariat', '1B', 'OSVA', 'OSVA', 'Views_ExecSec', 'VIEWS_ExecSec_Team1', organization_RT_Id, true);

List<Account> currentViewsAccounts = [SELECT Name FROM Account WHERE Name IN :testAccounts.keySet() AND CF_VIEWS_Account__c = TRUE AND CF_Group_ID__c != NULL];

for (Account currentViewsAccount : currentViewsAccounts) {
    if (testAccounts.containsKey(currentViewsAccount.Name)) {
        testAccounts.get(currentViewsAccount.Name).Id = currentViewsAccount.Id;
    }
}

upsert testAccounts.values();

Set<String> testUserNames = new Set<String>{
        //'oclauser@libertyits.com'+environment, 'oclauser2@libertyits.com'+environment, 'vhauser@libertyits.com'+environment, 'vhauser2@libertyits.com'+environment, 'vbauser@libertyits.com'+environment, 'vbauser2@libertyits.com'+environment, 'oituser@libertyits.com'+environment, 'bvauser@va.gov.invalid'+environment, 'oeiuser@va.gov.invalid'+environment, 'execsecuser@va.gov.invalid'+environment
    'oclauser2@bah.com'+environment, 'vhauser2@bah.com'+environment, 'vbauser2@bah.com'+environment, 'oituser@libertyits.com'+environment, 'bvauser@va.gov.invalid'+environment, 'oeiuser@va.gov.invalid'+environment, 'execsecuser@va.gov.invalid'+environment
};

List<User> testUsers = [SELECT FirstName,LastName,Email,Username FROM User WHERE Username IN :testUserNames];

Id vaEmployeeRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('VA_Employees').getRecordTypeId();

Id kwFormerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('KW_Member_Former').getRecordTypeId();

List<Contact> vaContacts = new List<Contact>();

Contact setupContact(String firstName, String lastName, String email, Id userId, Id recordTypeId, Boolean isViewsContact, String accountName) {
    return new Contact(FirstName = firstName, LastName = lastName, Email = email, User_ID__c = userId, RecordTypeId = recordTypeId, CF_VIEWS_Contact__c = isViewsContact, AccountId = testAccounts.get(accountName).Id, Account_Record_Type__c = 'VA_Organization', MailingCity = 'Happy City', MailingState = 'Alaska', MailingStreet = '1 Happy Street', MailingPostalCode = '12345', MailingCountry = 'United States');
}

for (User u : testUsers) {

    String accountName;

    if (u.LastName.contains('OCLA')) {
        accountName = accountPrefix + 'OCLA-009 Assistant Secretary of Congressional and Legislative Affairs';
    } else if (u.LastName.contains('VHA')) {
        accountName = accountPrefix + 'VHA-10EG GAO/OIG Accountability Liaison Office';
    } else if (u.LastName.contains('VBA')) {
        accountName = accountPrefix + 'VBA-20A13 PI&ICS';
    } else if (u.LastName.contains('OIT')) {
        accountName = accountPrefix + 'OI&T-005X the Executive Director, Privacy';
    } else if (u.LastName.contains('BVA')) {
        accountName = accountPrefix + 'BVA-01 Board of Veteran\'s Appeals';
    } else if (u.LastName.contains('OEI')) {
        accountName = accountPrefix + 'OEI-008 Office of Enterprise Integration';
    } else if (u.LastName.contains('Execsec')) {
        accountName = accountPrefix + 'OSVA-001B Executive Secretariat';
    }

    if (!u.Email.contains('@va.gov')) {
        vaContacts.add(
                setupContact(u.FirstName, u.LastName, u.Email.substringBefore('@') + '@va.gov.invalid', u.Id, vaEmployeeRecordTypeId, true, accountName)
        );
        vaContacts.add(
                setupContact(u.FirstName, u.LastName + ' Email', u.Email.replace('.unconfirmed', ''), u.Id, vaEmployeeRecordTypeId, true, accountName)
        );
    } else {
        vaContacts.add(
                setupContact(u.FirstName, u.LastName, u.Email.replace('.unconfirmed', ''), u.Id, vaEmployeeRecordTypeId, true, accountName)
        );
    }
}

insert vaContacts;