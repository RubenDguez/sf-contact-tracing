/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ContactTrigger {

    @isTest
    static void afterInsertTest() {
        List<Account> testAccounts = new List<Account>();
        
        testAccounts.add(new Account(Name='Test Account1'));
        testAccounts.add(new Account(Name='Test Account2'));
        
        insert testAccounts;
        
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName='TestContact1', Account=testAccounts[0]));
        testContacts.add(new Contact(LastName='TestContact2', Account=testAccounts[0]));
        testContacts.add(new Contact(LastName='TestContact3', Account=testAccounts[0]));
        testContacts.add(new Contact(LastName='TestContact4', Account=testAccounts[1]));

        insert testContacts;

        List<Account> accts = [SELECT Id, Active_Contacts__c FROM Account];

        System.assertEquals(3, accts[0].Active_Contacts__c, 'Active Contacts assertion failed.');
        System.assertEquals(1, accts[1].Active_Contacts__c, 'Active Contacts assertion failed.');
    }
}
