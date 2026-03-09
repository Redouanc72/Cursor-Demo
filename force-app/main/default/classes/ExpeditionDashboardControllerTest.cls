/**
 * @description Test for ExpeditionDashboardController.
 */
@IsTest
private class ExpeditionDashboardControllerTest {

    @IsTest
    static void getDashboardData_empty() {
        Test.startTest();
        ExpeditionDashboardController.DashboardData data = ExpeditionDashboardController.getDashboardData();
        Test.stopTest();
        System.assertNotEquals(null, data);
        System.assertEquals(0, data.expeditions.size());
        System.assertNotEquals(null, data.byMonth);
        System.assertNotEquals(null, data.byLandingSite);
    }

    @IsTest
    static void getDashboardData_withBookings() {
        Lunar_Explorer__c explorer = new Lunar_Explorer__c(Full_Name__c = 'Test Explorer', Email__c = 'test@example.com');
        insert explorer;
        Expedition_Booking__c b = new Expedition_Booking__c(
            Expedition_Name__c = 'Test Expedition',
            Explorer__c = explorer.Id,
            Launch_Date__c = Date.today().addDays(7),
            Landing_Site__c = 'Mare Tranquillitatis',
            Status__c = 'Confirmed',
            Compliance_Status__c = 'Cleared'
        );
        insert b;

        Test.startTest();
        ExpeditionDashboardController.DashboardData data = ExpeditionDashboardController.getDashboardData();
        Test.stopTest();

        System.assertNotEquals(null, data);
        System.assertEquals(1, data.expeditions.size());
        System.assertEquals('Test Expedition', data.expeditions[0].expeditionName);
        System.assertEquals('Test Explorer', data.expeditions[0].explorerName);
        System.assertEquals(0, data.expeditions[0].gearItemCount);
        System.assertEquals('Cleared', data.expeditions[0].complianceStatus);
    }
}
