public class FOM_DataSetup {
    
    private Boolean hasCustomPermission = FeatureManagement.checkPermission('FOM_Data_Setup');
    String profileId = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1].Id;

    public void buildData() {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
        	FOM_DataSetupHandler.buildData();
        }
    }
    
    public void loadAuthorities() {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
        	FOM_DataSetupHandler.loadAuthorities();
        }
    }
    
    public void loadContacts() {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
        	FOM_DataSetupHandler.loadContacts();
        }
    }
    
    public void createUsers(Map<String, String> firstNameAndLastNameMap) {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
        	FOM_DataSetup_UserCreation.loadUsers(firstNameAndLastNameMap);
        }
    }
    
    public void createContacts(Map<String, String> firstNameAndLastNameMap) {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
            FOM_DataSetup_UserCreation.createContacts(firstNameAndLastNameMap);
        }
    }
    
    // Destroys all FOM Data (Includes: FOM Accounts, FOM Contacts, FDRs,
    // Authorities, Related Authorities, Related FDR Authorities)
    public void destroyData() {
        if (hasCustomPermission || UserInfo.getProfileId() == profileId) {
        	FOM_DataSetupHandler.destroyData();
        }
    }
}