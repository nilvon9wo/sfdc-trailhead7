public virtual class DB_GroupSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Group.id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Group.sObjectType;
    }
    
    public virtual List<Group> selectByName(Set<String> nameSet) {
        return (List<Group>) Database.query(
                newQueryFactory().setCondition('name IN :nameSet').toSOQL()
        );
    }  
}