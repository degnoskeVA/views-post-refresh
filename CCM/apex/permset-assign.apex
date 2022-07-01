

 

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

 

List<User> testUsers2 = [SELECT Id, FirstName FROM User WHERE Username IN :usernames2]; 

Set<String> ednaPermissionSets = new Set<String> { 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Case_Mail_Record_Type_Access', 

    'ExecSec_User', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Primary_Case_Owner', 

    'Views_ArchivalCases_Read', 

    'VIEWS_CCM_App_User', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> oscarPermissionSets = new Set<String> { 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Generic_Congressional_Correspondence', 

    'VIEWS_Internal_Packages', 

    'VIEWS_Primary_Case_Owner', 

    'Views_ArchivalCases_Read', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> elisePermissionSets = new Set<String> { 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Case_Mail_Record_Type_Access', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Primary_Case_Owner', 

    'Views_ArchivalCases_Read', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> tracyPermissionSets = new Set<String> { 

    'CF_Privilege_User_TUG', 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Case_Mail_Record_Type_Access', 

    'ExecSec_User', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Generic_Congressional_Correspondence', 

    'VIEWS_Internal_Packages', 

    'VIEWS_Primary_Case_Owner', 

    'VIEWS_Trusted_User_Permission_Set', 

    'Views_ArchivalCases_Create_Attachments', 

    'Views_ArchivalCases_Read', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> susanPermissionSets = new Set<String> { 

    'CF_Privilege_User_TUG', 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Case_Mail_Record_Type_Access', 

    'ExecSec_User', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Generic_Congressional_Correspondence', 

    'VIEWS_Internal_Packages', 

    'VIEWS_Primary_Case_Owner', 

    'VIEWS_Super_User', 

    'VIEWS_Trusted_User_Permission_Set', 

    'Views_ArchivalCases_Create_Attachments', 

    'Views_ArchivalCases_Read', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> larryOrSamanthaPermissionSets = new Set<String> { 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'Views_ArchivalCases_Read', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

Set<String> timPermissionSets = new Set<String> { 

    'CF_Privilege_User_TUG', 

    'KnowWho_User_Read_Access', 

    'Views_Liaison_SME_User', 

    'Lightning_Experience_User', 

    'VIEWS_Case_Mail_Record_Type_Access', 

    'ExecSec_User', 

    'VIEWS_Contact_Role_Manager', 

    'VIEWS_Generic_Congressional_Correspondence', 

    'VIEWS_Internal_Packages', 

    'VIEWS_Primary_Case_Owner', 

    'VIEWS_Trusted_User_Permission_Set', 

    'Views_ArchivalCases_Create_Attachments', 

    'Views_ArchivalCases_Read', 

    'Views_ArchivalCases_Full', 

    'VIEWS_Presidential_and_Legislative_Actions', 

    'VIEWS_CCM_App_User', 

    'VIEWS_CCM_Security_Agreement' 

}; 

 

List<PermissionSet> relevantPermissionSets = [SELECT Id, Name FROM PermissionSet WHERE Name IN :susanPermissionSets]; 

List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>(); 

 

for(User u : testUsers2) { 

for(PermissionSet ps : relevantPermissionSets) { 

    if(u.firstName == 'Edna') { 

        if(ednaPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Oscar') { 

        if(oscarPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Elise') { 

        if(elisePermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Tracy') { 

        if(tracyPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Susan') { 

        if(susanPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Larry' || u.firstName == 'Samantha') { 

        if(larryOrSamanthaPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

    else if(u.firstName == 'Tim') { 

        if(timPermissionSets.contains(ps.Name)) { 

            permissionSetAssignments.add(new PermissionSetAssignment(AssigneeId=u.Id, PermissionSetId=ps.Id)); 

        } 

    } 

} 

} 

insert permissionSetAssignments; 