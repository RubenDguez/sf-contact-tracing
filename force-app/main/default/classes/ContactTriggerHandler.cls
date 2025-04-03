public class ContactTriggerHandler {
    private static void updateAccountActiveContactCount(List<Contact> contactRecords) {
        Set<Id> idSet = new Set<Id>();
        List<Account> accountList = new List<Account>();
        
        for (Contact record : contactRecords) {
            if (String.isNotBlank(record.AccountId)) {
                idSet.add(record.AccountId);
            }
        }
        
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) totalContacts
            FROM Contact
            WHERE Active__c = TRUE AND AccountId IN :idSet
            GROUP BY AccountId
        ];
        
        for (AggregateResult result : results) {
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
            Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
            accountList.add(acc);
        }
        
        update accountList;        
    }
    
    public static void afterInsert(List<Contact> contactRecords) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactRecords);
    }
    
    public static void afterUpdate(List<Contact> contactRecords) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactRecords);
    }
    
    public static void afterDelete(List<Contact> contactRecords) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactRecords);
    }
    public static void afterUndelete(List<Contact> contactRecords) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactRecords);
    }
}