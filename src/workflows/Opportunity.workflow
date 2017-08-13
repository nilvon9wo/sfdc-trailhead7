<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_account_manager_about_opportunity</fullName>
        <description>Email account manager about opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Public_Files/Sales_Opportunity_Update</template>
    </alerts>
    <alerts>
        <fullName>Email_division_manager_about_opportunity</fullName>
        <description>Email division manager about opportunity</description>
        <protected>false</protected>
        <recipients>
            <field>Division_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Public_Files/Sales_Opportunity_Update</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deselect_Account_Active_Opportunity</fullName>
        <field>Active_Opportunity__c</field>
        <literalValue>0</literalValue>
        <name>Deselect Account: Active Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Select_Account_Active_Opportunity</fullName>
        <field>Active_Opportunity__c</field>
        <literalValue>1</literalValue>
        <name>Select Account: Active Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>When Closed Lost and high-value%2C notify the account and division manager</fullName>
        <actions>
            <name>Email_account_manager_about_opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_division_manager_about_opportunity</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>100000</value>
        </criteriaItems>
        <description>When a high-value opportunity moves to the Closed Lost stage, notify the account and division manager</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When Closed Lost%2C deselect Active Opportunity on account</fullName>
        <actions>
            <name>Deselect_Account_Active_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <description>When an opportunity moves to the Closed Lost stage, deselect the Active Opportunity field on the account.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When Closed Won%2C notify account manager and start process for contract</fullName>
        <actions>
            <name>Email_account_manager_about_opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Deselect_Account_Active_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Create_contract_for_closed_opportunity</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Follow_up_on_new_contract</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>When an opportunity moves to the Closed Won stage, notify the account manager, assign the account manager a task to create an associated contract, and schedule a follow-up task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When created%2C select Active Opportunity on account</fullName>
        <actions>
            <name>Select_Account_Active_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>When an opportunity is created, select the Active Opportunity field on the associated account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>When in Negotiation and high-value%2C notify account and division manager</fullName>
        <actions>
            <name>Email_account_manager_about_opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_division_manager_about_opportunity</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiation/Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>100000</value>
        </criteriaItems>
        <description>If a high-value opportunity moves to the Negotiation/Review stage, email a notification to the division manager.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Create_contract_for_closed_opportunity</fullName>
        <assignedToType>accountOwner</assignedToType>
        <description>Use the closed opportunity to create a contract for the associated account. 

Account: The account associated with this opportunity
Status: Draft
Contract Start Date: 1 month from today
Contract Term: 12</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create contract for closed opportunity</subject>
    </tasks>
    <tasks>
        <fullName>Follow_up_on_new_contract</fullName>
        <assignedToType>accountOwner</assignedToType>
        <description>Follow up with the customer on the contract for this account.</description>
        <dueDateOffset>9</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow up on new contract</subject>
    </tasks>
</Workflow>
