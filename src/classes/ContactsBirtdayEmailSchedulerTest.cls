@isTest
public class ContactsBirtdayEmailSchedulerTest {
    public static String CRON_EXP = '0 0 9 * * ?';
    
    @testSetup 
    static void setup() {
        Account acc=new Account(Name='Test acc');
        insert acc;
        ID accId=acc.Id;
        
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName='LastName', 
                                        FirstName='FirstName',
                                        AccountId=accId,
                                        Birthdate=Date.Today().AddYears(-20),
                                        Email='Email@domain.com'));
        insert contactList;
    }
    
    @IsTest
    static void testScheduledJob() {
        test.startTest();
        String jobId = System.schedule('Scheduled ContactsBirtdayEmailScheduler',
            CRON_EXP, 
            new ContactsBirtdayEmailScheduler());  
        test.stopTest();
    }
}