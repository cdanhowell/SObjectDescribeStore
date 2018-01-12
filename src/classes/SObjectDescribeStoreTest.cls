@isTest
public with sharing class SObjectDescribeStoreTest {

    //////////////////////////////////////////////////////////////////////////////
    //                    getPopulatedFieldDescribes                            //
    //////////////////////////////////////////////////////////////////////////////
    @isTest static void test_getPopulatedFieldDescribes() {
        // Arrange
        Account acct = new Account(
            Name = 'acctName',
            Phone = '123-123-1234',
            Industry = 'some industry'
        );

        Id userId = UserInfo.getUserId();

        // Act
        List<DescribeFieldResult> result = SObjectDescribeStore.getPopulatedFieldDescribes(acct);

        // Assert
        System.assert(result != null);
        System.assertEquals(3, result.size());
        System.assert(SObjectDescribeStore.fieldDescribeStore.containsKey(userId));
        System.assertEquals(3, SObjectDescribeStore.fieldDescribeStore.get(userId).size());
    }

    @isTest static void test_getPopulatedFieldDescribes_nullParam() {

        try {
            SObjectDescribeStore.getPopulatedFieldDescribes(null);
            System.assert(false, 'exception expected but not thrown');
        }
        catch(NullPointerException npex) {
            System.assert(true, 'exception expected');
            System.assert(npex.getMessage().contains('sObj'));
        }
        catch(Exception ex) {
            System.assert(false, 'exception expected, but not this type: ' + ex.getMessage());
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    //                    getFieldDescribe                                      //
    //////////////////////////////////////////////////////////////////////////////
    @isTest static void test_getFieldDescribe_singleUserMultipleInvocations() {
        // Arrange
        Id userId = UserInfo.getUserId();

        SObjectType accountType = Account.getSObjectType();
        SObjectField nameField = accountType.getDescribe().fields.getMap().get('Name');
        SObjectField idField = accountType.getDescribe().fields.getMap().get('Id');

        // Act
        DescribeFieldResult dsr = SObjectDescribeStore.getFieldDescribe(nameField);
        DescribeFieldResult dsr2 = SObjectDescribeStore.getFieldDescribe(idField);

        // Assert
        System.assert(dsr != null);
        System.assertEquals(1, SObjectDescribeStore.fieldDescribeStore.size());
        System.assert(SObjectDescribeStore.fieldDescribeStore.containsKey(userId));
        System.assertEquals(2, SObjectDescribeStore.fieldDescribeStore.get(userId).size());
    }

    @isTest static void test_getFieldDescribe_multipleUsers() {
        // Arrange
        Id userId = UserInfo.getUserId();
        User testUser = UsersTestUtils.createStandardUser();

        SObjectType accountType = Account.getSObjectType();
        SObjectField nameField = accountType.getDescribe().fields.getMap().get('Name');

        // Act
        DescribeFieldResult dsr = SObjectDescribeStore.getFieldDescribe(nameField);
        DescribeFieldResult dsr2;

        System.runAs(testUser) {
            dsr2 = SObjectDescribeStore.getFieldDescribe(nameField);
        }

        // Assert
        System.assert(dsr != null);
        System.assertEquals(2, SObjectDescribeStore.fieldDescribeStore.size());
        System.assert(SObjectDescribeStore.fieldDescribeStore.containsKey(userId));
        System.assertEquals(1, SObjectDescribeStore.fieldDescribeStore.get(userId).size());
    }

    @isTest static void test_getFieldDescribe_singleUser() {
        // Arrange
        Id userId = UserInfo.getUserId();
        SObjectType accountType = Account.getSObjectType();
        SObjectField nameField = accountType.getDescribe().fields.getMap().get('Name');

        // Act
        DescribeFieldResult dsr = SObjectDescribeStore.getFieldDescribe(nameField);

        // Assert
        System.assert(dsr != null);
        System.assertEquals(1, SObjectDescribeStore.fieldDescribeStore.size());
        System.assert(SObjectDescribeStore.fieldDescribeStore.containsKey(userId));
        System.assertEquals(1, SObjectDescribeStore.fieldDescribeStore.get(userId).size());
    }

    @isTest static void test_getFieldDescribe_nullParam() {

        try {
            SObjectDescribeStore.getFieldDescribe(null);
            System.assert(false, 'exception expected but not thrown');
        }
        catch(NullPointerException npex) {
            System.assert(true, 'exception expected');
            System.assert(npex.getMessage().contains('field'));
        }
        catch(Exception ex) {
            System.assert(false, 'exception expected, but not this type: ' + ex.getMessage());
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    //                    getSObjectDescribe                                    //
    //////////////////////////////////////////////////////////////////////////////
    @isTest static void test_getSObjectDescribe_singleUserMultipleInvocations() {
        // Arrange
        Id userId = UserInfo.getUserId();

        // Act
        DescribeSObjectResult result = SObjectDescribeStore.getSObjectDescribe(Account.getSObjectType());
        DescribeSObjectResult secondResult = SObjectDescribeStore.getSObjectDescribe(Account.getSObjectType());

        // Assert
        System.assert(result != null);
        System.assertEquals(1, SObjectDescribeStore.sobjectDescribeStore.size());
        System.assert(SObjectDescribeStore.sobjectDescribeStore.containsKey(userId));
        System.assertEquals(1, SObjectDescribeStore.sobjectDescribeStore.get(userId).size());
        System.assertEquals(Account.getSObjectType().getDescribe(), 
            SObjectDescribeStore.sobjectDescribeStore.get(userId).get(Account.getSObjectType()));
    }

    @isTest static void test_getSObjectDescribe_multipleUsers() {
        // Arrange
        Id userId = UserInfo.getUserId();
        User testUser = UsersTestUtils.createStandardUser();

        // Act
        DescribeSObjectResult result = SObjectDescribeStore.getSObjectDescribe(Account.getSObjectType());
        
        DescribeSObjectResult secondResult;
        System.runAs(testUser) {
            secondResult = SObjectDescribeStore.getSObjectDescribe(Account.getSObjectType());
        }

        // Assert
        System.assert(result != null);
        System.assertEquals(2, SObjectDescribeStore.sobjectDescribeStore.size());
        System.assert(SObjectDescribeStore.sobjectDescribeStore.containsKey(userId));
        System.assert(SObjectDescribeStore.sobjectDescribeStore.containsKey(testuser.Id));
        System.assertEquals(Account.getSObjectType().getDescribe(), 
            SObjectDescribeStore.sobjectDescribeStore.get(userId).get(Account.getSObjectType()));
        System.assertEquals(Account.getSObjectType().getDescribe(), 
            SObjectDescribeStore.sobjectDescribeStore.get(testUser.Id).get(Account.getSObjectType()));
    }

    @isTest static void test_getSObjectDescribe_singleUser() {
        // Arrange
        Id userId = UserInfo.getUserId();

        // Act
        DescribeSObjectResult result = SObjectDescribeStore.getSObjectDescribe(Account.getSObjectType());

        // Assert
        System.assert(result != null);
        System.assertEquals(1, SObjectDescribeStore.sobjectDescribeStore.size());
        System.assert(SObjectDescribeStore.sobjectDescribeStore.containsKey(userId));
        System.assertEquals(Account.getSObjectType().getDescribe(), 
            SObjectDescribeStore.sobjectDescribeStore.get(userId).get(Account.getSObjectType()));
    }

    @isTest static void test_getSObjectDescribe_nullParam() {

        try {
            SObjectDescribeStore.getSObjectDescribe(null);
            System.assert(false, 'exception expected but not thrown');
        }
        catch(NullPointerException npex) {
            System.assert(true, 'exception expected');
            System.assert(npex.getMessage().contains('sobjType'));
        }
        catch(Exception ex) {
            System.assert(false, 'exception expected, but not this type: ' + ex.getMessage());
        }
    }
}