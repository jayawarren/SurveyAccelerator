INSERT INTO Seer_STG.dbo.Member 
		(
		[MemberCleansedID],
		[OrganizationName],
		[OrganizationId],
		[MemberId],
		[FamilyId],
		[NumberInHousehold],
		[HeadOfHousehold],
		[MemberFirstName],
		[MemberMiddleName],
		[MemberLastName],
		[MemberNameSuffix],
		[Address1],
		[Address2],
		[AddressCity],
		[AddressState],
		[AddressPostal],
		[AddressCountry],
		[ParsedAddress1],
		[ParsedAddress2],
		[ParsedAddressCity],
		[ParsedAddressState],
		[ParsedAddressPostal],
		[ParsedAddressCountry],
		[ParsedAddressLineQuality],
		[ParsedAddressCSZQuality],
		[HomePhone],
		[Gender],
		[Ethnicity],
		[Birthdate],
		[MembershipDate],
		[Category],
		[MembershipType],
		[StaffType],
		[FullTimePartTime],
		[HourlySalary],
		[IsPrimaryMember],
		[IsEmployee],
		[IsDonor],
		[IsProgramMember],
		[IsNewMember],
		[IsActive],
		[RemovalReason],
		[Comments],
		[RecordType],
		[MailableMember],
		[EmailableMember],
		[MailableEmployee],
		[EmailableEmployee],
		[EmailableNewMember],
		[EmailableProgramMember],
		[ProgramSiteLocation],
		[Phone],
		[EmailAddress],
		[ExactAge],
		[EstimatedAge],
		[EstimatedHouseholdIncomeAmount],
		[CountyIncomePercentile],
		[MaritalStatus],
		[Filler01],
		[Filler02],
		[Filler03],
		[Filler04],
		[Filler05],
		[Filler06],
		[Filler07],
		[Filler08],
		[Filler09],
		[HomeBusinessIndicator],
		[PresenceOfChildren03],
		[GenderOfChildren03],
		[PresenceOfChildren46],
		[GenderOfChildren46],
		[PresenceOfChildren79],
		[GenderOfChildren79],
		[PresenceOfChildren1012],
		[GenderOfChildren1012],
		[PresenceOfChildren1318],
		[GenderOfChildren1318],
		[NumberOfAdultsInHousehold],
		[Homeowner],
		[ProbableHomeowner],
		[LengthOfResidence],
		[DwellingUnitSizeCode],
		[YearBuilt],
		[MultiCoDirectMail],
		[NewsAndFinancial],
		[CurrentEstimatedMedianFamilyIncome],
		[MedianEducationYearsAttained],
		[PctOccManagement],
		[PctOccHealthTechnologists],
		[PctWhiteOnly],
		[MedianHousingValue],
		[PctPopulationUnder4],
		[PctPopulation59],
		[PctPopulation1013],
		[PctPopulation1417],
		[PctDwellingOwnerOccupied],
		[PctDwellingRenterOccupied],
		[CurrentEstimatedFamilyIncomeDecile],
		[BibleDevotionalReligious],
		[VolunteerWork],
		[HOHEducationFlag],
		[HOHOccupationFlag],
		[AnimalWelfareContributions],
		[ChildrensWelfare],
		[CulturalWelfare],
		[Environmental],
		[HealthRelated],
		[Political],
		[ReligiousContributions],
		[SocialServices],
		[UseMacComputer],
		[OwnCDRom],
		[UseModem],
		[OwnComputer],
		[LaserPrinter],
		[ColorPrinter],
		[UseInternetService],
		[StockBondInvestor],
		[CDMoneyMarketInvestor],
		[IRAInvestor],
		[MutualFundInvestor],
		[RealEstateInvestor],
		[Crafts],
		[EstimatedCurrentHomeValue],
		[Latitude],
		[Longitude],
		[LevLatLong],
		[FipsStateCode],
		[FipsCountyCode],
		[CensusTract],
		[CensusBlockGroup],
		[BlockId],
		[MCDCCDCode],
		[CBSACode],
		[EnhancementMatchType],
		[CensusMatchLevel],
		[CurrentEstimatedFamilyIncomeAmount],
		[CurrentEstimatedFamilyIncomeCode]
		)
