// ============================================================
// Lunar Basecamp Outfitters — Sample Data Generator
// ============================================================
// Run: sf apex run --file scripts/apex/createLunarDemoData.apex --target-org <alias>
//
// Creates:
//   5  Lunar_Explorer__c
//  15  Gear_Item__c
//   8  Expedition_Booking__c
//  12  Safety_Certification__c
//  14  Expedition_Gear__c (junction)
// ─────────────────────────────────────────────────────────────
// Prerequisites: Metadata deployed + LunarBasecampOutfittersFull
//               Access permission set assigned to running user
// ============================================================

// ── 1. LUNAR EXPLORERS ───────────────────────────────────────

List<Lunar_Explorer__c> explorers = new List<Lunar_Explorer__c>{
    new Lunar_Explorer__c(
        Name                    = 'Sarah Chen',
        Full_Name__c            = 'Sarah Chen',
        Email__c                = 'sarah.chen@lunarbasecamp.demo',
        EVA_Hours__c            = 320,
        Certification_Level__c  = 'Master Lunar Alpinist',
        Medical_Clearance_Date__c = Date.today().addMonths(-3),
        Emergency_Contact__c    = 'David Chen — +1 415 555 0192'
    ),
    new Lunar_Explorer__c(
        Name                    = 'Marcus Rodriguez',
        Full_Name__c            = 'Marcus Rodriguez',
        Email__c                = 'marcus.rodriguez@lunarbasecamp.demo',
        EVA_Hours__c            = 185,
        Certification_Level__c  = 'Advanced Lava Tube Explorer',
        Medical_Clearance_Date__c = Date.today().addMonths(-5),
        Emergency_Contact__c    = 'Elena Rodriguez — +1 512 555 0348'
    ),
    new Lunar_Explorer__c(
        Name                    = 'Yuki Tanaka',
        Full_Name__c            = 'Yuki Tanaka',
        Email__c                = 'yuki.tanaka@lunarbasecamp.demo',
        EVA_Hours__c            = 67,
        Certification_Level__c  = 'Novice Crater Walker',
        Medical_Clearance_Date__c = Date.today().addMonths(-1),
        Emergency_Contact__c    = 'Hiroshi Tanaka — +81 90 5555 7821'
    ),
    new Lunar_Explorer__c(
        Name                    = 'Dmitri Volkov',
        Full_Name__c            = 'Dmitri Volkov',
        Email__c                = 'dmitri.volkov@lunarbasecamp.demo',
        EVA_Hours__c            = 498,
        Certification_Level__c  = 'Master Lunar Alpinist',
        Medical_Clearance_Date__c = Date.today().addMonths(-2),
        Emergency_Contact__c    = 'Natasha Volkova — +7 499 555 3317'
    ),
    new Lunar_Explorer__c(
        Name                    = 'Amara Okonkwo',
        Full_Name__c            = 'Amara Okonkwo',
        Email__c                = 'amara.okonkwo@lunarbasecamp.demo',
        EVA_Hours__c            = 112,
        Certification_Level__c  = 'Advanced Lava Tube Explorer',
        Medical_Clearance_Date__c = Date.today().addMonths(-4),
        Emergency_Contact__c    = 'Chidinma Okonkwo — +234 80 5555 9142'
    )
};
insert explorers;
System.debug('✓ Inserted ' + explorers.size() + ' Lunar Explorers');

Id chenId      = explorers[0].Id;
Id rodriguezId = explorers[1].Id;
Id tanakaId    = explorers[2].Id;
Id volkovId    = explorers[3].Id;
Id okonkwoId   = explorers[4].Id;


// ── 2. GEAR ITEMS ─────────────────────────────────────────────
// Serial number format: LBO-YYYY-NNN
// Statuses: Available (9), Rented (4), Maintenance (1), Retired (1)

