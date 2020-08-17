public class FutureDemo {
  @future
  public static void someFutureMethod(Set<Id> recordIdSet) {
    List<Account> accounts = [Select Id, Name from Account Where Id IN :recordIdSet];
    // process account records to do awesome stuff
      for(Account account_i:accounts){
          account_i.Phone='1111';
      }
      
  }
}