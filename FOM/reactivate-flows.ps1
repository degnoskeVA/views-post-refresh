param($username)

# Reactivate ViewsSSNUpdateTrigger
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml -Raw) -replace '<status>Inactive</status>','<status>Active</status>'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/ViewsSSNUpdateTrigger.trigger-meta.xml
sfdx force:source:deploy -m ApexTrigger:ViewsSSNUpdateTrigger  -u $username

# Reactivate AccountTrigger
(Get-Content -path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml -Raw) -replace '<status>Inactive</status>','<status>Active</status>'| Set-Content -Path ../views-post-refresh/force-app/main/default/triggers/AccountTrigger.trigger-meta.xml
sfdx force:source:deploy -m ApexTrigger:AccountTrigger  -u $username

# Reactivate FOM Update External ID workflow Rule
sfdx force:source:retrieve -m "WorkflowRule:Account.FOM Update External ID"  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml -Raw) -replace '<active>false</active>','<active>true</active>'| Set-Content -Path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml
sfdx force:source:deploy -m "Workflow:Account"  -u $username

# Reactivate Update Owner on VA Org Record Type  workflow Rule
sfdx force:source:retrieve -m "WorkflowRule:Account.Update Owner on VA Org Record Type"  -u $username -w 5
(Get-Content -path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml -Raw) -replace '<active>false</active>','<active>true</active>'| Set-Content -Path ../views-post-refresh/force-app/main/default/workflows/Account.workflow-meta.xml
sfdx force:source:deploy -m "Workflow:Account"  -u $username

# Reactivate Process Builders
$flowArray = "CF_Account_Related_Functionality_Edit_Account", "CF_Move_Contact_To_New_Office_Process", "CF_Mark_User_As_Inactive", "CF_User_When_the_Contact_is_Created_Process", "Create_FOM_Data_Collection_Requests", "FOM_Default_Account_POC_from_POC_If_Null"

foreach ($flow in $flowArray)
{
$path = "../views-post-refresh/force-app/main/default/flowDefinitions/$flow.flowDefinition-meta.xml"
sfdx force:source:retrieve -m flowDefinition:$flow  -u $username -w 5
(gc -Path $path) | where {$_ -ne ""} | (Set-Content -Path $path)
(gc $flow".txt" ) | ac -Path $path
(gc -Path $path) -replace 'metadata"/', 'metadata"' | sc $path
"</FlowDefinition>" | ac -Path $path
sfdx force:source:deploy -m flowDefinition:$flow  -u $username
}

# Reactivate ViewsSSNUpdateTrigger
$path = "../views-post-refresh/force-app/main/default/objects/Account/validationRules/FOM_Activities_Field_Required_On_Level2s.validationRule-meta.xml"
sfdx force:source:retrieve -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username -w 5
(Get-Content -path $path -Raw) -replace '<active>false</active>','<active>true</active>'| Set-Content -Path $path
sfdx force:source:deploy -m ValidationRule:Account.FOM_Activities_Field_Required_On_Level2s  -u $username

