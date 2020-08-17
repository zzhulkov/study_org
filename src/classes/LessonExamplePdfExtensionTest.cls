@IsTest
private with sharing class LessonExamplePdfExtensionTest {
	
    @TestSetup
    static void seupTestData() {
        Id studentRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Student').getRecordTypeId();
        Id teacherRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Teacher').getRecordTypeId();
        
        Contact testStudent = new Contact(
        	RecordTypeId = studentRTId,
            LastName     = 'Test Student'
        );
        Contact testTeacher = new Contact(
            RecordTypeId = teacherRTId,
            LastName     = 'Test Teacher',
            Email		 = 'test@email.com'
        );
        insert new List<Contact>{testStudent, testTeacher};
        
        Course__c testCourse = new Course__c(
        	Name = 'Test Course'
        );
        insert testCourse;
        
        Lesson__c testLesson = new Lesson__c(
        	Name             = 'Test Lesson',
            Course__c        = testCourse.Id,
            StartDateTime__c = DateTime.now().addDays(2),
            EndDateTime__c   = DateTime.now().addDays(2).addHours(2),
            Teacher__c	     = testTeacher.Id
        );
        insert testLesson;
        
        LessonAttendee__c testLessonAttendee = new LessonAttendee__c(
        	Lesson__c  = testLesson.Id,
            Student__c = testStudent.Id
        );
        insert testLessonAttendee;
    }
    
    @IsTest
    static void examplePDFTest() {
        // given
        Lesson__c testLesson = [SELECT Id FROM Lesson__c LIMIT 1];
        
        // when
        Test.startTest();
        Apexpages.StandardController stdCtrl = new Apexpages.StandardController(testLesson);
        LessonExamplePdfExtension extension = new LessonExamplePdfExtension(stdCtrl);
        Test.stopTest();
        
        // then
        System.assertEquals(1, extension.lessonAttendeeList.size());
    }
}