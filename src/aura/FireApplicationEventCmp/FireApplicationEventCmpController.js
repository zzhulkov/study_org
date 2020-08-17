({
    fireApplicationEvent: function(cmp, event) {
        var appEvent = $A.get("e.c:ApplicationEventTest");
        appEvent.setParams({
            message : "An application event fired me. " + "It all happened so fast. Now, I'm everywhere!" 
        });
        appEvent.fire();
    }
})