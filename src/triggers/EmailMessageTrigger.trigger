trigger EmailMessageTrigger on EmailMessage (after insert, after delete) {
    if(trigger.isAfter && trigger.isInsert){
        EmailMessageTriggerHandler.handleAfterInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isDelete){
        EmailMessageTriggerHandler.handleAfterDelete((Map<Id, EmailMessage>) trigger.oldMap);
    }
}