@isTest
public with sharing class EmailMessageTriggerHandlerTest {
    @testSetup
    static void setupTestData(){
        Case caseToIns=new Case(Status='New', Origin='Web');
        insert caseToIns;
    }
    
    @isTest
    static void insertSingleOutboundEmail(){
        
        //when
        Case selectedCase=[SELECT id FROM Case LIMIT 1];
        EmailMessage email = new EmailMessage();
        email.Incoming=false;
        email.subject = 'test subject'; // email subject
        email.ParentId=selectedCase.id;
        test.startTest();
        insert email;
        test.stopTest();
        
        //then
        selectedCase=[SELECT id,NumberOfInboundEmails__c, NumberOfOutboundEmails__c FROM Case LIMIT 1];
        System.assertEquals(1, selectedCase.NumberOfOutboundEmails__c, 'Case.NumberOfOutboundEmails__c shoud be 1');
    }

    
    @isTest
    static void emailMessageInsertTest(){
        //given
        Case selectedCase=[SELECT id FROM Case LIMIT 1];
        List<EmailMessage> emailMesList=new List<EmailMessage>();
        
        //when
        EmailMessage email = new EmailMessage();
        email.Incoming=true;
        email.fromAddress = 'sender@example.com'; // from address
        email.fromName = 'Dan Perkins'; // from name
        email.subject = 'This is the Subject!'; // email subject
        email.ParentId=selectedCase.id;
        emailMesList.add(email);
        EmailMessage email2 = new EmailMessage();
        email2.Incoming=false;
        email2.subject = 'This is the Subject!'; // email subject
        email2.ParentId=selectedCase.id;
        emailMesList.add(email2);

        test.startTest();
        insert emailMesList;
        test.stopTest();
        
        //then
        selectedCase=[SELECT id,NumberOfInboundEmails__c, NumberOfOutboundEmails__c FROM Case LIMIT 1];
        System.assertEquals(1, selectedCase.NumberOfInboundEmails__c, 'Case.NumberOfInboundEmails__c shoud be 1');
        System.assertEquals(1, selectedCase.NumberOfOutboundEmails__c, 'Case.NumberOfOutboundEmails__c shoud be 1');
        
    }
    
    
    @isTest
    static void emailMessageDeleteTest(){
        //given
        Case selectedCase=[SELECT id FROM Case LIMIT 1];
        List<EmailMessage> emailMesList=new List<EmailMessage>();
        
        //when
        EmailMessage email = new EmailMessage();
        email.Incoming=true;
        email.fromAddress = 'sender@example.com'; // from address
        email.fromName = 'Dan Perkins'; // from name
        email.subject = 'This is the Subject!'; // email subject
        email.ParentId=selectedCase.id;
        emailMesList.add(email);
        EmailMessage email2 = new EmailMessage();
        email2.Incoming=false;
        email2.subject = 'This is the Subject!'; // email subject
        email2.ParentId=selectedCase.id;
        emailMesList.add(email2);
        
        
        //when
        test.startTest();
        insert emailMesList;
        delete emailMesList;
        test.stopTest();
        
        //then
        selectedCase=[SELECT id,NumberOfInboundEmails__c, NumberOfOutboundEmails__c FROM Case LIMIT 1];
        System.assertEquals(0, selectedCase.NumberOfInboundEmails__c, 'Case.NumberOfInboundEmails__c ');
        System.assertEquals(0, selectedCase.NumberOfOutboundEmails__c, 'Case.NumberOfOutboundEmails__c ');
            
        
    }
    
}