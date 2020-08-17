({
    init: function(cmp) {
        var self = this;
        
        var action = cmp.get("c.obtainLessonInitData");
        action.setParams({
            courseId: cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger
                var lesson = response.getReturnValue();
                
                this.fireLessonCreation(cmp, lesson);
                
            } else if (state === "INCOMPLETE") {
                console.log("Something went wrong");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " +  errors[0].message);
                } else {
                    console.log("Something went wrong");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fireLessonCreation: function(cmp, data) {
        var action = $A.get("e.force:createRecord");
        action.setParams({
            entityApiName: "Lesson__c",
            defaultFieldValues: data
        });
        action.fire();
    }
});