SELECT	A.[MemberCleansedID],
		B.[OrganizationName],
		B.[OrganizationId],
		B.[MemberId],
		B.[FamilyId],
		B.[NumberInHousehold],
		B.[HeadOfHousehold],
		B.[MemberFirstName],
		B.[MemberMiddleName],
		B.[MemberLastName],
		B.[MemberNameSuffix],
		B.[Address1],
		B.[Address2],
		B.[AddressCity],
		B.[AddressState],
		B.[AddressPostal],
		B.[AddressCountry],
		B.[ParsedAddress1],
		B.[ParsedAddress2],
		B.[ParsedAddressCity],
		B.[ParsedAddressState],
		B.[ParsedAddressPostal],
		B.[ParsedAddressCountry],
		B.[ParsedAddressLineQuality],
		B.[ParsedAddressCSZQuality],
		B.[HomePhone],
		B.[Gender],
		B.[Ethnicity],
		B.[Birthdate],
		B.[MembershipDate],
		B.[Category],
		B.[MembershipType],
		B.[StaffType],
		B.[FullTimePartTime],
		B.[HourlySalary],
		B.[IsPrimaryMember],
		B.[IsEmployee],
		B.[IsDonor],
		B.[IsProgramMember],
		B.[IsNewMember],
		B.[IsActive],
		B.[RemovalReason],
		B.[Comments],
		B.[RecordType],
		B.[MailableMember],
		B.[EmailableMember],
		B.[MailableEmployee],
		B.[EmailableEmployee],
		B.[EmailableNewMember],
		B.[EmailableProgramMember],
		B.[ProgramSiteLocation],
		C.[Phone],
		C.[EmailAddress],
		C.[ExactAge],
		C.[EstimatedAge],
		C.[EstimatedHouseholdIncomeAmount],
		C.[CountyIncomePercentile],
		C.[MaritalStatus],
		C.[Filler01],
		C.[Filler02],
		C.[Filler03],
		C.[Filler04],
		C.[Filler05],
		C.[Filler06],
		C.[Filler07],
		C.[Filler08],
		C.[Filler09],
		C.[HomeBusinessIndicator],
		C.[PresenceOfChildren03],
		C.[GenderOfChildren03],
		C.[PresenceOfChildren46],
		C.[GenderOfChildren46],
		C.[PresenceOfChildren79],
		C.[GenderOfChildren79],
		C.[PresenceOfChildren1012],
		C.[GenderOfChildren1012],
		C.[PresenceOfChildren1318],
		C.[GenderOfChildren1318],
		C.[NumberOfAdultsInHousehold],
		C.[Homeowner],
		C.[ProbableHomeowner],
		C.[LengthOfResidence],
		C.[DwellingUnitSizeCode],
		C.[YearBuilt],
		C.[MultiCoDirectMail],
		C.[NewsAndFinancial],
		C.[CurrentEstimatedMedianFamilyIncome],
		C.[MedianEducationYearsAttained],
		C.[PctOccManagement],
		C.[PctOccHealthTechnologists],
		C.[PctWhiteOnly],
		C.[MedianHousingValue],
		C.[PctPopulationUnder4],
		C.[PctPopulation59],
		C.[PctPopulation1013],
		C.[PctPopulation1417],
		C.[PctDwellingOwnerOccupied],
		C.[PctDwellingRenterOccupied],
		C.[CurrentEstimatedFamilyIncomeDecile],
		C.[BibleDevotionalReligious],
		C.[VolunteerWork],
		C.[HOHEducationFlag],
		C.[HOHOccupationFlag],
		C.[AnimalWelfareContributions],
		C.[ChildrensWelfare],
		C.[CulturalWelfare],
		C.[Environmental],
		C.[HealthRelated],
		C.[Political],
		C.[ReligiousContributions],
		C.[SocialServices],
		C.[UseMacComputer],
		C.[OwnCDRom],
		C.[UseModem],
		C.[OwnComputer],
		C.[LaserPrinter],
		C.[ColorPrinter],
		C.[UseInternetService],
		C.[StockBondInvestor],
		C.[CDMoneyMarketInvestor],
		C.[IRAInvestor],
		C.[MutualFundInvestor],
		C.[RealEstateInvestor],
		C.[Crafts],
		C.[EstimatedCurrentHomeValue],
		C.[Latitude],
		C.[Longitude],
		C.[LevLatLong],
		C.[FipsStateCode],
		C.[FipsCountyCode],
		C.[CensusTract],
		C.[CensusBlockGroup],
		C.[BlockId],
		C.[MCDCCDCode],
		C.[CBSACode],
		C.[EnhancementMatchType],
		C.[CensusMatchLevel],
		C.[CurrentEstimatedFamilyIncomeAmount],
		C.[CurrentEstimatedFamilyIncomeCode]
		