List<Gear_Item__c> gear = new List<Gear_Item__c>{

    // ── Pressure Suits ──────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'Apollo Heritage Pressure Suit X7',
        Item_Name__c          = 'Apollo Heritage Pressure Suit X7',
        Category__c           = 'Pressure Suit',
        Serial_Number__c      = 'LBO-2024-001',
        Maintenance_Due_Date__c = Date.today().addMonths(4),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 4500,
        Purchase_Price__c     = 185000
    ),
    new Gear_Item__c(
        Name                  = 'Apollo Heritage Pressure Suit X7 #2',
        Item_Name__c          = 'Apollo Heritage Pressure Suit X7',
        Category__c           = 'Pressure Suit',
        Serial_Number__c      = 'LBO-2024-002',
        Maintenance_Due_Date__c = Date.today().addMonths(2),
        Status__c             = 'Rented',
        Daily_Rental_Rate__c  = 4500,
        Purchase_Price__c     = 185000
    ),
    new Gear_Item__c(
        Name                  = 'Apollo Heritage Pressure Suit X7 #3',
        Item_Name__c          = 'Apollo Heritage Pressure Suit X7',
        Category__c           = 'Pressure Suit',
        Serial_Number__c      = 'LBO-2024-003',
        Maintenance_Due_Date__c = Date.today().addDays(-7),    // overdue — in maintenance
        Status__c             = 'Maintenance',
        Daily_Rental_Rate__c  = 4500,
        Purchase_Price__c     = 185000
    ),

    // ── Lunar Boots ─────────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'CraterGrip Magnetic Boots Mk III',
        Item_Name__c          = 'CraterGrip Magnetic Boots Mk III',
        Category__c           = 'Boots',
        Serial_Number__c      = 'LBO-2024-004',
        Maintenance_Due_Date__c = Date.today().addMonths(6),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 650,
        Purchase_Price__c     = 28000
    ),
    new Gear_Item__c(
        Name                  = 'CraterGrip Magnetic Boots Mk III #2',
        Item_Name__c          = 'CraterGrip Magnetic Boots Mk III',
        Category__c           = 'Boots',
        Serial_Number__c      = 'LBO-2024-005',
        Maintenance_Due_Date__c = Date.today().addMonths(5),
        Status__c             = 'Rented',
        Daily_Rental_Rate__c  = 650,
        Purchase_Price__c     = 28000
    ),

    // ── Communication Devices ───────────────────────────────
    new Gear_Item__c(
        Name                  = 'HorizonLink Comm Headset Pro',
        Item_Name__c          = 'HorizonLink Comm Headset Pro',
        Category__c           = 'Communication Device',
        Serial_Number__c      = 'LBO-2024-006',
        Maintenance_Due_Date__c = Date.today().addMonths(8),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 800,
        Purchase_Price__c     = 32000
    ),
    new Gear_Item__c(
        Name                  = 'HorizonLink Comm Headset Pro #2',
        Item_Name__c          = 'HorizonLink Comm Headset Pro',
        Category__c           = 'Communication Device',
        Serial_Number__c      = 'LBO-2024-007',
        Maintenance_Due_Date__c = Date.today().addMonths(7),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 800,
        Purchase_Price__c     = 32000
    ),

    // ── Tether Kits ─────────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'TitanThread Tether Kit Elite',
        Item_Name__c          = 'TitanThread Tether Kit Elite',
        Category__c           = 'Tether Kit',
        Serial_Number__c      = 'LBO-2024-008',
        Maintenance_Due_Date__c = Date.today().addMonths(3),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 520,
        Purchase_Price__c     = 18500
    ),
    new Gear_Item__c(
        Name                  = 'TitanThread Tether Kit Elite #2',
        Item_Name__c          = 'TitanThread Tether Kit Elite',
        Category__c           = 'Tether Kit',
        Serial_Number__c      = 'LBO-2024-009',
        Maintenance_Due_Date__c = Date.today().addMonths(1),
        Status__c             = 'Rented',
        Daily_Rental_Rate__c  = 520,
        Purchase_Price__c     = 18500
    ),

    // ── Oxygen Systems ──────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'LunarBreath O2 System Gen-4',
        Item_Name__c          = 'LunarBreath O2 System Gen-4',
        Category__c           = 'Oxygen System',
        Serial_Number__c      = 'LBO-2024-010',
        Maintenance_Due_Date__c = Date.today().addMonths(5),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 3200,
        Purchase_Price__c     = 145000
    ),
    new Gear_Item__c(
        Name                  = 'LunarBreath O2 System Gen-4 #2',
        Item_Name__c          = 'LunarBreath O2 System Gen-4',
        Category__c           = 'Oxygen System',
        Serial_Number__c      = 'LBO-2024-011',
        Maintenance_Due_Date__c = Date.today().addMonths(3),
        Status__c             = 'Rented',
        Daily_Rental_Rate__c  = 3200,
        Purchase_Price__c     = 145000
    ),

    // ── Crater Anchors ──────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'ShackletonPro Ice Anchor Set',
        Item_Name__c          = 'ShackletonPro Ice Anchor Set',
        Category__c           = 'Crater Anchor',
        Serial_Number__c      = 'LBO-2024-012',
        Maintenance_Due_Date__c = Date.today().addMonths(9),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 580,
        Purchase_Price__c     = 22000
    ),
    new Gear_Item__c(
        Name                  = 'ShackletonPro Ice Anchor Set #2',
        Item_Name__c          = 'ShackletonPro Ice Anchor Set',
        Category__c           = 'Crater Anchor',
        Serial_Number__c      = 'LBO-2024-013',
        Maintenance_Due_Date__c = Date.today().addMonths(9),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 580,
        Purchase_Price__c     = 22000
    ),

    // ── Gloves ──────────────────────────────────────────────
    new Gear_Item__c(
        Name                  = 'OrionFlex EVA Gloves Type-C',
        Item_Name__c          = 'OrionFlex EVA Gloves Type-C',
        Category__c           = 'Gloves',
        Serial_Number__c      = 'LBO-2024-014',
        Maintenance_Due_Date__c = Date.today().addMonths(11),
        Status__c             = 'Available',
        Daily_Rental_Rate__c  = 500,
        Purchase_Price__c     = 15500
    ),
    new Gear_Item__c(
        Name                  = 'OrionFlex EVA Gloves Type-C #2',
        Item_Name__c          = 'OrionFlex EVA Gloves Type-C',
        Category__c           = 'Gloves',
        Serial_Number__c      = 'LBO-2024-015',
        Maintenance_Due_Date__c = Date.today(),
        Status__c             = 'Retired',
        Daily_Rental_Rate__c  = 500,
        Purchase_Price__c     = 15500
    )
};
insert gear;
System.debug('✓ Inserted ' + gear.size() + ' Gear Items');

