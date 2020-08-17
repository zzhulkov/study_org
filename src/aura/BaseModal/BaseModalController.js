({
    doInit: function(cmp, event, helper) {
        helper.init(cmp);
    },

    onClose: function(cmp, event, helper) {
        helper.emitClose(cmp);
    },

    onOutClick: function(cmp, event, helper) {
        if (cmp.get("v.isCloseByOutclick")){
            helper.emitClose(cmp);
        }
    },

    stopPropagation: function(cmp, event, helper) {
        helper.stopEvent(event);
    }
});