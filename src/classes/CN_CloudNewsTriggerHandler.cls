public class CN_CloudNewsTriggerHandler extends fflib_SObjectDomain {
    List<Cloud_News__e> cloudNewsList;
    CN_CloudNewsService cloudNewsService; 

    public CN_CloudNewsTriggerHandler(List<Cloud_News__e> cloudNewsList, CN_CloudNewsService cloudNewsService) {
        super(cloudNewsList);
        this.cloudNewsList = cloudNewsList;
        this.cloudNewsService = cloudNewsService; 
    }
    
    public CN_CloudNewsTriggerHandler(List<Cloud_News__e> cloudNewsList) {
        this(cloudNewsList, new CN_CloudNewsService());
    }
 
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> cloudNewsList) {
            return new CN_CloudNewsTriggerHandler (cloudNewsList);
        }
    } 
	
    public override void onAfterInsert() {
    	this.cloudNewsService.listenToNews(this.cloudNewsList);
    }
}