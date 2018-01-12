public with sharing class SObjectDescribeStore {

	@testVisible
	private static final Map<Id, Map<SObjectType, DescribeSObjectResult>> sobjectDescribeStore;

	@testVisible
	private static final Map<Id, Map<SObjectField, DescribeFieldResult>> fieldDescribeStore;

	static {
		sobjectDescribeStore = new Map<Id, Map<SObjectType, DescribeSObjectResult>>();
		fieldDescribeStore = new Map<Id, Map<SObjectField, DescribeFieldResult>>();
	}

	public static DescribeSObjectResult getSObjectDescribe(SObjectType sobjType) {

		Args.isNotNull(sobjType, 'sobjType');

		Id userId = UserInfo.getUserId();

		if (!sobjectDescribeStore.containsKey(userId)) { // user doesn't have a describe store yet
			sobjectDescribeStore.put(userId, new Map<SObjectType, DescribeSObjectResult>());
		}

		DescribeSObjectResult dsr = sobjectDescribeStore.get(userId).get(sobjType);
		if (dsr == null) { // The store doesn't have a describe for this sobject for this user
			dsr = sobjType.getDescribe();
			sobjectDescribeStore.get(userId).put(sobjType, dsr);
		}

		return dsr;
	}

	public static DescribeFieldResult getFieldDescribe(SObjectField field) {

		Args.isNotNull(field, 'field');

		Id userId = UserInfo.getUserId();

		if (!fieldDescribeStore.containsKey(userId)) { // user doesn't have an entry in the store yet
			fieldDescribeStore.put(userId, new Map<SObjectField, DescribeFieldresult>());
		}

		DescribeFieldResult dfr = fieldDescribeStore.get(userId).get(field);
		if (dfr == null) { // user doesn't have an entry yet for this field
			dfr = field.getDescribe();
			fieldDescribeStore.get(userId).put(field, dfr);
		}

		return dfr;
	}

	public static List<DescribeFieldResult> getPopulatedFieldDescribes(SObject sObj) {

		Args.isNotNull(sObj, 'sObj');

		DescribeSObjectResult dsr = getSObjectDescribe(sObj.getSObjectType());

		List<DescribeFieldResult> populatedFieldDescribes = new List<DescribeFieldResult>();

		for (String fieldName : sObj.getPopulatedFieldsAsMap().keySet()) {
			System.debug('fieldName: ' + fieldName);

			SObjectField field = dsr.fields.getMap().get(fieldName);

			if (field != null) {
				populatedFieldDescribes.add(getFieldDescribe(field));
			}
		}

		return populatedFieldDescribes;
	}
}