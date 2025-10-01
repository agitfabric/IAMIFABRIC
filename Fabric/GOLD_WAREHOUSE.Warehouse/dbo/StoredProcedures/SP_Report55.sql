CREATE PROCEDURE [dbo].[SP_Report55] 
AS
BEGIN

    TRUNCATE TABLE Report_55;

    WITH LatestRow AS (
        SELECT 
            h.Worker, a.RecordId, b.Name AS nama, a.PersonnelNumber AS npk, o.ValidFrom, a.ZOutlet,
            e.ZDealerSales AS dealer, e.Name AS outlet, e.SiteId AS kodeoutlet, q2.ZDepartment AS Departemen,
            q2.TitleId AS jabatan, c.Position, g.ParentPosition,
            l.Address AS alamat, m.Locator AS email, n.Locator AS phone,
            j.Name AS Report_To,
            DATEDIFF(year, k.BirthDate, DATEADD(HOUR,7,GETDATE())) - 1 AS umur, 
            DATEDIFF(year, c.ValidFrom, DATEADD(HOUR,7,GETDATE())) - 1 AS masa_kerja,
            a.ZKTPNo AS ktp, b.KnownAs AS nickname, o.ValidFrom AS join_date, o.ValidTo AS until_date,
            CASE 
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sumbagut'   THEN e.AreaCode + '-Sumatera bagian utara'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sumbagsel' THEN e.AreaCode + '-Sumatera bagian selatan'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'JKT'       THEN e.AreaCode + '-DKI Jakarta'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jabar'     THEN e.AreaCode + '-Jawa Barat'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jateng'    THEN e.AreaCode + '-Jawa Tengah'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Jatim'     THEN e.AreaCode + '-Jawa Timur'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Kalimantan' THEN e.AreaCode + '-Kalimantan'
                WHEN e.ZIAMIArea COLLATE Latin1_General_CI_AS = 'Sul_IBT'   THEN e.AreaCode + '-Sulawesi & IBT'
                ELSE e.ZIAMIArea 
            END AS Area,
            CASE 
                WHEN q1.AgitTitleLevel COLLATE Latin1_General_CI_AS = 'Blank'            THEN 'blank'
                WHEN q1.AgitTitleLevel COLLATE Latin1_General_CI_AS = 'Salesman'         THEN 'salesman'
                WHEN q1.AgitTitleLevel COLLATE Latin1_General_CI_AS = 'Supervisor'       THEN 'supervisor'
                WHEN q1.AgitTitleLevel COLLATE Latin1_General_CI_AS = 'Branchmanager'    THEN 'branch manager'
                WHEN q1.AgitTitleLevel COLLATE Latin1_General_CI_AS = 'Operation Manager' THEN 'operation manager'
                ELSE q1.AgitTitleLevel 
            END AS title_level, 
            v.penjualan, r.MaritalStatus,
            k.BirthDate, k.ZEducationLevel,
            s.Description AS birthday_city, k.PersonBirthCountryRegion AS birth_country, 
            DATEDIFF(year, k.BirthDate, DATEADD(HOUR,7,GETDATE())) 
                + CASE WHEN (DATEADD(year, DATEDIFF(year, k.BirthDate, DATEADD(HOUR,7,GETDATE())), k.BirthDate) > DATEADD(HOUR,7,GETDATE())) 
                       THEN -1 ELSE 0 END AS age,
            k.NationalityCountryRegion AS nationality, r.NumberOfDependents AS num_dependent, k.Gender,
            a.WorkerType,
            l.ZIPCodePublic AS postal_code, l.Street AS Street, t.Description AS city, u.Description AS training,
            w.Affix AS Jenjang, ZHobby, ZReligion, ZBloodType, a.PersonalTitle, ZWorkerBankAccount AS BankName, 
            BankAccountNumber AS WorkerBankAccount, a.ZNPWP,
            ROW_NUMBER() OVER (PARTITION BY a.Person1 ORDER BY l._RecId_LogisticsPostalAddress DESC) AS rn,
            IIF(DATEADD(HOUR,7,GETDATE()) BETWEEN o.ValidFrom AND o.ValidTo, 1, 0) AS is_Active
        FROM SILVER_WAREHOUSE.dbo.Worker a
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable b 
            ON b.RecordId = a.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.HcmWorkerPrimaryPositionAssignmentView c 
            ON c.Worker = a.RecordId 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN c.ValidFrom AND c.ValidTo 
           AND c.IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'YES'
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZInventSites e 
            ON e.SiteId COLLATE Latin1_General_CI_AS = a.ZOutlet COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.PositionHierarchy g 
            ON g.Position = c.Position 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN g.ValidFrom AND g.ValidTo 
        LEFT JOIN SILVER_WAREHOUSE.dbo.PositionWorkerAssignment h 
            ON h.Position = g.ParentPosition 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN h.ValidFrom AND h.ValidTo 
           AND h.IsPrimaryPosition COLLATE Latin1_General_CI_AS = 'Yes'
        LEFT JOIN SILVER_WAREHOUSE.dbo.Worker i 
            ON i.RecordId = h.Worker
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyTable j 
            ON j.RecordId = i.Person1     
        LEFT JOIN SILVER_WAREHOUSE.dbo.PersonPrivateDetails k 
            ON k.Person = a.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyPostalAddressView l 
            ON l.Party = a.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyContactInfoView m 
            ON m.Party = a.Person1 
           AND m.Type COLLATE Latin1_General_CI_AS = 'Email' 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN m.ValidFrom AND m.ValidTo 
           AND m.IsPrimary COLLATE Latin1_General_CI_AS = 'YES'
        LEFT JOIN SILVER_WAREHOUSE.dbo.DirPartyContactInfoView n 
            ON n.Party = a.Person1 
           AND n.Type COLLATE Latin1_General_CI_AS = 'Phone' 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN n.ValidFrom AND n.ValidTo 
           AND n.IsPrimary COLLATE Latin1_General_CI_AS = 'YES'
        LEFT JOIN SILVER_WAREHOUSE.dbo.Employment o 
            ON o.Worker = a.RecordId 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN o.ValidFrom AND o.ValidTo
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZLogisticsEntityPostalAddress p1 
            ON p1.Entity = e.RecordId 
           AND p1.EntityType COLLATE Latin1_General_CI_AS = 'Party' 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN p1.ValidFrom AND p1.ValidTo 
           AND p1.IsPrimary COLLATE Latin1_General_CI_AS = 'YES'
        LEFT JOIN SILVER_WAREHOUSE.dbo.AddressCity p2 
            ON p2.Name COLLATE Latin1_General_CI_AS = p1.City COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmWorkerTitle q1 
            ON q1.Worker = a.RecordId 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN q1.ValidFrom AND q1.ValidTo
        LEFT JOIN SILVER_WAREHOUSE.dbo.ZHcmTitle q2 
            ON q2.RecordId = q1.Title
        LEFT JOIN SILVER_WAREHOUSE.dbo.PersonDetails r 
            ON r.PersonPublic = a.Person1 
           AND DATEADD(HOUR,7,GETDATE()) BETWEEN r.ValidFrom AND r.ValidTo
        LEFT JOIN SILVER_WAREHOUSE.dbo.AddressCity s 
            ON s.Name COLLATE Latin1_General_CI_AS = k.PersonBirthCity COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.AddressCity t 
            ON t.Name COLLATE Latin1_General_CI_AS = l.City COLLATE Latin1_General_CI_AS
        LEFT JOIN SILVER_WAREHOUSE.dbo.PersonCourse u 
            ON u.Person = a.Person1
        LEFT JOIN SILVER_WAREHOUSE.dbo.NameAffix w 
            ON w.RecordId = b.PersonalSuffix
        LEFT JOIN SILVER_WAREHOUSE.dbo.WorkerBankAccount x 
            ON x.PersonnelNumber COLLATE Latin1_General_CI_AS = a.PersonnelNumber COLLATE Latin1_General_CI_AS
        LEFT JOIN (
            SELECT ZSalesman, COUNT(ZSalesman) AS penjualan
            FROM SILVER_WAREHOUSE.dbo.SalesTable 
            WHERE SalesStatus COLLATE Latin1_General_CI_AS = 'Invoiced'
            GROUP BY ZSalesman
        ) v 
            ON v.ZSalesman COLLATE Latin1_General_CI_AS = a.PersonnelNumber COLLATE Latin1_General_CI_AS
        WHERE a.ZOutlet COLLATE Latin1_General_CI_AS NOT LIKE '%KZU%' 
          AND l.IsPrimary COLLATE Latin1_General_CI_AS = 'Yes'
    )

    INSERT INTO Report_55
    SELECT * FROM LatestRow
    WHERE rn = 1;

END