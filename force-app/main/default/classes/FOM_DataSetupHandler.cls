public class FOM_DataSetupHandler {
    
	private static ID fomAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('VA Organization').getRecordTypeId();
    
    @future
    public static void buildData() {
        loadAccounts();
    //    loadContacts();
    //   loadAuthorities();
     //  updateAccounts();
        // Create Accounts from CSV
        // Create Contacts from CSV (Associate each contact to FOM account)
        // Update Accounts to have parentId
        // Create FDR from CSV (Associate each FDR to FOM account)
        // Create Authorities from CSV
        // Create releated authorities (if needed)
        // Create fdr releated authorities (if needed)
    }
    
    public static void loadAccounts() {
        StaticResource sr = [SELECT ID, body FROM StaticResource WHERE Name = 'FOM_DataSetup_Account' LIMIT 1];
        String fomAccountData = sr.body.toString();
        
        List<Account> accountsToInsert = new List<Account>();
        List<Id> accountIds = new List<Id>();
        
        Utility_RowIterator r = New Utility_RowIterator(fomAccountData,'\n'); //Replace \n with whatever delineates your row
		
        String firstRow;
        String ParentAccountName;
        Map<String,String> accountNameToParentAccount = new Map<String,String>();
        
        while (r.hasNext())
        {
            firstRow = r.next();
            
            Utility_RowIterator z = New Utility_RowIterator(firstRow,'\t'); //Replace \n with whatever delineates your row
        	
            Account acc = new Account();
            acc.In_FOM__c = z.next();
            acc.CF_VIEWS_Account__c = true;
            acc.RecordTypeId = z.next();
            acc.Name = z.next();
            ParentAccountName = z.next();
            acc.Active__c = z.next();
            acc.CF_Mail_Code__c = z.next();
            acc.VA_Organization_Acronym__c = z.next();
            acc.FOM_External_URL__c = z.next();
            acc.FOM_Functions_and_Activities__c = z.next();
            acc.FOM_Intranet_URL__c = z.next();
            acc.FOM_Level__c = z.next();
            acc.FOM_Mission__c = z.next();
            acc.FOM_Office_Type__c = z.next(); 
            acc.FOM_Overview__c = z.next();
            
            accountNameToParentAccount.put(acc.Name, ParentAccountName);
            
            accountsToInsert.add(acc);
        }
        
        insert accountsToInsert;
        
        Map<String,ID> accountNameToId = new Map<String,iD>();
        
        for (Account acc : accountsToInsert)
        {
            accountNameToId.put(acc.Name, acc.Id);
        }
        
       	List<Account> accountsToUpdate = new List<Account>();
        
        String parentName;
        Id parentAccountId;
        
        for (Account acc : accountsToInsert)
        {
            parentName = accountNameToParentAccount.get(acc.Name);
            parentAccountId = accountNameToId.get(parentName);
            acc.ParentId = parentAccountId;
            
            if (acc.ParentId != null)
            {
            	accountsToUpdate.add(acc);
            }
        }
        
        if (accountsToUpdate.size() != 0)
        {
            update accountsToUpdate;
        }
        
    }
    
    @future
    public static void loadContacts() {
     
        List<Account> accountsAdded = [Select Id From Account 
                                       Where In_FOM__c = 'Yes' 
                                       AND RecordTypeId =: fomAccountRecType];

		List<Id> accountIds = new List<Id>();
        
        for (Account acc : accountsAdded)
        {
            accountIds.add(acc.id);
        }
        
        StaticResource sr = [SELECT ID, body FROM StaticResource WHERE Name = 'FOM_DataSetup_Contact' LIMIT 1];
        String fomContactData = sr.body.toString();
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        Utility_RowIterator r = New Utility_RowIterator(fomContactData,'\n'); //Replace \n with whatever delineates your row

        String firstRow;
        Integer i = 0;
        while (r.hasNext())
        {
            firstRow = r.next();
            
            Utility_RowIterator z = New Utility_RowIterator(firstRow,'\t'); //Replace \n with whatever delineates your row

            Contact c = new Contact();
            c.RecordTypeId = z.next();
            c.VBA_ERP_Lunch_Break__c = z.next();
            c.FirstName = z.next();
            c.LastName = z.next();
            c.Email = z.next(); 
            c.MobilePhone = z.next();
            if (accountIds.size()  > i )
            {
            	c.AccountId = accountIds[i];
            }
            else
            {
            	c.AccountId = accountIds[0];
            }
            i++;
            
            contactsToInsert.add(c);
        }
        
        insert contactsToInsert;
        
    }
    
    @future
    public static void loadAuthorities() {
        StaticResource sr = [SELECT ID, body FROM StaticResource WHERE Name = 'FOM_DataSetup_Auth' LIMIT 1];
 //       String fomAuthorityData =  EncodingUtil.base64Encode(sr.body);
        String fomAuthorityData = sr.body.toString();
        
        List<FOM_Authority__c> authoritiesToInsert = new List<FOM_Authority__c>();
        
        Utility_RowIterator r = New Utility_RowIterator(fomAuthorityData,'\n'); //Replace \n with whatever delineates your row

        String firstRow;
        
        while (r.hasNext())
        {
            firstRow = r.next();
            
            Utility_RowIterator z = New Utility_RowIterator(firstRow,'\t'); //Replace \n with whatever delineates your row

            FOM_Authority__c auth = new FOM_Authority__c();
      //      auth.Id = z.next();
            auth.Name = z.next();
            auth.FOM_Name__c  = z.next();
            auth.FOM_Duplicate_Check__c = z.next();
            auth.FOM_URL__c = z.next(); 
            auth.Short_Title__c = z.next();
            auth.Authority_Type__c = z.next();
            
            authoritiesToInsert.add(auth);
        }
        
        insert authoritiesToInsert;
        
    }
    
    // Destroys all FOM Data (Includes: FOM Accounts, FOM Contacts, FDRs,
    // Authorities, Related Authorities, Related FDR Authorities)
    @future
    public static void destroyData() {
    	List<Account> accountsToDelete = [Select Id From Account 
                                          Where In_FOM__c = 'Yes' 
                                          AND RecordTypeId =: fomAccountRecType];
        
        List<Id> accountIds = new List<Id>();
        
        for (Account acc : accountsToDelete)
        {
            accountIds.add(acc.Id);
        }
        
        List<Contact> contactsToDelete = [Select Id From Contact Where AccountId In :accountIds];
        
        List<FOM_Data_Collection__c> fdrsToDelete = [Select Id From FOM_Data_Collection__c];
        
        List<FOM_Authority_Junction__c> relatedAuthoritiesToDelete = [Select Id From FOM_Authority_Junction__c];
        
        List<FOM_FDR_Authority_Junction__c> relatedFdrAuthoritiesToDelete = [Select Id From FOM_FDR_Authority_Junction__c];
        
        List<FOM_Authority__c> authoritiesToDelete = [Select Id From FOM_Authority__c];
        
        if (relatedAuthoritiesToDelete.size() != 0)
        {
            System.debug('relatedAuthoritiesToDelete.size()');
            System.debug(relatedAuthoritiesToDelete.size());
            delete relatedAuthoritiesToDelete;
        }
        if (relatedFdrAuthoritiesToDelete.size() != 0)
        {
            System.debug('relatedFdrAuthoritiesToDelete.size()');
            System.debug(relatedFdrAuthoritiesToDelete.size());
            delete relatedFdrAuthoritiesToDelete;
        }
        if (authoritiesToDelete.size() != 0)
        {
            System.debug('authoritiesToDelete.size()');
            System.debug(authoritiesToDelete.size());
            delete authoritiesToDelete;
        }
        if (fdrsToDelete.size() != 0)
        {
            System.debug('fdrsToDelete.size()');
            System.debug(fdrsToDelete.size());
            delete fdrsToDelete;
        }
        if (contactsToDelete.size() != 0)
        {
            System.debug('contactsToDelete.size()');
            System.debug(contactsToDelete.size());
            delete contactsToDelete;
        }
        if (accountsToDelete.size() != 0)
        {
            System.debug('accountsToDelete.size()');
            System.debug(accountsToDelete.size());
            delete accountsToDelete;
        }
            								
    }
}