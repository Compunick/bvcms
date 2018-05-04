CREATE FUNCTION [dbo].[GetTotalContributionsAgeRange]
(
	@fd DATETIME, 
	@td DATETIME,
	@campusid INT,
	@nontaxded BIT,
	@includeUnclosed BIT,
	@fundids VARCHAR(MAX)
)
RETURNS TABLE 
AS
RETURN 
(
	WITH ranges AS (
		SELECT 
			Amount = SUM(c.ContributionAmount), 
			[Count] = COUNT(*),
			[Range] = CASE WHEN ISNULL(p.Age, 0) = 0 THEN 0 ELSE p.Age / 10 + 1 END
		FROM dbo.ContributionSearch(NULL, NULL, NULL, NULL, @fd, @td, @campusid, 0, 2, 0, 
				CASE WHEN ISNULL(@nontaxded, 0) = 1 THEN 'nontaxded' ELSE 'taxded' END,
				NULL, 0, NULL, @includeUnclosed, NULL, NULL, NULL, @fundids) cs
		JOIN dbo.Contribution c ON c.ContributionId = cs.ContributionId
		JOIN dbo.People p ON p.PeopleId = c.PeopleId
		GROUP BY c.PeopleId, p.Age
	)
	SELECT 
		Total = SUM(r.Amount), 
		[Count] = SUM(r.COUNT), 
		DonorCount = COUNT(*),
		[Range] = CASE WHEN ISNULL(r.[Range], 0) = 0 THEN '0' 
					   ELSE FORMAT(r.[Range] * 10 - 9, 'n0') + ' - ' + FORMAT(r.[Range] * 10, 'n0')
				  END
	FROM ranges r
	GROUP BY r.[Range]
)

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
