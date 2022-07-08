public class FOM_DataSetup_UserCreation {
    
    private static Id nintexProfileId = [SELECT Id FROM Profile WHERE Name = 'Views Nintex'].Id;
    private static String password = 'ViewsDev2020!!';
    private static String email = 'viewsdevteam@bah.com';
    private static String orgName;
    private static List<User> userList = new List<User>();
    private static List<User> userListWithId = new List<User>();
    private static Boolean insertUserSuccessful = true;
    private static Id fomAccountId = [Select Id, Name FROM Account Where  IN_FOM__C = 'yes' ORDER BY Name LIMIT 1].Id; 
    private static Id vaEmployeeRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName='VA_Employees'].Id;

    public static void loadUsers(Map<String, String> firstNameAndLastNameMap)
    {
        orgName = URL.getSalesforceBaseUrl().toExternalForm();	
        orgName = orgName.substringBefore('.');	
        orgName = orgname.substringAfter('--');
        
        createUsers(firstNameAndLastNameMap);
        
        getUserIds(userList);
        
        createPermissionSetAssignments(firstNameAndLastNameMap);
        
        createGroupMembers(firstNameAndLastNameMap);
        
    }
    
    public static Boolean createUsers(Map<String, String> firstNameAndLastNameMap) {
    	System.debug('createUsers Enter');
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
        }
        return insertUserSuccessful;
    }
    
    public static void getUserIds(List<User> userList) {
     List<String> fedIds = new List<String>();
        
        for (User user : userList){ 
            fedIds.add(user.FederationIdentifier); 
        }
        
        for (String fedId : fedIds) { 
            userListWithId = [SELECT Id, FirstName, LastName from User WHERE FederationIdentifier in :fedIds]; 
        }    
    }
    
     
    public static void createPermissionSetAssignments(Map<String, String> firstNameAndLastNameMap) {
        
        Id Lightning_Experience_User = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Lightning_Experience_User'].Id;          
        Id FOM_Action_Officer_PermSet  = [SELECT Id, Name FROM PermissionSet WHERE Name = 'FOM_Action_Officer'].Id;       
        Id Point_Of_Contact_PermSet  = [SELECT Id, Name FROM PermissionSet WHERE Name = 'FOM_Point_of_Contact_Data_Entry_Official'].Id;
        Id FOM_Coordinator_PermSet  = [SELECT Id, Name FROM PermissionSet WHERE Name = 'FOM_Coordinator'].Id;
        Id FOM_AuthorityManager_PermSet  = [SELECT Id, Name FROM PermissionSet WHERE Name = 'FOM_Authority_Manager'].Id;
        Id FOM_Acr_PermSet  = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Account_Change_Request_Access'].Id;
        
        List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
        List<Contact> contactsToCreate = new List<Contact>();
        List<String> createUserNameStringList = new List<String>();
        for(String name : firstNameAndLastNameMap.keySet()) {
            String firstAndLastName = name + ' ' + firstNameAndLastNameMap.get(name);
            createUserNameStringList.add(firstAndLastName);
        }
        
        List<User> userListFromQuery = [Select Id, FirstName, LastName From User Where Name in :createUserNameStringList];
        
        for (User u : userListFromQuery) {
            permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = Lightning_Experience_User));
        }
        
        for (User u : userListFromQuery) {
            if (u.LastName.contains('ActionOfficer')) {
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_Action_Officer_PermSet));
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_AuthorityManager_PermSet));
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_Acr_PermSet));
            }
            else if (u.LastName.contains('POC')) {
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = Point_Of_Contact_PermSet));
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_Acr_PermSet));
            }
            else if (u.LastName.contains('AuthorityManager')) {
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_AuthorityManager_PermSet));
            }
            else {
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_Coordinator_PermSet));
                permissionSetAssignmentList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = FOM_Acr_PermSet));
            }
        }
        
        insert permissionSetAssignmentList;  
    }
    
     
    public static void createGroupMembers(Map<String, String> firstNameAndLastNameMap) {
        List<groupmember> groupmemberList = new List<groupmember>();
        
        Id All_Users_Group = [SELECT Id FROM Group WHERE DeveloperName = 'All_users'].Id;
        Id FOM_Action_Officer_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_Action_Officers'].Id;
        Id Point_Of_Contact_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_POCs'].Id;
        Id FOM_Data_Entry_Staff_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_Data_Entry_Staff'].Id;
        Id FOM_Coordinator_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_Coordinator'].Id;
        Id FOM_AuthorityManagers_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_Authority_Managers'].Id;
        Id FOM_RecieveEmail_Group = [SELECT Id FROM Group WHERE DeveloperName = 'FOM_Receive_Email_Group'].Id;
        Id VA_Hierarchy_Manager_Group = [SELECT Id FROM Group WHERE DeveloperName = 'VA_Hierarchy_Manager_Group'].Id;
        
        List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
        List<Contact> contactsToCreate = new List<Contact>();
        List<String> createUserNameStringList = new List<String>();
        for(String name : firstNameAndLastNameMap.keySet()) {
            String firstAndLastName = name + ' ' + firstNameAndLastNameMap.get(name);
            createUserNameStringList.add(firstAndLastName);
        }
        
        List<User> userListFromQuery = [Select Id, FirstName, LastName From User Where Name in :createUserNameStringList];
        
        for (User u : userListFromQuery) {
            groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = All_Users_Group));
        }
        
        for (User u : userListFromQuery) {
            if (u.LastName.contains('ActionOfficer')) {
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = FOM_Action_Officer_Group));
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = FOM_RecieveEmail_Group));
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = VA_Hierarchy_Manager_Group));
            }
            else if (u.LastName.contains('POC')) {
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = Point_Of_Contact_Group));
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = FOM_Data_Entry_Staff_Group));
            }
            else if (u.LastName.contains('AuthorityManager')) {
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = FOM_AuthorityManagers_Group));
            }
            else {
                groupmemberList.add(new groupmember(UserOrGroupId = u.id, groupId = FOM_Coordinator_Group));
            }
        }
            
        insert groupmemberList;
    }
    
    public static void createContacts(Map<String, String> firstNameAndLastNameMap) {
        List<Contact> contactsToCreate = new List<Contact>();
        List<String> createUserNameStringList = new List<String>();
        for(String name : firstNameAndLastNameMap.keySet()) {
            String firstAndLastName = name + ' ' + firstNameAndLastNameMap.get(name);
            createUserNameStringList.add(firstAndLastName);
        }
        
        List<User> userListFromQuery = [Select Id, FirstName, LastName From User Where Name in :createUserNameStringList];

        for(User u : userListFromQuery) {		 
            Contact c = new Contact();
            c.RecordTypeId = vaEmployeeRecordTypeId;
            c.FirstName = u.FirstName;
            c.LastName = u.LastName;
            c.Email = u.FirstName + '.' + u.LastName.substringBefore(' ') + '@va.gov.test';
            c.CF_VIEWS_Contact__c = true;
            c.AccountId = fomAccountId;
            c.User_ID__c = u.Id;
            contactsToCreate.add(c);
        }
        
        System.debug(contactsToCreate);
    
        if(!contactsToCreate.isEmpty()) {
            try {
                Database.SaveResult[] srList = Database.insert(contactsToCreate, false);
                
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                    
                    System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error while inserting contact: ' + err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                }
                
            } catch(DMLException e) { System.debug('insert contactsToCreate :: ' + e); }
        }
    System.debug('createContacts Exit');
    }
}