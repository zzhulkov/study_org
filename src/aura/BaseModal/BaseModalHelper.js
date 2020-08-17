({
    init: function(cmp){
        if (cmp.get("v.isCloseByEsc")) {
            document.addEventListener("keyup", event => {
                if (event.key === "Escape" && cmp.get("v.isOpen")) {
                    this.emitClose(cmp);
                }
            });
        }
    },

    emitClose: function(cmp) {
        var event = cmp.getEvent("onclose");
        event.fire();
    },

    stopEvent: function(event) {
        event.stopPropagation();
    }
});