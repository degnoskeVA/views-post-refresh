##### Table of Contents  
[After Every Refresh](#after_every_refresh)  

[CCM Manual Steps](#ccm) 

[FOM Manual Steps](#fom)  

[GAO Manual Steps](#gao)  

# Manual Steps

<a name="after_every_refresh"/>
## After Every Sandbox Refresh

### Update Environment AUTH URL

Authenticating our sfdx cli to a sandbox
1.)  Enter sfdx auth command: sfdx auth:web:login --instanceurl "<Sandbox URL>"

$customUrl value is the custom url of the sandbox. We need to use the "my.salesforce" domain vs the "lightning.force" domain ( instead of    "https://va--int.lightning.force.com/" we want to use "https://va--int.my.salesforce.com" )

A full command example :     sfdx auth:web:login --instanceurl "https://va-funq.my.salesforce.com"



2.) after entering this command, a browser tab will open up.  Make sure the custom url exists in the address bar of the browser


3.) Provide username and password and login


4.) If successful we should receive message like: "Successfully authorized jonathon.schleicher@va.gov.funq with org ID #######90880" 


5.) To get authurl store enter "sfdx force:org:display -u "mpie-dev" --verbose" in the terminal


6.) Copy the AUTH URL


7.) Go to the github repository -> Settings -> Environments -> Choose the environment that was refreshed


8.) Open up the AUTH_URL Secret and paste the Auth URL surrounded in double quotes

<a name="ccm"/>

## CCM Manual Post-Refresh Steps

### Email to Case setup (Step can be run independently of the automation) 

From setup, go to Email Services, select VIEWS Email to Case 

Click new email address to set up these 3 addresses: 

Email Address Name & Email Address: 

&emsp; lean_letter 

&emsp; generic_cong_corr 

&emsp; case_mail 

Active: Checked 

Context User: Salesforce Administrator 

Accept Email From: Blank 


An email address will be auto generated for each email address added  

From setup, go to custom settings, click manage for VIEWS Email to Case Mapping 

Edit the Views_ExecSec record, change the Service Email Address field to the email address generated from the steps above that starts with Lean_letter. 

Edit the Views_OCLA record, change the Service Email Address field to the email address generated from the steps above that starts with Generic_cong_corr. 

Edit the Case Mail record, change the Service Email Address field to the email address generated from the steps above that starts with Case_mail. 

<a name="fom"/>

## FOM Manual Post-Refresh Steps
Migrate docgen packages 

Log into another environment already refreshed to migrate from.  (If there is any issue finding one, can request DTC to migrate to sandbox from prod) 

In this migrate-from environment, switch to classic. 

Select plus sign in navigation bar 
 
Find and select DocGen Packages 
 
Click Go! Next to view: 
 
Select the three packages 

Click Migrate DocGen Packages Button 

Click Sandbox Login button (make sure your sandbox user has the FOM permission sets) 

Choose ‘Use Custom Domain’ link 
 
Enter custom domain name (exclude https:// ), and then Continue button 

Enter your login credentials for the destination org 

Click Next button 

Put them in the DocGen Files folder 

Click Migrate button 

<a name="gao"/>

## GAO Manual Steps

### Pre-Deployment
#### SPRING CM Connection

1) In Salesforce, use the app launcher to find the “SpringCM Setup” link.  

2) Click the “Setup Connection” button

3) A prompt will show up to select the SpringCM environment you would like to connect to.  If the SpringCM environment is a sandbox, select Test (UAT)

4) You will then be prompted to log in to the SpringCM environment. 

5) After logging in, you should get a success message on the setup page saying your Salesforce Org has been connected to your SpringCM account. 

### Post-Deployment
#### SPRING CM Group Setup - This step cannot be run until all test users have confirmed emails

1) In the Sandbox, open up the dev console

2) Run the following in anonymous apex


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
update accounts;)