// Gear index reference (0-based):
//  0 = Pressure Suit #1 — Available     8 = Tether Kit #2   — Rented
//  1 = Pressure Suit #2 — Rented        9 = O2 System #1    — Available
//  2 = Pressure Suit #3 — Maintenance  10 = O2 System #2    — Rented
//  3 = Boots #1         — Available    11 = Ice Anchor #1   — Available
//  4 = Boots #2         — Rented       12 = Ice Anchor #2   — Available
//  5 = Comm Headset #1  — Available    13 = Gloves #1       — Available
//  6 = Comm Headset #2  — Available    14 = Gloves #2       — Retired
//  7 = Tether Kit #1    — Available

Id suitAvail    = gear[0].Id;
Id bootsAvail   = gear[3].Id;
Id commAvail1   = gear[5].Id;
Id commAvail2   = gear[6].Id;
Id tetherAvail  = gear[7].Id;
Id o2Avail      = gear[9].Id;
Id anchorAvail1 = gear[11].Id;
Id anchorAvail2 = gear[12].Id;
Id glovesAvail  = gear[13].Id;


// ── 3. EXPEDITION BOOKINGS ─────────────────────────────────────
// Launch dates spread over the next 6 months (March–September 2026).
// One booking is currently In Progress (launched 4 days ago).

