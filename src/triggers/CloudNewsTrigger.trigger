trigger CloudNewsTrigger on Cloud_News__e (after insert) {
	fflib_SObjectDomain.triggerHandler(CN_CloudNewsTriggerHandler.class);
}