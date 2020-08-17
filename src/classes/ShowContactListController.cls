public class ShowContactListController {

    @AuraEnabled
    public static List < Contact > fetchCont(Integer intOffSet) {
        return [
                SELECT Id, Name, Email, Birthdate, Account.Name, Account.Id
                FROM Contact
                LIMIT 20
                OFFSET :Integer.valueOf(intOffSet)
        ];

    }

    @AuraEnabled
    public static Integer getNumberOrRows() {
        AggregateResult[] agRes = [
                SELECT COUNT(Id) numberOfRows
                FROM Contact
        ];
        return Integer.valueOf(agRes[0].get('numberOfRows'));
    }

    @AuraEnabled
    public static List<Id> deleteContacts(List<Id> toDelContactsIdList) {
        Database.DeleteResult[] deleteResults = Database.delete(toDelContactsIdList, false);
        List <Id> failedIdsToDelList = new List <Id>();
        for (Integer i = 0; i < deleteResults.size(); i++) {
            if (!(deleteResults[i].isSuccess())) {
                failedIdsToDelList.add(toDelContactsIdList[i]);
            }
        }
        return failedIdsToDelList;
    }
}