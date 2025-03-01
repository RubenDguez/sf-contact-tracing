// Class Account Controller
public class AccountController {    
    private static final String UPDATE_AVG_CASE_RESOLUTION_BASE_QUERY = 'SELECT Id, Average_Case_Resolution_Days__c, (SELECT CreatedDate, ClosedDate FROM Cases) FROM Account';
    
    private static List<Account> avgCaseResolutionDaysUpdater(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.Cases.size() == 0) continue;
            
            Double totalDays = 0;

            for(Case caseObject : account.Cases) {
                if (caseObject.CreatedDate == NULL || caseObject.ClosedDate == NULL) continue;
                
                totalDays += Math.abs(caseObject.CreatedDate.Date().daysBetween(caseObject.ClosedDate.date()));
            }

            account.Average_Case_Resolution_Days__c = totalDays / (Double)account.Cases.size();
        }
        
        return accounts;
    }
    
    public static List<Account> updateAvgCaseResolutionDays() {
        List<Account> accounts = Database.query(UPDATE_AVG_CASE_RESOLUTION_BASE_QUERY);
        
        accounts = avgCaseResolutionDaysUpdater(accounts);
        
        update accounts;
        return accounts;
    }
    
    public static Account updateAvgCaseResolutionDays(Id id) {
        List<Account> account = Database.query(UPDATE_AVG_CASE_RESOLUTION_BASE_QUERY + ' WHERE Id = :id');
        
        account = avgCaseResolutionDaysUpdater(account);
        
        update account;
        return account[0];      
    }
    
    public static List<Account> updateAvgCaseResolutionDays(List<Id> ids) {
        List<Account> accounts = Database.query(UPDATE_AVG_CASE_RESOLUTION_BASE_QUERY + ' WHERE Id IN :ids');
        
        accounts = avgCaseResolutionDaysUpdater(accounts);
        
        update accounts;
        return accounts;
    }
}