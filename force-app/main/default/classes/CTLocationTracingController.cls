/**
 * @description       : 
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : 
 * @last modified on  : 2025-03-01
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
**/
public with sharing class CTLocationTracingController {
    private static final String LOCATION_TRACING_QUERY = 'SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c';


    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param query 
    * @return List<Location_Tracing__c> 
    **/
    private static List<Location_Tracing__c> getLocations(String query) {
        List<Location_Tracing__c> locations = Database.query(query);

        if (locations != null && locations.size() > 0) {
            return locations;
        }

        return null; 
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param locationId 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        String query = LOCATION_TRACING_QUERY + ' WHERE Id = :locationId ORDER BY Visit_Date__c DESC';

        return getLocations(query);
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param personsIds 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personsIds) {
        String query = LOCATION_TRACING_QUERY + ' WHERE Person__c IN :personsIds AND Visit_Date__c = LAST_N_DAYS:10';

        return getLocations(query);
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-01 
    * @param locationIds 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        String personHealth = 'Green';
        String query = LOCATION_TRACING_QUERY + ' WHERE Id IN :locationIds AND Person__r.Health_Status__c = :personHealth AND Visit_Date__c = LAST_N_DAYS:10';

        return getLocations(query);
    }
}
