USE Test;

DECLARE @RowCount INT
DECLARE @Random INT
DECLARE @Upper INT
DECLARE @Lower INT

SET @Lower = 1;
SET @Upper = 101;
SET @RowCount = 1;

WHILE @RowCount < 100001
BEGIN
	SET @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0);

	INSERT INTO Packages
	(
		 [ID]
		,[Weight]
		,[BinNo]
	)
	VALUES
	(
		 @RowCount
		,@Random
		,NULL
	)

	SET @RowCount = @RowCount + 1
END