List<Expedition_Booking__c> bookings = new List<Expedition_Booking__c>{

    // BK-0: Tycho Shadow Traverse — Confirmed, launches in ~37 days
    new Expedition_Booking__c(
        Expedition_Name__c = 'Tycho Shadow Traverse',
        Explorer__c        = chenId,
        Launch_Date__c     = Date.today().addDays(37),
        Return_Date__c     = Date.today().addDays(44),
        Landing_Site__c    = 'Tycho Crater',
        Status__c          = 'Confirmed',
        Total_Cost__c      = 285000
    ),

    // BK-1: Mare Tranquillitatis Heritage Walk — Planned
    new Expedition_Booking__c(
        Expedition_Name__c = 'Mare Tranquillitatis Heritage Walk',
        Explorer__c        = rodriguezId,
        Launch_Date__c     = Date.today().addDays(53),
        Return_Date__c     = Date.today().addDays(59),
        Landing_Site__c    = 'Mare Tranquillitatis',
        Status__c          = 'Planned',
        Total_Cost__c      = 165000
    ),

    // BK-2: Shackleton Ice Core Expedition — Confirmed
    new Expedition_Booking__c(
        Expedition_Name__c = 'Shackleton Ice Core Expedition',
        Explorer__c        = volkovId,
        Launch_Date__c     = Date.today().addDays(72),
        Return_Date__c     = Date.today().addDays(80),
        Landing_Site__c    = 'Shackleton Rim',
        Status__c          = 'Confirmed',
        Total_Cost__c      = 420000
    ),

    // BK-3: Hadley Rille Geological Survey — Planned
    new Expedition_Booking__c(
        Expedition_Name__c = 'Hadley Rille Geological Survey',
        Explorer__c        = okonkwoId,
        Launch_Date__c     = Date.today().addDays(93),
        Return_Date__c     = Date.today().addDays(100),
        Landing_Site__c    = 'Hadley Rille',
        Status__c          = 'Planned',
        Total_Cost__c      = 195000
    ),

    // BK-4: Aristarchus Plateau Summit Push — Planned (Yuki's first expedition)
    new Expedition_Booking__c(
        Expedition_Name__c = 'Aristarchus Plateau Summit Push',
        Explorer__c        = tanakaId,
        Launch_Date__c     = Date.today().addDays(118),
        Return_Date__c     = Date.today().addDays(125),
        Landing_Site__c    = 'Aristarchus Plateau',
        Status__c          = 'Planned',
        Total_Cost__c      = 87000
    ),

    // BK-5: Tycho Rim Sunrise Circuit — Planned
    new Expedition_Booking__c(
        Expedition_Name__c = 'Tycho Rim Sunrise Circuit',
        Explorer__c        = chenId,
        Launch_Date__c     = Date.today().addDays(133),
        Return_Date__c     = Date.today().addDays(138),
        Landing_Site__c    = 'Tycho Crater',
        Status__c          = 'Planned',
        Total_Cost__c      = 310000
    ),

    // BK-6: Tranquility Base Anniversary Tour — Planned
    new Expedition_Booking__c(
        Expedition_Name__c = 'Tranquility Base Anniversary Tour',
        Explorer__c        = volkovId,
        Launch_Date__c     = Date.today().addDays(159),
        Return_Date__c     = Date.today().addDays(164),
        Landing_Site__c    = 'Mare Tranquillitatis',
        Status__c          = 'Planned',
        Total_Cost__c      = 225000
    ),

    // BK-7: Night Watch Crater Recon — In Progress (launched 4 days ago)
    new Expedition_Booking__c(
        Expedition_Name__c = 'Night Watch Crater Recon',
        Explorer__c        = rodriguezId,
        Launch_Date__c     = Date.today().addDays(-4),
        Return_Date__c     = Date.today().addDays(3),
        Landing_Site__c    = 'Mare Tranquillitatis',
        Status__c          = 'In Progress',
        Total_Cost__c      = 152000
    )
};
insert bookings;
System.debug('✓ Inserted ' + bookings.size() + ' Expedition Bookings');

