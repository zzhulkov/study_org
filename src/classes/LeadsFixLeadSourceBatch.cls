global class LeadsFixLeadSourceBatch implements Database.Batchable<sObject>, Database.Stateful  {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Integer successRecordsProcessed = 0;
    global Integer failedRecordsProcessed = 0;
    private String query;
    private String leadSource;
    
    public LeadsFixLeadSourceBatch(String leadSource) {
        this.leadSource = String.isNotBlank(leadSource) ? leadSource : 'WEB';
        this.query =  'SELECT  Id  ' 
            + 'FROM Lead ' 
            + 'WHERE CreatedDate = LAST_N_MONTHS:2 OR CreatedDate = THIS_MONTH'
            ;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        List<Lead> leadList = new List<Lead>();
        for (Lead lead_i : scope) {
            lead_i.LeadSource=this.leadSource;
            leadList.add(lead_i);
            recordsProcessed = recordsProcessed + 1;
        }
        Database.SaveResult[] srList = Database.update(leadList, false);
        
        // Iterate through each returned result
        for (Integer i = 0; i < srList.size(); i++) {
            if (srList[i].isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated lead. Lead ID: ' + srList[i].getId());
                successRecordsProcessed++;
            }
            else {
                // Operation failed, so get all errors  
                failedRecordsProcessed++;              
                for(Database.Error err : srList[i].getErrors()) {
                    System.debug('The following error has occurred.: ' + leadList[i].Id);                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Lead fields that affected this error: ' + err.getFields());
                }
            }
        }
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        EmailManager.sendMail('zhylkof@gmail.com', 'test job:' + bc.getJobId(), 'Test');
    }   
    
}