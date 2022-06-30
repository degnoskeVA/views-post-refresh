String environment = 'viewsdeval'; // change to 'staging' or etc as needed   

  

Set<String> usernames = new Set<String> {   

    'Edna.ExecSec@example.com.' + environment,   

    'Oscar.OCLA@example.com.' + environment,   

    'Elise.Executive@example.com.' + environment,   

    'Susan.Superuser@example.com.' + environment,   

    'Tracy.Trusteduser@example.com.' + environment,   

    'Larry.Liaison@example.com.' + environment,   

    'Samantha.SME@example.com.' + environment,   

    'Tim.Trusteduser@example.com.' + environment   

};  

  

String userEmail = 'viewsdevteam@bah.com';  

Id congressionalLetterProfileId = [SELECT Id FROM Profile WHERE Name = 'Views Congressional Letters'].Id;  

  

List<User> testUsers = new List<User>();  

for(String username : usernames) {  

    String firstAndLastName = username.substringBefore('@');  

    String alias = firstAndLastName.replace('.', '').substring(0, 8);  

    String firstName = firstAndLastName.substringBefore('.');  

    String lastName = firstAndLastName.replace('.', '').replace(firstName, '');  

  

    User u = new User(  

        Alias = alias,  

        Email = userEmail + '.unconfirmed',  

        EmailEncodingKey = 'UTF-8',  

        FederationIdentifier = username,  

        FirstName = firstName,  

        LastName = lastName,  

        LanguageLocaleKey = 'en_US',  

        LocaleSidKey = 'en_US',  

        ProfileId = congressionalLetterProfileId,  

        TimeZoneSidKey = 'America/New_York',  

        UserName = username  

    ); 

     

    testUsers.add(u);  

}  

  

insert testUsers;  

  

/*** Set Passwords ***/  

String password = 'ViewsDev2020!!';  

  

for(User u : testUsers) {  

    System.setPassword(u.Id,password);  

    u.Email = userEmail;  

} 

update testUsers; 