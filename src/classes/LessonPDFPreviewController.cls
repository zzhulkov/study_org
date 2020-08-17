public class LessonPDFPreviewController {
	
    @AuraEnabled
    public static Response saveLessonPDF(Id lessonId) {
        PageReference lessonPDF = new PageReference('/apex/' + 'LessonExamplePDF');
        lessonPDF.getParameters().put('id', lessonId);
        
        String fileName = 'PDF Name';
        
        Blob pdfContent = Test.isRunningTest()
                        ? Blob.valueOf('Test Blob String')
                        : lessonPDF.getContentAsPDF();
        
        ContentVersion contVersion = new ContentVersion();
        contVersion.ContentLocation = 'S';
        contVersion.PathOnClient = fileName;
        contVersion.PathOnClient = fileName;
        contVersion.Title = fileName;
        contVersion.VersionData = pdfContent;
        insert contVersion;
        
        contVersion = [
            SELECT Id, ContentDocumentId 
            FROM ContentVersion 
            WHERE Id = :contVersion.Id
        ];
        
        ContentDocumentLink contDocumentLink = new ContentDocumentLink();
        contDocumentLink.ContentDocumentId = contVersion.ContentDocumentId;
        contDocumentLink.LinkedEntityId = lessonId;
        contDocumentLink.ShareType = 'V';
        insert contDocumentLink;
        
        return new Response(contVersion.ContentDocumentId);
    }
    
    @AuraEnabled
    public static Response sendLessonPDF(Id lessonId) {
    	List<Lesson__c> lessonList = [
            SELECT Id, Teacher__c, Teacher__r.Email
            FROM Lesson__c
            WHERE Id = :lessonId
        ];    
        if (lessonList.isEmpty()) {
            return new Response(false, 'Lesson Id is not valid', 'error');
        }
        
        return new Response(true);
    }
}