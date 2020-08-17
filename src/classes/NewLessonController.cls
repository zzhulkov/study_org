public with sharing class NewLessonController {
    
    @auraEnabled
    public static Lesson__c obtainLessonInitData(Id courseId){
        Lesson__c lesson=new Lesson__c(Course__c=courseId, Name='Name', 
                                       startDateTime__c=DateTime.now(),
                                       endDateTime__c=DateTime.now().addHours(2));
        return lesson;
    }
}