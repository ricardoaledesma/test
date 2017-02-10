IF OBJECT_ID('UP_ALLOCATES_PACKAGES_IN_BINS') IS NULL 
EXEC('CREATE PROCEDURE UP_ALLOCATES_PACKAGES_IN_BINS AS SET NOCOUNT ON;') 
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE UP_ALLOCATES_PACKAGES_IN_BINS
AS
BEGIN
	DECLARE @ERROR VARCHAR(MAX) = NULL;
	BEGIN TRY
		IF OBJECT_ID('Bins_tmp', 'U') IS NOT NULL
			DROP TABLE Bins_tmp;
		SELECT * INTO Bins_tmp FROM (SELECT * FROM Bins) T;

		IF OBJECT_ID('Packages_tmp', 'U') IS NOT NULL
			DROP TABLE Packages_tmp;
		SELECT * INTO Packages_tmp FROM (SELECT * FROM Packages) T;
	
		DECLARE @BinNo int, @SpaceLeft int, @BinFetchStatus int;
		DECLARE @PackId int, @PackWeight  int, @PackBinNo int, @PackFetchStatus int;

		DECLARE @BinsCursor CURSOR
		SET @BinsCursor = CURSOR LOCAL FOR
		SELECT * FROM Bins_tmp ORDER BY SpaceLeft DESC, BinNo ASC

		DECLARE @PackCursor CURSOR 
		
		OPEN @BinsCursor;
		FETCH NEXT FROM @BinsCursor INTO @BinNo,@Spaceleft;
	
		SET @BinFetchStatus = @@FETCH_STATUS;

		WHILE @BinFetchStatus = 0
		BEGIN
			SET @PackCursor = CURSOR LOCAL FOR
			SELECT * FROM Packages_tmp where BinNo is null ORDER BY Weight DESC, ID ASC;
			
			OPEN @PackCursor;
			FETCH NEXT FROM @PackCursor INTO @PackId, @PackWeight, @PackBinNo;
			SET @PackFetchStatus = @@FETCH_STATUS;
			WHILE @PackFetchStatus = 0 OR @Spaceleft = 0
			BEGIN
				IF @PackWeight < @Spaceleft
				BEGIN
					SET @SpaceLeft = @SpaceLeft - @PackWeight;
					UPDATE Bins_tmp SET SpaceLeft = SpaceLeft - @PackWeight where BinNo = @BinNo;
					UPDATE Packages_tmp SET BinNo = @BinNo WHERE ID = @PackId;
				END

				FETCH NEXT FROM @PackCursor INTO @PackId, @PackWeight, @PackBinNo;
				SET @PackFetchStatus = @@FETCH_STATUS
			END
			
			CLOSE @PackCursor;
			DEALLOCATE @PackCursor;
		
			FETCH NEXT FROM @BinsCursor INTO @BinNo,@Spaceleft;
			SET @BinFetchStatus = @@FETCH_STATUS
		END;

		CLOSE @BinsCursor;
		DEALLOCATE @BinsCursor;
	END TRY
	BEGIN CATCH
		IF (SELECT CURSOR_STATUS('global','PackCursor')) >= -1
		BEGIN
			IF (SELECT CURSOR_STATUS('global','PackCursor')) > -1
			BEGIN
				CLOSE @PackCursor
			END
			DEALLOCATE @PackCursor
		END
		IF (SELECT CURSOR_STATUS('global','BinsCursor')) >= -1
		BEGIN
			IF (SELECT CURSOR_STATUS('global','BinsCursor')) > -1
			BEGIN
				CLOSE @BinsCursor
			END
			DEALLOCATE @BinsCursor
		END
		SET @ERROR = CONVERT(varchar(10),ERROR_NUMBER())+': '+ERROR_MESSAGE();
		PRINT @ERROR;
	END CATCH
END
GO

