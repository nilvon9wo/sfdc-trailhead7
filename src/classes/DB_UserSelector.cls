public virtual class DB_UserSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User.id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }
    
    public virtual List<User> selectActive() {
        return (List<User>) Database.query(
        	newQueryFactory().setCondition('IsActive = true').toSOQL()
        );
    }  
}