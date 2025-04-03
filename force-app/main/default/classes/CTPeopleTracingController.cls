/**
 * @description       :
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             :
 * @last modified on  : 2025-03-07
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
 **/
public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String recordId) {
        List<People_Tracing__c> peopleTracingRecords = new List<People_Tracing__c>();
        
        if (Schema.sObjectType.People_Tracing__c.isAccessible()) {
            peopleTracingRecords = [SELECT Id, Name, Contact_Type__c, Contact_Date__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c 
               FROM People_Tracing__c 
               WHERE Person_1__c = :recordId 
               OR Person_2__c = :recordId
               ORDER BY Contact_Date__c DESC];
        }

        return peopleTracingRecords;
    }
    
    private static List<People_Tracing__c> checkDuplicatesGetExistingRecords(List<People_Tracing__c> newPeopleTraces) {
        Set<Id> peopleIds = new Set<Id>();
        for (People_Tracing__c trace : newPeopleTraces) {
            peopleIds.add(trace.Person_1__c);
            peopleIds.add(trace.Person_2__c);
        }
        
        List<People_Tracing__c> existingRecords = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE Person_1__c IN :peopleIds
            OR Person_2__c IN :peopleIds
        ];

        if (existingRecords == null || existingRecords.size() <= 0) {
            return null;
        }

        return existingRecords;
    }

    private static Map<Id, Set<Id>> checkDuplicatesGetMapOfExistingRecords(List<People_Tracing__c> existingRecords) {
        Map<Id, Set<Id>> mapExistingRecords = new Map<Id, Set<Id>>();

        // Build Map for Person 1
        for (People_Tracing__c trace : existingRecords) {
            if(!mapExistingRecords.containsKey(trace.Person_1__c)) {
                mapExistingRecords.put(trace.Person_1__c, new Set<Id>());
            }
            
            mapExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);
        }
        
        // Build Map for Person 2
        for (People_Tracing__c trace : existingRecords) {
            if(!mapExistingRecords.containsKey(trace.Person_2__c)) {
                mapExistingRecords.put(trace.Person_2__c, new Set<Id>());
            }
            
            mapExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
        }

        if (mapExistingRecords == null || mapExistingRecords.size() <= 0) {
            return null;
        }

        return mapExistingRecords;
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {
        List<People_Tracing__c> existingRecords = checkDuplicatesGetExistingRecords(newPeopleTraces);
        if (existingRecords == null) { return null; }

        Map<Id, Set<Id>> mapExistingRecords = checkDuplicatesGetMapOfExistingRecords(existingRecords);
        if (mapExistingRecords == null) { return null; }

        // Check if new People traces has duplicates with Map of Existing records
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
        for (People_Tracing__c trace : newPeopleTraces) {
            if((mapExistingRecords.containsKey(trace.Person_1__c) && mapExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c)) ||
                (mapExistingRecords.containsKey(trace.Person_2__c) && mapExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))
            ) {
                duplicates.add(trace);
            }
        }
        
        
        return duplicates;
    }
}