/**
 * @description       : Main controller class for the Person__c object
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : Contact Tracing
 * @last modified on  : 2025-03-01
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
 **/
public with sharing class CTPersonController {
    private static final String PERSON_QUERY = 'SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c';
    
    /**
     * @description     : Generate unique token using mobile number Use MD5 algorithm to generate one-way hash
     * @author argenis.dominguez@argenis.dominguez.com | 2025-02-28
     * @param mobile
     * @return String
     **/
    public static String getToken(String mobile) {
        Blob obj = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', obj);
        String result = EncodingUtil.base64Encode(hash);
        
        return result;
    }
    
    /**
     * @description
     * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01
     * @return List<Person__c>
     **/
    public static List<Person__c> getRecentHealthChanges() {
        String query = PERSON_QUERY + ' ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100';
        List<Person__c> people = Database.query(query);
        
        if (people != null && people.size() > 0) {
            return people;
        }
        
        return null;
    }
    
    /**
     * @description
     * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01
     * @param searchTerm
     * @return List<Person__c>
     **/
    public static List<Person__c> searchPeople(String searchTerm) {
        searchTerm = '%' + searchTerm + '%';
        String query = PERSON_QUERY + ' WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC';
        List<Person__c> people = Database.query(query);
        
        if (people != null && people.size() > 0) {
            return people;
        }
        
        return null;
    }
    
    /**
     * @description
     * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01
     * @param personId
     * @return Person__c
     **/
    public static Person__c getPersonById(String personId) {
        String query = PERSON_QUERY + ' WHERE Id = :personId';
        List<Person__c> people = Database.query(query);
        
        if (people != null && people.size() > 0) {
            return people[0];
        }
        
        return null;
    }
}