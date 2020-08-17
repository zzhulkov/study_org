({
    sendPDF: function(cmp, event, helper) {
        var action = cmp.get("c.sendPDFByEmail");
        action.setParams({
            lessonId: cmp.get("v.recordId"),
            email: cmp.get("v.emailAddress")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "SUCCESS",
                    "title": "Success!",
                    "message": "PDF is seend."
                });
                toastEvent.fire();
                
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
    }
})