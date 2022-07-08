FOM_DataSetup fomData = new FOM_DataSetup(); 

fomData.buildData(); 

FOM_DataSetup fomData = new FOM_DataSetup(); 
fomData.loadAuthorities(); 
 

FOM_DataSetup fomData = new FOM_DataSetup(); 

fomData.loadContacts(); 

 
FOM_DataSetup fomData = new FOM_DataSetup(); 

Map<String, String> firstNameAndLastNameMap = new Map<String, String>{'Ace' => 'ActionOfficer', 'Cody' => 'Coordinator', 'Poppy' => 'POC', 'Arthur' => 'AuthorityManager'}; 

fomData.createUsers(firstNameAndLastNameMap); 

 

FOM_DataSetup fomData = new FOM_DataSetup(); 

Map<String, String> firstNameAndLastNameMap = new Map<String, String>{'Ace' => 'ActionOfficer', 'Cody' => 'Coordinator', 'Poppy' => 'POC', 'Arthur' => 'AuthorityManager'}; 

fomData.createContacts(firstNameAndLastNameMap); 