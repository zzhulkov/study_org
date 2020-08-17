public with sharing class AccountTriggerHandler {
    
    
    public static void handleAfterInsert(List<Account> newList, Map<Id,sObject> newAccMap){
        generateGuidId(newAccMap.keyset(), 'zhylkof@gmail.com');
    }
    
    @future(callout=true)
    private static void generateGuidId(Set<Id> newSetId, String emailAddress){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.uuidgenerator.net/api/version1');
        request.setMethod('GET');
        List<Account> accList=[Select Id
                               From Account
                               Where Id in :newSetId];
        List<Account> accsToUpdate=new List<Account>();
        List<ID> failedAccIDs=new List<ID>();
        for(Account acc_i:accList){
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200){
                acc_i.guidId__c=response.getBody();
                accsToUpdate.add(acc_i);
            }
            else{
                failedAccIDs.add(acc_i.Id);
            }
            
            if(accsToUpdate.size()>0){
                update accsToUpdate;
            }
            
            if(failedAccIds.size()>0){
                failedAccIDs.remove(null);
                EmailManager.SendMail(emailAddress, 'Error', 'Account trigger handler-> after insert: next account IDs failed to update GUID ID : ' +string.join(failedAccIDs,' '));
            }
        }
    }
    
}