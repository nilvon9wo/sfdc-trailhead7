@isTest
public with sharing class CN_CloudNewsTriggerIntTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
    @isTest public static void testCloudNewsTriggerShouldCreateCases() {
    	// Arrange
    	Group testGroup = new Group(name = 'Regional Dispatch', type = 'Queue');
    	insert testGroup;
    	insert new QueuesObject(queueId = testGroup.id, SObjectType = 'Case');
    	
    	Cloud_News__e testCloudNews = new Cloud_News__e(
    		Location__c = 'Mountain City',
    		News_Content__c = 'Test message.',
    		Urgent__c = true
    	); 
    	
		// Act
		Database.SaveResult saveResult;
        Test.startTest();
        System.runAs(TestRunner){
        	saveResult = EventBus.publish(testCloudNews);
        }
        Test.stopTest();

		// Assert
		List<Case> caseList = [SELECT id FROM Case];
		System.assertEquals(1, caseList.size());
    }
}