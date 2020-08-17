trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    
	if (Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
	}    
    
    if (Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if (Trigger.isAfter && Trigger.isDelete){
        OpportunityTriggerHandler.handleAfterDelete(Trigger.oldMap);
	}
    
    if (Trigger.isAfter && Trigger.isUndelete){
        OpportunityTriggerHandler.handleAfterUndelete(Trigger.new);
	}
}