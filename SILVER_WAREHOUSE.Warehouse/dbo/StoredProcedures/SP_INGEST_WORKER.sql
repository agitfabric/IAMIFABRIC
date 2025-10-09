CREATE   PROCEDURE SP_INGEST_WORKER AS
Delete a 
FROM SILVER_WAREHOUSE.dbo.Worker a 
Inner join BRONZE_LAKEHOUSE.dbo.temp_Worker b on b.PersonnelNumber = a.PersonnelNumber;

WITH ranked_data AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY PersonnelNumber ORDER BY ObjectId ASC) as rn
    FROM BRONZE_LAKEHOUSE.dbo.temp_Worker
)
Insert Into SILVER_WAREHOUSE.dbo.Worker
SELECT AddressBooks, AddressCity, AddressCountryRegionId, AddressCountryRegionISOCode, AddressCounty,
           AddressDistrictName, AddressLocationId, AddressNameDescription, AddressPurpose, AddressState,
           AddressStreet, AddressValidFrom, AddressValidTo, AddressZipCode, AllowRehire, AnniversaryDateTime,
           Applications, BenefitEligibilityOverrides, BillOfMaterialsHeaders, BillOfMaterialsVersions, BirthDate,
           CitizenshipCountryRegion, Contacts, CreatedDateTime1, DeceasedDate, DisabledVerificationDate,
           Discussions, Education, ElectronicLocationId, Employment, EthnicOriginId, ExpatriateRulingValidFrom,
           ExpatriateRulingValidTo, FatherBirthCountryRegion, FinancialDimensionValueLegalEntityOverride, FirstName,
           Gender, Goals, InjuryIncidents, InventoryCountingJournalHeader, InventoryCountingJournalLine, IsDisabled,
           IsDisabledVeteran, IsExpatriateRulingApplicable, IsFulltimeStudent, ItemSpecificBillOfMaterialsHeaders,
           KnownAs, LanguageId, LastName, LastNamePrefix, MaritalStatus, MiddleName, MilitaryServiceEndDate,
           MilitaryServiceStartDate, ModifiedDateTime1, MotherBirthCountryRegion, Name, NameAlias,
           NameSequenceDisplayAs, NationalityCountryRegion, NativeLanguageId, NumberOfDependents, ObjectId,
           OfficeLocation, OfficeLocationId, OriginalHireDateTime, OutletName, PartyNumber, PartyType,
           PayStatement, PayStatementEarningLine, Person1, PersonalContactOrganizationWorkerContact,
           PersonalContactPersonWorkerContact, PersonalSuffix, PersonalTitle, PersonBirthCity, PersonBirthCountryRegion,
           PersonDetailsValidFrom, PersonDetailsValidTo, PersonnelNumber, PhoneticFirstName, PhoneticLastName,
           PhoneticMiddleName, PlannedTimeAndAttendanceAbsenceRegistrations, Positions, PrimaryAddressLocation,
           PrimaryContactEmail, PrimaryContactEmailDescription, PrimaryContactEmailIsIM, PrimaryContactEmailIsPrivate,
           PrimaryContactEmailPurpose, PrimaryContactFacebook, PrimaryContactFacebookDescription,
           PrimaryContactFacebookIsPrivate, PrimaryContactFacebookPurpose, PrimaryContactFax, PrimaryContactFaxDescription,
           PrimaryContactFaxExtension, PrimaryContactFaxIsPrivate, PrimaryContactFaxPurpose, PrimaryContactLinkedIn,
           PrimaryContactLinkedInDescription, PrimaryContactLinkedInIsPrivate, PrimaryContactLinkedInPurpose,
           PrimaryContactPhone, PrimaryContactPhoneDescription, PrimaryContactPhoneExtension, PrimaryContactPhoneIsMobile,
           PrimaryContactPhoneIsPrivate, PrimaryContactPhonePurpose, PrimaryContactTwitter, PrimaryContactTwitterDescription,
           PrimaryContactTwitterIsPrivate, PrimaryContactTwitterPurpose, PrimaryContactURL, PrimaryContactURLDescription,
           PrimaryContactURLIsPrivate, PrimaryContactURLPurpose, ProfessionalSuffix, ProfessionalTitle,
           PublishedRequestForQuotationHeader, RecordId, RecruitingProjects, RequestForQuotationJournalHeaders,
           RouteHeaders, RouteVersions, SeniorityDate, ServiceAgreementHeaders, ServiceAgreementLines,
           ServiceOrderHeaders, ServiceOrderLines, SummaryValidFrom, SummaryValidTo, TaxTransactions,
           TimeAndAttendanceActivityRegistrations, TimeAndAttendanceManualPremiumRegistrations, TitleId,
           TradeAllowanceAgreementHeaders, TransferredTimeAndAttendanceActivityRegistrations, VeteranStatusId,
           W2BoxReportingAdjustments, WorkerAddress, WorkerBankAccount, WorkerBankAccountDisbursements,
           WorkerEnrolledAccrualInquiry, WorkerEnrolledAccruals, WorkerEnrolledBenefitInquiry, WorkerEnrolledBenefits,
           WorkerExam, WorkerPositionEarningCode, WorkerResponsibleFixedAsset, WorkerStatus, WorkerTaxCodeParameters,
           WorkerTaxCodes, WorkerTaxRegion, WorkerTitles, WorkerType, WorksFromHome, ZDealerSales, ZDepartment,
           ZKTPNo, ZNPWP, ZOutlet, ZSalesGroup, AccountNum, BankName, ZJumlahPersonnel, Last_update 
FROM ranked_data
WHERE rn = 1
--Select * FROM BRONZE_LAKEHOUSE.dbo.temp_Worker