@isTest
private with sharing class OpportunityTriggerHandlerTest {
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
    }
    
    @isTest
    static void countNumberOfOppsTest(){
        //given
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        //when
        Opportunity opp1=new Opportunity(Name='forTets2', 
                                         CloseDate=Date.today().addDays(10), 
                                         StageName='Prospecting', 
                                         AccountId=testAccount.id);
        insert opp1;
        
        //then
        testAccount=[SELECT id, NumberOfOpps__c, (SELECT id FROM Opportunities) FROM Account WHERE id=:testAccount.Id];
        system.assertEquals(testAccount.Opportunities.size(), 
                            testAccount.NumberOfOpps__c, 
                            'Number of opportunities doesn\'t match');
        
        //when
        Opportunity opp2=new Opportunity(Name='forTets3', 
                                         CloseDate=Date.today().addDays(10), 
                                         StageName='Prospecting',
                                         AccountId=testAccount.id);
        insert opp2;
        
        //then
        testAccount=[SELECT id, NumberOfOpps__c, (SELECT id FROM Opportunities) FROM Account WHERE id=:testAccount.Id];
        system.assertEquals(testAccount.Opportunities.size(), 
                            testAccount.NumberOfOpps__c, 
                            'Number of opportunities doesn\'t match');
        
        //when
        delete opp1;
        
        //then
        testAccount=[SELECT id, NumberOfOpps__c, (SELECT id FROM Opportunities) FROM Account WHERE id=:testAccount.Id];
        system.assertEquals(testAccount.Opportunities.size(), 
                            testAccount.NumberOfOpps__c, 
                            'Number of opportunities doesn\'t match');
        
        //when
        undelete opp1;
        
        //then
        testAccount=[SELECT id, NumberOfOpps__c, (SELECT id FROM Opportunities) 
                     FROM Account 
                     WHERE id=:testAccount.Id];
        
        system.assertEquals(testAccount.Opportunities.size(), 
                            testAccount.NumberOfOpps__c, 
                            'Number of opportunities doesn\'t match');
        
        //when
         Account testAccount2 = new Account(
            Name = 'Test Account2'
        );
        insert testAccount2;
         testAccount2=[SELECT id, NumberOfOpps__c, 
                       (SELECT id FROM Opportunities) 
                       FROM Account 
                       WHERE id=:testAccount2.Id];
        opp2.AccountId=testAccount2.Id;
        update opp2;
        
        //then
        testAccount=[SELECT id, NumberOfOpps__c, 
                     (SELECT id FROM Opportunities) 
                     FROM Account WHERE id=:testAccount.Id];
        
        system.assertEquals(testAccount.Opportunities.size(), 
                            testAccount.NumberOfOpps__c, 
                            'Number of opportunities doesn\'t match');
    }
    
    @isTest
    static void addTaskTest(){
        //given
        Opportunity opp1=new Opportunity(Name='forTets1', 
                                         CloseDate=Date.today().addDays(1), 
                                         StageName='Prospecting');
        insert opp1;
        opp1=[Select id, StageName 
              FROM Opportunity 
              WHERE id=:opp1.Id]; 
        
        //when
        opp1.StageName = 'Closed Won';
        update opp1;
        
        //then
        opp1=[Select id, StageName, (Select id, Subject FROM Tasks) 
              FROM Opportunity 
              WHERE id=:opp1.Id];
        system.assertEquals(opp1.Tasks[0].Subject, 'Follow up Closed Won','Task description doen\'t match' );
    }
}