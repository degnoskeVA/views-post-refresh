//Script #1 GAO Setup


Id congressionalLetterProfileId = [SELECT Id FROM Profile WHERE Name = 'Views Congressional Letters'].Id;

List<User> testUsersToCreate = new List<User>();

void setupUser(String firstName, String lastName, String email, boolean emailConfirmationNeeded) {
    String alias = (firstName + lastName).replace(' ','');
    String emailConfirmationString = emailConfirmationNeeded ? '.unconfirmed' : '';
    if (alias.length() > 8) alias = alias.substring(0,8);
    testUsersToCreate.add(
            new User(
                    Alias = alias,
                    Email = email + emailConfirmationString,
                    EmailEncodingKey = 'UTF-8',
                    FederationIdentifier = firstName + lastName,
                    FirstName = firstName,
                    LastName = lastName,
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    ProfileId = '00et0000000QI0w',
                    TimeZoneSidKey = 'America/New_York',
                    Username = email + '.' + environmentName
            )
    );
}

setupUser('Orlando', 'OCLA', 'oclauser2@bah.com', true);
//setupUser('Olivia', 'OCLA', 'oclauser2@bah.com', true);
setupUser('Victor', 'VHA', 'vhauser2@bah.com', true);
//setupUser('Violet', 'VHA', 'vhauser2@bah.com', true);
setupUser('Ben', 'VBA', 'vbauser2@bah.com', true);
//setupUser('Beth', 'VBA', 'vbauser2@bah.com', true);
setupUser('Tiffany', 'OIT', 'oituser@bah.com', true);

setupUser('Adam', 'BVA', 'bvauser@va.gov.invalid', false);
setupUser('Oden', 'OEI', 'oeiuser@va.gov.invalid', false);
setupUser('Eden', 'Execsec', 'execsecuser@va.gov.invalid', false);

insert testUsersToCreate;

String password = 'GAODev2020!!';

for(User u : testUsersToCreate) {
    System.setPassword(u.Id,password);
    u.Email = u.Email.replace('.unconfirmed', '');
}

update testUsersToCreate;