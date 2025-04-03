/**
 * @description       : 
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : 
 * @last modified on  : 2025-03-05
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

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-05 
    * @param newLocationTraces 
    * @return List<Location_Tracing__c> 
    **/
    private static List<Location_Tracing__c> getCheckDuplicatesExistingRecords(List<Location_Tracing__c> newLocationTraces) {
        List<Location_Tracing__c> existingRecords = new List<Location_Tracing__c>();
        set<Id> locationsIds = new Set<Id>();
        set<Id> personsIds = new Set<Id>();

        for (Location_Tracing__c trace : newLocationTraces) {
            locationsIds.add(trace.Location__c);
            personsIds.add(trace.Person__c);
        }

        if (Schema.sObjectType.Location_Tracing__c.fields.Location__c.isAccessible() && Schema.sObjectType.Location_Tracing__c.fields.Person__c.isAccessible()) {
            existingRecords = [SELECT Id, Location__c, Person__c FROM Location_Tracing__c WHERE Location__c IN :locationsIds AND Person__c IN :personsIds];
        }

        if (existingRecords == null || existingRecords.size() == 0) {
            return null;
        }

        return existingRecords;
    }

    /**
    * @description 
    * @author argenis.dominguez@argenis.dominguez.com | 2025-03-05 
    * @param newLocationTraces 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        List<Location_Tracing__c> existingRecords = getCheckDuplicatesExistingRecords(newLocationTraces);

        if (existingRecords != null) {
            for (Location_Tracing__c trace : existingRecords) {
                if (!mapOfExistingRecords.containsKey(trace.Location__c)) {
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }

                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }

            for (Location_Tracing__c trace : newLocationTraces) {
                if (mapOfExistingRecords.containsKey(trace.Location__c) && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)) {
                    duplicates.add(trace);
                }
            }
        }

        return duplicates;
    }
}