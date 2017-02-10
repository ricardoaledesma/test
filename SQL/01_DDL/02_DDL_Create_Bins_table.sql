USE [Test]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Packages](
	[ID] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[BinNo] [int] NULL,
 CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Packages]  WITH CHECK ADD  CONSTRAINT [FK_Packages_Packages] FOREIGN KEY([ID])
REFERENCES [dbo].[Packages] ([ID])
GO

ALTER TABLE [dbo].[Packages] CHECK CONSTRAINT [FK_Packages_Packages]
GO
