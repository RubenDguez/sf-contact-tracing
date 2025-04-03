/**
 * @description       : 
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : 
 * @last modified on  : 2025-03-01
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
**/
public with sharing class CTLocationController {
    private static final String LOCATION_QUERY = 'SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Status__c, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c FROM Location__c';

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @return List<Location__c> 
    **/
    public static List<Location__c> getRecentStatusChanges() {
        String query = LOCATION_QUERY + ' ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100';
        List<Location__c> locations = Database.query(query);

        if (locations != null && locations.size() > 0) {
            return locations;
        }

        return null;
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param searchTerm 
    * @return List<Location__c> 
    **/
    public static List<Location__c> searchLocations(String searchTerm) {
        searchTerm = '%' + searchTerm + '%';
        String query = LOCATION_QUERY + ' WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC';
        List<Location__c> locations = Database.query(query);

        if (locations != null && locations.size() > 0) {
            return locations;
        }

        return null;
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param locationId 
    * @return Location__c 
    **/
    public static Location__c getLocationById(String locationId) {
        String query = LOCATION_QUERY + ' WHERE Id = :locationId';
        List<Location__c> locations = Database.query(query);

        if (!locations.isEmpty() && locations.size() > 0) {
            return locations[0];
        }

        return null;
    }
}