trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContractTriggerHandler.afterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            ContractTriggerHandler.afterUpdate(Trigger.new);
        }
        when AFTER_DELETE {
            ContractTriggerHandler.afterDelete(Trigger.old);
        }
        when AFTER_UNDELETE {
            ContractTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}