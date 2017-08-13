public with sharing class CN_CloudNewsService {
	DB_GenericDml genericDml;
	DB_GroupSelector groupSelector;
	
	public CN_CloudNewsService(DB_GenericDml genericDml, DB_GroupSelector groupSelector){
		this.genericDml = genericDml;
		this.groupSelector = groupSelector;
	}

	public CN_CloudNewsService(){
		this(new DB_GenericDml(), new DB_GroupSelector());
	}

	public List<DataBase.SaveResult> createAndPublish() {
		List<Cloud_News__e> newsEventList = new List<Cloud_News__e>	{
			this.createNewsEvent('Lake Road is closed due to mudslides', true),
			this.createNewsEvent('Small incident on Goat Lane causing traffic.', false)
		};
		
		return publish(newsEventList);
	}
	
	public List<Case> listenToNews(List<Cloud_News__e> cloudNewsList) { 
		Group groupQueue = this.groupSelector.selectByName(new Set<String>{'Regional Dispatch'})[0];

		List<Case> caseList = new List<Case>();
		for (Cloud_News__e cloudNews : cloudNewsList) {
			if (cloudNews.Urgent__c) {
				caseList.add(new Case(
					subject = 'News team dispatch to ' + cloudNews.Location__c,
					priority = 'High',
					ownerId = groupQueue.id
				));
			}
		}		
		
		this.genericDml.doInsert(caseList);
		return caseList;
	}

	private Cloud_News__e createNewsEvent(String content, Boolean isUrgent) {
		return new Cloud_News__e(
			Urgent__c = isUrgent,
			News_Content__c = content
		);
	}    
	
	private List<DataBase.SaveResult> publish (List<Cloud_News__e> newsEventList) {
		List<DataBase.SaveResult> saveResultList = EventBus.publish(newsEventList);
		
		for (DataBase.SaveResult saveResult : saveResultList) {
			if (saveResult.isSuccess()) {
				System.debug(LoggingLevel.INFO, 'Successfully published event.');
			}
			else {
				for (Database.Error error : saveResult.getErrors()) {
					System.debug(LoggingLevel.ERROR, 'Error returned: ' + error.getStatusCode() + ' - ' + error.getMessage());
				}
			}
		}
		
		return saveResultList;
	}
}