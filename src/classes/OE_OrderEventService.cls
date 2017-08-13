public with sharing class OE_OrderEventService {
	DB_GenericDml genericDml;
	DB_UserSelector userSelector;
	
	public OE_OrderEventService(DB_GenericDml genericDml, DB_UserSelector userSelector) {
		this.genericDml = genericDml;
		this.userSelector = userSelector;
	}

	public OE_OrderEventService() {
		this(new DB_GenericDml(), new DB_UserSelector());
	}
	
	
	public List<Task> listen(List<Order_Event__e> orderEventList) { 
		User activeUser = this.userSelector.selectActive()[0];

		List<Task> taskList = new List<Task>();
		for (Order_Event__e orderEvent : orderEventList) {
			if (orderEvent.Has_Shipped__c) {
				taskList.add(new Task(
					subject = 'Follow up on shipped order ' + orderEvent.Order_Number__c,
					priority = 'Medium',
					status = 'New',
					ownerId = activeUser.id
				));
			}
		}		
		
		this.genericDml.doInsert(taskList);
		return taskList;
	}
}