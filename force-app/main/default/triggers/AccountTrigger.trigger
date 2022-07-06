trigger AccountTrigger on Account (before insert, after insert, after update, before update) {
    
    if (FeatureManagement.checkPermission('DisableTriggersFlag') == True) {
        // User has DisableTriggersFlag enabled so break out of the current method/trigger
        return;
    }
    
    FOM_AccountTriggerHandler fomHandler = new FOM_AccountTriggerHandler(Trigger.oldMap, Trigger.newMap);
    
    if(Trigger.isBefore && Trigger.isInsert) {
        fomHandler.onBeforeInsert();
    } 
    if(Trigger.isBefore && Trigger.isUpdate) {
        fomHandler.onBeforeUpdate();
    } 
    if(Trigger.isAfter && Trigger.isInsert) {
        fomHandler.onAfterInsert();
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        fomHandler.onAfterUpdate();
    }
}