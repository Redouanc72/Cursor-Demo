/**
 * @description Controller for Lunar Expedition Dashboard LWC.
 * Queries Expedition_Booking__c (Confirmed/In Progress), explorer names, gear counts,
 * and chart aggregates (by month, by landing site).
 * @author Lunar Basecamp Outfitters
 */
public with sharing class ExpeditionDashboardController {

    /**
     * Wrapper for expedition card data and map marker.
     */
    public class ExpeditionCard {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String expeditionName { get; set; }
        @AuraEnabled public String explorerName { get; set; }
        @AuraEnabled public String explorerId { get; set; }
        @AuraEnabled public Date launchDate { get; set; }
        @AuraEnabled public Date returnDate { get; set; }
        @AuraEnabled public String landingSite { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String complianceStatus { get; set; }
        @AuraEnabled public Decimal totalCost { get; set; }
        @AuraEnabled public Integer gearItemCount { get; set; }
    }

    /**
     * Chart data: bookings by month (e.g. "2026-03") or by landing site.
     */
    public class ChartBucket {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public Integer value { get; set; }
    }

    /**
     * Dashboard payload: expeditions + chart data.
     */
    public class DashboardData {
        @AuraEnabled public List<ExpeditionCard> expeditions { get; set; }
        @AuraEnabled public List<ChartBucket> byMonth { get; set; }
        @AuraEnabled public List<ChartBucket> byLandingSite { get; set; }
    }

    /**
     * Fetches expeditions with Status = Confirmed or In Progress, plus chart aggregates.
     * @return DashboardData with expedition cards and chart buckets
     */
    @AuraEnabled(cacheable=true)
    public static DashboardData getDashboardData() {
        List<Expedition_Booking__c> bookings = [
            SELECT Id, Name, Expedition_Name__c,
                   Explorer__c, Explorer__r.Full_Name__c,
                   Launch_Date__c, Return_Date__c, Landing_Site__c,
                   Status__c, Compliance_Status__c, Total_Cost__c,
                   (SELECT Id FROM Expedition_Gear__r)
            FROM Expedition_Booking__c
            WHERE Status__c IN ('Confirmed', 'In Progress')
            WITH SECURITY_ENFORCED
            ORDER BY Launch_Date__c ASC NULLS LAST
        ];

        List<ExpeditionCard> cards = new List<ExpeditionCard>();
        for (Expedition_Booking__c b : bookings) {
            ExpeditionCard c = new ExpeditionCard();
            c.id = b.Id;
            c.expeditionName = b.Expedition_Name__c;
            c.explorerName = b.Explorer__r != null ? b.Explorer__r.Full_Name__c : '';
            c.explorerId = b.Explorer__c;
            c.launchDate = b.Launch_Date__c;
            c.returnDate = b.Return_Date__c;
            c.landingSite = b.Landing_Site__c;
            c.status = b.Status__c;
            c.complianceStatus = b.Compliance_Status__c != null ? b.Compliance_Status__c : 'Pending';
            c.totalCost = b.Total_Cost__c;
            c.gearItemCount = b.Expedition_Gear__r != null ? b.Expedition_Gear__r.size() : 0;
            cards.add(c);
        }

        List<Expedition_Booking__c> allForCharts = [
            SELECT Id, Launch_Date__c, Landing_Site__c
            FROM Expedition_Booking__c
            WHERE Launch_Date__c != null
            WITH SECURITY_ENFORCED
        ];

        Map<String, Integer> monthCount = new Map<String, Integer>();
        Map<String, Integer> siteCount = new Map<String, Integer>();
        for (Expedition_Booking__c b : allForCharts) {
            String monthStr = String.valueOf(b.Launch_Date__c.month()).leftPad(2, '0');
            String monthKey = String.valueOf(b.Launch_Date__c.year()) + '-' + monthStr;
            monthCount.put(monthKey, monthCount.get(monthKey) == null ? 1 : monthCount.get(monthKey) + 1);
            String site = String.isNotBlank(b.Landing_Site__c) ? b.Landing_Site__c : 'Unspecified';
            siteCount.put(site, siteCount.get(site) == null ? 1 : siteCount.get(site) + 1);
        }

        List<ChartBucket> byMonth = new List<ChartBucket>();
        List<String> months = new List<String>(monthCount.keySet());
        months.sort();
        for (String m : months) {
            ChartBucket bucket = new ChartBucket();
            bucket.label = m;
            bucket.value = monthCount.get(m);
            byMonth.add(bucket);
        }

        List<ChartBucket> byLandingSite = new List<ChartBucket>();
        List<String> sites = new List<String>(siteCount.keySet());
        sites.sort();
        for (String site : sites) {
            ChartBucket bucket = new ChartBucket();
            bucket.label = site;
            bucket.value = siteCount.get(site);
            byLandingSite.add(bucket);
        }

        DashboardData data = new DashboardData();
        data.expeditions = cards;
        data.byMonth = byMonth;
        data.byLandingSite = byLandingSite;
        return data;
    }
}
