##### Table of Contents  
[After Every Refresh](#after_every_refresh)  
[CCM Manual Steps](#ccm) 
[FOM Manual Steps](#fom) 

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