ALTER TABLE [dbo].[RecReg] ADD CONSTRAINT [PK_Participant] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
