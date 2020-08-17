@isTest
public with sharing class ContactTriggerHandlerTest {
    
	@TestSetup
    static void setupTestData() {
        
    }
    
    @isTest
    static void handleBeforeDeleteTest(){
        //given
        Contact con =new Contact(lastName='contact test delete');
        insert con;
        con=[Select id FROM Contact WHERE id=:con.id];
        Case additionalCase= new Case(Status='New', ContactId=con.Id, Origin='Email');
        insert additionalCase;
        
        //then
         try {
            delete con;
            System.assert(false, 'Exception was expected');
        } catch (Exception ex) {
            System.assert(ex.getMessage().containsIgnoreCase(Label.Contact_cannot_be_closed_when_a_related_Case_is_still_open));
        }
    }
}