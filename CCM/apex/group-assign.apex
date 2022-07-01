

 

Set<String> usernames3 = new Set<String> { 

    'Edna.ExecSec@example.com.' + environment, 

    'Oscar.OCLA@example.com.' + environment, 

    'Elise.Executive@example.com.' + environment, 

    'Susan.Superuser@example.com.' + environment, 

    'Tracy.Trusteduser@example.com.' + environment, 

    'Larry.Liaison@example.com.' + environment, 

    'Samantha.SME@example.com.' + environment, 

    'Tim.Trusteduser@example.com.' + environment 

}; 

 

 

List<User> testUsers3 = [SELECT Id, FirstName FROM User WHERE Username IN :usernames3]; 

 

 

 

Set<String> allGroups= new Set<String> { 

    'VIEWS_VETERAN_AND_CONGRESSIONAL_CASEMAIL', 

    'Views_Trusted_User_Group', 

    'VIEWS_Super_User_Group', 

    'VIEWS_Executive_Correspondence', 

    'VIEWS_ExecSec_Team1', 

    'Views_Group', 

    'All_users', 

    'VIEWS_ExecSec_Team', 

    'Views_OCLA_Team1', 

    'VIEWS_Folder_Handlers', 

    'VIEWS Trusted User Group-' 

}; 

 

Set<String> eliseGroups = new Set<String> { 

    'VIEWS_VETERAN_AND_CONGRESSIONAL_CASEMAIL', 

    'VIEWS_Executive_Correspondence', 

    'Views_Group', 

    'All_users' 

}; 

 

Set<String> ednaGroups = new Set<String> { 

    'VIEWS_ExecSec_Team1', 

    'All_users', 

    'VIEWS_ExecSec_Team', 

    'Views_Group' 

}; 

 

Set<String> larryGroups = new Set<String> { 

    'All_users', 

    'Views_Group' 

}; 

 

Set<String> oscarGroups = new Set<String> { 

    'Views_OCLA_Team1', 

    'All_users', 

    'VIEWS_Folder_Handlers', 

    'Views_Group' 

}; 

 

Set<String> susanGroups = new Set<String> { 

    'All_users', 

    'VIEWS_Super_User_Group', 

    'Views_Group' 

}; 

 

Set<String> tracyGroups = new Set<String> { 

    'VViews_Trusted_User_Group', 

    'VIEWS_ExecSec_Team1', 

    'All_users', 

    'Views_Group', 

    'Views_Trusted_User_Group' 

}; 

 

Set<String> timGroups = new Set<String> { 

    'VViews_Trusted_User_Group', 

    'Views_OCLA_Team1', 

    'All_users', 

    'Views_Group', 

    'VIEWS_VETERAN_AND_CONGRESSIONAL_CASEMAIL', 

    'Views_Trusted_User_Group' 

}; 

 

 

List<Group> groups = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN :allGroups]; 

List<GroupMember> groupMembers = new List<GroupMember>(); 

 

for(User u : testUsers3) { 

for(Group g : groups) { 

    if(u.firstName == 'Elise') { 

        if(eliseGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Edna') { 

        if(ednaGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Larry') { 

        if(larryGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Oscar') { 

        if(oscarGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Tracy') { 

        if(tracyGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Susan') { 

        if(susanGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

    else if(u.firstName == 'Tim') { 

        if(timGroups.contains(g.DeveloperName)) { 

            groupMembers.add(new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id)); 

        } 

    } 

} 

} 

 

insert groupMembers;