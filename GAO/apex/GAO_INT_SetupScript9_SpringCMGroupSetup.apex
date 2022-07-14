//Script #9 GAO Setup

String accountPrefix = 'GAO ';
Set<String> accountNames = new Set<String>{
        accountPrefix + 'VHA-10EG GAO/OIG Accountability Liaison Office',
        accountPrefix + 'VBA-20A13 PI&ICS',
        accountPrefix + 'OI&T-005X the Executive Director, Privacy',
        accountPrefix + 'OI&T-005 Information Technology',
        accountPrefix + 'OCLA-009 Assistant Secretary of Congressional and Legislative Affairs',
        accountPrefix + 'OSVA-001B Executive Secretariat'
};
List<Account> accounts = [SELECT Name,CF_Group_ID__c FROM Account WHERE Name IN :accountNames AND CF_VIEWS_Account__c = TRUE AND RecordType.DeveloperName = 'VA_Organization'];
SpringCM_CalloutService cs = SpringCM_CalloutService.newInstance();
for (Account a : accounts) {
    List<GroupMember> gms = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :a.CF_Group_ID__c];
    Set<Id> uIds = new Set<Id>();
    for (GroupMember gm : gms) {
        uIds.add(gm.UserOrGroupId);
    }
    List<User> users = [SELECT Email FROM User WHERE Id IN :uIds];
    Map<String,SpringCM_Objects.User> emailsToSpringUsers = VIEWS_GAO_Utility.mapSpringCMUserToEmail(cs.getUsers());
    List<SpringCM_Objects.User> users2 = new List<SpringCM_Objects.User>();
    for (User u : users) {
        if (emailsToSpringUsers.containsKey(u.Email.toLowerCase())) {
            users2.add(emailsToSpringUsers.get(u.Email.toLowerCase()));
        }
    }
    SpringCM_Objects.SpringCMGroup g;
    try {
        g = cs.getGroup(a.Name);
        g.GroupMembers = new SpringCM_Objects.Users();
        g.GroupMembers.Items = users2;
        cs.updateSpringCMGroup(g);
    }
    catch (Exception e) {
        g = cs.createSecurityGroup(a.Name, users2);
    }
    a.VIEWS_SpringCM_Group_Href__c = g.Href;
}
update accounts;