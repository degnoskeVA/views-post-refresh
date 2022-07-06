trigger ViewsSSNUpdateTrigger on Contact (before insert, before update) {   
    if (FeatureManagement.checkPermission('DisableTriggersFlag') == True) {
        // User has DisableTriggersFlag enabled so break out of the current method/trigger
        return;
    }
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {          
            ViewsSSNUpdateTriggerFacade.syncSSNAndGenderFields(Trigger.new,Trigger.oldMap);         
        }
    }
}