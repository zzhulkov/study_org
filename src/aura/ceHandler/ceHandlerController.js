/* ceHandlerController.js */
({
    handleComponentEvent : function(cmp, event) {
        var message = event.getParam("message");

        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents"));
        cmp.set("v.numEvents", numEventsHandled + 1);
    }
})