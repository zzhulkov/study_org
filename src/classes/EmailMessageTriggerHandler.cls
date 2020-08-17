public class EmailMessageTriggerHandler {
    public static void handleAfterInsert(List<EmailMessage> newEmailList){
        caseCountNumberOfEmails(newEmailList, null);
    }
    
    public static void handleAfterDelete(Map<Id, EmailMessage> oldMap){
        caseCountNumberOfEmails(null, oldMap);
    }
    
    private static void caseCountNumberOfEmails(List<EmailMessage> newList, Map<Id, EmailMessage> oldMap) {
        Map<Id, Integer> caseIdToNumOfInboundEmailsMap = new Map<Id, Integer>();
        Map<Id, Integer> caseIdToNumOfOutboundEmailsMap = new Map<Id, Integer>();
        List<Case> casesToUpdateList = new List<Case>();
        Map <Id, Case> casesToUpdMap=new Map<Id, Case>();
        
        List<EmailMessage> emailMessageToProcessList = (!Trigger.isDelete)
            								? newList
            								: oldMap.values();        
        for (EmailMessage mess_i : emailMessageToProcessList) {
            if ((Trigger.isInsert || Trigger.isDelete) && mess_i.ParentID != null) {
                if(!mess_i.Incoming){
                    caseIdToNumOfOutboundEmailsMap.put(mess_i.ParentId, 0);
                }
                if(mess_i.Incoming ){
                    caseIdToNumOfInboundEmailsMap.put(mess_i.ParentId, 0);
                }
            }
         }
        if (!caseIdToNumOfInboundEmailsMap.isEmpty()) {
            List<AggregateResult> aggResList=[
                SELECT COUNT(Id) inboundEmailCount, ParentID caseId
                FROM EmailMessage
                WHERE ParentId IN :caseIdToNumOfInboundEmailsMap.keySet() AND Incoming = TRUE
                GROUP BY ParentID
            ];
            
            if (!aggResList.isEmpty()) {
                for (AggregateResult result_i : aggResList) {
                    if (caseIdToNumOfInboundEmailsMap.containsKey((Id)result_i.get('caseId'))) {
                        caseIdToNumOfInboundEmailsMap.put((Id)result_i.get('caseId'), (Integer)result_i.get('inboundEmailCount'));
                    }
                }
            }
        }
        //////////////////////////////////
        
        if (!caseIdToNumOfOutboundEmailsMap.isEmpty()) {
            List<AggregateResult> aggResList=[
                SELECT COUNT(Id) outboundEmailCount, ParentID caseId
                FROM EmailMessage
                WHERE ParentId IN :caseIdToNumOfOutboundEmailsMap.keySet()AND Incoming = FALSE
                GROUP BY ParentID
            ];
            
            if (!aggResList.isEmpty()) {
                for (AggregateResult result_i : aggResList) {
                    if (caseIdToNumOfOutboundEmailsMap.containsKey((Id)result_i.get('caseId'))) {
                        caseIdToNumOfOutboundEmailsMap.put((Id)result_i.get('caseId'), (Integer)result_i.get('outboundEmailCount'));
                    }
                }
            }
        }
        
        for (Id caseId_i : caseIdToNumOfInboundEmailsMap.keySet()) { //add cases with inbound emails to updateMap
            casesToUpdMap.put(caseId_i, new Case(
                	Id = caseId_i,
                    NumberOfInboundEmails__c = caseIdToNumOfInboundEmailsMap.get(caseId_i)
                ));
        }
        for (Id caseId_i : caseIdToNumOfOutboundEmailsMap.keySet()) { //add cases with outbound emails to updatemap
            if(casesToUpdMap.containsKey(caseId_i)){ //cases with both type of emails
                Case caseToModify=casesToUpdMap.get(caseId_i);
                caseToModify.NumberOfOutboundEmails__c=caseIdToNumOfOutboundEmailsMap.get(caseId_i);
                casesToUpdMap.put(caseId_i, caseToModify);
            }
            else{ //cases with only outbound emails
                Case caseToModify=new Case();
                caseToModify.Id=caseId_i;
                caseToModify.NumberOfOutboundEmails__c=caseIdToNumOfOutboundEmailsMap.get(caseId_i);
                casesToUpdMap.put(caseId_i, caseToModify);
            }
        }
        
        update casesToUpdMap.values();
    }
}