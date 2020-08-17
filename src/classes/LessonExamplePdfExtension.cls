public with sharing class LessonExamplePdfExtension {
	
    private Lesson__c lesson;
    public  List<LessonAttendee__c> lessonAttendeeList { get; set; } 
    
    public LessonExamplePdfExtension(ApexPages.StandardController stdController) {
        
        this.lesson = (Lesson__c)stdController.getRecord();
        this.lessonAttendeeList = [SELECT Id
                                        , Student__r.Name 
                                     FROM LessonAttendee__c
                                    WHERE Lesson__c =: this.lesson.Id
                                      AND WillBeAbsent__c = false];
    }
}