param($username)

# Deactivate ViewsSSNUpdateTrigger
sfdx force:source:retrieve -m ApexTrigger:ViewsSSNUpdateTrigger  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml -Raw) -replace '<status>Active</status>','<status>Inactive</status>'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml
sfdx force:source:deploy -m ApexTrigger:ViewsSSNUpdateTrigger  -u $username

# Deactivate AccountTrigger
sfdx force:source:retrieve -m ApexTrigger:AccountTrigger  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml -Raw) -replace '<status>Active</status>','<status>Inactive</status>'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml
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
$flowArray = "CF_Account_Related_Functionality_Edit_Account", "CF_Move_Contact_To_New_Office_Process", "CF_Mark_User_As_Inactive", "CF_User_When_the_Contact_is_Created_Process", "Create_FOM_Data_Collection_Requests", "FOM_Default_Account_POC_from_POC_If_Null"
foreach ($flow in $flowArray)
{
$path = "../views-post-refresh/force-app/main/default/flowDefinitions/$flow.flowDefinition-meta.xml"
sfdx force:source:retrieve -m flowDefinition:$flow -w 5 -u $username
(gc $path -TotalCount 3)[-1] |  Set-Content $flow".txt"
(Get-Content -path $path -Raw) -replace '<activeVersionNumber>.+','<activeVersionNumber>0</activeVersionNumber>'| Set-Content $path
sfdx force:source:deploy -m flowDefinition:$flow -u $username
}

# Deactivate ViewsSSNUpdateTrigger
$path = "../views-post-refresh/force-app/main/default/objects/Account/validationRules/FOM_Activities_Field_Required_On_Level2s.validationRule-meta.xml"
sfdx force:source:retrieve -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username -w 5
(Get-Content -path $path -Raw) -replace '<active>true</active>','<active>false</active>'| Set-Content -Path $path
sfdx force:source:deploy -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username

