({
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.contList");
        var reverse = sortDirection !== 'asc';
        switch(fieldName){
            case 'linkContName': data = Object.assign([],
                                                       data.sort(this.sortBy('Name', reverse ? -1 : 1)));
                break;
            case 'linkAccName' : data = Object.assign([],
                                                      data.sort(this.sortBy('AccountName', reverse ? -1 : 1)));
                break;

            default: data = Object.assign([],
                                          data.sort(this.sortBy(fieldName, reverse ? -1 : 1)));
        }
        cmp.set("v.contList", data);
    },


    getContacts: function (cmp, event, offSetCount) {
        var self = this;
        var action = cmp.get("c.fetchCont");
        action.setParams({
            "intOffSet" : offSetCount
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var loadedRecords = self.formatData(response.getReturnValue());
                console.log("loaded records: " + loadedRecords);
                var currentContList=cmp.get("v.contList");
                cmp.set("v.contList", currentContList.concat(loadedRecords));
            }
            console.log( cmp.get("v.contList"));
            event.getSource().set("v.isLoading", false);
            console.log(event.getSource());

        });
        $A.enqueueAction(action);
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        
        return function (a, b) {
           var A = (key(a)) ? (key(a)) : "";
                   var B = key(b) ? key(b) : "";
                   return reverse * ((A.toLowerCase() > B.toLowerCase()) - (B.toLowerCase() > A.toLowerCase()));
        };
    },
    
    formatData : function( rows ) {
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            row.linkContName = '/'+row.Id;
            if (row.Account) {
                row.AccountName = row.Account.Name;
                row.AccountId = row.Account.Id;
                row.linkAccName='/'+row.AccountId;
            }
        }
        return rows;
    },
    
    deleteConts : function(cmp, event, helper){

        //console.log("LENGTH= "+ selectedContactsList.length);
        var selectedContactsList=cmp.find("contactsTable").getSelectedRows();
        var contactIdsToDelList=[];
        for(var i=0; i<selectedContactsList.length;i++){
            contactIdsToDelList.push(selectedContactsList[i].Id);
        }
        var action = cmp.get("c.deleteContacts");
        action.setParams({
            "toDelContactsIdList": contactIdsToDelList 
        });
        action.setCallback(this, function(response){
            
            var state=response.getState();
            if(state==="SUCCESS")
                var returnVal=response.getReturnValue();
            var toastEvent = $A.get('e.force:showToast');
            if(returnVal.length===0){
                toastEvent.setParams({
                    'title': 'Success!',
                    'type': 'success',
                    'mode': 'dismissable',
                    'message': 'records deleted'
                });
                // Fire success toast event ( Show toast )
                toastEvent.fire();            
            } else{
                var failedRecords=returnVal.join('<br>');
                toastEvent.setParams({
                    'title': 'Failed to delete some contacts:',
                    'type': 'error',
                    'mode': 'dismissable',
                    'message': failedRecords
                });
                // Fire success toast event ( Show toast )
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})