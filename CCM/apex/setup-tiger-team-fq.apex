public static Functional_Queue__c createFunctionalQueue(String functionalQueueName) { 

    Functional_Queue__c testFunctionalQueue = new Functional_Queue__c(); 

    testFunctionalQueue.Name = functionalQueueName; 

    return testFunctionalQueue; 

} 

 

public static Functional_Queue_Member__c createFunctionalQueueMember(Id functionalQueueId, Id contactId) { 

    Functional_Queue_Member__c testFunctionalQueueMember = new Functional_Queue_Member__c(); 

    testFunctionalQueueMember.Functional_Queue__c = functionalQueueId; 

    testFunctionalQueueMember.Contact_Member__c = contactId; 

    return testFunctionalQueueMember; 

} 

 

Functional_Queue__c tigerTeamOne = createFunctionalQueue('Tiger Team One'); 

tigerTeamOne.Associated_Application__c = 'VIEWS'; 

 

Functional_Queue__c tigerTeamTwo = createFunctionalQueue('Tiger Team Two'); 

tigerTeamTwo.Associated_Application__c = 'VIEWS'; 

 

Functional_Queue__c tigerTeamThree = createFunctionalQueue('Tiger Team Three'); 

tigerTeamThree.Associated_Application__c = 'VIEWS'; 

 

Functional_Queue__c tigerTeamFour = createFunctionalQueue('Tiger Team Four'); 

tigerTeamFour.Associated_Application__c = 'VIEWS'; 

 

insert new List<Functional_Queue__c>{tigerTeamOne, tigerTeamTwo, tigerTeamThree, tigerTeamFour}; 

 

Sub_Functional_Queue__c subQTigerTeamFour = new Sub_Functional_Queue__c(); 

subQTigerTeamFour.Parent_Functional_Queue__c = tigerTeamThree.Id; 

subQTigerTeamFour.Sub_Functional_Queue__c = tigerTeamFour.Id; 

 

Sub_Functional_Queue__c subQTigerTeamThree = new Sub_Functional_Queue__c(); 

subQTigerTeamThree.Parent_Functional_Queue__c = tigerTeamTwo.Id; 

subQTigerTeamThree.Sub_Functional_Queue__c = tigerTeamThree.Id; 

 

Sub_Functional_Queue__c subQTigerTeamTwo = new Sub_Functional_Queue__c(); 

subQTigerTeamTwo.Parent_Functional_Queue__c = tigerTeamOne.Id; 

subQTigerTeamTwo.Sub_Functional_Queue__c = tigerTeamTwo.Id; 

 

insert new List<Sub_Functional_Queue__c>{subQTigerTeamFour, subQTigerTeamThree, subQTigerTeamTwo}; 

 

Contact larryLiaison = [SELECT Id, Name FROM Contact WHERE Name = 'Larry Liaison' LIMIT 1]; 

Functional_Queue_Member__c queueMemberLarry = createFunctionalQueueMember(tigerTeamFour.Id, larryLiaison.Id); 

 

Contact ednaExec = [SELECT Id, Name FROM Contact WHERE Name = 'Edna ExecSec' LIMIT 1]; 

Functional_Queue_Member__c queueMemberEdna = createFunctionalQueueMember(tigerTeamThree.Id, ednaExec.Id); 

 

Contact tracyTrustedUser = [SELECT Id, Name FROM Contact WHERE Name = 'Tracy TrustedUser' LIMIT 1]; 

Functional_Queue_Member__c queueMemberTracy = createFunctionalQueueMember(tigerTeamTwo.Id, tracyTrustedUser.Id); 

 

Contact oscarOcla = [SELECT Id, Name FROM Contact WHERE Name = 'Oscar OCLA' LIMIT 1]; 

Functional_Queue_Member__c queueMemberOscar = createFunctionalQueueMember(tigerTeamOne.Id, oscarOcla.Id); 

 

Contact eliseExec = [SELECT Id, Name FROM Contact WHERE Name = 'Elise Executive' LIMIT 1]; 

Functional_Queue_Member__c queueMemberElise = createFunctionalQueueMember(tigerTeamOne.Id, eliseExec.Id); 

 

insert new List<Functional_Queue_Member__c>{queueMemberLarry, queueMemberEdna, queueMemberTracy, queueMemberOscar, queueMemberElise}; 