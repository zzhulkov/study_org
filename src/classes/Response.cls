public class Response {
	@AuraEnabled
    public Boolean isSuccess   { get; set; }
    @AuraEnabled
    public String  message     { get; set; }
    @AuraEnabled
    public String  messageType { get; set; }
	@AuraEnabled
    public Object  result      { get; set; }
    
    public Response() {}

    public Response(Object result) {
        this.isSuccess = true;
        this.result = result;
    }
    
    public Response(Boolean isSuccess, String message, String messageType) {
        this.isSuccess = isSuccess;
        this.message = message;
        this.messageType = messageType;
    }
    
    public Response(Boolean isSuccess, String message, String messageType, Object result) {
        this.isSuccess = isSuccess;
        this.message = message;
        this.messageType = messageType;
        this.result = result;
    }
    
    public static Response exceptionResponse(Exception ex) {
        System.debug('Exception: ' + ex.getMessage());
        System.debug('Line: ' + ex.getLineNumber());
        return new Response(false, ex.getMessage(), 'error');
    }
}