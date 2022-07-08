FOM_DataSetup fomData = new FOM_DataSetup(); 

Map<String, String> firstNameAndLastNameMap = new Map<String, String>{'Ace' => 'ActionOfficer', 'Cody' => 'Coordinator', 'Poppy' => 'POC', 'Arthur' => 'AuthorityManager'}; 

fomData.createContacts(firstNameAndLastNameMap); 