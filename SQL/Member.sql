Drop Table [Member]
go
CREATE TABLE [Member](
	[Member_Key] varchar(20),
	[Seer_Key] varchar(20),
	[MemberCleansedID] [varchar](20),
	[OrganizationName] [varchar](50),
	[OrganizationId] [varchar](20),
	[MemberId] [varchar](20),
	[FamilyId] [varchar](50),
	[NumberInHousehold] [varchar](10),
	[HeadOfHousehold] [varchar](1),
	[MemberFirstName] [varchar](50),
	[MemberMiddleName] [varchar](50),
	[MemberLastName] [varchar](50),
	[MemberNameSuffix] [varchar](10),
	[Address1] [varchar](100),
	[Address2] [varchar](100),
	[AddressCity] [varchar](100),
	[AddressState] [varchar](25),
	[AddressPostal] [varchar](25),
	[AddressCountry] [varchar](25),
	[ParsedAddress1] [varchar](100),
	[ParsedAddress2] [varchar](100),
	[ParsedAddressCity] [varchar](100),
	[ParsedAddressState] [varchar](25),
	[ParsedAddressPostal] [varchar](25),
	[ParsedAddressCountry] [varchar](25),
	[ParsedAddressLineQuality] [varchar](20),
	[ParsedAddressCSZQuality] [varchar](20),
	[HomePhone] [varchar](50),
	[Gender] [varchar](1),
	[Ethnicity] [varchar](50),
	[Birthdate] [varchar](25),
	[MembershipDate] [varchar](25),
	[Category] [varchar](75),
	[MembershipType] [varchar](75),
	[StaffType] [varchar](75),
	[FullTimePartTime] [varchar](50),
	[HourlySalary] [varchar](50),
	[IsPrimaryMember] [varchar](1),
	[IsEmployee] [varchar](1),
	[IsDonor] [varchar](1),
	[IsProgramMember] [varchar](1),
	[IsNewMember] [varchar](1),
	[IsHealthSeeker] [varchar](1),
	[IsActive] [varchar](1),
	[RemovalReason] [varchar](100),
	[Comments] [varchar](255),
	[RecordType] [varchar](75),
	[MailableMember] [varchar](1),
	[EmailableMember] [varchar](1),
	[MailableEmployee] [varchar](1),
	[EmailableEmployee] [varchar](1),
	[EmailableNewMember] [varchar](1),
	[EmailableProgramMember] [varchar](1),
	[ProgramSiteLocation] [varchar] (100),
	[Phone] [varchar](50),
	[EmailAddress] [varchar](100),
	[ExactAge] [varchar](5),
	[EstimatedAge] [varchar](5),
	[EstimatedHouseholdIncomeAmount] [varchar](1),
	[CountyIncomePercentile] [varchar](20),
	[MaritalStatus] [varchar](5),
	[Filler01] [varchar](1),
	[Filler02] [varchar](1),
	[Filler03] [varchar](1),
	[Filler04] [varchar](1),
	[Filler05] [varchar](1),
	[Filler06] [varchar](1),
	[Filler07] [varchar](1),
	[Filler08] [varchar](1),
	[Filler09] [varchar](1),
	[HomeBusinessIndicator] [varchar](1),
	[PresenceOfChildren03] [varchar](1),
	[GenderOfChildren03] [varchar](1),
	[PresenceOfChildren46] [varchar](1),
	[GenderOfChildren46] [varchar](1),
	[PresenceOfChildren79] [varchar](1),
	[GenderOfChildren79] [varchar](1),
	[PresenceOfChildren1012] [varchar](1),
	[GenderOfChildren1012] [varchar](1),
	[PresenceOfChildren1318] [varchar](1),
	[GenderOfChildren1318] [varchar](1),
	[NumberOfAdultsInHousehold] [varchar](10),
	[Homeowner] [varchar](1),
	[ProbableHomeowner] [varchar](5),
	[LengthOfResidence] [varchar](1000),
	[DwellingUnitSizeCode] [varchar](1),
	[YearBuilt] [varchar](10),
	[MultiCoDirectMail] [varchar](1),
	[NewsAndFinancial] [varchar](10),
	[CurrentEstimatedMedianFamilyIncome] [varchar](10),
	[MedianEducationYearsAttained] [varchar](5),
	[PctOccManagement] [varchar](20),
	[PctOccHealthTechnologists] [varchar](20),
	[PctWhiteOnly] [varchar](20),
	[MedianHousingValue] [varchar](20),
	[PctPopulationUnder4] [varchar](20),
	[PctPopulation59] [varchar](20),
	[PctPopulation1013] [varchar](20),
	[PctPopulation1417] [varchar](20),
	[PctDwellingOwnerOccupied] [varchar](20),
	[PctDwellingRenterOccupied] [varchar](20),
	[CurrentEstimatedFamilyIncomeDecile] [varchar](20),
	[BibleDevotionalReligious] [varchar](1),
	[VolunteerWork] [varchar](1),
	[HOHEducationFlag] [varchar](5),
	[HOHOccupationFlag] [varchar](5),
	[AnimalWelfareContributions] [varchar](1),
	[ChildrensWelfare] [varchar](1),
	[CulturalWelfare] [varchar](1),
	[Environmental] [varchar](1),
	[HealthRelated] [varchar](1),
	[Political] [varchar](1),
	[ReligiousContributions] [varchar](1),
	[SocialServices] [varchar](1),
	[UseMacComputer] [varchar](1),
	[OwnCDRom] [varchar](1),
	[UseModem] [varchar](1),
	[OwnComputer] [varchar](1),
	[LaserPrinter] [varchar](1),
	[ColorPrinter] [varchar](1),
	[UseInternetService] [varchar](1),
	[StockBondInvestor] [varchar](1),
	[CDMoneyMarketInvestor] [varchar](1),
	[IRAInvestor] [varchar](1),
	[MutualFundInvestor] [varchar](1),
	[RealEstateInvestor] [varchar](1),
	[Crafts] [varchar](1),
	[EstimatedCurrentHomeValue] [varchar](20),
	[Latitude] [varchar](10),
	[Longitude] [varchar](10),
	[LevLatLong] [varchar](1),
	[FipsStateCode] [varchar](75),
	[FipsCountyCode] [varchar](75),
	[CensusTract] [varchar](25),
	[CensusBlockGroup] [varchar](25),
	[BlockId] [varchar](25),
	[MCDCCDCode] [varchar](75),
	[CBSACode] [varchar](75),
	[EnhancementMatchType] [varchar](1),
	[CensusMatchLevel] [varchar](1),
	[CurrentEstimatedFamilyIncomeAmount] [varchar](20),
	[CurrentEstimatedFamilyIncomeCode] [varchar](1),
	[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP

GO




