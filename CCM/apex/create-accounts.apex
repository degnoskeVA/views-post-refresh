
Id organizationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VA_Organization').getRecordTypeId(); 

 

// primary offices 

 

Set<String> hierarchyGroupAPINames = new Set<String> { 

        'Views_ExecSec', 

        'VIEWS_ExecSec_Team1', 

        'VIEWS_ExecSec_Team', 

        'Views_OCLA', 

        'Views_OCLA_Team1', 

        'Views_OCLA_Team', 

        'VBA_20_Under_Secretary_for_Benefits', 

        'VBA_20_Under_Secretary_for_Benefits1', 

        'VBA_201_the_Principal_Deputy_Under_Secre', 

        'VBA_201_the_Principal_Deputy_Under_Secre1', 

        'VBA_20A1_the_Deputy_Chief_of_Staff', 

        'VBA_20A1_the_Deputy_Chief_of_Staff1', 

        'OI_T_005_Information_Technology', 

        'OI_T_005_Information_Technology1', 

        'VHA_10P_DUSH_for_Policy_and_Services', 

        'VHA_10P_DUSH_for_Policy_and_Services1' 

}; 

 

List<Group> hierarchyGroups = [SELECT Id, Type, DeveloperName FROM Group WHERE DeveloperName IN :hierarchyGroupAPINames]; 

 

String modulePrefix = 'CCM '; 

public static Account AccountWrapper(String name, String mailcode, String acronym) { 

    Account a = new Account(Name = modulePrefix + name, CF_Mail_Code__c = mailcode, VA_Organization_Acronym__c = acronym, RecordTypeId = organizationRecordTypeId, CF_VIEWS_Account__c = true); 

 

    for(Group g : hierarchyGroups) { 

        if(mailcode == '001B') { 

            if(g.DeveloperName == 'Views_ExecSec' && g.Type == 'Queue') { 

                String queueId = g.Id; 
                a.CF_Queue_ID__c = queueId.substring(0,queueId.length()-3); 

            } else if(g.DeveloperName == 'VIEWS_ExecSec_Team1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VIEWS_ExecSec_Team' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '009') { 

            if(g.DeveloperName == 'Views_OCLA' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'Views_OCLA_Team1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'Views_OCLA_Team' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '20') { 

            if(g.DeveloperName == 'VBA_20_Under_Secretary_for_Benefits' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_20_Under_Secretary_for_Benefits1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_20_Under_Secretary_for_Benefits' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '201') { 

            if(g.DeveloperName == 'VBA_201_the_Principal_Deputy_Under_Secre' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_201_the_Principal_Deputy_Under_Secre1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_201_the_Principal_Deputy_Under_Secre' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '20A1') { 

            if(g.DeveloperName == 'VBA_20A1_the_Deputy_Chief_of_Staff' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_20A1_the_Deputy_Chief_of_Staff1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VBA_20A1_the_Deputy_Chief_of_Staff' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '005') { 

            if(g.DeveloperName == 'OI_T_005_Information_Technology' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'OI_T_005_Information_Technology1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'OI_T_005_Information_Technology' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

        else if(mailcode == '10P') { 

            if(g.DeveloperName == 'VHA_10P_DUSH_for_Policy_and_Services' && g.Type == 'Queue') { 

                a.CF_Queue_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VHA_10P_DUSH_for_Policy_and_Services1' && g.Type == 'Regular') { 

                a.CF_Group_ID__c = g.Id; 

            } else if(g.DeveloperName == 'VHA_10P_DUSH_for_Policy_and_Services' && g.Type == 'Regular') { 

                a.CF_Nested_Group_ID__c = g.Id; 

            } 

        } 

    } 

     

    return a; 

} 

 

Map<String,Account> accountsToCreate = new Map<String,Account>(); 

accountsToCreate.put('OSVA-001B Executive Secretariat', AccountWrapper('OSVA-001B Executive Secretariat', '001B', 'OSVA')); 

accountsToCreate.put('OCLA-009 Assistant Secretary of Congrega', AccountWrapper('OCLA-009 Assistant Secretary of Congrega', '009', 'OCLA')); 

accountsToCreate.put('VBA-20 Under Secretary for Benefits', AccountWrapper('VBA-20 Under Secretary for Benefits', '20', 'VBA')); 

accountsToCreate.put('VBA-201 the Principal Deputy Under Secretary for Benefits', AccountWrapper('VBA-201 the Principal Deputy Under Secretary for Benefits', '201', 'VBA')); 

accountsToCreate.put('VBA-20A1 the Deputy Chief of Staff', AccountWrapper('VBA-20A1 the Deputy Chief of Staff', '20A1', 'VBA')); 

accountsToCreate.put('OI&T-005 Assistant Secretary for Information and Technology and Chief Information Officer', AccountWrapper('OI&T-005 Assistant Secretary for Information and Technology and Chief Information Officer', '005', 'OI&T')); 

accountsToCreate.put('VHA-10P DUSH for Policy and Services', AccountWrapper('VHA-10P DUSH for Policy and Services', '10P', 'VHA')); 

 

List<Account> currentViewsAccounts = [SELECT Name FROM Account WHERE CF_Group_ID__c != NULL AND CF_VIEWS_Account__c = TRUE]; 

 

for (Account currentViewsAccount : currentViewsAccounts) { 

    if (accountsToCreate.keySet().contains(currentViewsAccount.Name)) { 

        accountsToCreate.get(currentViewsAccount.Name).Id = currentViewsAccount.Id; 

    } 

} 

 

upsert accountsToCreate.values();