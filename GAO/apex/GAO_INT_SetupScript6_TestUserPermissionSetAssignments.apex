//Script #6 GAO Setup

/*** Create User Permissionset Assignments ***/

// Environment postfix. Should be manually changed if not run in REG


Set<String> testUserNames = new Set<String>{
        //'oclauser@libertyits.com'+environment,
        'oclauser2@bah.com'+environment,
        //'vhauser@libertyits.com'+environment,
        'vhauser2@bah.com'+environment,
        //'vbauser@libertyits.com'+environment,
        'vbauser2@bah.com'+environment,
        'oituser@bah.com'+environment,
        'bvauser@va.gov.invalid'+environment,
        'oeiuser@va.gov.invalid'+environment,
        'execsecuser@va.gov.invalid'+environment
};

List<User> testUsers2 = [SELECT FirstName,LastName,Email,Username FROM User WHERE Username IN :testUserNames];

Set<String> oclaUserPermissionSets = new Set<String>{
        'VIEWS_GAO_Case_Record_Type_Access',
        'VIEWS_Primary_Case_Owner',
        'Lightning_Experience_User',
        'KnowWho_User_Read_Access',
        'Views_Liaison_SME_User',
        'VIEWS_Case_Mail_Record_Type_Access',
        'ExecSec_User',
        'VIEWS_Contact_Role_Manager',
        'VIEWS_Internal_Packages',
        'VIEWS_Generic_Congressional_Correspondence',
        'Views_ArchivalCases_Read',
        'Views_GAO_Case_Owner_Permissions',
        'VIEWS_GAO_App_User'
};

Set<String> vhaUserPermissionSets = new Set<String>{
        'VIEWS_GAO_Case_Record_Type_Access',
        'VIEWS_Primary_Case_Owner',
        'Lightning_Experience_User',
        'KnowWho_User_Read_Access',
        'Views_Liaison_SME_User',
        'VIEWS_Case_Mail_Record_Type_Access',
        'ExecSec_User',
        'Views_ArchivalCases_Read',
        'VIEWS_GAO_App_User'
};

Set<String> vbaUserPermissionSets = new Set<String>{
        'VIEWS_GAO_Case_Record_Type_Access',
        'VIEWS_Primary_Case_Owner',
        'Lightning_Experience_User',
        'KnowWho_User_Read_Access',
        'Views_Liaison_SME_User',
        'VIEWS_Case_Mail_Record_Type_Access',
        'VIEWS_Contact_Role_Manager',
        'VIEWS_Internal_Packages',
        'Views_ArchivalCases_Read',
        'VBA_COS_Office_Staff',
        'VIEWS_GAO_App_User'
};

Set<String> oitUserPermissionSets = new Set<String>{
        'VIEWS_GAO_Case_Record_Type_Access',
        'VIEWS_Primary_Case_Owner',
        'Lightning_Experience_User',
        'KnowWho_User_Read_Access',
        'Views_Liaison_SME_User',
        'VIEWS_Case_Mail_Record_Type_Access',
        'VIEWS_Internal_Packages',
        'Views_ArchivalCases_Read',
        'Identity_Features',
        'MyVA_Dashboards_Modify_All',
        'MyVA_Dashboards_Monthly_Edits',
        'VIEWS_GAO_App_User'
};

Set<String> otherPermissionSets = new Set<String>{
        'VIEWS_GAO_Case_Record_Type_Access',
        'VIEWS_Primary_Case_Owner',
        'Lightning_Experience_User',
        'Views_Liaison_SME_User',
        'VIEWS_GAO_App_User'
};

List<PermissionSet> userPermissionSets = [SELECT Name FROM PermissionSet WHERE Name IN :oclaUserPermissionSets OR Name IN :vhaUserPermissionSets OR Name IN :vbaUserPermissionSets OR Name IN :oitUserPermissionSets];

List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
for (User testUser : testUsers2) {
    for (PermissionSet userPermSet : userPermissionSets) {
        if (testUser.LastName.contains('OCLA') && oclaUserPermissionSets.contains(userPermSet.Name)) {
            assignments.add(
                    new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = userPermSet.Id)
            );
        } else if (testUser.LastName.contains('VHA') && vhaUserPermissionSets.contains(userPermSet.Name)) {
            assignments.add(
                    new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = userPermSet.Id)
            );
        } else if (testUser.LastName.contains('VBA') && vbaUserPermissionSets.contains(userPermSet.Name)) {
            assignments.add(
                    new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = userPermSet.Id)
            );
        } else if (testUser.LastName.contains('OIT') && oitUserPermissionSets.contains(userPermSet.Name)) {
            assignments.add(
                    new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = userPermSet.Id)
            );
        } else if (otherPermissionSets.contains(userPermSet.Name)) {
            assignments.add(
                    new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = userPermSet.Id)
            );
        }
    }
}

insert assignments;