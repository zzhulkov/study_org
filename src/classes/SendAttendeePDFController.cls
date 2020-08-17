public class SendAttendeePDFController {

    @AuraEnabled
    public static void sendPDFByEmail(Id lessonId, String email) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{email});
        mail.setPlainTextBody('Test message');
        PageReference pagePDF = Page.LessonExamplePDF;
        pagePDF.getParameters().put('id', lessonId);
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.FileName = 'Test.pdf';
        attachment.ContentType = 'application/pdf';
        attachment.Body = Test.isRunningTest()
            ? Blob.valueOf('Test Blob String')
            : pagePDF.getContentAsPDF();
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail}, false);
    }
}