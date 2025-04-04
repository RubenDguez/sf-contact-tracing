/**
 * @description       :
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             :
 * @last modified on  : 2025-04-03
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
 **/
public with sharing class ContactTriggerHandler {
    private class ContactTriggerHandlerException extends Exception {}

    /**
     * @description
     * @author argenis.dominguez@argenis.dominguez.com | 2025-04-03
     * @param contactList
     **/
    private static void updateAccountActiveContactCount(List<Contact> contactList) {
        if (!Schema.sObjectType.Contact.isAccessible() || !Schema.sObjectType.Account.isUpdateable()) {
            throw new ContactTriggerHandlerException('Insufficient permissions to access Contact or update Account.');
        }
        
        Set<Id> idSet = new Set<Id>();
        List<Account> accountList = new List<Account>();
        
        for (Contact record : contactList) {
            if (String.isNotBlank(record.AccountId)) {
                idSet.add(record.AccountId);
            }
        }
        
        List<AggregateResult> results = [
                SELECT AccountId, COUNT(Id) contactCount
                FROM Contact
                WHERE Active__c = TRUE AND AccountId IN :idSet
                GROUP BY AccountId
            ];

        if (contactList.size() != results.size()) {
            Set<Id> acctsIds = new Set<Id>();
            for (Contact contactRecord : contactList) {
                acctsIds.add(contactRecord.AccountId);
            }

            List<Account> accts = [SELECT Active_Contacts__c FROM Account WHERE Id IN :acctsIds];

            for (Account acc : accts) {
                acc.Active_Contacts__c = 0;
            }

            update accts;
        }
        
        for (AggregateResult result : results) {
            String accId = String.valueOf(result.get('AccountId'));
            Integer contactCount = Integer.valueOf(result.get('contactCount'));
            accountList.add(new Account(Id = accId, Active_Contacts__c = contactCount));
        }

        update accountList;
    }
    
    /**
     * @description After Insert
     * @author argenis.dominguez@argenis.dominguez.com | 2025-04-03
     * @param contactList
     **/
    public static void afterInsert(List<Contact> contactList) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactList);
    }
    
    /**
     * @description After Update
     * @author argenis.dominguez@argenis.dominguez.com | 2025-04-03
     * @param contactList
     **/
    public static void afterUpdate(List<Contact> contactList, Map<Id, Contact> oldContacsMap) {
        List<Contact> contList = new List<Contact>();

        for (Contact contactRecord : contactList) {
            if (oldContacsMap.get(contactRecord.Id).Active__c != contactRecord.Active__c) {
                    contList.add(contactRecord);
            }

            if(oldContacsMap.get(contactRecord.Id).AccountId != contactRecord.AccountId) {
                contList.add(contactRecord);
                contList.add(oldContacsMap.get(contactRecord.Id));
            }
        }        

        for (Contact contactRecord : contList) {
            System.debug('Id: ' + contactRecord.Id + ' AccountId: ' + contactRecord.AccountId);
        }

        if (contList.size() > 0) {
            ContactTriggerHandler.updateAccountActiveContactCount(contList);
        }
    }
    
    /**
     * @description After Delete
     * @author argenis.dominguez@argenis.dominguez.com | 2025-04-03
     * @param contactList
     **/
    public static void afterDelete(List<Contact> contactList) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactList);
    }
    /**
     * @description After Undelete
     * @author argenis.dominguez@argenis.dominguez.com | 2025-04-03
     * @param contactList
     **/
    public static void afterUndelete(List<Contact> contactList) {
        ContactTriggerHandler.updateAccountActiveContactCount(contactList);
    }
}
