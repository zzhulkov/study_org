public class ShowContactListController {
    
    @AuraEnabled
    public static List < Contact > fetchCont() {
        return [ SELECT Id, Name, Email, Birthdate, Account.Name FROM Contact];
    }
    
    @AuraEnabled
    public static List<Id> deleteContacts(List<Id> toDelContactsIdList){
        Database.DeleteResult[] deleteResults = Database.delete(toDelContactsIdList, false);
        List <Id> failedIdsToDelList=new List <Id>();
        for(Integer i=0; i<deleteResults.size(); i++){
            if(!(deleteResults[i].isSuccess())){
                failedIdsToDelList.add(toDelContactsIdList[i]);
            }  
        }
        return failedIdsToDelList;
    }
}