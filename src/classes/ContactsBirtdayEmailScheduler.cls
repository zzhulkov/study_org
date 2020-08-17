global class ContactsBirtdayEmailScheduler implements Schedulable {
	
    global void execute(SchedulableContext ctx) {
        List<Contact> contactList = [
            SELECT Id, firstName, lastName, email
            FROM Contact 
            WHERE Birthdate = TODAY
        ];
        if (contactList.isEmpty()) {
            return;
        }
        
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for (Contact contact_i : contactList) {
            emailsList.add(
            	generateEmail(contact_i)
            );
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsList);
    }
    
    private Messaging.SingleEmailMessage generateEmail(Contact contact) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contact.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Happy bitthday!' );
        mail.setPlainTextBody('Happy birtday dear '+ contact.LastName 
                              + '!!! Your discount coupon for 100$ is HB2020  you can only use it for 2 weeks');
        return mail;
    }
}