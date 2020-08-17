({
    onInit : function(cmp, event, helper) {
        cmp.set('v.mycolumns', [
            {label: 'Name', fieldName: 'linkContName', type: 'url', sortable : true, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Email', fieldName: 'Email', type: 'email', sortable : true},
            {label: 'Birthday', fieldName: 'Birthdate', type: 'date', sortable : true},
            {label: 'Account Name', fieldName: 'linkAccName', type: 'url', sortable : true, typeAttributes: { label: { fieldName: 'AccountName' }, target: '_blank'}  }
        ]);
        console.log("in init func");
        helper.getContacts(cmp, event, 0);
    },
    
    handleSelection :function (cmp, event, helper){
        var selRows=event.getParam("selectedRows");
        if(selRows.length>0){
            cmp.set("v.isDisableButtonDelete",false);
        } else{
            cmp.set("v.isDisableButtonDelete",true);
        }
        /**/
    },

    loadMoreData : function(cmp, event, helper) {
        debugger;
        console.log(event.getSource());
        event.getSource().set("v.isLoading", true);
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.getContacts(cmp, event, cmp.get('v.contList').length);
        console.log( "isLoading= " +event.getSource("v.isLoading"));
    },
    
    deleteSelectedContacts: function(cmp, event, helper){
        helper.deleteConts(cmp,event,helper);
        //helper.getContacts(cmp,event,helper);
    },
    
    handleSort :function (cmp, event, helper){
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    newRecord :function(cmp, event,helper){
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Contact"
        });
        createAcountContactEvent.fire();
    }

})