Id bk0 = bookings[0].Id;  // Tycho Shadow Traverse       — Chen
Id bk1 = bookings[1].Id;  // Mare Heritage Walk          — Rodriguez
Id bk2 = bookings[2].Id;  // Shackleton Ice Core         — Volkov
Id bk3 = bookings[3].Id;  // Hadley Rille Survey         — Okonkwo
Id bk4 = bookings[4].Id;  // Aristarchus Summit Push     — Tanaka
Id bk7 = bookings[7].Id;  // Night Watch (In Progress)   — Rodriguez


// ── 4. SAFETY CERTIFICATIONS ──────────────────────────────────
// Mix of: current valid, expired, and one failed assessment.
// Instructors: Commander Yao Fei, Dr. Priya Nair,
//              Lt. Ben Okafor, Engineer Layla Hassan, Dr. Mei-Lin Zhao

List<Safety_Certification__c> certs = new List<Safety_Certification__c>{

    // ── Sarah Chen (320 hrs, Master Lunar Alpinist) ─────────
    // Basic EVA — EXPIRED (issued 2023, 2-year validity)
    new Safety_Certification__c(
        Explorer__c          = chenId,
        Certification_Type__c = 'Basic EVA',
        Issued_Date__c       = Date.newInstance(2023, 1, 15),
        Expiry_Date__c       = Date.newInstance(2025, 1, 15),
        Instructor_Name__c   = 'Commander Yao Fei',
        Pass_Status__c       = true
    ),
    // Crater Navigation — valid until Jun 2026
    new Safety_Certification__c(
        Explorer__c          = chenId,
        Certification_Type__c = 'Crater Navigation',
        Issued_Date__c       = Date.newInstance(2024, 6, 10),
        Expiry_Date__c       = Date.newInstance(2026, 6, 10),
        Instructor_Name__c   = 'Dr. Priya Nair',
        Pass_Status__c       = true
    ),
    // Low-G Climbing — valid until Aug 2027
    new Safety_Certification__c(
        Explorer__c          = chenId,
        Certification_Type__c = 'Low-G Climbing',
        Issued_Date__c       = Date.newInstance(2025, 8, 22),
        Expiry_Date__c       = Date.newInstance(2027, 8, 22),
        Instructor_Name__c   = 'Lt. Ben Okafor',
        Pass_Status__c       = true
    ),

    // ── Marcus Rodriguez (185 hrs, Advanced) ────────────────
    // Basic EVA — expired Mar 5 2026 (4 days ago)
    new Safety_Certification__c(
        Explorer__c          = rodriguezId,
        Certification_Type__c = 'Basic EVA',
        Issued_Date__c       = Date.newInstance(2024, 3, 5),
        Expiry_Date__c       = Date.newInstance(2026, 3, 5),
        Instructor_Name__c   = 'Commander Yao Fei',
        Pass_Status__c       = true
    ),
    // Crater Navigation — valid until Jan 2027
    new Safety_Certification__c(
        Explorer__c          = rodriguezId,
        Certification_Type__c = 'Crater Navigation',
        Issued_Date__c       = Date.newInstance(2025, 1, 20),
        Expiry_Date__c       = Date.newInstance(2027, 1, 20),
        Instructor_Name__c   = 'Dr. Priya Nair',
        Pass_Status__c       = true
    ),

    // ── Yuki Tanaka (67 hrs, Novice) ────────────────────────
    // Basic EVA — valid until Nov 2027
    new Safety_Certification__c(
        Explorer__c          = tanakaId,
        Certification_Type__c = 'Basic EVA',
        Issued_Date__c       = Date.newInstance(2025, 11, 10),
        Expiry_Date__c       = Date.newInstance(2027, 11, 10),
        Instructor_Name__c   = 'Lt. Ben Okafor',
        Pass_Status__c       = true
    ),
    // Emergency Repair — FAILED assessment (date issued, but Pass_Status = false)
    new Safety_Certification__c(
        Explorer__c          = tanakaId,
        Certification_Type__c = 'Emergency Repair',
        Issued_Date__c       = Date.newInstance(2025, 11, 12),
        Expiry_Date__c       = Date.newInstance(2027, 11, 12),
        Instructor_Name__c   = 'Engineer Layla Hassan',
        Pass_Status__c       = false
    ),

    // ── Dmitri Volkov (498 hrs, Master) ─────────────────────
    // Basic EVA — EXPIRED Jul 2024
    new Safety_Certification__c(
        Explorer__c          = volkovId,
        Certification_Type__c = 'Basic EVA',
        Issued_Date__c       = Date.newInstance(2022, 7, 30),
        Expiry_Date__c       = Date.newInstance(2024, 7, 30),
        Instructor_Name__c   = 'Commander Yao Fei',
        Pass_Status__c       = true
    ),
    // Crater Navigation — valid until Sep 2026
    new Safety_Certification__c(
        Explorer__c          = volkovId,
        Certification_Type__c = 'Crater Navigation',
        Issued_Date__c       = Date.newInstance(2024, 9, 15),
        Expiry_Date__c       = Date.newInstance(2026, 9, 15),
        Instructor_Name__c   = 'Dr. Priya Nair',
        Pass_Status__c       = true
    ),
    // Solar Radiation Protocol — valid until Apr 2027
    new Safety_Certification__c(
        Explorer__c          = volkovId,
        Certification_Type__c = 'Solar Radiation Protocol',
        Issued_Date__c       = Date.newInstance(2025, 4, 18),
        Expiry_Date__c       = Date.newInstance(2027, 4, 18),
        Instructor_Name__c   = 'Dr. Mei-Lin Zhao',
        Pass_Status__c       = true
    ),

    // ── Amara Okonkwo (112 hrs, Advanced) ───────────────────
    // Basic EVA — valid until Aug 2026
    new Safety_Certification__c(
        Explorer__c          = okonkwoId,
        Certification_Type__c = 'Basic EVA',
        Issued_Date__c       = Date.newInstance(2024, 8, 12),
        Expiry_Date__c       = Date.newInstance(2026, 8, 12),
        Instructor_Name__c   = 'Lt. Ben Okafor',
        Pass_Status__c       = true
    ),
    // Crater Navigation — valid until Sep 2027
    new Safety_Certification__c(
        Explorer__c          = okonkwoId,
        Certification_Type__c = 'Crater Navigation',
        Issued_Date__c       = Date.newInstance(2025, 9, 3),
        Expiry_Date__c       = Date.newInstance(2027, 9, 3),
        Instructor_Name__c   = 'Dr. Priya Nair',
        Pass_Status__c       = true
    )
};
insert certs;
System.debug('✓ Inserted ' + certs.size() + ' Safety Certifications');


