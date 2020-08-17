@isTest
global class UuidGeneratorHttpsCalloutMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('8c626774-c02e-11ea-b3de-0242ac130004');
        response.setStatusCode(200);
        return response; 
    }
}