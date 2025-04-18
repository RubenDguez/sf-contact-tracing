/**
 * @description       : 
 * @author            : argenis.dominguez@argenis.dominguez.com
 * @group             : 
 * @last modified on  : 2025-04-03
 * @last modified by  : argenis.dominguez@argenis.dominguez.com
**/
trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContactTriggerHandler.afterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE {
            ContactTriggerHandler.afterDelete(Trigger.old);
        }
        when AFTER_UNDELETE {
            ContactTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}
