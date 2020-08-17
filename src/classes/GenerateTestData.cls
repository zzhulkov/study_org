public class GenerateTestData {
	
    public static void generate() {
        
        Id studentRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Student').getRecordTypeId();
        Id teacherRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Teacher').getRecordTypeId();
        
        List<Contact> studentList = new List<Contact>();
        List<Contact> teacherList = new List<Contact>();
        
        List<Course__c> courseList = new List<Course__c>();
        List<Lesson__c> lessonList = new List<Lesson__c>();
        List<LessonAttendee__c> lessonAttendeeList = new List<LessonAttendee__c>();
        
        for (Integer i = 0; i < 20; i++) {
            studentList.add(generateContact(studentRTId, 'Student', i));
        }
        for (Integer i = 0; i < 5; i++) {
            teacherList.add(generateContact(teacherRTId, 'Teacher', i));
            courseList.add(generateCourse(i));
        }
        
        if (!studentList.isEmpty()) {
            insert studentList;
        }
        if (!teacherList.isEmpty()) {
            insert teacherList;
        }
        if (!courseList.isEmpty()) {
            insert courseList;
            
            for (Course__c course_i : courseList) {
                for (Integer i = 0; i < 3; i++) {
                    lessonList.add(generateLesson(course_i.Id, teacherList[i].Id, i));
                }
            }
            if (!lessonList.isEmpty()) {
                insert lessonList;
                
                for (Lesson__c lesson_i : lessonList) {
                    for (Integer i = 0; i < 7; i++) {
                        lessonAttendeeList.add(generateLessonAttendee(lesson_i.Id, studentList[i].Id));
                    }
                }
                if (!lessonAttendeeList.isEmpty()) {
                    insert lessonAttendeeList;
                }
            }
        }
        
    }
    
    private static Contact generateContact(Id recordTypeId, String lastName, Integer ind) {
        return new Contact(
        	RecordTypeId = recordTypeId,
            LastName     = lastName + '_' + ind
        );
    }
    
    private static Course__c generateCourse(Integer ind) {
        return new Course__c(
        	Name = 'Course_' + ind
        );
    }
    
    private static Lesson__c generateLesson(Id courseId, Id teacherId, Integer ind) {
        return new Lesson__c(
        	Name             = 'Lesson_' + ind,
            Course__c        = courseId,
            Teacher__c       = teacherId,
            StartDateTime__c = DateTime.now().addDays(ind),
            EndDateTime__c   = DateTime.now().addDays(ind).addHours(1)
        );
    }
    
    private static LessonAttendee__c generateLessonAttendee(Id lessonId, Id studentId) {
        return new LessonAttendee__c(
            Lesson__c  = lessonId,
            Student__c = studentId
        );
    }
}