SELECT	A.[OrganizationName],
		B.[OrganizationNumber],
		A.[AssociationName],
		A.[AssociationNumber],
		A.[OfficialBranchName],
		B.[ShortBranchName],
		A.[OfficialBranchNumber],
		B.[LocalBranchNumber],
		B.[BranchAddress1],
		B.[BranchAddress2],
		B.[BranchCity],
		B.[BranchState],
		B.[BranchPostal],
		B.[BranchCountry],
		B.[BranchAddressLineQuality],
		B.[BranchAddressCSZQuality],
		B.[SignatureName],
		B.[SignatureTitle],
		B.[CallName],
		B.[CallBranchAssociation],
		B.[CallPhone],
		B.[MemberCount],
		B.[UnitCount],
		B.[LoadDate],
		A.[PhoneNumber],
		A.[MSAOnFile],
		A.[SourceID],
		A.[SubSourceID],
		A.[PeerGroup],
		[ActiveFlag],
		[CustomQuestion1],
		[CustomQuestion2],
		[CustomQuestion3]
FROM	(
		SELECT	o.Type AS OrganizationName,
				case when o.Name = 'YMCA of Philadelphia and Vicinity' then 'Philadelphia Freedom Valley YMCA'
					else o.Name
				end AS AssociationName,
				o.Number AS AssociationNumber,
				o.PhoneNumber,
				case when so.Name = 'YMCA of Philadelphia and Vicinity' then 'Philadelphia Freedom Valley YMCA'
					else so.Name
				end AS OfficialBranchName,
				COALESCE(LEFT(so.OrganizationNumber, 20), '') AS OfficialBranchNumber,
				o.MSAOnFile,
				o.OrgainizationID AS SourceID,
				so.SuborganizationID As SubSourceID,
				o.OrganizationGroup as PeerGroup,
				1 AS Active
		FROM 	OISDB.dbo.tblOrganization o
				LEFT OUTER JOIN OISDB.dbo.tblSuborganization so
					ON so.OrgainizationID = o.OrgainizationID
		) A
		LEFT OUTER JOIN SeerStaging.OIS.Organizations B
			ON A.OrganizationName = B.OrganizationName
			AND A.AssociationName = B.AssociationName
			AND A.AssociationNumber = B.AssociationNumber
			AND A.OfficialBranchName = B.OfficialBranchName
			AND A.OfficialBranchNumber = B.OfficialBranchNumber
