@isTest
public class FOM_DataSetupTest {
	
    @isTest
    static void testBuildData() {
        FOM_DataSetup accountSetup = new FOM_DataSetup();
        Test.startTest();
        accountSetup.buildData();
        Test.stopTest();
    }
    
    @isTest
    static void testLoadAuthorities() {
        FOM_DataSetup accountSetup = new FOM_DataSetup();
        Test.startTest();
        accountSetup.loadAuthorities();
        Test.stopTest();
    }
    
    @isTest
    static void testLoadContacts() {
        Account account0 = createFomAccount(null, '0');
        Account account1 = createFomAccount(account0, '1');
        FOM_DataSetup accountSetup = new FOM_DataSetup();
        Test.startTest();
        accountSetup.loadContacts();
        Test.stopTest();
    } 
    
    @isTest
    static void testCreateUsers() {
        Account account0 = createFomAccount(null, '0');
		FOM_DataSetup userSetup = new FOM_DataSetup();
        Map<String, String> firstNameAndLastNameMap = new Map<String, String> {'Tes' => 'ActionOfficer', 'Test' => 'Coordinator', 'Testr' => 'POC'};
        
        Test.startTest();
        
		userSetup.createUsers(firstNameAndLastNameMap);
        
        Test.stopTest();
    } 
    
    @isTest
    static void testCreateContacts() {
        Account account0 = createFomAccount(null, '0');
        Map<String, String> firstNameAndLastNameMap = new Map<String, String> {'Ace' => 'ActionOfficer', 'Cody' => 'Coordinator', 'Poppy' => 'POC'};
        FOM_DataSetup_UserCreation userSetup = new FOM_DataSetup_UserCreation();
		createUsers(firstNameAndLastNameMap);
        
        FOM_DataSetup contactSetup = new FOM_DataSetup();
        
        Test.startTest();

        contactSetup.createContacts(firstNameAndLastNameMap);
        
        Test.stopTest();
    } 
    
    @isTest
    static void testDestroyData() {
        FOM_DataSetup accountSetup = new FOM_DataSetup();
        Test.startTest();
        accountSetup.destroyData();
        Test.stopTest();
    }
    
    private static Account createFomAccount(Account parentAccount, String orgLevel){
        Id accVaOrgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId();
        
        Account newAccount = new Account(Name = 'Test' + System.currentTimeMillis(),
            							 RecordTypeId = accVaOrgRecordTypeId,
                                         In_FOM__c = 'Yes',
                                         CF_VIEWS_Account__c = true,
                                         ParentId = parentAccount == null ? null : parentAccount.Id,
                                         FOM_Level__c = orgLevel);
        
        insert newAccount;
        return newAccount;
    }
    
    private static Boolean createUsers(Map<String, String> firstNameAndLastNameMap) {
    	System.debug('createUsers Enter');
        Id nintexProfileId = [SELECT Id FROM Profile WHERE Name = 'Views Nintex'].Id;
        String password = 'ViewsDev2020!!';
    	String email = 'viewsdevteam@bah.com';
        String orgName = URL.getSalesforceBaseUrl().toExternalForm();	
        orgName = orgName.substringBefore('.');	
        orgName = orgname.substringAfter('--');
        List<User> userList = new List<User>();
        Boolean insertUserSuccessful = true;
        for(String name : firstNameAndLastNameMap.keySet()) {
            String firstAndLastName = name + '.' + firstNameAndLastNameMap.get(name);
            String alias = firstAndLastName.replace('.', '').substring(0, 8);
            String firstName = firstAndLastName.substringBefore('.');
            String lastName = firstAndLastName.replace('.', '').replace(firstName, '');
            String username = firstName + '.' + lastName + '@example.com.' + orgName;	
    		System.debug('Username = ' + username);
            User u = new User(Alias = alias,
                                Email = email,
                                EmailEncodingKey = 'UTF-8',
                                FederationIdentifier = firstAndLastName + '@va.gov',
                                FirstName = firstName,
                                LastName = lastName,
                                LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US',
                                ProfileId = nintexProfileId,
                                TimeZoneSidKey = 'America/New_York',
                                UserName = username
            );
            System.debug('FederationIdentifier = ' + u.FederationIdentifier);
            userList.add(u);
        }
        
        if(!userList.isEmpty()) {
            try {
                Database.SaveResult[] srList = Database.insert(userList, false);	
                
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                    System.debug('Successfully inserted User. User ID: ' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()){
                            System.debug('The following error has occurred while inserting user ID ' + sr.getID());
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('User fields that affected this error: '  + err.getFields());
                        }
                        insertUserSuccessful = false;
                    }
                }
            } catch(DMLException e) {
                System.debug('insert userList exception :: ' +  e + e.getDmlType(0));
                insertUserSuccessful = false;
            }
        System.debug('createUsers Exit');
        }
        Return insertUserSuccessful;
    
    }
}