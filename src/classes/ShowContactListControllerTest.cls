@isTest
public class ShowContactListControllerTest {
    
    @testSetup
    static void setupData(){
        List<Contact> contList= new List<Contact>();
        Contact con1 = new Contact (lastName='test1');
        contList.add(con1);
        con1=new Contact(lastName='test2');
        contList.add(con1);
        insert contList;
    }
    @isTest
    public static void fetchContTest(){
        List<Contact> selectedContList=ShowContactListController.fetchCont();
        System.assertEquals(2, selectedContList.size());
    }
    
    @isTest
    public static void deleteContacts(){
        Contact con= [SELECT id FROM Contact Limit 1];
        List<Id> contactIdsList=new List<Id>();
        contactIdsList.add(con.Id);
        contactIdsList=ShowContactListController.deleteContacts(contactIdsList);
        List<Contact> allContacts=[SELECT id FROM Contact];
        System.assertEquals(1, allContacts.size());
    }

}