public class UpdateParentAccountQueue implements Queueable{
    private List<Account> accounts;
    private ID parent;
    
    public UpdateParentAccountQueue(List<Account> records, ID id) {
        this.accounts = records;
        this.parent = id;
    }
    public void execute(QueueableContext context) {
        for (Account account : accounts) {
          account.parentId = parent;
          // perform other processing or callout
        }
        update accounts;
    }
}