USE [master]
GO
/****** Object:  Database [CompagniaAerea]    Script Date: 13/07/2025 15:22:17 ******/
CREATE DATABASE [CompagniaAerea]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CompagniaAerea', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CompagniaAerea.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CompagniaAerea_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CompagniaAerea_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [CompagniaAerea] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CompagniaAerea].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CompagniaAerea] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CompagniaAerea] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CompagniaAerea] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CompagniaAerea] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CompagniaAerea] SET ARITHABORT OFF 
GO
ALTER DATABASE [CompagniaAerea] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CompagniaAerea] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CompagniaAerea] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CompagniaAerea] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CompagniaAerea] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CompagniaAerea] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CompagniaAerea] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CompagniaAerea] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CompagniaAerea] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CompagniaAerea] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CompagniaAerea] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CompagniaAerea] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CompagniaAerea] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CompagniaAerea] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CompagniaAerea] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CompagniaAerea] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CompagniaAerea] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CompagniaAerea] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CompagniaAerea] SET  MULTI_USER 
GO
ALTER DATABASE [CompagniaAerea] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CompagniaAerea] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CompagniaAerea] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CompagniaAerea] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CompagniaAerea] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CompagniaAerea] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CompagniaAerea] SET QUERY_STORE = ON
GO
ALTER DATABASE [CompagniaAerea] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [CompagniaAerea]
GO
/****** Object:  Table [dbo].[Aereo]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aereo](
	[aereo_id] [nvarchar](20) NOT NULL,
	[codice_modello] [nvarchar](50) NOT NULL,
	[nome_modello] [nvarchar](100) NULL,
	[aereo_status] [nvarchar](50) NULL,
	[aereo_tipo] [nvarchar](20) NULL,
	[posti_ClasseBusiness] [int] NULL,
	[posti_ClasseEconomy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[aereo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Aeroporti]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aeroporti](
	[codice_IATA] [char](3) NOT NULL,
	[aeroporto_nome] [nvarchar](100) NOT NULL,
	[aeroporto_codice_ICAO] [char](4) NULL,
	[coordinate_lat] [decimal](9, 6) NULL,
	[coordinate_long] [decimal](9, 6) NULL,
	[aeroporto_citta] [nvarchar](100) NULL,
	[aeroporto_status] [nvarchar](20) NULL,
	[regione_id] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[codice_IATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Classe]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classe](
	[classe_id] [char](1) NOT NULL,
	[classe_nome] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[classe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compagnia]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compagnia](
	[compagnia_id] [char](2) NOT NULL,
	[compagnia_nome] [nvarchar](100) NOT NULL,
	[compagnia_codice_ICAO] [char](4) NULL,
	[compagnia_StarAlliance] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[compagnia_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentoIdentificativo]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentoIdentificativo](
	[documento_id] [int] IDENTITY(1,1) NOT NULL,
	[passeggero_id] [int] NOT NULL,
	[documento_tipo] [nvarchar](20) NULL,
	[documento_DataScadenza] [date] NOT NULL,
	[codice_documento] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[documento_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codice_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[passeggero_id] ASC,
	[documento_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Passeggero]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Passeggero](
	[passeggero_id] [int] IDENTITY(1,1) NOT NULL,
	[passeggero_codice]  AS (right('000000'+CONVERT([varchar](6),[passeggero_id]),(6))) PERSISTED,
	[passeggero_nome] [nvarchar](100) NOT NULL,
	[passeggero_cognome] [nvarchar](100) NOT NULL,
	[passeggero_via] [nvarchar](100) NULL,
	[passeggero_CAP] [nvarchar](10) NULL,
	[passeggero_citta] [nvarchar](100) NULL,
	[passeggero_FrequentFlyer] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[passeggero_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[passeggero_codice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prenotazione]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prenotazione](
	[prenotazione_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[prenotazione_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrenotazioniPasseggeri]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrenotazioniPasseggeri](
	[passeggero_id] [int] NOT NULL,
	[prenotazione_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[passeggero_id] ASC,
	[prenotazione_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Regione]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Regione](
	[regione_id] [nvarchar](10) NOT NULL,
	[stato_id] [char](2) NOT NULL,
	[regione_nome] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[regione_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SegmentoPrenotazione]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SegmentoPrenotazione](
	[prenotazione_id] [int] NOT NULL,
	[prenotazione_num] [int] NOT NULL,
	[compagnia_id] [char](2) NOT NULL,
	[volo_num] [nvarchar](10) NOT NULL,
	[data_ora_partenza_prevista] [datetime] NOT NULL,
	[classe_id] [char](1) NOT NULL,
	[prezzo_segmento] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[prenotazione_id] ASC,
	[prenotazione_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stato]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stato](
	[stato_id] [char](2) NOT NULL,
	[stato_nome] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[stato_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VoliAstratti]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoliAstratti](
	[compagnia_id] [char](2) NOT NULL,
	[volo_num] [nvarchar](10) NOT NULL,
	[aeroporto_partenza_id] [char](3) NOT NULL,
	[aeroporto_arrivo_id] [char](3) NOT NULL,
	[aereo_id] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[compagnia_id] ASC,
	[volo_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VoliSpecifici]    Script Date: 13/07/2025 15:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoliSpecifici](
	[compagnia_id] [char](2) NOT NULL,
	[volo_num] [nvarchar](10) NOT NULL,
	[data_ora_partenza_prevista] [datetime] NOT NULL,
	[data_ora_arrivo_prevista] [datetime] NOT NULL,
	[data_ora_partenza_effettiva] [datetime] NULL,
	[data_ora_arrivo_effettiva] [datetime] NULL,
	[volo_status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[compagnia_id] ASC,
	[volo_num] ASC,
	[data_ora_partenza_prevista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Aereo] ADD  DEFAULT ((0)) FOR [posti_ClasseBusiness]
GO
ALTER TABLE [dbo].[Aereo] ADD  DEFAULT ((0)) FOR [posti_ClasseEconomy]
GO
ALTER TABLE [dbo].[Compagnia] ADD  DEFAULT ((0)) FOR [compagnia_StarAlliance]
GO
ALTER TABLE [dbo].[Passeggero] ADD  DEFAULT ((0)) FOR [passeggero_FrequentFlyer]
GO
ALTER TABLE [dbo].[Aeroporti]  WITH NOCHECK ADD FOREIGN KEY([regione_id])
REFERENCES [dbo].[Regione] ([regione_id])
GO
ALTER TABLE [dbo].[DocumentoIdentificativo]  WITH NOCHECK ADD FOREIGN KEY([passeggero_id])
REFERENCES [dbo].[Passeggero] ([passeggero_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PrenotazioniPasseggeri]  WITH NOCHECK ADD FOREIGN KEY([passeggero_id])
REFERENCES [dbo].[Passeggero] ([passeggero_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PrenotazioniPasseggeri]  WITH NOCHECK ADD FOREIGN KEY([prenotazione_id])
REFERENCES [dbo].[Prenotazione] ([prenotazione_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Regione]  WITH NOCHECK ADD FOREIGN KEY([stato_id])
REFERENCES [dbo].[Stato] ([stato_id])
GO
ALTER TABLE [dbo].[SegmentoPrenotazione]  WITH NOCHECK ADD FOREIGN KEY([classe_id])
REFERENCES [dbo].[Classe] ([classe_id])
GO
ALTER TABLE [dbo].[SegmentoPrenotazione]  WITH NOCHECK ADD FOREIGN KEY([prenotazione_id])
REFERENCES [dbo].[Prenotazione] ([prenotazione_id])
GO
ALTER TABLE [dbo].[SegmentoPrenotazione]  WITH NOCHECK ADD FOREIGN KEY([compagnia_id], [volo_num], [data_ora_partenza_prevista])
REFERENCES [dbo].[VoliSpecifici] ([compagnia_id], [volo_num], [data_ora_partenza_prevista])
GO
ALTER TABLE [dbo].[VoliAstratti]  WITH CHECK ADD FOREIGN KEY([aereo_id])
REFERENCES [dbo].[Aereo] ([aereo_id])
GO
ALTER TABLE [dbo].[VoliAstratti]  WITH NOCHECK ADD FOREIGN KEY([aeroporto_partenza_id])
REFERENCES [dbo].[Aeroporti] ([codice_IATA])
GO
ALTER TABLE [dbo].[VoliAstratti]  WITH NOCHECK ADD FOREIGN KEY([aeroporto_arrivo_id])
REFERENCES [dbo].[Aeroporti] ([codice_IATA])
GO
ALTER TABLE [dbo].[VoliAstratti]  WITH NOCHECK ADD FOREIGN KEY([compagnia_id])
REFERENCES [dbo].[Compagnia] ([compagnia_id])
GO
ALTER TABLE [dbo].[VoliSpecifici]  WITH NOCHECK ADD FOREIGN KEY([compagnia_id], [volo_num])
REFERENCES [dbo].[VoliAstratti] ([compagnia_id], [volo_num])
GO
ALTER TABLE [dbo].[Aereo]  WITH NOCHECK ADD CHECK  (([aereo_tipo]='cargo' OR [aereo_tipo]='privato' OR [aereo_tipo]='commerciale'))
GO
ALTER TABLE [dbo].[Aereo]  WITH NOCHECK ADD CHECK  (([posti_ClasseBusiness]>=(0)))
GO
ALTER TABLE [dbo].[Aereo]  WITH NOCHECK ADD CHECK  (([posti_ClasseEconomy]>=(0)))
GO
ALTER TABLE [dbo].[Classe]  WITH CHECK ADD CHECK  (([classe_id]='Y' OR [classe_id]='J'))
GO
ALTER TABLE [dbo].[Classe]  WITH CHECK ADD CHECK  (([classe_nome]='economy' OR [classe_nome]='business'))
GO
ALTER TABLE [dbo].[DocumentoIdentificativo]  WITH NOCHECK ADD CHECK  (([documento_tipo]='PASSAPORTO' OR [documento_tipo]='PATENTE' OR [documento_tipo]='CI'))
GO
ALTER TABLE [dbo].[VoliAstratti]  WITH NOCHECK ADD CHECK  (([aeroporto_partenza_id]<>[aeroporto_arrivo_id]))
GO
USE [master]
GO
ALTER DATABASE [CompagniaAerea] SET  READ_WRITE 
GO
