
CREATE DATABASE challengedb
GO


USE challengedb
GO

CREATE TABLE TipoAtencion (
    [Id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](8) NOT NULL,
	[tipo] [varchar](10) NOT NULL,
	[Duracion] int NOT NULL
	PRIMARY KEY ([Id]),
);



INSERT INTO [dbo].[TipoAtencion]([codigo],[tipo],[Duracion])VALUES ('cola1','Cola 1'   ,2);
INSERT INTO [dbo].[TipoAtencion]([codigo],[tipo],[Duracion])VALUES ('cola2','Cola 2'   ,3);


CREATE TABLE [dbo].[Atencion](
	[Id] [VARCHAR](100) NOT NULL,
	[NombreCliente] [VARCHAR](100) NOT NULL,
	[TipoAtencionId] int NOT NULL,
	[FechaCreacion] DATETIME DEFAULT GETDATE()
    FOREIGN KEY ([TipoAtencionId]) REFERENCES TipoAtencion([Id])
);


GO

CREATE PROCEDURE [dbo].[sp_insertar_turno]
          @Id VARCHAR(100) ,
		  @NombreCliente VARCHAR(100) ,
	      @CodigoTipoAtencion VARCHAR(8) ,
		  @Estado BIT OUTPUT,
		  @Mensaje VARCHAR(100) OUTPUT
     
AS
BEGIN
      SET NOCOUNT ON;
 

 IF EXISTS (SELECT 1 FROM [Atencion] WHERE ID=@Id)
	BEGIN
	 SELECT @Mensaje = 'Este código ya está registrada',@Estado=0
	END
  ELSE
    BEGIN

	DECLARE @TipoAtencionId INT
	SELECT @TipoAtencionId=Id FROM [dbo].[TipoAtencion] WHERE codigo=@CodigoTipoAtencion

	INSERT INTO [dbo].[Atencion]
           ([Id],[NombreCliente]
           ,[TipoAtencionId])
     VALUES
           (@Id,
		   @NombreCliente
           ,@TipoAtencionId)

	 SELECT @Mensaje = 'Registrada correctamente',@Estado=1
	END
   

END
GO


CREATE PROCEDURE [dbo].[sp_obtener_tipos_atencion]
AS
BEGIN
      SET NOCOUNT ON;
 
SELECT [Id]
      ,[codigo]
      ,[tipo]
      ,[Duracion]
  FROM [dbo].[TipoAtencion]

END


GO

CREATE PROCEDURE [dbo].[sp_obtener_atenciones_en_cola]
    @CodigoAtencion VARCHAR(8)
AS
BEGIN
      SET NOCOUNT ON;
 

DELETE FROM [dbo].[Atencion] WHERE DATEDIFF(MINUTE, [FechaCreacion], GETDATE()) >=2 

SELECT A.[Id]
      ,[NombreCliente]
      ,[TipoAtencionId]
	  ,[FechaCreacion]
  FROM [dbo].[Atencion] AS A
  JOIN [dbo].[TipoAtencion] AS B
  ON A.TipoAtencionId=B.Id
  AND B.codigo=@CodigoAtencion
  ORDER BY A.[Id]
  

END


