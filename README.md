# Manual Steps

## Email to Case setup (Step can be run independently of the automation) 

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
