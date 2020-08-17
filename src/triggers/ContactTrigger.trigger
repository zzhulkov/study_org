trigger ContactTrigger on Contact (before delete) {
	if (Trigger.isBefore && Trigger.isDelete){
        ContactTriggerHandler.handleBeforeDelete(Trigger.old);
    }
}