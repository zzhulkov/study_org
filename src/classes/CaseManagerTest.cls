@isTest
private class CaseManagerTest {
    
    @isTest
    static void createCaseExsistContactTest(){
        Contact con =new Contact(LastName='Test',
                                 Email='email1@gmail.com');
        insert con;
        ID thisCaseId = CaseManager.createCase(
            'Ferocious chipmunk', 'New', 'Phone', 'email1@gmail.com');
        // Verify results
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Subject, ContactId FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(con.Id, thisCase.ContactId);
        
    }
    
    @isTest
    static void createCaseNotExsistContactTest(){
        ID thisCaseId = CaseManager.createCase(
            'Ferocious chipmunk', 'New', 'Phone', 'email1@gmail.com');
        // Verify results
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Subject, ContactId FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assert(thisCase.ContactId!=null);
        
    }
    
    @isTest
    static void createCaseEmptyEmailContactTest(){
        ID thisCaseId = CaseManager.createCase(
            'Ferocious chipmunk', 'New', 'Phone', null);
        // Verify results
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Subject, ContactId FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assert(thisCase.ContactId!=null);
        
    }
}