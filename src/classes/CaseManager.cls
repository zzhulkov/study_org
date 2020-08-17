@RestResource(urlMapping='/Cases/*')
global with sharing class CaseManager {
    
    @HttpPost
    global static ID createCase(String subject, String status, String origin, String email) {
        
        if(email!=null){
            List<Contact> contList=[Select id 
                                    From Contact
                                    Where Email=:email];
            if(contList.size()>0){ //contact exsist
                Case caseToInsert=new Case(Subject=subject,
                                           Status=status,
                                           Origin=origin,
                                           ContactId=contList[0].Id);
                insert caseToInsert;
                return caseToInsert.Id;
            }
            
            else{//contact do NOT exsist
                return createContactAndCase(subject, status, origin);
            }
        }
        
        else{//email field is NULL
            return createContactAndCase(subject, status, origin);
        }
        
    }  
    
    private static ID createContactAndCase(String subject, String status, String origin){
        Contact con=new Contact(Lastname='UNKNOWN');
        insert con;
        Case caseToIns=new Case(Subject=subject,
                                Status=status,
                                Origin=origin,
                                ContactId=con.Id);
        insert caseToIns;
        return caseToIns.Id;
    }
}