trigger OrderEventTrigger on Order_Event__e (after insert) {
	//fflib_SObjectDomain.triggerHandler(OE_OrderEventTriggerHandler.class);

		User activeUser = (new DB_UserSelector()).selectActive()[0];

		List<Task> taskList = new List<Task>();
		for (Order_Event__e orderEvent : Trigger.New) {
			if (orderEvent.Has_Shipped__c) {
				taskList.add(new Task(
					subject = 'Follow up on shipped order ' + orderEvent.Order_Number__c,
					priority = 'Medium',
					status = 'New',
					ownerId = activeUser.id
				));
			}
		}		
		
		insert taskList;
}