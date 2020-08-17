({
    TOAST_TYPES: {
        INFO: "info",
        SUCCESS: "success",
        WARNING: "warning",
        ERROR: "error",
    },
    navigateToURL: function(url) {
        if (url) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                url: url
            });
            urlEvent.fire();
        }
    },

    navigateToURLRecordId: function (recordId) {
        if (recordId) {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": recordId
            });
            navEvt.fire();
        }
    },

    showToast: function(options) {
        var message = options.message;
        if (typeof message !== 'string') {
            if (typeof message === 'object' && message.message) {
                options.message = message.message;
            } else {
                options.message = JSON.stringify(message);
            }
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(options);
        toastEvent.fire();
    },

    executeApex: function(cmp, params, options) {
    var self = this;
          var defaultOptions = {
              withResponseObj: false
          };
          options = Object.assign({}, defaultOptions, options);
          var apexAction = options.apexAction;

          return new Promise(
              $A.getCallback(function(resolve, reject) {
                  var action = cmp.get('c.' + apexAction);
                  action.setParams(params);

                  action.setCallback(this, function(callbackResult) {
                      if (options.withLoader) {
                          self.hideLoader(cmp);
                      }
                      if (callbackResult.getState() === 'SUCCESS') {
                          var resp = callbackResult.getReturnValue();
                          if (!options.withResponseObj) {
                              return resolve(resp);
                          }
                          if (resp.isSuccess) {
                              return resolve(resp.result);
                          } else {
                              console.log('ERROR in ' + apexAction + ' call', resp.message);
                              return reject(resp.message);
                          }
                      } else if (callbackResult.getState() === 'ERROR') {
                          console.log('ERROR', callbackResult.getError());
                          return reject(callbackResult.getError());
                      }
                  });
                  $A.enqueueAction(action);
              })
          );
      }
});