@IsTest
private class AccountTriggerHandlerTest {
    
    @isTest
    static void specifyDescriptionTest(){
        Test.setMock(HttpCalloutMock.class, new UuidGeneratorHttpsCalloutMock()); 
        List<Account> accList=new  List<Account>();
        accList.add(new Account(Name = 'Test'));
        test.starttest();
        insert accList;
        test.stoptest();
        accList = [SELECT Id FROM Account WHERE guidId__c !=null];
        system.debug(accList.size());
        System.assertEquals(1, accList.size());
        
    }
    
}