param($username)

# Deactivate ViewsSSNUpdateTrigger
sfdx force:source:retrieve -m ApexTrigger:ViewsSSNUpdateTrigger  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml -Raw) -replace 'true','false'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml
sfdx force:source:deploy -m ApexTrigger:ViewsSSNUpdateTrigger  -u $username

# Deactivate AccountTrigger
sfdx force:source:retrieve -m ApexTrigger:AccountTrigger  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml -Raw) -replace 'active','Inactive'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml
sfdx force:source:deploy -m ApexTrigger:AccountTrigger  -u $username

# Deactivate FOM Update External ID workflow Rule
sfdx force:source:retrieve -m "WorkflowRule:Account.FOM Update External ID"  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml -Raw) -replace '<active>true</active>','<active>false</active>'| Set-Content -Path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml
sfdx force:source:deploy -m "Workflow:Account"  -u $username

# Deactivate Update Owner on VA Org Record Type  workflow Rule
sfdx force:source:retrieve -m "WorkflowRule:Account.Update Owner on VA Org Record Type"  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml -Raw) -replace '<active>true</active>','<active>false</active>'| Set-Content -Path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml
sfdx force:source:deploy -m "Workflow:Account"  -u $username

# Deactivate CF_Account_Related_Functionality_Edit_Account workflow Rule
sfdx force:source:retrieve -m "flowDefinition:CF_Account_Related_Functionality_Edit_Account"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/CF_Account_Related_Functionality_Edit_account.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc cf-account-output.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Account_Related_Functionality_Edit_Account.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Account_Related_Functionality_Edit_Account.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:CF_Account_Related_Functionality_Edit_Account"  -u $username

# Deactivate CF_Move_Contact_To_New_Office_Process workflow Rule
sfdx force:source:retrieve -m "flowDefinition:CF_Move_Contact_To_New_Office_Process"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/CF_Move_Contact_To_New_Office_Process.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc cf-contact-utility-output.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Move_Contact_To_New_Office_Process.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Move_Contact_To_New_Office_Process.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:CF_Move_Contact_To_New_Office_Process"  -u $username

# Deactivate CF_Mark_User_As_Inactive workflow Rule
sfdx force:source:retrieve -m "flowDefinition:CF_Mark_User_As_Inactive"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/CF_Mark_User_As_Inactive.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc cf-mark-inactive-output.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Mark_User_As_Inactive.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_Mark_User_As_Inactive.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:CF_Mark_User_As_Inactive"  -u $username

# Deactivate CF_User_When_the_Contact_is_Created_Process  workflow Rule
sfdx force:source:retrieve -m "flowDefinition:CF_User_When_the_Contact_is_Created_Process"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/CF_User_When_the_Contact_is_Created_Process.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc cf-user-when-contact-is-created-output.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_User_When_the_Contact_is_Created_Process.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/CF_User_When_the_Contact_is_Created_Process.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:CF_User_When_the_Contact_is_Created_Process"  -u $username

# Deactivate Create_FOM_Data_Collection_Requests  workflow Rule
sfdx force:source:retrieve -m "flowDefinition:Create_FOM_Data_Collection_Requests"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/Create_FOM_Data_Collection_Requests.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc create-fom-data-collection-output.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/Create_FOM_Data_Collection_Requests.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/Create_FOM_Data_Collection_Requests.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:Create_FOM_Data_Collection_Requests"  -u $username

# Deactivate FOM_Default_Account_POC_from_POC_If_Null  workflow Rule
sfdx force:source:retrieve -m "flowDefinition:FOM_Default_Account_POC_from_POC_If_Null"  -u $username -w 5
(gc force-app/main/default/flowDefinitions/FOM_Default_Account_POC_From_POC_If_Null.flowDefinition-meta.xml -TotalCount 3)[-1] |  sc default-poc.txt 
(Get-Content -path ../views-post-refresh/force-app/main/default/flowDefinitions/FOM_Default_Account_POC_From_POC_If_Null.flowDefinition-meta.xml -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content -Path ../views-post-refresh/force-app/main/default/flowDefinitions/FOM_Default_Account_POC_from_POC_If_Null.flowDefinition-meta.xml
sfdx force:source:deploy -m "flowDefinition:FOM_Default_Account_POC_from_POC_If_Null"  -u $username

# Deactivate ViewsSSNUpdateTrigger
sfdx force:source:retrieve -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/objects/Account/validationRules/FOM_Activities_Field_Required_On_Level2s.validationRule-meta.xml -Raw) -replace '<active>true</active>','<active>false</active>'| Set-Content -Path ../views-post-refresh/force-app/main/default/objects/Account/validationRules/FOM_Activities_Field_Required_On_Level2s.validationRule-meta.xml
sfdx force:source:deploy -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username

