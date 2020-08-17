public with sharing class ContactTriggerHandler {
    public static void handleBeforeDelete(List<Contact> oldContacts){
        validateContactDelete(oldContacts);
    }
    
    private static void validateContactDelete(List<Contact> oldContacts){
        for(Contact con: [SELECT Id
                          FROM Contact
                          WHERE Id in :oldContacts AND Id in (Select ContactId 
                                                              From Case 
                                                              WHERE IsClosed = FALSE)]){
            trigger.oldMap.get(con.Id).addError(
                Label.Contact_cannot_be_closed_when_a_related_Case_is_still_open);
        }
    }
}