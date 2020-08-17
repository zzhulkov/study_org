public with sharing class OpportunityTriggerHandler {
    
    public static void handleAfterInsert(List<Opportunity> newOpps){
        countNumberOfOpps(newOpps, null);
    }
    
    public static void handleAfterUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps){
        addTask(newOpps, oldOpps);
        countNumberOfOpps(newOpps, oldOpps);
    }
    
    public static void handleAfterDelete(Map<Id, Opportunity> oldOpps){
        countNumberOfOpps(null, oldOpps);
    }
    
    public static void handleAfterUndelete(List<Opportunity> newOpps){
        countNumberOfOpps(newOpps, null);
    }
    
    
    private static void addTask (List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps){
        List<Task> taskList =new List<Task>();
        
        for (Opportunity opp : newOpps) {
            if (oldOpps.get(opp.Id).StageName != opp.StageName && opp.StageName == 'Closed Won')
                taskList.add(new Task(WhatId = opp.id, 
                                      Subject = 'Follow up Closed Won'));
        }
        
        if(!taskList.isEmpty())
        insert taskList;
    }
    
    private static void countNumberOfOpps(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIdSet = new Set<Id>();
        
        List<Opportunity> opportunityToProcessList = (!Trigger.isDelete)
            ? newList
            : oldMap.values();        
        for (Opportunity opp_i : opportunityToProcessList) {
            if ((Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete) && opp_i.AccountId != null) {
                accountIdSet.add(opp_i.AccountId);
            }
            
            if (Trigger.isUpdate && opp_i.AccountId != oldMap.get(opp_i.Id).AccountId) {
                if (opp_i.AccountId != null) {
                    accountIdSet.add(opp_i.AccountId);
                }
                if (oldMap.get(opp_i.Id).AccountId != null) {
                    accountIdSet.add(oldMap.get(opp_i.Id).AccountId);
                }
            }
        }
        if (accountIdSet.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdateList = new List<Account>();
        for (Account account_i : [
            SELECT Id, (SELECT Id FROM Opportunities)
            FROM Account 
            WHERE Id IN :accountIdSet
        ]) {
            account_i.NumberOfOpps__c = account_i.Opportunities.size();
            accountsToUpdateList.add(account_i);
        }
        update accountsToUpdateList;
    }
}