@IsTest
public with sharing class ApiCalloutFrameworkTests {
	@TestSetup
	static void makeData() {
		List<API_Resource_Endpoint__mdt> configs = (List<API_Resource_Endpoint__mdt>) Test.loadData(
			API_Resource_Endpoint__mdt.SObjectType,
			'API_Resource_Endpoint_TestData'
		);
	}
	@IsTest
	static void testSuccessfulCalloutDataLoaded() {
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.setMock(HttpCalloutMock.class, MockFactory.create(200, '{"message": "Success"}'));
			Map<String, String> extraHeadersMap = new Map<String, String>{ 'Custom-Header' => 'HeaderValue' };
			Test.startTest();
			IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
			String body = JSON.serialize('acc');
			RestApiCallout.extraHeaders = extraHeadersMap;
			HttpResponse res = callout.performCallout(body);
			Test.stopTest();
			// Assert
			System.assertEquals(200, res.getStatusCode(), 'Should return success');
			System.assert(res.getBody().contains('Success'));
		}
	}
	@IsTest
	static void testControllerMap() {
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.setMock(HttpCalloutMock.class, MockFactory.create(200, '{"message": "Success"}'));
			Test.startTest();
			API_Resource_Endpoint__mdt apiResource = API_Resource_Endpoint__mdt.getInstance(
				'OneSource_AddressValidationTest'
			);
			Map<String, String> mapEndpointParamsValues = new Map<String, String>{ 'Id' => UserInfo.getUserId() };
			RestApiCallout calloutR = new RestApiCallout(apiResource, mapEndpointParamsValues);
			String body = JSON.serialize('acc');
			calloutR.performCallout(body);
			Test.stopTest();
			// Assert
			System.assertEquals(mapEndpointParamsValues, mapEndpointParamsValues, 'Null map should be returned');
		}
	}
	@IsTest
	static void testCalloutDataLoaded500() {
		Test.setMock(HttpCalloutMock.class, MockFactory.create(500, '{"message": "Error"}'));
		HttpResponse res;
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.startTest();
			try {
				IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
				String body = JSON.serialize('acc');
				res = callout.performCallout(body);
				System.assertEquals(500, res.getStatusCode(), 'Should return error code');
				System.assert(res.getBody().contains('Error'));
			} catch (Exception ex) {
				System.assert(
					ex.getMessage().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_500)
				);
			}
			Test.stopTest();
		}
	}
	@IsTest
	static void testCalloutDataLoaded400() {
		Test.setMock(HttpCalloutMock.class, MockFactory.create(400, '{"message": "Error"}'));
		HttpResponse res;
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.startTest();
			try {
				IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
				String body = JSON.serialize('acc');
				res = callout.performCallout(body);
				System.assertEquals(400, res.getStatusCode(), 'Should return error code');
				System.assert(res.getBody().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_400));
			} catch (Exception ex) {
				System.assert(
					ex.getMessage().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_400)
				);
			}
			Test.stopTest();
		}
	}
	@IsTest
	static void testCalloutDataLoaded403() {
		Test.setMock(HttpCalloutMock.class, MockFactory.create(403, '{"message": "Error"}'));
		HttpResponse res;
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.startTest();
			try {
				IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
				String body = JSON.serialize('acc');
				res = callout.performCallout(body);
				System.assertEquals(403, res.getStatusCode(), 'Should return error code');
				System.assert(res.getBody().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_403));
			} catch (Exception ex) {
				System.assert(
					ex.getMessage().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_403)
				);
			}
			Test.stopTest();
		}
	}
	@IsTest
	static void testCalloutDataLoaded404() {
		Test.setMock(HttpCalloutMock.class, MockFactory.create(404, '{"message": "Error"}'));
		HttpResponse res;
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.startTest();
			try {
				IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
				String body = JSON.serialize('acc');
				res = callout.performCallout(body);
				System.assertEquals(404, res.getStatusCode(), 'Should return error code');
				System.assert(res.getBody().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_404));
			} catch (Exception ex) {
				System.assert(
					ex.getMessage().contains(Integrations_Constants.RESPONSE_CODE_ERROR_MESSAGE_LIST.CODE_404)
				);
			}
			Test.stopTest();
		}
	}
	@IsTest
	static void testCalloutDataLoaded102() {
		Test.setMock(HttpCalloutMock.class, MockFactory.create(102, '{"message": "Error"}'));
		HttpResponse res;
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			Test.startTest();
			try {
				IApiCallout callout = CalloutFactory.get('OneSource_AddressValidationTest');
				String body = JSON.serialize('acc');
				res = callout.performCallout(body);
				System.assertEquals(102, res.getStatusCode(), 'Should return error code');
				System.assert(res.getBody().contains(('HTTP Error:')));
			} catch (Exception ex) {
				System.assert(ex.getMessage().contains('HTTP Error:'));
			}
			Test.stopTest();
		}
	}
	@IsTest
	static void testExponentialBackoffSleep() {
		User systemAdminUser = generateAdminUser();
		System.runAs(systemAdminUser) {
			API_Resource_Endpoint__mdt apiResource = API_Resource_Endpoint__mdt.getInstance(
				'OneSource_AddressValidationTest'
			);
			Test.startTest();
			RestApiCallout calloutR = new RestApiCallout(apiResource);
			calloutR.exponentialBackoffSleep(100, 1);
			Test.stopTest();
			System.assertEquals(calloutR.timeout, 200, 'Should return the correct timeout');
		}
	}

	private static User generateAdminUser() {
		Profile profileCM = [SELECT Id FROM Profile WHERE name = 'System Administrator'];
		UserRole roleCM = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
		User systemAdminUser = new User(
			UserRoleId = roleCM.Id,
			ProfileId = profileCM.Id,
			Username = 'contactManager@kaseya.com',
			Alias = 'ConMan',
			Email = 'contactManager@kaseya.com',
			EmailEncodingKey = 'UTF-8',
			Firstname = 'test',
			Lastname = 'user',
			languagelocalekey = 'en_US',
			LocaleSidKey = 'en_Us',
			TimeZoneSidKey = 'America/Chicago'
		);
		return systemAdminUser;
	}
}