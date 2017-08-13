public class OE_OrderEventTriggerHandler extends fflib_SObjectDomain {
    List<Order_Event__e> orderEventList;
    OE_OrderEventService orderEventService; 

    public OE_OrderEventTriggerHandler(List<Order_Event__e> orderEventList, OE_OrderEventService orderEventService) {
        super(orderEventList);
        this.orderEventList = orderEventList;
        this.orderEventService = orderEventService; 
    }
     
    public OE_OrderEventTriggerHandler(List<Order_Event__e> orderEventList) {
        this(orderEventList, new OE_OrderEventService());
    }
 
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> orderEventList) {
            return new OE_OrderEventTriggerHandler (orderEventList);
        }
    } 
	
    public override void onAfterInsert() {
    	this.orderEventService.listen(this.orderEventList);
    }
}