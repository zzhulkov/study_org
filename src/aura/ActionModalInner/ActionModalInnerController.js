({
    onInit: function(cmp, event, helper) {

    },

    onScrollBody: function(cmp, event, helper) {
        var bodyScrollerCmp = cmp.find("bodyScroller");
        if (bodyScrollerCmp) {
            bodyScrollerCmp.scrollTo("top");
        }
    }
});