// ── 5. EXPEDITION GEAR (JUNCTION) ─────────────────────────────
// Links gear items to expedition bookings.
// Only uses gear with Status__c = 'Available'.
//
// BK-0 Tycho Shadow Traverse     : Full kit (suit, boots, comm, O2, tether x2)
// BK-1 Mare Heritage Walk         : Comm headset + gloves
// BK-2 Shackleton Ice Core        : Dual anchor sets + O2 + tether
// BK-3 Hadley Rille Survey        : Boots + gloves + comm
// BK-4 Aristarchus Summit Push    : Suit + gloves + comm
// BK-7 Night Watch (In Progress)  : Tether + O2 + comm

List<Expedition_Gear__c> junctions = new List<Expedition_Gear__c>{

    // BK-0: Tycho Shadow Traverse (Sarah Chen — full technical kit)
    new Expedition_Gear__c(Expedition_Booking__c = bk0, Gear_Item__c = suitAvail,    Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk0, Gear_Item__c = bootsAvail,   Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk0, Gear_Item__c = commAvail1,   Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk0, Gear_Item__c = o2Avail,      Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk0, Gear_Item__c = tetherAvail,  Quantity__c = 2),

    // BK-1: Mare Heritage Walk (Marcus Rodriguez — light comm + gloves)
    new Expedition_Gear__c(Expedition_Booking__c = bk1, Gear_Item__c = commAvail2,   Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk1, Gear_Item__c = glovesAvail,  Quantity__c = 1),

    // BK-2: Shackleton Ice Core (Dmitri Volkov — anchor-heavy polar kit)
    new Expedition_Gear__c(Expedition_Booking__c = bk2, Gear_Item__c = anchorAvail1, Quantity__c = 2),
    new Expedition_Gear__c(Expedition_Booking__c = bk2, Gear_Item__c = anchorAvail2, Quantity__c = 2),
    new Expedition_Gear__c(Expedition_Booking__c = bk2, Gear_Item__c = tetherAvail,  Quantity__c = 1),

    // BK-3: Hadley Rille Survey (Amara Okonkwo — field survey loadout)
    new Expedition_Gear__c(Expedition_Booking__c = bk3, Gear_Item__c = bootsAvail,   Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk3, Gear_Item__c = commAvail1,   Quantity__c = 1),

    // BK-4: Aristarchus Summit Push (Yuki Tanaka — beginner essentials)
    new Expedition_Gear__c(Expedition_Booking__c = bk4, Gear_Item__c = suitAvail,    Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk4, Gear_Item__c = glovesAvail,  Quantity__c = 1),

    // BK-7: Night Watch Crater Recon (Rodriguez — currently on surface)
    new Expedition_Gear__c(Expedition_Booking__c = bk7, Gear_Item__c = o2Avail,      Quantity__c = 1),
    new Expedition_Gear__c(Expedition_Booking__c = bk7, Gear_Item__c = tetherAvail,  Quantity__c = 1)
};
insert junctions;
System.debug('✓ Inserted ' + junctions.size() + ' Expedition Gear junction records');