FROM	(
		SELECT	MAX(MemberCleansedID) MemberCleansedID/*,
				[OrganizationId],
				[MemberId],
				[MemberFirstName],
				[MemberMiddleName],
				[MemberLastName],
				[ParsedAddressCity],
				[ParsedAddressState],
				[ParsedAddressPostal],
				[EmailAddress]*/
				
		FROM	[SeerStaging].[mem].[MemberCleansed]

		--WHERE	MemberFirstName = 'Aaron'
		--		AND MemberLastName = 'Kirschenfeld'

		GROUP BY [OrganizationId],
				[MemberId],
				[MemberFirstName],
				[MemberMiddleName],
				[MemberLastName],
				[ParsedAddressCity],
				[ParsedAddressState],
				[ParsedAddressPostal],
				[EmailAddress]
		) A
		INNER JOIN [SeerStaging].[mem].[MemberCleansed] B
				ON A.MemberCleansedID = B.MemberCleansedID
		LEFT JOIN [SeerStaging].[mem].[MemberExperianEnhanced] C
				ON COALESCE(B.[JobOrderNumber], '') = COALESCE(C.[JobOrderNumber], '')
					AND COALESCE(B.[OrganizationId], '') = COALESCE(C.[OrganizationID], '')
					AND COALESCE(B.[MemberId], '') = COALESCE(C.[MemberID], '')
					AND COALESCE(B.[MemberFirstName], '') = COALESCE(C.[MemberFirstName], '')
					AND COALESCE(B.[MemberMiddleName], '') = COALESCE(C.[MemberMiddleName], '')
					AND COALESCE(B.[MemberLastName], '') = COALESCE(C.[MemberLastName], '')
					AND COALESCE(B.[EmailAddress], '') = COALESCE(C.[EmailAddress], '')
					
