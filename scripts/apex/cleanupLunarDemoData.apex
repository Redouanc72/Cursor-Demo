// ============================================================
// Lunar Basecamp Outfitters — Data Cleanup Script
// ============================================================
// Run: sf apex run --file scripts/apex/cleanupLunarDemoData.apex --target-org <alias>
//
// Deletes all demo records created by createLunarDemoData.apex.
// Order: Expedition_Gear__c → Safety_Certification__c →
//        Expedition_Booking__c → Gear_Item__c → Lunar_Explorer__c
// ============================================================

// ── Expedition Gear (junction — must go first; child of both M-D parents)
List<Expedition_Gear__c> eg = [
    SELECT Id FROM Expedition_Gear__c
    WHERE Expedition_Booking__r.Expedition_Name__c IN (
        'Tycho Shadow Traverse',
        'Mare Tranquillitatis Heritage Walk',
        'Shackleton Ice Core Expedition',
        'Hadley Rille Geological Survey',
        'Aristarchus Plateau Summit Push',
        'Tycho Rim Sunrise Circuit',
        'Tranquility Base Anniversary Tour',
        'Night Watch Crater Recon'
    )
    WITH USER_MODE
];
delete eg;
System.debug('✓ Deleted ' + eg.size() + ' Expedition Gear records');

// ── Safety Certifications
List<Safety_Certification__c> sc = [
    SELECT Id FROM Safety_Certification__c
    WHERE Explorer__r.Name IN (
        'Sarah Chen', 'Marcus Rodriguez', 'Yuki Tanaka',
        'Dmitri Volkov', 'Amara Okonkwo'
    )
    WITH USER_MODE
];
delete sc;
System.debug('✓ Deleted ' + sc.size() + ' Safety Certification records');

// ── Expedition Bookings
List<Expedition_Booking__c> eb = [
    SELECT Id FROM Expedition_Booking__c
    WHERE Expedition_Name__c IN (
        'Tycho Shadow Traverse',
        'Mare Tranquillitatis Heritage Walk',
        'Shackleton Ice Core Expedition',
        'Hadley Rille Geological Survey',
        'Aristarchus Plateau Summit Push',
        'Tycho Rim Sunrise Circuit',
        'Tranquility Base Anniversary Tour',
        'Night Watch Crater Recon'
    )
    WITH USER_MODE
];
delete eb;
System.debug('✓ Deleted ' + eb.size() + ' Expedition Booking records');

// ── Gear Items (by serial number range)
List<Gear_Item__c> gi = [
    SELECT Id FROM Gear_Item__c
    WHERE Serial_Number__c IN (
        'LBO-2024-001', 'LBO-2024-002', 'LBO-2024-003',
        'LBO-2024-004', 'LBO-2024-005', 'LBO-2024-006',
        'LBO-2024-007', 'LBO-2024-008', 'LBO-2024-009',
        'LBO-2024-010', 'LBO-2024-011', 'LBO-2024-012',
        'LBO-2024-013', 'LBO-2024-014', 'LBO-2024-015'
    )
    WITH USER_MODE
];
delete gi;
System.debug('✓ Deleted ' + gi.size() + ' Gear Item records');

// ── Lunar Explorers
List<Lunar_Explorer__c> le = [
    SELECT Id FROM Lunar_Explorer__c
    WHERE Name IN (
        'Sarah Chen', 'Marcus Rodriguez', 'Yuki Tanaka',
        'Dmitri Volkov', 'Amara Okonkwo'
    )
    WITH USER_MODE
];
delete le;
System.debug('✓ Deleted ' + le.size() + ' Lunar Explorer records');

// ── SUMMARY ───────────────────────────────────────────────────
Integer total = eg.size() + sc.size() + eb.size() + gi.size() + le.size();

System.debug('');
System.debug('════════════════════════════════════════════════════');
System.debug('  Lunar Basecamp Outfitters — Cleanup Complete      ');
System.debug('════════════════════════════════════════════════════');
System.debug('  Expedition Gear   deleted : ' + eg.size());
System.debug('  Safety Certs      deleted : ' + sc.size());
System.debug('  Expedition Bookings deleted: ' + eb.size());
System.debug('  Gear Items        deleted : ' + gi.size());
System.debug('  Lunar Explorers   deleted : ' + le.size());
System.debug('  ─────────────────────────────────────────────────');
System.debug('  Total records deleted     : ' + total);
System.debug('════════════════════════════════════════════════════');
