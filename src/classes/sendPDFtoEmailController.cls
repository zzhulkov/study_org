public with sharing class sendPDFtoEmailController {
    public ID lessonId{get; set;}
    public String emailAddress;
    
    public sendPDFtoEmailController(ApexPages.StandardController controller){
        lessonId=controller.getRecord().Id; 

    }

    
    public void setEmailAddress(String emailAddress){
        this.emailAddress=emailAddress;
    }
    
    public String getEmailAddress(){
        return this.emailAddress;
    }
    
    public void sendPdf(){

        List<String> emailAddrList=new List<String>();
        emailAddrList.add(emailAddress);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailAddrList);
        mail.setPlainTextBody('Test message');
        
        PageReference pagePDF = Page.LessonExamplePdf;
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