// ── SUMMARY ───────────────────────────────────────────────────
Integer total = explorers.size() + gear.size() + bookings.size() + certs.size() + junctions.size();

System.debug('');
System.debug('════════════════════════════════════════════════════');
System.debug('  Lunar Basecamp Outfitters — Data Load Complete    ');
System.debug('════════════════════════════════════════════════════');
System.debug('  Lunar Explorers        : ' + explorers.size());
System.debug('  Gear Items             : ' + gear.size());
System.debug('  Expedition Bookings    : ' + bookings.size());
System.debug('  Safety Certifications  : ' + certs.size());
System.debug('  Expedition Gear (junc) : ' + junctions.size());
System.debug('  ─────────────────────────────────────────────────');
System.debug('  Total records inserted : ' + total);
System.debug('════════════════════════════════════════════════════');
System.debug('');
System.debug('  Booking status breakdown:');
System.debug('    Confirmed   : 2  (Tycho Shadow Traverse, Shackleton Ice Core)');
System.debug('    In Progress : 1  (Night Watch Crater Recon)');
System.debug('    Planned     : 5  (future launches Apr–Sep 2026)');
System.debug('');
System.debug('  Certification highlights:');
System.debug('    Expired     : 3  (Chen Basic EVA, Rodriguez Basic EVA, Volkov Basic EVA)');
System.debug('    Failed      : 1  (Tanaka Emergency Repair)');
System.debug('    Current     : 8');
System.debug('════════════════════════════════════════════════════');
