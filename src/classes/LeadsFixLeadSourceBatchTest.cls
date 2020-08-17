@isTest
public class LeadsFixLeadSourceBatchTest {
    @testSetup 
    static void setup() {
        List<Lead> leadsList = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leadsList.add(new Lead(lastName='Lead '+i, 
                                   Company='Test Company'));
        }
        insert leadsList;
    }
    
    @isTest
    static void test() { 
        //system.debug([select count() from Lead]);
        Test.startTest();
        LeadsFixLeadSourceBatch leadFix = new LeadsFixLeadSourceBatch('Test lead source');
        Id batchId = Database.executeBatch(leadFix);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [select count() 
                                  from Lead 
                                  where LeadSource = 'Test lead source']);
    }
}