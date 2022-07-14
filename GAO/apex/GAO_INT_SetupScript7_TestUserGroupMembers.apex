//Script #7 GAO Setup

/*** Create Group Member Assignments ***/

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

List<User> testUsers3 = [SELECT FirstName,LastName,Email,Username FROM User WHERE Username IN :testUserNames];

Set<String> oclaGroups = new Set<String>{
        'Views_Group',
        'Views_OCLA_Team1',
        'OCLA_009_Assistant_Secretary_of_Congrega'
};
Set<String> vhaGroups = new Set<String>{
        'Views_Group',
        'VHA_10EG_GAO_OIG_Accountability_Liaison'
};
Set<String> vbaGroups = new Set<String>{
        'Views_Group',
        'VBA_20A13_PI_ICS1'
};
Set<String> oitGroups = new Set<String>{
        'Views_Group',
        'OI_T_005X_the_Executive_Director_Privac1',
        'OI_T_005X3_Office_of_Compliance_Tracking1'
};
Set<String> bvaGroups = new Set<String>{
        'Views_Group',
        'BVA_01_Board_of_Veteran_s_Appeals1'
};
Set<String> oeiGroups = new Set<String>{
        'Views_Group',
        'OEI_008_Enterprise_Integration1'
};
Set<String> execsecGroups = new Set<String>{
        'Views_Group',
        'VIEWS_ExecSec_Team1'
};

List<Group> groups = [
        SELECT DeveloperName FROM Group WHERE (DeveloperName IN :oclaGroups OR DeveloperName IN :vhaGroups OR DeveloperName IN :vbaGroups OR DeveloperName IN :oitGroups OR DeveloperName IN :bvaGroups OR DeveloperName IN :oeiGroups OR DeveloperName IN :execsecGroups) AND Type = 'Regular'];

List<GroupMember> groupMembers = new List<GroupMember>();
for (User testUser : testUsers3) {
    for (Group userGroup : groups) {
        if (testUser.LastName.contains('OCLA') && oclaGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('VHA') && vhaGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('VBA') && vbaGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('OIT') && oitGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('BVA') && bvaGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('OEI') && oeiGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        } else if (testUser.LastName.contains('Execsec') && execsecGroups.contains(userGroup.DeveloperName)) {
            groupMembers.add(
                    new GroupMember(UserOrGroupId = testUser.Id, GroupId = userGroup.Id)
            );
        }
    }
}

insert groupMembers;