GROUP BY A.[MemberCleansedID],
		B.[OrganizationName],
		B.[OrganizationId],
		B.[MemberId],
		B.[FamilyId],
		B.[NumberInHousehold],
		B.[HeadOfHousehold],
		B.[MemberFirstName],
		B.[MemberMiddleName],
		B.[MemberLastName],
		B.[MemberNameSuffix],
		B.[Address1],
		B.[Address2],
		B.[AddressCity],
		B.[AddressState],
		B.[AddressPostal],
		B.[AddressCountry],
		B.[ParsedAddress1],
		B.[ParsedAddress2],
		B.[ParsedAddressCity],
		B.[ParsedAddressState],
		B.[ParsedAddressPostal],
		B.[ParsedAddressCountry],
		B.[ParsedAddressLineQuality],
		B.[ParsedAddressCSZQuality],
		B.[HomePhone],
		B.[Gender],
		B.[Ethnicity],
		B.[Birthdate],
		B.[MembershipDate],
		B.[Category],
		B.[MembershipType],
		B.[StaffType],
		B.[FullTimePartTime],
		B.[HourlySalary],
		B.[IsPrimaryMember],
		B.[IsEmployee],
		B.[IsDonor],
		B.[IsProgramMember],
		B.[IsNewMember],
		B.[IsActive],
		B.[RemovalReason],
		B.[Comments],
		B.[RecordType],
		B.[MailableMember],
		B.[EmailableMember],
		B.[MailableEmployee],
		B.[EmailableEmployee],
		B.[EmailableNewMember],
		B.[EmailableProgramMember],
		B.[ProgramSiteLocation],
		C.[Phone],
		C.[EmailAddress],
		C.[ExactAge],
		C.[EstimatedAge],
		C.[EstimatedHouseholdIncomeAmount],
		C.[CountyIncomePercentile],
		C.[MaritalStatus],
		C.[Filler01],
		C.[Filler02],
		C.[Filler03],
		C.[Filler04],
		C.[Filler05],
		C.[Filler06],
		C.[Filler07],
		C.[Filler08],
		C.[Filler09],
		C.[HomeBusinessIndicator],
		C.[PresenceOfChildren03],
		C.[GenderOfChildren03],
		C.[PresenceOfChildren46],
		C.[GenderOfChildren46],
		C.[PresenceOfChildren79],
		C.[GenderOfChildren79],
		C.[PresenceOfChildren1012],
		C.[GenderOfChildren1012],
		C.[PresenceOfChildren1318],
		C.[GenderOfChildren1318],
		C.[NumberOfAdultsInHousehold],
		C.[Homeowner],
		C.[ProbableHomeowner],
		C.[LengthOfResidence],
		C.[DwellingUnitSizeCode],
		C.[YearBuilt],
		C.[MultiCoDirectMail],
		C.[NewsAndFinancial],
		C.[CurrentEstimatedMedianFamilyIncome],
		C.[MedianEducationYearsAttained],
		C.[PctOccManagement],
		C.[PctOccHealthTechnologists],
		C.[PctWhiteOnly],
		C.[MedianHousingValue],
		C.[PctPopulationUnder4],
		C.[PctPopulation59],
		C.[PctPopulation1013],
		C.[PctPopulation1417],
		C.[PctDwellingOwnerOccupied],
		C.[PctDwellingRenterOccupied],
		C.[CurrentEstimatedFamilyIncomeDecile],
		C.[BibleDevotionalReligious],
		C.[VolunteerWork],
		C.[HOHEducationFlag],
		C.[HOHOccupationFlag],
		C.[AnimalWelfareContributions],
		C.[ChildrensWelfare],
		C.[CulturalWelfare],
		C.[Environmental],
		C.[HealthRelated],
		C.[Political],
		C.[ReligiousContributions],
		C.[SocialServices],
		C.[UseMacComputer],
		C.[OwnCDRom],
		C.[UseModem],
		C.[OwnComputer],
		C.[LaserPrinter],
		C.[ColorPrinter],
		C.[UseInternetService],
		C.[StockBondInvestor],
		C.[CDMoneyMarketInvestor],
		C.[IRAInvestor],
		C.[MutualFundInvestor],
		C.[RealEstateInvestor],
		C.[Crafts],
		C.[EstimatedCurrentHomeValue],
		C.[Latitude],
		C.[Longitude],
		C.[LevLatLong],
		C.[FipsStateCode],
		C.[FipsCountyCode],
		C.[CensusTract],
		C.[CensusBlockGroup],
		C.[BlockId],
		C.[MCDCCDCode],
		C.[CBSACode],
		C.[EnhancementMatchType],
		C.[CensusMatchLevel],
		C.[CurrentEstimatedFamilyIncomeAmount],
		C.[CurrentEstimatedFamilyIncomeCode]
						
			