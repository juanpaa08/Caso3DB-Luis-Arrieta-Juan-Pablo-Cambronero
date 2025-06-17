
GO
/****** Object:  Database [Caso3DB]    Script Date: 6/10/2025 7:47:11 AM ******/
/*CREATE DATABASE [Caso3DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Caso3DB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Caso3DB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Caso3DB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Caso3DB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO 
ALTER DATABASE [Caso3DB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Caso3DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Caso3DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Caso3DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Caso3DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Caso3DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Caso3DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [Caso3DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Caso3DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Caso3DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Caso3DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Caso3DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Caso3DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Caso3DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Caso3DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Caso3DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Caso3DB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Caso3DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Caso3DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Caso3DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Caso3DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Caso3DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Caso3DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Caso3DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Caso3DB] SET RECOVERY FULL 
GO
ALTER DATABASE [Caso3DB] SET  MULTI_USER 
GO
ALTER DATABASE [Caso3DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Caso3DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Caso3DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Caso3DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Caso3DB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Caso3DB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Caso3DB', N'ON'
GO
ALTER DATABASE [Caso3DB] SET QUERY_STORE = ON
GO
ALTER DATABASE [Caso3DB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO

GO

/****** Object:  User [root]    Script Date: 6/10/2025 7:47:11 AM ******/
CREATE USER [root] FOR LOGIN [root] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [root]
GO
/****** Object:  Table [dbo].[pv_accessLog]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
*/
CREATE TABLE [dbo].[pv_accessLog](
	[accessLogID] [int] IDENTITY(1,1) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[authMethod] [nchar](20) NOT NULL,
	[device] [nchar](20) NOT NULL,
	[IPaddress] [varbinary](250) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[errorCode] [nchar](200) NOT NULL,
	[deviceDescription] [nvarchar](max) NOT NULL,
	[sessionID] [nchar](200) NOT NULL,
	[approxLocation] [geography] NOT NULL,
	[loginID] [int] NOT NULL,
 CONSTRAINT [PK_pv_accessLog] PRIMARY KEY CLUSTERED 
(
	[accessLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_accountStatus]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_accountStatus](
	[accountStatusID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](30) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isDefault] [bit] NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_accountStatus] PRIMARY KEY CLUSTERED 
(
	[accountStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_algorithms]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_algorithms](
	[algorithmID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[keyLenght] [int] NOT NULL,
	[mode] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_algorithms] PRIMARY KEY CLUSTERED 
(
	[algorithmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_appInstance]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_appInstance](
	[appInstanceID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NOT NULL,
	[name] [nchar](30) NOT NULL,
	[version] [decimal](10, 2) NOT NULL,
	[deploymentDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[endPoint] [nchar](200) NOT NULL,
	[instanceHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_appInstance] PRIMARY KEY CLUSTERED 
(
	[appInstanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_availableMethods]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_availableMethods](
	[availableMethodID] [int] IDENTITY(1,1) NOT NULL,
	[paymentMethodID] [int] NOT NULL,
	[groupID] [int] NULL,
	[countryCode] [nchar](20) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[availabilityHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_availableMethods] PRIMARY KEY CLUSTERED 
(
	[availableMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_backUpConfig]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_backUpConfig](
	[backUpConfigID] [int] IDENTITY(1,1) NOT NULL,
	[logID] [int] NULL,
	[name] [nchar](30) NOT NULL,
	[frecuency] [nchar](20) NOT NULL,
	[executionTime] [time](7) NOT NULL,
	[storageLocation] [geography] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[retentionDays] [int] NOT NULL,
	[configurationHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_backUpConfig] PRIMARY KEY CLUSTERED 
(
	[backUpConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_backUpLog]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_backUpLog](
	[backUpLogID] [int] IDENTITY(1,1) NOT NULL,
	[backUpConfigID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[size] [int] NOT NULL,
	[fileLocation] [varbinary](250) NOT NULL,
	[backUpHash] [varbinary](250) NOT NULL,
	[errorDetails] [nchar](300) NULL,
 CONSTRAINT [PK_pv_backUpLog] PRIMARY KEY CLUSTERED 
(
	[backUpLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_balances]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_balances](
	[balanceID] [int] IDENTITY(1,1) NOT NULL,
	[balanceTypeID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[projectID] [int] NOT NULL,
	[currentBalance] [decimal](18, 2) NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_balances] PRIMARY KEY CLUSTERED 
(
	[balanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_balanceTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_balanceTypes](
	[balanceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](100) NULL,
 CONSTRAINT [PK_pv_balanceTypes] PRIMARY KEY CLUSTERED 
(
	[balanceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_biometricData]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_biometricData](
	[biometricDataID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[biometricType] [nchar](20) NOT NULL,
	[captureDevice] [nchar](30) NOT NULL,
	[captureDate] [datetime] NOT NULL,
	[sampleQuality] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[modelVersion] [nchar](20) NOT NULL,
	[integrityHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_biometricData] PRIMARY KEY CLUSTERED 
(
	[biometricDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_conditionTerms]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_conditionTerms](
	[conditionTermID] [int] IDENTITY(1,1) NOT NULL,
	[version] [decimal](10, 2) NOT NULL,
	[content] [text] NOT NULL,
	[publicationDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[acceptanceDate] [datetime] NULL,
	[termHash] [varbinary](250) NOT NULL,
	[userGuideID] [int] NOT NULL,
 CONSTRAINT [PK_pv_conditionTerms] PRIMARY KEY CLUSTERED 
(
	[conditionTermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_contactInfoType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_contactInfoType](
	[contactInfoTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
 CONSTRAINT [PK_pv_contactInfoType] PRIMARY KEY CLUSTERED 
(
	[contactInfoTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_contractTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_contractTypes](
	[contractTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_contractTypes] PRIMARY KEY CLUSTERED 
(
	[contractTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_contributionStatuses]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_contributionStatuses](
	[contributionStatusID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_contributionStatuses] PRIMARY KEY CLUSTERED 
(
	[contributionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_criteriaTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_criteriaTypes](
	[criteriaTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_criteriaTypes] PRIMARY KEY CLUSTERED 
(
	[criteriaTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_crowdfundingContributions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_crowdfundingContributions](
	[crowdfundinCotributionID] [int] IDENTITY(1,1) NOT NULL,
	[projectID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[contributionDate] [datetime] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[currencyCode] [nchar](3) NOT NULL,
	[isMatchedByGob] [bit] NULL,
	[matchedAmount] [decimal](18, 2) NOT NULL,
	[contributionStatusID] [int] NOT NULL,
	[description] [nchar](500) NULL,
	[paymentMethodID] [int] NOT NULL,
	[prevHash] [varbinary](512) NOT NULL,
	[cryptographicKeyID] [int] NOT NULL,
 CONSTRAINT [PK_pv_crowdfundingContributions] PRIMARY KEY CLUSTERED 
(
	[crowdfundinCotributionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_cryptographicKeys]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_cryptographicKeys](
	[cryptographicKeyID] [int] IDENTITY(1,1) NOT NULL,
	[keyType] [int] NOT NULL,
	[algorithm] [int] NOT NULL,
	[keyValue] [varbinary](250) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[mainUse] [int] NOT NULL,
	[hashKey] [varbinary](250) NOT NULL,
	[enclaveID] [int] NOT NULL,
	[digitalSignatureID] [int] NOT NULL,
	[userID] [int] NULL,
	[institutionID] [nchar](10) NULL,
 CONSTRAINT [PK_pv_cryptographicKey] PRIMARY KEY CLUSTERED 
(
	[cryptographicKeyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_currencies]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_currencies](
	[currencyID] [int] NOT NULL,
	[name] [nchar](20) NULL,
	[acronym] [nchar](10) NULL,
	[symbol] [nchar](5) NULL,
	[country] [nchar](50) NULL,
 CONSTRAINT [PK_pv_currencies] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_dataTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_dataTypes](
	[dataTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_dataTypes] PRIMARY KEY CLUSTERED 
(
	[dataTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_departments]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_departments](
	[departmentID] [int] IDENTITY(1,1) NOT NULL,
	[institutionID] [int] NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_departments] PRIMARY KEY CLUSTERED 
(
	[departmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_digitalCertificates]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_digitalCertificates](
	[digitalCertificateID] [int] IDENTITY(1,1) NOT NULL,
	[certificateValue] [varbinary](250) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[emissor] [nchar](250) NOT NULL,
	[certificateHash] [varbinary](250) NOT NULL,
	[criptographicKey] [int] NOT NULL,
 CONSTRAINT [PK_pv_digitalCertificate] PRIMARY KEY CLUSTERED 
(
	[digitalCertificateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_digitalSignature]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_digitalSignature](
	[digitalSignatureID] [int] IDENTITY(1,1) NOT NULL,
	[cryptographicKeyID] [int] NOT NULL,
	[signatureValue] [binary](200) NOT NULL,
	[signatureDate] [datetime] NOT NULL,
	[transactionType] [nchar](20) NOT NULL,
	[transactionHash] [varbinary](250) NOT NULL,
	[status] [nchar](20) NULL,
 CONSTRAINT [PK_pv_digitalSignature] PRIMARY KEY CLUSTERED 
(
	[digitalSignatureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_documentMediaFiles]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_documentMediaFiles](
	[documentMediaFileID] [int] IDENTITY(1,1) NOT NULL,
	[proposalDocumentID] [int] NOT NULL,
	[mediaFileID] [int] NOT NULL,
	[workflowStepOrder] [nchar](200) NOT NULL,
 CONSTRAINT [PK_pv_documentMediaFiles] PRIMARY KEY CLUSTERED 
(
	[documentMediaFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_documentType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_documentType](
	[documentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_documentType] PRIMARY KEY CLUSTERED 
(
	[documentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_documentTypeWorkflowDefs]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_documentTypeWorkflowDefs](
	[documentTypeWorkflowDefID] [int] IDENTITY(1,1) NOT NULL,
	[workflowDefinitionID] [int] NOT NULL,
	[documentTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_documentTypeWorkflowDefs] PRIMARY KEY CLUSTERED 
(
	[documentTypeWorkflowDefID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_documentValidations]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_documentValidations](
	[documentValidationID] [int] NOT NULL,
	[stepName] [nchar](100) NOT NULL,
	[stepOrder] [tinyint] NOT NULL,
	[validationStatusID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[completedAt] [datetime] NOT NULL,
	[attempts] [int] NOT NULL,
	[errorTypeID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[proposalDocumentID] [int] NOT NULL,
 CONSTRAINT [PK_pv_documentValidations] PRIMARY KEY CLUSTERED 
(
	[documentValidationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_elegibilityCriteria]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_elegibilityCriteria](
	[elegibilityCriteriaID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[criteriaTypeID] [int] NOT NULL,
	[value] [varchar](max) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_elegibilityCriteria] PRIMARY KEY CLUSTERED 
(
	[elegibilityCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_errorTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_errorTypes](
	[errorTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_errorTypes] PRIMARY KEY CLUSTERED 
(
	[errorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_eventType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_eventType](
	[eventTypesID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_eventType] PRIMARY KEY CLUSTERED 
(
	[eventTypesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_exchangeRates]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_exchangeRates](
	[exchangeRateID] [int] IDENTITY(1,1) NOT NULL,
	[currencyIDSource] [int] NOT NULL,
	[currencyIDDestiny] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[exchangeRate] [float] NOT NULL,
	[currentExchcangeRate] [bit] NOT NULL,
	[currencyID] [int] NOT NULL,
 CONSTRAINT [PK_pv_exchangeRates] PRIMARY KEY CLUSTERED 
(
	[exchangeRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_frequentQA]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_frequentQA](
	[frequentQAID] [int] IDENTITY(1,1) NOT NULL,
	[question] [nchar](100) NOT NULL,
	[answer] [text] NOT NULL,
	[category] [nchar](20) NOT NULL,
	[systemLanguageID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[order] [int] NOT NULL,
 CONSTRAINT [PK_pv_frequentQA] PRIMARY KEY CLUSTERED 
(
	[frequentQAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_groupFeatures]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_groupFeatures](
	[groupFeatureID] [int] IDENTITY(1,1) NOT NULL,
	[groupID] [int] NOT NULL,
	[groupFeatureTypeID] [int] NOT NULL,
	[value] [nchar](500) NOT NULL,
 CONSTRAINT [PK_pv_groupFeatures] PRIMARY KEY CLUSTERED 
(
	[groupFeatureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_groupFeatureTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_groupFeatureTypes](
	[groupFeatureTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[dataTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_groupFeatureTypes] PRIMARY KEY CLUSTERED 
(
	[groupFeatureTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_groups]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_groups](
	[groupID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[groupTypeID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_pv_groups] PRIMARY KEY CLUSTERED 
(
	[groupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_groupTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_groupTypes](
	[groupTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_pv_groupTypes] PRIMARY KEY CLUSTERED 
(
	[groupTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_groupUser]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_groupUser](
	[groupUserID] [int] IDENTITY(1,1) NOT NULL,
	[groupID] [int] NOT NULL,
	[joinDate] [datetime] NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_groupUser] PRIMARY KEY CLUSTERED 
(
	[groupUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_herarchyLevels]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_herarchyLevels](
	[herarchyLevelID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[levelOrder] [int] NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_herarchyLevels] PRIMARY KEY CLUSTERED 
(
	[herarchyLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_institutionMembers]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_institutionMembers](
	[institutionMemberID] [int] IDENTITY(1,1) NOT NULL,
	[institutionID] [int] NOT NULL,
	[institutionRoleID] [int] NOT NULL,
	[startDate] [datetime] NULL,
	[endDate] [datetime] NOT NULL,
	[contractTypeID] [int] NOT NULL,
	[departmentID] [int] NOT NULL,
	[herarchyLevelID] [int] NOT NULL,
	[verificationDoc] [varbinary](250) NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_institutionMembers] PRIMARY KEY CLUSTERED 
(
	[institutionMemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_institutionRoles]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_institutionRoles](
	[institutionRoleID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_institutionRoles] PRIMARY KEY CLUSTERED 
(
	[institutionRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_institutions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_institutions](
	[institutionID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[insType] [nchar](50) NOT NULL,
	[legalID] [varbinary](250) NOT NULL,
	[registrationDate] [datetime] NOT NULL,
	[institutionStatusID] [int] NOT NULL,
	[sectorID] [int] NOT NULL,
	[size] [nchar](20) NOT NULL,
	[legalLocation] [geography] NOT NULL,
	[symKeyEncryptedWithMaster] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_pv_institution] PRIMARY KEY CLUSTERED 
(
	[institutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_institutionStatus]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_institutionStatus](
	[institutionStatusID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isDefault] [bit] NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_institutionStatus] PRIMARY KEY CLUSTERED 
(
	[institutionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_institutionUserKeys]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_institutionUserKeys](
	[institutionUserKey] [int] IDENTITY(1,1) NOT NULL,
	[institutionID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[encryptedInstKeyForUser] [varbinary](max) NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_institutionUserKeys] PRIMARY KEY CLUSTERED 
(
	[institutionUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_integrityLog]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_integrityLog](
	[integrityLogID] [int] IDENTITY(1,1) NOT NULL,
	[affectedTable] [nchar](50) NOT NULL,
	[valueHash] [varbinary](250) NOT NULL,
	[verificationDate] [datetime] NOT NULL,
	[result] [nchar](20) NOT NULL,
	[details] [nchar](250) NOT NULL,
	[digitalSignatureID] [int] NULL,
	[logHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_integrityLog] PRIMARY KEY CLUSTERED 
(
	[integrityLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_keyTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_keyTypes](
	[keyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_keyTypes] PRIMARY KEY CLUSTERED 
(
	[keyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_kpiUnitTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_kpiUnitTypes](
	[kpiUnitID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[unitValue] [decimal](18, 8) NOT NULL,
 CONSTRAINT [PK_pv_kpiUnitTypes] PRIMARY KEY CLUSTERED 
(
	[kpiUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_labelRelationships]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_labelRelationships](
	[labelRelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[proposalLabelID] [int] NOT NULL,
	[assosiationDate] [datetime] NOT NULL,
	[weight] [decimal](10, 2) NOT NULL,
	[status] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_labelRelationships] PRIMARY KEY CLUSTERED 
(
	[labelRelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_loginAttempts]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_loginAttempts](
	[loginAttemptID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[attempDate] [datetime] NOT NULL,
	[IPadress] [varbinary](250) NOT NULL,
	[device] [int] NOT NULL,
	[attemptType] [nchar](20) NOT NULL,
	[result] [nchar](20) NOT NULL,
	[errorDetails] [nchar](200) NULL,
	[attemptHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_loginAttempts] PRIMARY KEY CLUSTERED 
(
	[loginAttemptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_loginAuditory]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_loginAuditory](
	[loginAuditory] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[eventType] [nchar](20) NOT NULL,
	[datetime] [datetime] NOT NULL,
	[IPaddress] [varbinary](250) NOT NULL,
	[device] [int] NOT NULL,
	[description] [nchar](200) NULL,
	[riskDanger] [nchar](20) NOT NULL,
	[takenAction] [nchar](50) NOT NULL,
	[recordHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_loginAuditory] PRIMARY KEY CLUSTERED 
(
	[loginAuditory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_logins]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_logins](
	[loginID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[logToken] [varbinary](512) NOT NULL,
	[starDate] [datetime] NOT NULL,
	[lastActivityDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[IPadress] [varbinary](512) NOT NULL,
	[userDescription] [nchar](200) NULL,
	[syncedDeviceID] [int] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[loginData] [nvarchar](200) NOT NULL,
	[refreshToken] [varbinary](512) NOT NULL,
 CONSTRAINT [PK_pv_logins] PRIMARY KEY CLUSTERED 
(
	[loginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_logs]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_logs](
	[logID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NOT NULL,
	[description] [nchar](200) NOT NULL,
	[postTime] [datetime] NOT NULL,
	[computer] [nchar](30) NOT NULL,
	[userName] [nchar](50) NOT NULL,
	[trace] [nchar](120) NULL,
	[referenceID1] [bigint] NOT NULL,
	[referenceID2] [bigint] NOT NULL,
	[value1] [nchar](50) NOT NULL,
	[value2] [nchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[logTypeID] [int] NOT NULL,
	[logSourceID] [int] NOT NULL,
	[logSeverityID] [int] NOT NULL,
 CONSTRAINT [PK_pv_logs] PRIMARY KEY CLUSTERED 
(
	[logID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_logSeverities]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_logSeverities](
	[logSeverityID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NULL,
 CONSTRAINT [PK_pv_logSeverities] PRIMARY KEY CLUSTERED 
(
	[logSeverityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_logSources]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_logSources](
	[logSourceID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_pv_logSources] PRIMARY KEY CLUSTERED 
(
	[logSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_logType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_logType](
	[logTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[reference1] [bigint] NOT NULL,
	[reference2] [bigint] NOT NULL,
	[value1] [nchar](50) NOT NULL,
	[value2] [nchar](50) NOT NULL,
 CONSTRAINT [PK_pv_logType] PRIMARY KEY CLUSTERED 
(
	[logTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_mainUses]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_mainUses](
	[mainUseID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](50) NOT NULL,
	[name] [nchar](100) NOT NULL,
	[description] [nchar](300) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_mainUses] PRIMARY KEY CLUSTERED 
(
	[mainUseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_mediaFiles]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_mediaFiles](
	[mediaFileID] [int] IDENTITY(1,1) NOT NULL,
	[deleted] [bit] NOT NULL,
	[mediaTypeID] [int] NOT NULL,
	[fileURL] [nchar](200) NOT NULL,
	[fileName] [nchar](50) NOT NULL,
	[lastUpdated] [datetime] NOT NULL,
	[fileSize] [int] NULL,
	[status] [nchar](1000) NOT NULL,
 CONSTRAINT [PK_pv_mediaFiles] PRIMARY KEY CLUSTERED 
(
	[mediaFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_mediaTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_mediaTypes](
	[mediaTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[mediaExtension] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_pv_mediaTypes] PRIMARY KEY CLUSTERED 
(
	[mediaTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_milestoneVotes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_milestoneVotes](
	[milestonesVoteID] [int] IDENTITY(1,1) NOT NULL,
	[projectMilestoneID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[votingCoreID] [int] NOT NULL,
 CONSTRAINT [PK_pv_milestoneVotes] PRIMARY KEY CLUSTERED 
(
	[milestonesVoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_notificationTemplate]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_notificationTemplate](
	[notificationTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[content] [text] NOT NULL,
	[notificationType] [nchar](20) NOT NULL,
	[systemLanguageID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[allowedVariables] [varchar](max) NOT NULL,
	[templateHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_notificationTemplate] PRIMARY KEY CLUSTERED 
(
	[notificationTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_passwordHash]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_passwordHash](
	[passwordHashID] [int] IDENTITY(1,1) NOT NULL,
	[passwordHash] [varbinary](512) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[expiresAt] [datetime] NOT NULL,
	[mustChange] [bit] NOT NULL,
	[isCompromised] [bit] NOT NULL,
	[lastVerifiedAt] [datetime] NOT NULL,
	[updatedAt] [nchar](10) NOT NULL,
 CONSTRAINT [PK_pv_passwordHash] PRIMARY KEY CLUSTERED 
(
	[passwordHashID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_passwordHistory]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_passwordHistory](
	[passwordHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[userCredentialID] [int] NOT NULL,
	[passwordHashID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[reason] [nchar](100) NOT NULL,
 CONSTRAINT [PK_pv_passwordHistory] PRIMARY KEY CLUSTERED 
(
	[passwordHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_paymentMethods]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_paymentMethods](
	[paymentMethodID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[secretKey] [nchar](20) NOT NULL,
	[key] [varbinary](250) NOT NULL,
	[apiURL] [nchar](20) NOT NULL,
	[logoURL] [datetime] NOT NULL,
	[configJSON] [varbinary](250) NULL,
	[lastUpdated] [datetime] NULL,
	[enabled] [bit] NULL,
 CONSTRAINT [PK_pv_paymentMethods] PRIMARY KEY CLUSTERED 
(
	[paymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_payments]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_payments](
	[paymentID] [int] IDENTITY(1,1) NOT NULL,
	[paymentMethodID] [int] NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[actualAmount] [decimal](18, 2) NOT NULL,
	[result] [nchar](60) NOT NULL,
	[authetication] [nchar](200) NOT NULL,
	[reference] [nchar](60) NOT NULL,
	[chargedToken] [varbinary](512) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[error] [nchar](200) NOT NULL,
	[paymentDate] [datetime] NOT NULL,
	[checksum] [varbinary](512) NOT NULL,
	[currencyID] [int] NOT NULL,
 CONSTRAINT [PK_pv_payments] PRIMARY KEY CLUSTERED 
(
	[paymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_pendingRequests]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_pendingRequests](
	[pendingRequestID] [int] IDENTITY(1,1) NOT NULL,
	[institutionID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[requestNumber] [nchar](50) NOT NULL,
	[encryptedPayLoad] [varbinary](max) NOT NULL,
	[digitalSignatureID] [int] NOT NULL,
	[requestStatusID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_pendingRequests] PRIMARY KEY CLUSTERED 
(
	[pendingRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_permissionRole]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_permissionRole](
	[permissionRole] [int] IDENTITY(1,1) NOT NULL,
	[roleID] [int] NOT NULL,
	[permissionID] [int] NOT NULL,
	[assignmentDate] [datetime] NOT NULL,
	[accessType] [nchar](20) NOT NULL,
	[restriction] [varchar](max) NOT NULL,
	[status] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_permissionRole] PRIMARY KEY CLUSTERED 
(
	[permissionRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_permissions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_permissions](
	[permissionID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](200) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[category] [nchar](20) NOT NULL,
	[criticLevel] [nchar](20) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[version] [nchar](40) NOT NULL,
	[dependencies] [varchar](max) NOT NULL,
 CONSTRAINT [PK_pv_permissions] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_profileHistory]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_profileHistory](
	[profileHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[changeDate] [datetime] NOT NULL,
	[changeType] [nchar](20) NOT NULL,
	[previousValue] [varbinary](250) NOT NULL,
	[newValue] [varbinary](250) NOT NULL,
	[originIP] [varbinary](250) NOT NULL,
	[destinyIP] [varbinary](250) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[userProfileID] [int] NOT NULL,
 CONSTRAINT [PK_pv_profileHistory] PRIMARY KEY CLUSTERED 
(
	[profileHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_projectMilestones]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_projectMilestones](
	[projectMilestoneID] [int] IDENTITY(1,1) NOT NULL,
	[projectID] [int] NOT NULL,
	[title] [nchar](200) NOT NULL,
	[description] [nchar](500) NULL,
	[assignedBudget] [decimal](18, 2) NOT NULL,
	[currencyCode] [nchar](3) NOT NULL,
	[startDate] [datetime] NULL,
	[dueDate] [datetime] NULL,
	[actualCloseDate] [datetime] NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[expectedDuration] [decimal](10, 2) NOT NULL,
	[checksum] [varbinary](512) NOT NULL,
	[projectStatusID] [int] NOT NULL,
 CONSTRAINT [PK_pv_projectMilestones] PRIMARY KEY CLUSTERED 
(
	[projectMilestoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_projects]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_projects](
	[projectID] [int] IDENTITY(1,1) NOT NULL,
	[title] [nchar](200) NOT NULL,
	[summary] [nchar](500) NOT NULL,
	[fullDescription] [text] NULL,
	[userID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[projectStatusID] [int] NOT NULL,
	[requestedAmount] [decimal](18, 2) NOT NULL,
	[currencyID] [int] NOT NULL,
	[expectedStartDate] [datetime] NULL,
	[endDate] [datetime] NULL,
	[configuration] [varbinary](512) NULL,
	[expectedDuration] [decimal](10, 2) NOT NULL,
	[checksum] [varbinary](500) NULL,
 CONSTRAINT [PK_pv_projects] PRIMARY KEY CLUSTERED 
(
	[projectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_projectStatuses]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_projectStatuses](
	[projectStatusID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_projectStatuses] PRIMARY KEY CLUSTERED 
(
	[projectStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_projectTask]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_projectTask](
	[projectTaskID] [int] IDENTITY(1,1) NOT NULL,
	[projectMilestoneID] [int] NOT NULL,
	[title] [nchar](200) NOT NULL,
	[description] [nchar](500) NULL,
	[userID] [int] NOT NULL,
	[expectedDuration] [decimal](10, 2) NOT NULL,
	[startDate] [datetime] NULL,
	[dueDate] [datetime] NULL,
	[actualEndDate] [datetime] NULL,
	[projectStatusID] [int] NOT NULL,
	[budgetAllocated] [decimal](18, 2) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[kpiDescription] [nchar](500) NOT NULL,
	[kpiTargetValue] [decimal](18, 4) NOT NULL,
	[kpiUnitID] [int] NOT NULL,
	[kpiURL] [nchar](500) NULL,
	[checksum] [varbinary](500) NOT NULL,
 CONSTRAINT [PK_pv_projectTask] PRIMARY KEY CLUSTERED 
(
	[projectTaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalCollaborators]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalCollaborators](
	[proposalColaboratorID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[role] [nchar](30) NULL,
 CONSTRAINT [PK_pv_proposalCollaborators] PRIMARY KEY CLUSTERED 
(
	[proposalColaboratorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalComment]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalComment](
	[proposalCommentID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[content] [text] NOT NULL,
	[publishDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[likes] [int] NOT NULL,
	[reports] [int] NOT NULL,
	[proposalVersion] [int] NOT NULL,
 CONSTRAINT [PK_pv_proposalComment] PRIMARY KEY CLUSTERED 
(
	[proposalCommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalContent]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalContent](
	[proposalConttentID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[proposalContentType] [nchar](20) NOT NULL,
	[fileURL] [nchar](300) NOT NULL,
	[fileType] [nchar](20) NOT NULL,
	[lastUpdate] [datetime] NULL,
	[comment] [text] NOT NULL,
	[reviewDate] [datetime] NOT NULL,
	[categoryName] [nchar](30) NOT NULL,
	[tagName] [nchar](30) NOT NULL,
	[description] [nchar](300) NOT NULL,
	[expirationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_proposalContent] PRIMARY KEY CLUSTERED 
(
	[proposalConttentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalCore]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalCore](
	[proposalCoreID] [int] IDENTITY(1,1) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[benefits] [nchar](350) NOT NULL,
	[estimatedBudget] [decimal](16, 2) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[lastUpdate] [datetime] NULL,
	[createdAt] [datetime] NOT NULL,
	[proposalID] [int] NOT NULL,
 CONSTRAINT [PK_pv_proposalCore] PRIMARY KEY CLUSTERED 
(
	[proposalCoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalDocument]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalDocument](
	[proposalDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[proposalVersionID] [int] NOT NULL,
	[fileName] [nchar](50) NOT NULL,
	[fileHash] [varbinary](250) NOT NULL,
	[size] [int] NOT NULL,
	[format] [nchar](10) NOT NULL,
	[uploadDate] [datetime] NOT NULL,
	[validationStatusID] [int] NOT NULL,
	[storageLocation] [varbinary](250) NOT NULL,
	[userID] [int] NOT NULL,
	[institutionID] [int] NULL,
	[mediaTypeID] [int] NOT NULL,
	[documentTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_proposalDocument_1] PRIMARY KEY CLUSTERED 
(
	[proposalDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalImpactGroups]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalImpactGroups](
	[proposalImpactGroupID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[groupID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK_pv_proposalImpactGroups] PRIMARY KEY CLUSTERED 
(
	[proposalImpactGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalImpactTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalImpactTypes](
	[proposalImpactTypeID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedtAt] [datetime] NULL,
 CONSTRAINT [PK_pv_proposalImpactTypes] PRIMARY KEY CLUSTERED 
(
	[proposalImpactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalLabel]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalLabel](
	[proposalLabelID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](20) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[category] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[userID] [int] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[popularity] [int] NOT NULL,
	[icon] [nchar](250) NOT NULL,
	[color] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_proposalLabel] PRIMARY KEY CLUSTERED 
(
	[proposalLabelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalReviews]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalReviews](
	[proposalReviewID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[internalComments] [text] NOT NULL,
	[decision] [nchar](20) NOT NULL,
	[score] [int] NOT NULL,
	[reviewFields] [varchar](max) NOT NULL,
 CONSTRAINT [PK_pv_proposalReviews] PRIMARY KEY CLUSTERED 
(
	[proposalReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalSponsor]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalSponsor](
	[proposalSponsor] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[sponsorType] [nchar](20) NOT NULL,
	[joinDate] [datetime] NOT NULL,
	[publcComment] [text] NOT NULL,
	[commitmentLevel] [int] NOT NULL,
	[isPrimary] [bit] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[visibility] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_proposalSponsor] PRIMARY KEY CLUSTERED 
(
	[proposalSponsor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalTargetGroups]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalTargetGroups](
	[proposalTargetGroupID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[groupID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK_pv_proposalTargetGroups] PRIMARY KEY CLUSTERED 
(
	[proposalTargetGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalType](
	[propposalTypeID] [int] NOT NULL,
	[name] [nchar](30) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[applicationLevel] [nchar](20) NOT NULL,
	[category] [nchar](20) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[minimumRequirements] [varchar](max) NOT NULL,
	[contentTemplate] [varchar](max) NOT NULL,
	[version] [nchar](20) NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_proposalType] PRIMARY KEY CLUSTERED 
(
	[propposalTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalValidation]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalValidation](
	[proposalValidation] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[proposalRequirementID] [int] NOT NULL,
	[result] [bit] NOT NULL,
	[message] [nchar](200) NOT NULL,
	[validationDate] [datetime] NOT NULL,
	[automaticSystem] [bit] NOT NULL,
	[technicalDetails] [varchar](max) NOT NULL,
 CONSTRAINT [PK_pv_proposalValidation] PRIMARY KEY CLUSTERED 
(
	[proposalValidation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_proposalVersion]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_proposalVersion](
	[proposalVersionID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[versionNumber] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[madeChanges] [text] NOT NULL,
	[versionStatus] [nchar](20) NOT NULL,
	[contentHash] [nchar](300) NOT NULL,
	[revisionComments] [text] NOT NULL,
 CONSTRAINT [PK_pv_proposalVersion] PRIMARY KEY CLUSTERED 
(
	[proposalVersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_propposals]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_propposals](
	[proposalID] [int] IDENTITY(1,1) NOT NULL,
	[proposalTypeID] [int] NOT NULL,
	[name] [nchar](150) NOT NULL,
	[userID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[integrityHash] [varbinary](512) NOT NULL,
	[description] [nchar](500) NULL,
 CONSTRAINT [PK_pv_proposals] PRIMARY KEY CLUSTERED 
(
	[proposalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_publicVotes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_publicVotes](
	[publicVoteID] [int] IDENTITY(1,1) NOT NULL,
	[tokenValue] [nchar](100) NOT NULL,
	[votingID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[userID] [int] NOT NULL,
	[voteID] [int] NOT NULL,
 CONSTRAINT [PK_pv_publicVotes] PRIMARY KEY CLUSTERED 
(
	[publicVoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_questionTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_questionTypes](
	[questionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_questionTypes] PRIMARY KEY CLUSTERED 
(
	[questionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_recoveryRequests]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_recoveryRequests](
	[recoveryRequestID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[method] [nchar](20) NOT NULL,
	[token] [varbinary](250) NOT NULL,
	[requestDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[newCredential] [varbinary](250) NULL,
	[syncedDeviceID] [int] NOT NULL,
	[IPaddress] [varbinary](250) NOT NULL,
	[failedAttempst] [int] NOT NULL,
 CONSTRAINT [PK_pv_recoveryRequests] PRIMARY KEY CLUSTERED 
(
	[recoveryRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_requestStatus]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_requestStatus](
	[requestStatusID] [int] NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_requestStatus] PRIMARY KEY CLUSTERED 
(
	[requestStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_resultDetails]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_resultDetails](
	[resultDetailID] [int] IDENTITY(1,1) NOT NULL,
	[votingResultID] [int] NOT NULL,
	[groupID] [int] NULL,
	[institutionID] [int] NULL,
	[totalVotes] [int] NOT NULL,
	[votesFor] [int] NOT NULL,
	[votesAgainst] [int] NOT NULL,
	[abstentionVotes] [int] NOT NULL,
	[generatioDate] [datetime] NOT NULL,
	[detailHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_resultDetails] PRIMARY KEY CLUSTERED 
(
	[resultDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_sectors]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_sectors](
	[sectorID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_sectors] PRIMARY KEY CLUSTERED 
(
	[sectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_secureEnclave]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_secureEnclave](
	[secureEnclaveID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[location] [geography] NOT NULL,
	[enclaveType] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](10) NOT NULL,
	[enclaveHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_secureEnclave] PRIMARY KEY CLUSTERED 
(
	[secureEnclaveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_secureTransaction]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_secureTransaction](
	[secureTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[transactionType] [nchar](20) NOT NULL,
	[transactionDate] [datetime] NOT NULL,
	[transactionHash] [varbinary](250) NOT NULL,
	[digitalSignatureID] [int] NOT NULL,
	[status] [nchar](20) NULL,
	[details] [varchar](max) NOT NULL,
 CONSTRAINT [PK_pv_secureTransaction] PRIMARY KEY CLUSTERED 
(
	[secureTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_securityAlert]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_securityAlert](
	[securityAlertID] [int] IDENTITY(1,1) NOT NULL,
	[generationDate] [datetime] NOT NULL,
	[alertType] [nchar](20) NOT NULL,
	[severity] [nchar](20) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[details] [varchar](max) NOT NULL,
	[attemptsID] [int] NOT NULL,
	[alertHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_securityAlert] PRIMARY KEY CLUSTERED 
(
	[securityAlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_securityPatch]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_securityPatch](
	[securityPatchID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NULL,
	[appInstanceID] [int] NULL,
	[name] [nchar](30) NOT NULL,
	[version] [decimal](10, 2) NOT NULL,
	[appDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[patchHash] [varbinary](250) NOT NULL,
	[vulnerability] [nchar](50) NOT NULL,
 CONSTRAINT [PK_pv_securityPatch] PRIMARY KEY CLUSTERED 
(
	[securityPatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_securityPolicy]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_securityPolicy](
	[securityPolicyID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](20) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[policyType] [nchar](20) NOT NULL,
	[configuration] [varchar](max) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[expirationDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[userID] [int] NULL,
	[policyHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_securityPolicy] PRIMARY KEY CLUSTERED 
(
	[securityPolicyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_securityToken]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_securityToken](
	[securityTokenID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[tokenType] [nchar](20) NOT NULL,
	[tokenValue] [varbinary](250) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[targetDevice] [nchar](50) NOT NULL,
	[purpose] [nchar](20) NOT NULL,
	[remainingAttempts] [int] NOT NULL,
 CONSTRAINT [PK_pv_securityToken] PRIMARY KEY CLUSTERED 
(
	[securityTokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_server]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_server](
	[serverID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[IPaddress] [varbinary](250) NOT NULL,
	[location] [geography] NOT NULL,
	[serverType] [nchar](10) NOT NULL,
	[registrationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[serverHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_server] PRIMARY KEY CLUSTERED 
(
	[serverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_SSLcertificate]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_SSLcertificate](
	[SSLcertificateID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NULL,
	[domain] [nchar](50) NOT NULL,
	[certificateValue] [varbinary](250) NOT NULL,
	[issueDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NULL,
	[emissor] [nchar](50) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[certificateHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_SSLcertificate] PRIMARY KEY CLUSTERED 
(
	[SSLcertificateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_supportMessage]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_supportMessage](
	[supportMessageID] [int] IDENTITY(1,1) NOT NULL,
	[supportTicketID] [int] NOT NULL,
	[content] [varbinary](250) NOT NULL,
	[deliveredDate] [datetime] NOT NULL,
	[isIntern] [bit] NOT NULL,
	[propposalDocumentID] [int] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[messageHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_supportMessage] PRIMARY KEY CLUSTERED 
(
	[supportMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_supportTicket]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_supportTicket](
	[supportTicketID] [int] IDENTITY(1,1) NOT NULL,
	[subject] [nchar](250) NOT NULL,
	[description] [text] NOT NULL,
	[category] [nchar](20) NOT NULL,
	[priority] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[closingDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[ticketHash] [varbinary](250) NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_supportTicket] PRIMARY KEY CLUSTERED 
(
	[supportTicketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_syncedDevices]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_syncedDevices](
	[syncedDeviceID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[deviceType] [nchar](30) NOT NULL,
	[model] [nchar](30) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[lastUsed] [datetime] NOT NULL,
	[trustLevel] [int] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[deviceCertificate] [varbinary](250) NOT NULL,
	[OS] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_syncedDevices] PRIMARY KEY CLUSTERED 
(
	[syncedDeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemAuditory]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemAuditory](
	[systemAuditoryID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NULL,
	[eventTypeID] [int] NOT NULL,
	[date] [datetime] NOT NULL,
	[module] [nchar](200) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[detail] [varchar](max) NOT NULL,
	[criticyLevel] [nchar](20) NOT NULL,
	[logHash] [varbinary](512) NOT NULL,
	[cryptographicKey] [int] NOT NULL,
 CONSTRAINT [PK_pv_systemAuditory] PRIMARY KEY CLUSTERED 
(
	[systemAuditoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemIncident]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemIncident](
	[systemIncidentID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NULL,
	[applicationInstanceID] [int] NULL,
	[reportDate] [datetime] NOT NULL,
	[incidentType] [nchar](20) NOT NULL,
	[severity] [nchar](20) NOT NULL,
	[description] [nchar](250) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[resolutionDate] [datetime] NULL,
	[incidentHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_systemIncident] PRIMARY KEY CLUSTERED 
(
	[systemIncidentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemLanguage]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemLanguage](
	[systemLanguageID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[isDefault] [bit] NOT NULL,
	[priority] [int] NOT NULL,
 CONSTRAINT [PK_pv_systemLanguage] PRIMARY KEY CLUSTERED 
(
	[systemLanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemLocks]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemLocks](
	[systemLockID] [int] IDENTITY(1,1) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[systemLockLevel] [nchar](20) NOT NULL,
	[source] [nchar](20) NOT NULL,
	[message] [nchar](250) NOT NULL,
	[userID] [int] NULL,
	[IPaddress] [varbinary](512) NOT NULL,
	[logHash] [varbinary](512) NOT NULL,
 CONSTRAINT [PK_pv_sytemLocks] PRIMARY KEY CLUSTERED 
(
	[systemLockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemMonitor]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemMonitor](
	[systemMonitorID] [int] IDENTITY(1,1) NOT NULL,
	[serverID] [int] NOT NULL,
	[applicationInstanceID] [int] NOT NULL,
	[logDate] [datetime] NOT NULL,
	[metricType] [nchar](20) NOT NULL,
	[value] [decimal](10, 2) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[details] [nchar](200) NOT NULL,
 CONSTRAINT [PK_pv_systemMonitor] PRIMARY KEY CLUSTERED 
(
	[systemMonitorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemParameter]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemParameter](
	[systemParameterID] [int] IDENTITY(1,1) NOT NULL,
	[value] [nchar](200) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[category] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[userID] [int] NULL,
	[status] [nchar](20) NULL,
	[isEncrypted] [bit] NOT NULL,
	[key] [nchar](200) NOT NULL,
 CONSTRAINT [PK_pv_systemParameter] PRIMARY KEY CLUSTERED 
(
	[systemParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_systemRoles]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_systemRoles](
	[systemRoleID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[level] [int] NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[scope] [nchar](20) NOT NULL,
	[priority] [int] NOT NULL,
 CONSTRAINT [PK_pv_systemRoles] PRIMARY KEY CLUSTERED 
(
	[systemRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_transactions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_transactions](
	[transactionID] [int] IDENTITY(1,1) NOT NULL,
	[transactionTypeID] [int] NOT NULL,
	[transactionAmount] [decimal](18, 2) NULL,
	[transactionDate] [datetime] NOT NULL,
	[details] [nchar](200) NOT NULL,
	[IPaddress] [varbinary](512) NOT NULL,
	[transactionHash] [varbinary](512) NOT NULL,
	[paymentMethodsID] [int] NOT NULL,
	[postTime] [datetime] NOT NULL,
	[referenceNumber] [nchar](200) NOT NULL,
	[convertedAmount] [decimal](18, 2) NOT NULL,
	[checksum] [varbinary](512) NOT NULL,
	[currencyID] [int] NOT NULL,
	[exchangeRateID] [int] NOT NULL,
	[paymentID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[transactionSubtypeID] [int] NOT NULL,
	[balanceTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_transactions] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_transactionSubType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_transactionSubType](
	[transactionSubTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [int] NOT NULL,
 CONSTRAINT [PK_pv_transactionSubType] PRIMARY KEY CLUSTERED 
(
	[transactionSubTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_transactionType]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_transactionType](
	[transactionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](60) NOT NULL,
 CONSTRAINT [PK_pv_transactionType] PRIMARY KEY CLUSTERED 
(
	[transactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_translation]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_translation](
	[translationID] [int] IDENTITY(1,1) NOT NULL,
	[systemLanguageID] [int] NOT NULL,
	[key] [nchar](200) NOT NULL,
	[value] [nchar](200) NOT NULL,
	[context] [nchar](200) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
	[translationHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_translation] PRIMARY KEY CLUSTERED 
(
	[translationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_UIconfiguration]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_UIconfiguration](
	[UIconfigurationID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NULL,
	[configurationType] [nchar](20) NOT NULL,
	[key] [nchar](200) NOT NULL,
	[value] [nchar](200) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[status] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_UIconfiguration] PRIMARY KEY CLUSTERED 
(
	[UIconfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userContactInfo]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userContactInfo](
	[userContactInfoID] [int] IDENTITY(1,1) NOT NULL,
	[value] [nchar](200) NOT NULL,
	[enabled] [bit] NOT NULL,
	[lastUpdate] [datetime] NULL,
	[userID] [int] NOT NULL,
	[contactInfoTypeID] [int] NOT NULL,
	[isPrimary] [bit] NULL,
 CONSTRAINT [PK_pv_userContactInfo] PRIMARY KEY CLUSTERED 
(
	[userContactInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userDemographics]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userDemographics](
	[userDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[userDemographicTypeID] [int] NOT NULL,
	[value] [nchar](500) NOT NULL,
 CONSTRAINT [PK_pv_userDemographics] PRIMARY KEY CLUSTERED 
(
	[userDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userDemographicTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userDemographicTypes](
	[userDemographicTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](100) NOT NULL,
	[dataTypeID] [int] NOT NULL,
	[description] [nchar](300) NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_pv_userDemographicTypes] PRIMARY KEY CLUSTERED 
(
	[userDemographicTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userGuide]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userGuide](
	[userGuideID] [int] NOT NULL,
	[title] [nchar](50) NOT NULL,
	[content] [text] NOT NULL,
	[category] [nchar](20) NOT NULL,
	[systemLanguageID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[userID] [int] NULL,
	[status] [nchar](20) NOT NULL,
	[version] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_pv_userGuide] PRIMARY KEY CLUSTERED 
(
	[userGuideID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userLocks]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userLocks](
	[userLockID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[lockType] [nchar](20) NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[lockDescription] [nchar](200) NOT NULL,
	[unlockCode] [varbinary](250) NOT NULL,
	[remainingAttempts] [int] NOT NULL,
	[autoUnlock] [bit] NOT NULL,
 CONSTRAINT [PK_pv_userLocks] PRIMARY KEY CLUSTERED 
(
	[userLockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userProfiles]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userProfiles](
	[userProfileID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[educationLevel] [nchar](20) NOT NULL,
	[ocupation] [nchar](20) NOT NULL,
	[disability] [bit] NOT NULL,
	[language] [nchar](20) NOT NULL,
	[residenceAddress] [geography] NOT NULL,
	[electoralDisctrict] [nchar](20) NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[nationality] [nchar](30) NOT NULL,
 CONSTRAINT [PK_pv_userProfile] PRIMARY KEY CLUSTERED 
(
	[userProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_userRole]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_userRole](
	[userRoleID] [int] IDENTITY(1,1) NOT NULL,
	[systemRoleID] [int] NOT NULL,
	[assigmentDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[institutionID] [int] NOT NULL,
	[groupID] [int] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[descripition] [nchar](200) NULL,
 CONSTRAINT [PK_pv_userRole] PRIMARY KEY CLUSTERED 
(
	[userRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_users]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_users](
	[userID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](30) NOT NULL,
	[lastName] [nchar](30) NOT NULL,
	[birthDate] [datetime] NOT NULL,
	[registerDate] [datetime] NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[accountStatusID] [int] NOT NULL,
	[identityHash] [nchar](250) NOT NULL,
	[password] [varbinary](512) NOT NULL,
	[failedAttempts] [int] NOT NULL,
	[publicKey] [varbinary](max) NOT NULL,
	[privateKeyEncrypted] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_pv_users] PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_validationStatus]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_validationStatus](
	[validationStatusID] [int] IDENTITY(1,1) NOT NULL,
	[code] [nchar](20) NOT NULL,
	[name] [nchar](50) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_validationStatus] PRIMARY KEY CLUSTERED 
(
	[validationStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_voteAllowedGroups]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_voteAllowedGroups](
	[voteAllowedGroupID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[groupID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_voteAllowedGroups] PRIMARY KEY CLUSTERED 
(
	[voteAllowedGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_voteArchives]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_voteArchives](
	[voteArchiveID] [int] IDENTITY(1,1) NOT NULL,
	[encryptedInfo] [varbinary](1000) NOT NULL,
 CONSTRAINT [PK_pv_voteArchives] PRIMARY KEY CLUSTERED 
(
	[voteArchiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_voteHash]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_voteHash](
	[voteHashID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[hashValue] [varbinary](250) NOT NULL,
	[algorithm] [nchar](500) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
 CONSTRAINT [PK_pv_voteHash] PRIMARY KEY CLUSTERED 
(
	[voteHashID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_voteQuestions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_voteQuestions](
	[voteQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[questionText] [nchar](500) NOT NULL,
	[questionTypeID] [int] NOT NULL,
	[maxSelections] [int] NOT NULL,
	[isRequired] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_voteQuestions] PRIMARY KEY CLUSTERED 
(
	[voteQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_voteQuestionsOptions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_voteQuestionsOptions](
	[voteQuestionOptionsID] [int] IDENTITY(1,1) NOT NULL,
	[questionID] [int] NOT NULL,
	[label] [nchar](200) NOT NULL,
	[optionURL] [nchar](500) NULL,
	[value] [nchar](200) NOT NULL,
	[dataTypeID] [int] NOT NULL,
	[orderIndex] [int] NOT NULL,
	[isActive] [bit] NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_voteQuestionsOptions] PRIMARY KEY CLUSTERED 
(
	[voteQuestionOptionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votes](
	[voteID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[proposalID] [int] NULL,
	[projectID] [int] NULL,
	[questionID] [int] NOT NULL,
	[optionID] [int] NOT NULL,
	[customValue] [nchar](500) NOT NULL,
	[voterHash] [varbinary](250) NOT NULL,
	[prevHash] [varbinary](512) NOT NULL,
	[criptographicKey] [int] NOT NULL,
	[voteDate] [datetime] NOT NULL,
	[tokenUsedAt] [datetime] NULL,
	[tokenValue] [varbinary](512) NULL,
 CONSTRAINT [PK_pv_votes] PRIMARY KEY CLUSTERED 
(
	[voteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingCore]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingCore](
	[votingCoreID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[title] [nchar](50) NOT NULL,
	[description] [text] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[approvalThreshold] [decimal](10, 2) NOT NULL,
	[isPublic] [bit] NOT NULL,
	[isActive] [bit] NOT NULL,
	[isPrivate] [bit] NOT NULL,
	[votingCoreResultTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_votingCore] PRIMARY KEY CLUSTERED 
(
	[votingCoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingCoreResultTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingCoreResultTypes](
	[votingCoreResultTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](100) NOT NULL,
	[isActive] [bit] NOT NULL,
	[updatedAt] [datetime] NULL,
 CONSTRAINT [PK_pv_votingCoreResultTypes] PRIMARY KEY CLUSTERED 
(
	[votingCoreResultTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingNotification]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingNotification](
	[votingNotificationID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[notificationType] [nchar](20) NOT NULL,
	[channel] [nchar](20) NOT NULL,
	[status] [nchar](20) NOT NULL,
	[priority] [nchar](20) NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_votingNotification] PRIMARY KEY CLUSTERED 
(
	[votingNotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingPeriod]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingPeriod](
	[votingPeriodID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[periodType] [nchar](20) NOT NULL,
	[modificationReason] [nchar](200) NULL,
	[createdAt] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingResult]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingResult](
	[votingResultID] [int] IDENTITY(1,1) NOT NULL,
	[votingID] [int] NOT NULL,
	[totalVotes] [int] NOT NULL,
	[totalValids] [int] NOT NULL,
	[winningOption] [nchar](20) NULL,
	[approvalPorcentage] [decimal](10, 2) NOT NULL,
	[quorumMeet] [bit] NOT NULL,
	[closingDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[resultHash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_votingResult] PRIMARY KEY CLUSTERED 
(
	[votingResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votings]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votings](
	[votingID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[configurationHash] [varbinary](512) NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[quorum] [int] NULL,
	[projectID] [int] NULL,
	[votingStatusID] [int] NOT NULL,
 CONSTRAINT [PK_pv_votings] PRIMARY KEY CLUSTERED 
(
	[votingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingStatuses]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingStatuses](
	[votingStatusID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](100) NOT NULL,
	[isActive] [bit] NOT NULL,
	[updatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_votingStatuses] PRIMARY KEY CLUSTERED 
(
	[votingStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingTargetGroups]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingTargetGroups](
	[votingTargetGroupsID] [int] IDENTITY(1,1) NOT NULL,
	[votingCoreID] [int] NOT NULL,
	[groupID] [int] NOT NULL,
 CONSTRAINT [PK_pv_votingTargetGroups] PRIMARY KEY CLUSTERED 
(
	[votingTargetGroupsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_votingToken]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_votingToken](
	[votingTokenID] [int] IDENTITY(1,1) NOT NULL,
	[tokenValue] [varbinary](512) NOT NULL,
	[issueDate] [datetime] NOT NULL,
	[expirationDate] [datetime] NOT NULL,
	[status] [nchar](20) NOT NULL,
	[votingID] [int] NOT NULL,
 CONSTRAINT [PK_pv_votingToken] PRIMARY KEY CLUSTERED 
(
	[votingTokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workflowDefinitions]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workflowDefinitions](
	[workflowDefinitionID] [int] IDENTITY(1,1) NOT NULL,
	[dagID] [nchar](100) NOT NULL,
	[description] [nchar](200) NOT NULL,
	[name] [nchar](100) NULL,
 CONSTRAINT [PK_pv_workflowDefinitions] PRIMARY KEY CLUSTERED 
(
	[workflowDefinitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workflowInstanceParameters]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workflowInstanceParameters](
	[workflowInstanceParameterID] [int] IDENTITY(1,1) NOT NULL,
	[workflowInstanceID] [int] NOT NULL,
	[parameterKey] [nchar](100) NOT NULL,
	[parameterValue] [nvarchar](max) NOT NULL,
	[dataTypeID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
 CONSTRAINT [PK_pv_workflowInstanceParameters] PRIMARY KEY CLUSTERED 
(
	[workflowInstanceParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workflowLogs]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workflowLogs](
	[workflowLogID] [int] IDENTITY(1,1) NOT NULL,
	[workflowInstanceID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[workflowLogTypeID] [int] NOT NULL,
	[message] [nchar](1000) NOT NULL,
	[description] [nchar](200) NULL,
	[detailsAI] [varchar](500) NOT NULL,
 CONSTRAINT [PK_pv_workflowLogs] PRIMARY KEY CLUSTERED 
(
	[workflowLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workflowLogTypes]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workflowLogTypes](
	[workflowLogTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nchar](50) NOT NULL,
 CONSTRAINT [PK_pv_workflowLogTypes] PRIMARY KEY CLUSTERED 
(
	[workflowLogTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workflowParameters]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workflowParameters](
	[workflowParameterID] [int] IDENTITY(1,1) NOT NULL,
	[workflowDefinitionID] [int] NOT NULL,
	[parameterKey] [nchar](50) NOT NULL,
	[parameterValueDefault] [varchar](500) NOT NULL,
	[dataType] [nchar](20) NOT NULL,
	[isRequired] [bit] NOT NULL,
 CONSTRAINT [PK_pv_workflowParameters] PRIMARY KEY CLUSTERED 
(
	[workflowParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pv_workFlowsInstances]    Script Date: 6/10/2025 7:47:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pv_workFlowsInstances](
	[workFlowID] [int] IDENTITY(1,1) NOT NULL,
	[proposalDocumentID] [int] NOT NULL,
	[dagRunID] [nchar](100) NOT NULL,
	[dagURL] [nchar](100) NOT NULL,
	[payload] [varchar](200) NOT NULL,
	[bucketOrigin] [nchar](200) NOT NULL,
	[validationStatusID] [int] NOT NULL,
	[startedAt] [datetime] NOT NULL,
	[finishedAt] [datetime] NOT NULL,
	[createdAt] [datetime] NOT NULL,
	[updatedAt] [datetime] NULL,
	[workflowsDefinitionID] [int] NOT NULL,
 CONSTRAINT [PK_pv_workFlows] PRIMARY KEY CLUSTERED 
(
	[workFlowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pv_proposalSponsor] ADD  CONSTRAINT [DF_pv_proposalSponsor_isPrimary]  DEFAULT ((0)) FOR [isPrimary]
GO
ALTER TABLE [dbo].[pv_proposalValidation] ADD  CONSTRAINT [DF_pv_proposalValidation_result]  DEFAULT ((0)) FOR [result]
GO
ALTER TABLE [dbo].[pv_proposalValidation] ADD  CONSTRAINT [DF_pv_proposalValidation_automaticSystem]  DEFAULT ((0)) FOR [automaticSystem]
GO
ALTER TABLE [dbo].[pv_systemLanguage] ADD  CONSTRAINT [DF_pv_systemLanguage_isDefault]  DEFAULT ((0)) FOR [isDefault]
GO
ALTER TABLE [dbo].[pv_systemParameter] ADD  CONSTRAINT [DF_pv_systemParameter_isEncrypted]  DEFAULT ((0)) FOR [isEncrypted]
GO
ALTER TABLE [dbo].[pv_userContactInfo] ADD  CONSTRAINT [DF_pv_userContactInfo_enabled]  DEFAULT ((0)) FOR [enabled]
GO
ALTER TABLE [dbo].[pv_userProfiles] ADD  CONSTRAINT [DF_pv_userProfile_disability]  DEFAULT ((0)) FOR [disability]
GO
ALTER TABLE [dbo].[pv_accessLog]  WITH CHECK ADD  CONSTRAINT [FK_pv_accessLog_pv_logins] FOREIGN KEY([loginID])
REFERENCES [dbo].[pv_logins] ([loginID])
GO
ALTER TABLE [dbo].[pv_accessLog] CHECK CONSTRAINT [FK_pv_accessLog_pv_logins]
GO
ALTER TABLE [dbo].[pv_appInstance]  WITH CHECK ADD  CONSTRAINT [FK_pv_appInstance_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_appInstance] CHECK CONSTRAINT [FK_pv_appInstance_pv_server]
GO
ALTER TABLE [dbo].[pv_availableMethods]  WITH CHECK ADD  CONSTRAINT [FK_pv_availableMethods_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_availableMethods] CHECK CONSTRAINT [FK_pv_availableMethods_pv_groups]
GO
ALTER TABLE [dbo].[pv_availableMethods]  WITH CHECK ADD  CONSTRAINT [FK_pv_availableMethods_pv_paymentMethods] FOREIGN KEY([paymentMethodID])
REFERENCES [dbo].[pv_paymentMethods] ([paymentMethodID])
GO
ALTER TABLE [dbo].[pv_availableMethods] CHECK CONSTRAINT [FK_pv_availableMethods_pv_paymentMethods]
GO
ALTER TABLE [dbo].[pv_backUpConfig]  WITH CHECK ADD  CONSTRAINT [FK_pv_backUpConfig_pv_logs] FOREIGN KEY([logID])
REFERENCES [dbo].[pv_logs] ([logID])
GO
ALTER TABLE [dbo].[pv_backUpConfig] CHECK CONSTRAINT [FK_pv_backUpConfig_pv_logs]
GO
ALTER TABLE [dbo].[pv_backUpLog]  WITH CHECK ADD  CONSTRAINT [FK_pv_backUpLog_pv_backUpConfig] FOREIGN KEY([backUpConfigID])
REFERENCES [dbo].[pv_backUpConfig] ([backUpConfigID])
GO
ALTER TABLE [dbo].[pv_backUpLog] CHECK CONSTRAINT [FK_pv_backUpLog_pv_backUpConfig]
GO
ALTER TABLE [dbo].[pv_balances]  WITH CHECK ADD  CONSTRAINT [FK_pv_balances_pv_balanceTypes] FOREIGN KEY([balanceTypeID])
REFERENCES [dbo].[pv_balanceTypes] ([balanceTypeID])
GO
ALTER TABLE [dbo].[pv_balances] CHECK CONSTRAINT [FK_pv_balances_pv_balanceTypes]
GO
ALTER TABLE [dbo].[pv_balances]  WITH CHECK ADD  CONSTRAINT [FK_pv_balances_pv_projects] FOREIGN KEY([projectID])
REFERENCES [dbo].[pv_projects] ([projectID])
GO
ALTER TABLE [dbo].[pv_balances] CHECK CONSTRAINT [FK_pv_balances_pv_projects]
GO
ALTER TABLE [dbo].[pv_balances]  WITH CHECK ADD  CONSTRAINT [FK_pv_balances_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_balances] CHECK CONSTRAINT [FK_pv_balances_pv_users]
GO
ALTER TABLE [dbo].[pv_biometricData]  WITH CHECK ADD  CONSTRAINT [FK_pv_biometricData_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_biometricData] CHECK CONSTRAINT [FK_pv_biometricData_pv_users]
GO
ALTER TABLE [dbo].[pv_conditionTerms]  WITH CHECK ADD  CONSTRAINT [FK_pv_conditionTerms_pv_userGuide] FOREIGN KEY([userGuideID])
REFERENCES [dbo].[pv_userGuide] ([userGuideID])
GO
ALTER TABLE [dbo].[pv_conditionTerms] CHECK CONSTRAINT [FK_pv_conditionTerms_pv_userGuide]
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions]  WITH CHECK ADD  CONSTRAINT [FK_pv_crowdfundingContributions_pv_contributionStatuses] FOREIGN KEY([contributionStatusID])
REFERENCES [dbo].[pv_contributionStatuses] ([contributionStatusID])
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions] CHECK CONSTRAINT [FK_pv_crowdfundingContributions_pv_contributionStatuses]
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions]  WITH CHECK ADD  CONSTRAINT [FK_pv_crowdfundingContributions_pv_cryptographicKeys] FOREIGN KEY([cryptographicKeyID])
REFERENCES [dbo].[pv_cryptographicKeys] ([cryptographicKeyID])
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions] CHECK CONSTRAINT [FK_pv_crowdfundingContributions_pv_cryptographicKeys]
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions]  WITH CHECK ADD  CONSTRAINT [FK_pv_crowdfundingContributions_pv_paymentMethods] FOREIGN KEY([paymentMethodID])
REFERENCES [dbo].[pv_paymentMethods] ([paymentMethodID])
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions] CHECK CONSTRAINT [FK_pv_crowdfundingContributions_pv_paymentMethods]
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions]  WITH CHECK ADD  CONSTRAINT [FK_pv_crowdfundingContributions_pv_projects] FOREIGN KEY([projectID])
REFERENCES [dbo].[pv_projects] ([projectID])
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions] CHECK CONSTRAINT [FK_pv_crowdfundingContributions_pv_projects]
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions]  WITH CHECK ADD  CONSTRAINT [FK_pv_crowdfundingContributions_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_crowdfundingContributions] CHECK CONSTRAINT [FK_pv_crowdfundingContributions_pv_users]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKey_pv_digitalSignature] FOREIGN KEY([digitalSignatureID])
REFERENCES [dbo].[pv_digitalSignature] ([digitalSignatureID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKey_pv_digitalSignature]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKey_pv_secureEnclave] FOREIGN KEY([enclaveID])
REFERENCES [dbo].[pv_secureEnclave] ([secureEnclaveID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKey_pv_secureEnclave]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKeys_pv_algorithms] FOREIGN KEY([algorithm])
REFERENCES [dbo].[pv_algorithms] ([algorithmID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKeys_pv_algorithms]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKeys_pv_keyTypes] FOREIGN KEY([keyType])
REFERENCES [dbo].[pv_keyTypes] ([keyTypeID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKeys_pv_keyTypes]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKeys_pv_mainUses] FOREIGN KEY([mainUse])
REFERENCES [dbo].[pv_mainUses] ([mainUseID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKeys_pv_mainUses]
GO
ALTER TABLE [dbo].[pv_cryptographicKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_cryptographicKeys_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_cryptographicKeys] CHECK CONSTRAINT [FK_pv_cryptographicKeys_pv_users]
GO
ALTER TABLE [dbo].[pv_departments]  WITH CHECK ADD  CONSTRAINT [FK_pv_departments_pv_institutions] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_departments] CHECK CONSTRAINT [FK_pv_departments_pv_institutions]
GO
ALTER TABLE [dbo].[pv_digitalCertificates]  WITH CHECK ADD  CONSTRAINT [FK_pv_digitalCertificate_pv_cryptographicKey] FOREIGN KEY([criptographicKey])
REFERENCES [dbo].[pv_cryptographicKeys] ([cryptographicKeyID])
GO
ALTER TABLE [dbo].[pv_digitalCertificates] CHECK CONSTRAINT [FK_pv_digitalCertificate_pv_cryptographicKey]
GO
ALTER TABLE [dbo].[pv_digitalSignature]  WITH CHECK ADD  CONSTRAINT [FK_pv_digitalSignature_pv_cryptographicKey] FOREIGN KEY([cryptographicKeyID])
REFERENCES [dbo].[pv_cryptographicKeys] ([cryptographicKeyID])
GO
ALTER TABLE [dbo].[pv_digitalSignature] CHECK CONSTRAINT [FK_pv_digitalSignature_pv_cryptographicKey]
GO
ALTER TABLE [dbo].[pv_documentMediaFiles]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentMediaFiles_pv_mediaFiles] FOREIGN KEY([mediaFileID])
REFERENCES [dbo].[pv_mediaFiles] ([mediaFileID])
GO
ALTER TABLE [dbo].[pv_documentMediaFiles] CHECK CONSTRAINT [FK_pv_documentMediaFiles_pv_mediaFiles]
GO
ALTER TABLE [dbo].[pv_documentMediaFiles]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentMediaFiles_pv_proposalDocument] FOREIGN KEY([proposalDocumentID])
REFERENCES [dbo].[pv_proposalDocument] ([proposalDocumentID])
GO
ALTER TABLE [dbo].[pv_documentMediaFiles] CHECK CONSTRAINT [FK_pv_documentMediaFiles_pv_proposalDocument]
GO
ALTER TABLE [dbo].[pv_documentTypeWorkflowDefs]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentTypeWorkflowDefs_pv_documentType] FOREIGN KEY([documentTypeID])
REFERENCES [dbo].[pv_documentType] ([documentTypeID])
GO
ALTER TABLE [dbo].[pv_documentTypeWorkflowDefs] CHECK CONSTRAINT [FK_pv_documentTypeWorkflowDefs_pv_documentType]
GO
ALTER TABLE [dbo].[pv_documentTypeWorkflowDefs]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentTypeWorkflowDefs_pv_workflowDefinitions] FOREIGN KEY([workflowDefinitionID])
REFERENCES [dbo].[pv_workflowDefinitions] ([workflowDefinitionID])
GO
ALTER TABLE [dbo].[pv_documentTypeWorkflowDefs] CHECK CONSTRAINT [FK_pv_documentTypeWorkflowDefs_pv_workflowDefinitions]
GO
ALTER TABLE [dbo].[pv_documentValidations]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentValidations_pv_errorTypes] FOREIGN KEY([errorTypeID])
REFERENCES [dbo].[pv_errorTypes] ([errorTypeID])
GO
ALTER TABLE [dbo].[pv_documentValidations] CHECK CONSTRAINT [FK_pv_documentValidations_pv_errorTypes]
GO
ALTER TABLE [dbo].[pv_documentValidations]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentValidations_pv_proposalDocument1] FOREIGN KEY([proposalDocumentID])
REFERENCES [dbo].[pv_proposalDocument] ([proposalDocumentID])
GO
ALTER TABLE [dbo].[pv_documentValidations] CHECK CONSTRAINT [FK_pv_documentValidations_pv_proposalDocument1]
GO
ALTER TABLE [dbo].[pv_documentValidations]  WITH CHECK ADD  CONSTRAINT [FK_pv_documentValidations_pv_validationStatus] FOREIGN KEY([validationStatusID])
REFERENCES [dbo].[pv_validationStatus] ([validationStatusID])
GO
ALTER TABLE [dbo].[pv_documentValidations] CHECK CONSTRAINT [FK_pv_documentValidations_pv_validationStatus]
GO
ALTER TABLE [dbo].[pv_elegibilityCriteria]  WITH CHECK ADD  CONSTRAINT [FK_pv_elegibilityCriteria_pv_criteriaTypes] FOREIGN KEY([criteriaTypeID])
REFERENCES [dbo].[pv_criteriaTypes] ([criteriaTypeID])
GO
ALTER TABLE [dbo].[pv_elegibilityCriteria] CHECK CONSTRAINT [FK_pv_elegibilityCriteria_pv_criteriaTypes]
GO
ALTER TABLE [dbo].[pv_elegibilityCriteria]  WITH CHECK ADD  CONSTRAINT [FK_pv_elegibilityCriteria_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_elegibilityCriteria] CHECK CONSTRAINT [FK_pv_elegibilityCriteria_pv_votings]
GO
ALTER TABLE [dbo].[pv_exchangeRates]  WITH CHECK ADD  CONSTRAINT [FK_pv_exchangeRates_pv_currencies] FOREIGN KEY([currencyID])
REFERENCES [dbo].[pv_currencies] ([currencyID])
GO
ALTER TABLE [dbo].[pv_exchangeRates] CHECK CONSTRAINT [FK_pv_exchangeRates_pv_currencies]
GO
ALTER TABLE [dbo].[pv_frequentQA]  WITH CHECK ADD  CONSTRAINT [FK_pv_frequentQA_pv_systemLanguage] FOREIGN KEY([systemLanguageID])
REFERENCES [dbo].[pv_systemLanguage] ([systemLanguageID])
GO
ALTER TABLE [dbo].[pv_frequentQA] CHECK CONSTRAINT [FK_pv_frequentQA_pv_systemLanguage]
GO
ALTER TABLE [dbo].[pv_groupFeatures]  WITH CHECK ADD  CONSTRAINT [FK_pv_groupFeatures_pv_groupFeatureTypes] FOREIGN KEY([groupFeatureTypeID])
REFERENCES [dbo].[pv_groupFeatureTypes] ([groupFeatureTypeID])
GO
ALTER TABLE [dbo].[pv_groupFeatures] CHECK CONSTRAINT [FK_pv_groupFeatures_pv_groupFeatureTypes]
GO
ALTER TABLE [dbo].[pv_groupFeatures]  WITH CHECK ADD  CONSTRAINT [FK_pv_groupFeatures_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_groupFeatures] CHECK CONSTRAINT [FK_pv_groupFeatures_pv_groups]
GO
ALTER TABLE [dbo].[pv_groupFeatureTypes]  WITH CHECK ADD  CONSTRAINT [FK_pv_groupFeatureTypes_pv_dataTypes] FOREIGN KEY([dataTypeID])
REFERENCES [dbo].[pv_dataTypes] ([dataTypeID])
GO
ALTER TABLE [dbo].[pv_groupFeatureTypes] CHECK CONSTRAINT [FK_pv_groupFeatureTypes_pv_dataTypes]
GO
ALTER TABLE [dbo].[pv_groups]  WITH CHECK ADD  CONSTRAINT [FK_pv_groups_pv_groupTypes] FOREIGN KEY([groupTypeID])
REFERENCES [dbo].[pv_groupTypes] ([groupTypeID])
GO
ALTER TABLE [dbo].[pv_groups] CHECK CONSTRAINT [FK_pv_groups_pv_groupTypes]
GO
ALTER TABLE [dbo].[pv_groupUser]  WITH CHECK ADD  CONSTRAINT [FK_pv_groupUser_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_groupUser] CHECK CONSTRAINT [FK_pv_groupUser_pv_groups]
GO
ALTER TABLE [dbo].[pv_groupUser]  WITH CHECK ADD  CONSTRAINT [FK_pv_groupUser_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_groupUser] CHECK CONSTRAINT [FK_pv_groupUser_pv_users]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_contractTypes] FOREIGN KEY([contractTypeID])
REFERENCES [dbo].[pv_contractTypes] ([contractTypeID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_contractTypes]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_departments] FOREIGN KEY([departmentID])
REFERENCES [dbo].[pv_departments] ([departmentID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_departments]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_herarchyLevels] FOREIGN KEY([herarchyLevelID])
REFERENCES [dbo].[pv_herarchyLevels] ([herarchyLevelID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_herarchyLevels]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_institution] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_institution]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_institutionRoles] FOREIGN KEY([institutionRoleID])
REFERENCES [dbo].[pv_institutionRoles] ([institutionRoleID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_institutionRoles]
GO
ALTER TABLE [dbo].[pv_institutionMembers]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionMembers_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_institutionMembers] CHECK CONSTRAINT [FK_pv_institutionMembers_pv_users]
GO
ALTER TABLE [dbo].[pv_institutions]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutions_pv_institutionStatus] FOREIGN KEY([institutionStatusID])
REFERENCES [dbo].[pv_institutionStatus] ([institutionStatusID])
GO
ALTER TABLE [dbo].[pv_institutions] CHECK CONSTRAINT [FK_pv_institutions_pv_institutionStatus]
GO
ALTER TABLE [dbo].[pv_institutions]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutions_pv_sectors] FOREIGN KEY([sectorID])
REFERENCES [dbo].[pv_sectors] ([sectorID])
GO
ALTER TABLE [dbo].[pv_institutions] CHECK CONSTRAINT [FK_pv_institutions_pv_sectors]
GO
ALTER TABLE [dbo].[pv_institutionUserKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionUserKeys_pv_institutions] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_institutionUserKeys] CHECK CONSTRAINT [FK_pv_institutionUserKeys_pv_institutions]
GO
ALTER TABLE [dbo].[pv_institutionUserKeys]  WITH CHECK ADD  CONSTRAINT [FK_pv_institutionUserKeys_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_institutionUserKeys] CHECK CONSTRAINT [FK_pv_institutionUserKeys_pv_users]
GO
ALTER TABLE [dbo].[pv_integrityLog]  WITH CHECK ADD  CONSTRAINT [FK_pv_integrityLog_pv_digitalSignature] FOREIGN KEY([digitalSignatureID])
REFERENCES [dbo].[pv_digitalSignature] ([digitalSignatureID])
GO
ALTER TABLE [dbo].[pv_integrityLog] CHECK CONSTRAINT [FK_pv_integrityLog_pv_digitalSignature]
GO
ALTER TABLE [dbo].[pv_labelRelationships]  WITH CHECK ADD  CONSTRAINT [FK_pv_labelRelationships_pv_proposalLabel] FOREIGN KEY([proposalLabelID])
REFERENCES [dbo].[pv_proposalLabel] ([proposalLabelID])
GO
ALTER TABLE [dbo].[pv_labelRelationships] CHECK CONSTRAINT [FK_pv_labelRelationships_pv_proposalLabel]
GO
ALTER TABLE [dbo].[pv_loginAttempts]  WITH CHECK ADD  CONSTRAINT [FK_pv_loginAttempts_pv_syncedDevices] FOREIGN KEY([device])
REFERENCES [dbo].[pv_syncedDevices] ([syncedDeviceID])
GO
ALTER TABLE [dbo].[pv_loginAttempts] CHECK CONSTRAINT [FK_pv_loginAttempts_pv_syncedDevices]
GO
ALTER TABLE [dbo].[pv_loginAttempts]  WITH CHECK ADD  CONSTRAINT [FK_pv_loginAttempts_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_loginAttempts] CHECK CONSTRAINT [FK_pv_loginAttempts_pv_users]
GO
ALTER TABLE [dbo].[pv_loginAuditory]  WITH CHECK ADD  CONSTRAINT [FK_pv_loginAuditory_pv_syncedDevices] FOREIGN KEY([device])
REFERENCES [dbo].[pv_syncedDevices] ([syncedDeviceID])
GO
ALTER TABLE [dbo].[pv_loginAuditory] CHECK CONSTRAINT [FK_pv_loginAuditory_pv_syncedDevices]
GO
ALTER TABLE [dbo].[pv_loginAuditory]  WITH CHECK ADD  CONSTRAINT [FK_pv_loginAuditory_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_loginAuditory] CHECK CONSTRAINT [FK_pv_loginAuditory_pv_users]
GO
ALTER TABLE [dbo].[pv_logins]  WITH CHECK ADD  CONSTRAINT [FK_pv_logins_pv_syncedDevices] FOREIGN KEY([syncedDeviceID])
REFERENCES [dbo].[pv_syncedDevices] ([syncedDeviceID])
GO
ALTER TABLE [dbo].[pv_logins] CHECK CONSTRAINT [FK_pv_logins_pv_syncedDevices]
GO
ALTER TABLE [dbo].[pv_logins]  WITH CHECK ADD  CONSTRAINT [FK_pv_logins_pv_users1] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_logins] CHECK CONSTRAINT [FK_pv_logins_pv_users1]
GO
ALTER TABLE [dbo].[pv_logs]  WITH CHECK ADD  CONSTRAINT [FK_pv_logs_pv_logSeverities] FOREIGN KEY([logSeverityID])
REFERENCES [dbo].[pv_logSeverities] ([logSeverityID])
GO
ALTER TABLE [dbo].[pv_logs] CHECK CONSTRAINT [FK_pv_logs_pv_logSeverities]
GO
ALTER TABLE [dbo].[pv_logs]  WITH CHECK ADD  CONSTRAINT [FK_pv_logs_pv_logSources] FOREIGN KEY([logSourceID])
REFERENCES [dbo].[pv_logSources] ([logSourceID])
GO
ALTER TABLE [dbo].[pv_logs] CHECK CONSTRAINT [FK_pv_logs_pv_logSources]
GO
ALTER TABLE [dbo].[pv_logs]  WITH CHECK ADD  CONSTRAINT [FK_pv_logs_pv_logType] FOREIGN KEY([logTypeID])
REFERENCES [dbo].[pv_logType] ([logTypeID])
GO
ALTER TABLE [dbo].[pv_logs] CHECK CONSTRAINT [FK_pv_logs_pv_logType]
GO
ALTER TABLE [dbo].[pv_logs]  WITH CHECK ADD  CONSTRAINT [FK_pv_logs_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_logs] CHECK CONSTRAINT [FK_pv_logs_pv_server]
GO
ALTER TABLE [dbo].[pv_mediaFiles]  WITH CHECK ADD  CONSTRAINT [FK_pv_mediaFiles_pv_mediaTypes] FOREIGN KEY([mediaTypeID])
REFERENCES [dbo].[pv_mediaTypes] ([mediaTypeID])
GO
ALTER TABLE [dbo].[pv_mediaFiles] CHECK CONSTRAINT [FK_pv_mediaFiles_pv_mediaTypes]
GO
ALTER TABLE [dbo].[pv_milestoneVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_milestoneVotes_pv_projectMilestones] FOREIGN KEY([projectMilestoneID])
REFERENCES [dbo].[pv_projectMilestones] ([projectMilestoneID])
GO
ALTER TABLE [dbo].[pv_milestoneVotes] CHECK CONSTRAINT [FK_pv_milestoneVotes_pv_projectMilestones]
GO
ALTER TABLE [dbo].[pv_milestoneVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_milestoneVotes_pv_votingCore] FOREIGN KEY([votingCoreID])
REFERENCES [dbo].[pv_votingCore] ([votingCoreID])
GO
ALTER TABLE [dbo].[pv_milestoneVotes] CHECK CONSTRAINT [FK_pv_milestoneVotes_pv_votingCore]
GO
ALTER TABLE [dbo].[pv_milestoneVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_milestoneVotes_pv_votingCore1] FOREIGN KEY([votingCoreID])
REFERENCES [dbo].[pv_votingCore] ([votingCoreID])
GO
ALTER TABLE [dbo].[pv_milestoneVotes] CHECK CONSTRAINT [FK_pv_milestoneVotes_pv_votingCore1]
GO
ALTER TABLE [dbo].[pv_notificationTemplate]  WITH CHECK ADD  CONSTRAINT [FK_pv_notificationTemplate_pv_systemLanguage] FOREIGN KEY([systemLanguageID])
REFERENCES [dbo].[pv_systemLanguage] ([systemLanguageID])
GO
ALTER TABLE [dbo].[pv_notificationTemplate] CHECK CONSTRAINT [FK_pv_notificationTemplate_pv_systemLanguage]
GO
ALTER TABLE [dbo].[pv_passwordHistory]  WITH CHECK ADD  CONSTRAINT [FK_pv_passwordHistory_pv_passwordHash] FOREIGN KEY([passwordHashID])
REFERENCES [dbo].[pv_passwordHash] ([passwordHashID])
GO
ALTER TABLE [dbo].[pv_passwordHistory] CHECK CONSTRAINT [FK_pv_passwordHistory_pv_passwordHash]
GO
ALTER TABLE [dbo].[pv_passwordHistory]  WITH CHECK ADD  CONSTRAINT [FK_pv_passwordHistory_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_passwordHistory] CHECK CONSTRAINT [FK_pv_passwordHistory_pv_users]
GO
ALTER TABLE [dbo].[pv_payments]  WITH CHECK ADD  CONSTRAINT [FK_pv_payments_pv_currencies] FOREIGN KEY([currencyID])
REFERENCES [dbo].[pv_currencies] ([currencyID])
GO
ALTER TABLE [dbo].[pv_payments] CHECK CONSTRAINT [FK_pv_payments_pv_currencies]
GO
ALTER TABLE [dbo].[pv_payments]  WITH CHECK ADD  CONSTRAINT [FK_pv_payments_pv_paymentMethods] FOREIGN KEY([paymentMethodID])
REFERENCES [dbo].[pv_paymentMethods] ([paymentMethodID])
GO
ALTER TABLE [dbo].[pv_payments] CHECK CONSTRAINT [FK_pv_payments_pv_paymentMethods]
GO
ALTER TABLE [dbo].[pv_pendingRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_pendingRequests_pv_digitalSignature] FOREIGN KEY([digitalSignatureID])
REFERENCES [dbo].[pv_digitalSignature] ([digitalSignatureID])
GO
ALTER TABLE [dbo].[pv_pendingRequests] CHECK CONSTRAINT [FK_pv_pendingRequests_pv_digitalSignature]
GO
ALTER TABLE [dbo].[pv_pendingRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_pendingRequests_pv_institutions] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_pendingRequests] CHECK CONSTRAINT [FK_pv_pendingRequests_pv_institutions]
GO
ALTER TABLE [dbo].[pv_pendingRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_pendingRequests_pv_requestStatus] FOREIGN KEY([requestStatusID])
REFERENCES [dbo].[pv_requestStatus] ([requestStatusID])
GO
ALTER TABLE [dbo].[pv_pendingRequests] CHECK CONSTRAINT [FK_pv_pendingRequests_pv_requestStatus]
GO
ALTER TABLE [dbo].[pv_pendingRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_pendingRequests_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_pendingRequests] CHECK CONSTRAINT [FK_pv_pendingRequests_pv_users]
GO
ALTER TABLE [dbo].[pv_permissionRole]  WITH CHECK ADD  CONSTRAINT [FK_pv_permissionRole_pv_permissions] FOREIGN KEY([permissionID])
REFERENCES [dbo].[pv_permissions] ([permissionID])
GO
ALTER TABLE [dbo].[pv_permissionRole] CHECK CONSTRAINT [FK_pv_permissionRole_pv_permissions]
GO
ALTER TABLE [dbo].[pv_permissionRole]  WITH CHECK ADD  CONSTRAINT [FK_pv_permissionRole_pv_systemRoles] FOREIGN KEY([roleID])
REFERENCES [dbo].[pv_systemRoles] ([systemRoleID])
GO
ALTER TABLE [dbo].[pv_permissionRole] CHECK CONSTRAINT [FK_pv_permissionRole_pv_systemRoles]
GO
ALTER TABLE [dbo].[pv_profileHistory]  WITH CHECK ADD  CONSTRAINT [FK_pv_profileHistory_pv_userProfiles] FOREIGN KEY([userProfileID])
REFERENCES [dbo].[pv_userProfiles] ([userProfileID])
GO
ALTER TABLE [dbo].[pv_profileHistory] CHECK CONSTRAINT [FK_pv_profileHistory_pv_userProfiles]
GO
ALTER TABLE [dbo].[pv_projectMilestones]  WITH CHECK ADD  CONSTRAINT [FK_pv_projectMilestones_pv_projects] FOREIGN KEY([projectID])
REFERENCES [dbo].[pv_projects] ([projectID])
GO
ALTER TABLE [dbo].[pv_projectMilestones] CHECK CONSTRAINT [FK_pv_projectMilestones_pv_projects]
GO
ALTER TABLE [dbo].[pv_projects]  WITH CHECK ADD  CONSTRAINT [FK_pv_projects_pv_currencies] FOREIGN KEY([currencyID])
REFERENCES [dbo].[pv_currencies] ([currencyID])
GO
ALTER TABLE [dbo].[pv_projects] CHECK CONSTRAINT [FK_pv_projects_pv_currencies]
GO
ALTER TABLE [dbo].[pv_projects]  WITH CHECK ADD  CONSTRAINT [FK_pv_projects_pv_projectStatuses] FOREIGN KEY([projectStatusID])
REFERENCES [dbo].[pv_projectStatuses] ([projectStatusID])
GO
ALTER TABLE [dbo].[pv_projects] CHECK CONSTRAINT [FK_pv_projects_pv_projectStatuses]
GO
ALTER TABLE [dbo].[pv_projects]  WITH CHECK ADD  CONSTRAINT [FK_pv_projects_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_projects] CHECK CONSTRAINT [FK_pv_projects_pv_users]
GO
ALTER TABLE [dbo].[pv_projectTask]  WITH CHECK ADD  CONSTRAINT [FK_pv_projectTask_pv_kpiUnitTypes] FOREIGN KEY([kpiUnitID])
REFERENCES [dbo].[pv_kpiUnitTypes] ([kpiUnitID])
GO
ALTER TABLE [dbo].[pv_projectTask] CHECK CONSTRAINT [FK_pv_projectTask_pv_kpiUnitTypes]
GO
ALTER TABLE [dbo].[pv_projectTask]  WITH CHECK ADD  CONSTRAINT [FK_pv_projectTask_pv_projectMilestones] FOREIGN KEY([projectMilestoneID])
REFERENCES [dbo].[pv_projectMilestones] ([projectMilestoneID])
GO
ALTER TABLE [dbo].[pv_projectTask] CHECK CONSTRAINT [FK_pv_projectTask_pv_projectMilestones]
GO
ALTER TABLE [dbo].[pv_projectTask]  WITH CHECK ADD  CONSTRAINT [FK_pv_projectTask_pv_projectStatuses] FOREIGN KEY([projectStatusID])
REFERENCES [dbo].[pv_projectStatuses] ([projectStatusID])
GO
ALTER TABLE [dbo].[pv_projectTask] CHECK CONSTRAINT [FK_pv_projectTask_pv_projectStatuses]
GO
ALTER TABLE [dbo].[pv_projectTask]  WITH CHECK ADD  CONSTRAINT [FK_pv_projectTask_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_projectTask] CHECK CONSTRAINT [FK_pv_projectTask_pv_users]
GO
ALTER TABLE [dbo].[pv_proposalCollaborators]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalCollaborators_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalCollaborators] CHECK CONSTRAINT [FK_pv_proposalCollaborators_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalComment]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalComment_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalComment] CHECK CONSTRAINT [FK_pv_proposalComment_pv_proposals]
GO
ALTER TABLE [dbo].[pv_proposalComment]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalComment_pv_proposalVersion] FOREIGN KEY([proposalVersion])
REFERENCES [dbo].[pv_proposalVersion] ([proposalVersionID])
GO
ALTER TABLE [dbo].[pv_proposalComment] CHECK CONSTRAINT [FK_pv_proposalComment_pv_proposalVersion]
GO
ALTER TABLE [dbo].[pv_proposalContent]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalContent_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalContent] CHECK CONSTRAINT [FK_pv_proposalContent_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalCore]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalCore_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalCore] CHECK CONSTRAINT [FK_pv_proposalCore_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_documentType] FOREIGN KEY([documentTypeID])
REFERENCES [dbo].[pv_documentType] ([documentTypeID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_documentType]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_institutionStatus] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutionStatus] ([institutionStatusID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_institutionStatus]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_mediaTypes] FOREIGN KEY([mediaTypeID])
REFERENCES [dbo].[pv_mediaTypes] ([mediaTypeID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_mediaTypes]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_proposalVersion] FOREIGN KEY([proposalVersionID])
REFERENCES [dbo].[pv_proposalVersion] ([proposalVersionID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_proposalVersion]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_proposalVersion1] FOREIGN KEY([proposalVersionID])
REFERENCES [dbo].[pv_proposalVersion] ([proposalVersionID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_proposalVersion1]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_users]
GO
ALTER TABLE [dbo].[pv_proposalDocument]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalDocument_pv_validationStatus] FOREIGN KEY([validationStatusID])
REFERENCES [dbo].[pv_validationStatus] ([validationStatusID])
GO
ALTER TABLE [dbo].[pv_proposalDocument] CHECK CONSTRAINT [FK_pv_proposalDocument_pv_validationStatus]
GO
ALTER TABLE [dbo].[pv_proposalImpactGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalImpactGroups_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_proposalImpactGroups] CHECK CONSTRAINT [FK_pv_proposalImpactGroups_pv_groups]
GO
ALTER TABLE [dbo].[pv_proposalImpactGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalImpactGroups_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalImpactGroups] CHECK CONSTRAINT [FK_pv_proposalImpactGroups_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalLabel]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalLabel_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_proposalLabel] CHECK CONSTRAINT [FK_pv_proposalLabel_pv_users]
GO
ALTER TABLE [dbo].[pv_proposalReviews]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalReviews_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalReviews] CHECK CONSTRAINT [FK_pv_proposalReviews_pv_proposals]
GO
ALTER TABLE [dbo].[pv_proposalSponsor]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalSponsor_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalSponsor] CHECK CONSTRAINT [FK_pv_proposalSponsor_pv_proposals]
GO
ALTER TABLE [dbo].[pv_proposalTargetGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalTargetGroups_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_proposalTargetGroups] CHECK CONSTRAINT [FK_pv_proposalTargetGroups_pv_groups]
GO
ALTER TABLE [dbo].[pv_proposalTargetGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalTargetGroups_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalTargetGroups] CHECK CONSTRAINT [FK_pv_proposalTargetGroups_pv_propposals]
GO
ALTER TABLE [dbo].[pv_proposalValidation]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalValidation_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalValidation] CHECK CONSTRAINT [FK_pv_proposalValidation_pv_proposals]
GO
ALTER TABLE [dbo].[pv_proposalVersion]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposalVersion_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_proposalVersion] CHECK CONSTRAINT [FK_pv_proposalVersion_pv_proposals]
GO
ALTER TABLE [dbo].[pv_propposals]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposals_pv_proposalType] FOREIGN KEY([proposalTypeID])
REFERENCES [dbo].[pv_proposalType] ([propposalTypeID])
GO
ALTER TABLE [dbo].[pv_propposals] CHECK CONSTRAINT [FK_pv_proposals_pv_proposalType]
GO
ALTER TABLE [dbo].[pv_propposals]  WITH CHECK ADD  CONSTRAINT [FK_pv_proposals_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_propposals] CHECK CONSTRAINT [FK_pv_proposals_pv_users]
GO
ALTER TABLE [dbo].[pv_publicVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_publicVotes_pv_users1] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_publicVotes] CHECK CONSTRAINT [FK_pv_publicVotes_pv_users1]
GO
ALTER TABLE [dbo].[pv_publicVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_publicVotes_pv_votes] FOREIGN KEY([voteID])
REFERENCES [dbo].[pv_votes] ([voteID])
GO
ALTER TABLE [dbo].[pv_publicVotes] CHECK CONSTRAINT [FK_pv_publicVotes_pv_votes]
GO
ALTER TABLE [dbo].[pv_publicVotes]  WITH CHECK ADD  CONSTRAINT [FK_pv_publicVotes_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_publicVotes] CHECK CONSTRAINT [FK_pv_publicVotes_pv_votings]
GO
ALTER TABLE [dbo].[pv_recoveryRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_recoveryRequests_pv_syncedDevices] FOREIGN KEY([syncedDeviceID])
REFERENCES [dbo].[pv_syncedDevices] ([syncedDeviceID])
GO
ALTER TABLE [dbo].[pv_recoveryRequests] CHECK CONSTRAINT [FK_pv_recoveryRequests_pv_syncedDevices]
GO
ALTER TABLE [dbo].[pv_recoveryRequests]  WITH CHECK ADD  CONSTRAINT [FK_pv_recoveryRequests_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_recoveryRequests] CHECK CONSTRAINT [FK_pv_recoveryRequests_pv_users]
GO
ALTER TABLE [dbo].[pv_resultDetails]  WITH CHECK ADD  CONSTRAINT [FK_pv_resultDetails_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_resultDetails] CHECK CONSTRAINT [FK_pv_resultDetails_pv_groups]
GO
ALTER TABLE [dbo].[pv_resultDetails]  WITH CHECK ADD  CONSTRAINT [FK_pv_resultDetails_pv_institutions] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_resultDetails] CHECK CONSTRAINT [FK_pv_resultDetails_pv_institutions]
GO
ALTER TABLE [dbo].[pv_resultDetails]  WITH CHECK ADD  CONSTRAINT [FK_pv_resultDetails_pv_votingResult] FOREIGN KEY([votingResultID])
REFERENCES [dbo].[pv_votingResult] ([votingResultID])
GO
ALTER TABLE [dbo].[pv_resultDetails] CHECK CONSTRAINT [FK_pv_resultDetails_pv_votingResult]
GO
ALTER TABLE [dbo].[pv_secureTransaction]  WITH CHECK ADD  CONSTRAINT [FK_pv_secureTransaction_pv_digitalSignature] FOREIGN KEY([digitalSignatureID])
REFERENCES [dbo].[pv_digitalSignature] ([digitalSignatureID])
GO
ALTER TABLE [dbo].[pv_secureTransaction] CHECK CONSTRAINT [FK_pv_secureTransaction_pv_digitalSignature]
GO
ALTER TABLE [dbo].[pv_securityAlert]  WITH CHECK ADD  CONSTRAINT [FK_pv_securityAlert_pv_loginAttempts] FOREIGN KEY([attemptsID])
REFERENCES [dbo].[pv_loginAttempts] ([loginAttemptID])
GO
ALTER TABLE [dbo].[pv_securityAlert] CHECK CONSTRAINT [FK_pv_securityAlert_pv_loginAttempts]
GO
ALTER TABLE [dbo].[pv_securityPatch]  WITH CHECK ADD  CONSTRAINT [FK_pv_securityPatch_pv_appInstance] FOREIGN KEY([appInstanceID])
REFERENCES [dbo].[pv_appInstance] ([appInstanceID])
GO
ALTER TABLE [dbo].[pv_securityPatch] CHECK CONSTRAINT [FK_pv_securityPatch_pv_appInstance]
GO
ALTER TABLE [dbo].[pv_securityPatch]  WITH CHECK ADD  CONSTRAINT [FK_pv_securityPatch_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_securityPatch] CHECK CONSTRAINT [FK_pv_securityPatch_pv_server]
GO
ALTER TABLE [dbo].[pv_securityPolicy]  WITH CHECK ADD  CONSTRAINT [FK_pv_securityPolicy_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_securityPolicy] CHECK CONSTRAINT [FK_pv_securityPolicy_pv_users]
GO
ALTER TABLE [dbo].[pv_securityToken]  WITH CHECK ADD  CONSTRAINT [FK_pv_securityToken_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_securityToken] CHECK CONSTRAINT [FK_pv_securityToken_pv_users]
GO
ALTER TABLE [dbo].[pv_SSLcertificate]  WITH CHECK ADD  CONSTRAINT [FK_pv_SSLcertificate_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_SSLcertificate] CHECK CONSTRAINT [FK_pv_SSLcertificate_pv_server]
GO
ALTER TABLE [dbo].[pv_supportMessage]  WITH CHECK ADD  CONSTRAINT [FK_pv_supportMessage_pv_supportTicket] FOREIGN KEY([supportTicketID])
REFERENCES [dbo].[pv_supportTicket] ([supportTicketID])
GO
ALTER TABLE [dbo].[pv_supportMessage] CHECK CONSTRAINT [FK_pv_supportMessage_pv_supportTicket]
GO
ALTER TABLE [dbo].[pv_supportTicket]  WITH CHECK ADD  CONSTRAINT [FK_pv_supportTicket_pv_users1] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_supportTicket] CHECK CONSTRAINT [FK_pv_supportTicket_pv_users1]
GO
ALTER TABLE [dbo].[pv_syncedDevices]  WITH CHECK ADD  CONSTRAINT [FK_pv_syncedDevices_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_syncedDevices] CHECK CONSTRAINT [FK_pv_syncedDevices_pv_users]
GO
ALTER TABLE [dbo].[pv_systemAuditory]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemAuditory_pv_cryptographicKeys] FOREIGN KEY([cryptographicKey])
REFERENCES [dbo].[pv_cryptographicKeys] ([cryptographicKeyID])
GO
ALTER TABLE [dbo].[pv_systemAuditory] CHECK CONSTRAINT [FK_pv_systemAuditory_pv_cryptographicKeys]
GO
ALTER TABLE [dbo].[pv_systemAuditory]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemAuditory_pv_eventType] FOREIGN KEY([eventTypeID])
REFERENCES [dbo].[pv_eventType] ([eventTypesID])
GO
ALTER TABLE [dbo].[pv_systemAuditory] CHECK CONSTRAINT [FK_pv_systemAuditory_pv_eventType]
GO
ALTER TABLE [dbo].[pv_systemAuditory]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemAuditory_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_systemAuditory] CHECK CONSTRAINT [FK_pv_systemAuditory_pv_users]
GO
ALTER TABLE [dbo].[pv_systemIncident]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemIncident_pv_appInstance] FOREIGN KEY([applicationInstanceID])
REFERENCES [dbo].[pv_appInstance] ([appInstanceID])
GO
ALTER TABLE [dbo].[pv_systemIncident] CHECK CONSTRAINT [FK_pv_systemIncident_pv_appInstance]
GO
ALTER TABLE [dbo].[pv_systemIncident]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemIncident_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_systemIncident] CHECK CONSTRAINT [FK_pv_systemIncident_pv_server]
GO
ALTER TABLE [dbo].[pv_systemLocks]  WITH CHECK ADD  CONSTRAINT [FK_pv_sytemLocks_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_systemLocks] CHECK CONSTRAINT [FK_pv_sytemLocks_pv_users]
GO
ALTER TABLE [dbo].[pv_systemMonitor]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemMonitor_pv_appInstance] FOREIGN KEY([applicationInstanceID])
REFERENCES [dbo].[pv_appInstance] ([appInstanceID])
GO
ALTER TABLE [dbo].[pv_systemMonitor] CHECK CONSTRAINT [FK_pv_systemMonitor_pv_appInstance]
GO
ALTER TABLE [dbo].[pv_systemMonitor]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemMonitor_pv_server] FOREIGN KEY([serverID])
REFERENCES [dbo].[pv_server] ([serverID])
GO
ALTER TABLE [dbo].[pv_systemMonitor] CHECK CONSTRAINT [FK_pv_systemMonitor_pv_server]
GO
ALTER TABLE [dbo].[pv_systemParameter]  WITH CHECK ADD  CONSTRAINT [FK_pv_systemParameter_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_systemParameter] CHECK CONSTRAINT [FK_pv_systemParameter_pv_users]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_balanceTypes] FOREIGN KEY([balanceTypeID])
REFERENCES [dbo].[pv_balanceTypes] ([balanceTypeID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_balanceTypes]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_currencies] FOREIGN KEY([currencyID])
REFERENCES [dbo].[pv_currencies] ([currencyID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_currencies]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_paymentMethods] FOREIGN KEY([paymentMethodsID])
REFERENCES [dbo].[pv_paymentMethods] ([paymentMethodID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_paymentMethods]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_payments] FOREIGN KEY([paymentMethodsID])
REFERENCES [dbo].[pv_payments] ([paymentID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_payments]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_transactionSubType] FOREIGN KEY([transactionSubtypeID])
REFERENCES [dbo].[pv_transactionSubType] ([transactionSubTypeID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_transactionSubType]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_transactionType] FOREIGN KEY([transactionTypeID])
REFERENCES [dbo].[pv_transactionType] ([transactionTypeID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_transactionType]
GO
ALTER TABLE [dbo].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [FK_pv_transactions_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_transactions] CHECK CONSTRAINT [FK_pv_transactions_pv_users]
GO
ALTER TABLE [dbo].[pv_translation]  WITH CHECK ADD  CONSTRAINT [FK_pv_translation_pv_systemLanguage] FOREIGN KEY([systemLanguageID])
REFERENCES [dbo].[pv_systemLanguage] ([systemLanguageID])
GO
ALTER TABLE [dbo].[pv_translation] CHECK CONSTRAINT [FK_pv_translation_pv_systemLanguage]
GO
ALTER TABLE [dbo].[pv_UIconfiguration]  WITH CHECK ADD  CONSTRAINT [FK_pv_UIconfiguration_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_UIconfiguration] CHECK CONSTRAINT [FK_pv_UIconfiguration_pv_users]
GO
ALTER TABLE [dbo].[pv_userContactInfo]  WITH CHECK ADD  CONSTRAINT [FK_pv_userContactInfo_pv_contactInfoType] FOREIGN KEY([contactInfoTypeID])
REFERENCES [dbo].[pv_contactInfoType] ([contactInfoTypeID])
GO
ALTER TABLE [dbo].[pv_userContactInfo] CHECK CONSTRAINT [FK_pv_userContactInfo_pv_contactInfoType]
GO
ALTER TABLE [dbo].[pv_userContactInfo]  WITH CHECK ADD  CONSTRAINT [FK_pv_userContactInfo_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userContactInfo] CHECK CONSTRAINT [FK_pv_userContactInfo_pv_users]
GO
ALTER TABLE [dbo].[pv_userDemographics]  WITH CHECK ADD  CONSTRAINT [FK_pv_userDemographics_pv_userDemographicTypes] FOREIGN KEY([userDemographicTypeID])
REFERENCES [dbo].[pv_userDemographicTypes] ([userDemographicTypeID])
GO
ALTER TABLE [dbo].[pv_userDemographics] CHECK CONSTRAINT [FK_pv_userDemographics_pv_userDemographicTypes]
GO
ALTER TABLE [dbo].[pv_userDemographics]  WITH CHECK ADD  CONSTRAINT [FK_pv_userDemographics_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userDemographics] CHECK CONSTRAINT [FK_pv_userDemographics_pv_users]
GO
ALTER TABLE [dbo].[pv_userDemographics]  WITH CHECK ADD  CONSTRAINT [FK_pv_userDemographics_pv_users1] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userDemographics] CHECK CONSTRAINT [FK_pv_userDemographics_pv_users1]
GO
ALTER TABLE [dbo].[pv_userDemographicTypes]  WITH CHECK ADD  CONSTRAINT [FK_pv_userDemographicTypes_pv_dataTypes] FOREIGN KEY([dataTypeID])
REFERENCES [dbo].[pv_dataTypes] ([dataTypeID])
GO
ALTER TABLE [dbo].[pv_userDemographicTypes] CHECK CONSTRAINT [FK_pv_userDemographicTypes_pv_dataTypes]
GO
ALTER TABLE [dbo].[pv_userGuide]  WITH CHECK ADD  CONSTRAINT [FK_pv_userGuide_pv_systemLanguage] FOREIGN KEY([systemLanguageID])
REFERENCES [dbo].[pv_systemLanguage] ([systemLanguageID])
GO
ALTER TABLE [dbo].[pv_userGuide] CHECK CONSTRAINT [FK_pv_userGuide_pv_systemLanguage]
GO
ALTER TABLE [dbo].[pv_userGuide]  WITH CHECK ADD  CONSTRAINT [FK_pv_userGuide_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userGuide] CHECK CONSTRAINT [FK_pv_userGuide_pv_users]
GO
ALTER TABLE [dbo].[pv_userLocks]  WITH CHECK ADD  CONSTRAINT [FK_pv_userLocks_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userLocks] CHECK CONSTRAINT [FK_pv_userLocks_pv_users]
GO
ALTER TABLE [dbo].[pv_userProfiles]  WITH CHECK ADD  CONSTRAINT [FK_pv_userProfile_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_userProfiles] CHECK CONSTRAINT [FK_pv_userProfile_pv_users]
GO
ALTER TABLE [dbo].[pv_userRole]  WITH CHECK ADD  CONSTRAINT [FK_pv_userRole_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_userRole] CHECK CONSTRAINT [FK_pv_userRole_pv_groups]
GO
ALTER TABLE [dbo].[pv_userRole]  WITH CHECK ADD  CONSTRAINT [FK_pv_userRole_pv_institution] FOREIGN KEY([institutionID])
REFERENCES [dbo].[pv_institutions] ([institutionID])
GO
ALTER TABLE [dbo].[pv_userRole] CHECK CONSTRAINT [FK_pv_userRole_pv_institution]
GO
ALTER TABLE [dbo].[pv_userRole]  WITH CHECK ADD  CONSTRAINT [FK_pv_userRole_pv_systemRoles] FOREIGN KEY([systemRoleID])
REFERENCES [dbo].[pv_systemRoles] ([systemRoleID])
GO
ALTER TABLE [dbo].[pv_userRole] CHECK CONSTRAINT [FK_pv_userRole_pv_systemRoles]
GO
ALTER TABLE [dbo].[pv_users]  WITH CHECK ADD  CONSTRAINT [FK_pv_users_pv_accountStatus] FOREIGN KEY([accountStatusID])
REFERENCES [dbo].[pv_accountStatus] ([accountStatusID])
GO
ALTER TABLE [dbo].[pv_users] CHECK CONSTRAINT [FK_pv_users_pv_accountStatus]
GO
ALTER TABLE [dbo].[pv_voteAllowedGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteAllowedGroups_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_voteAllowedGroups] CHECK CONSTRAINT [FK_pv_voteAllowedGroups_pv_groups]
GO
ALTER TABLE [dbo].[pv_voteAllowedGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteAllowedGroups_pv_votes] FOREIGN KEY([voteID])
REFERENCES [dbo].[pv_votes] ([voteID])
GO
ALTER TABLE [dbo].[pv_voteAllowedGroups] CHECK CONSTRAINT [FK_pv_voteAllowedGroups_pv_votes]
GO
ALTER TABLE [dbo].[pv_voteHash]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteHash_pv_votes] FOREIGN KEY([voteID])
REFERENCES [dbo].[pv_votes] ([voteID])
GO
ALTER TABLE [dbo].[pv_voteHash] CHECK CONSTRAINT [FK_pv_voteHash_pv_votes]
GO
ALTER TABLE [dbo].[pv_voteQuestions]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteQuestions_pv_questionTypes] FOREIGN KEY([questionTypeID])
REFERENCES [dbo].[pv_questionTypes] ([questionTypeID])
GO
ALTER TABLE [dbo].[pv_voteQuestions] CHECK CONSTRAINT [FK_pv_voteQuestions_pv_questionTypes]
GO
ALTER TABLE [dbo].[pv_voteQuestions]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteQuestions_pv_votes] FOREIGN KEY([voteID])
REFERENCES [dbo].[pv_votes] ([voteID])
GO
ALTER TABLE [dbo].[pv_voteQuestions] CHECK CONSTRAINT [FK_pv_voteQuestions_pv_votes]
GO
ALTER TABLE [dbo].[pv_voteQuestionsOptions]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteQuestionsOptions_pv_dataTypes] FOREIGN KEY([dataTypeID])
REFERENCES [dbo].[pv_dataTypes] ([dataTypeID])
GO
ALTER TABLE [dbo].[pv_voteQuestionsOptions] CHECK CONSTRAINT [FK_pv_voteQuestionsOptions_pv_dataTypes]
GO
ALTER TABLE [dbo].[pv_voteQuestionsOptions]  WITH CHECK ADD  CONSTRAINT [FK_pv_voteQuestionsOptions_pv_voteQuestions] FOREIGN KEY([questionID])
REFERENCES [dbo].[pv_voteQuestions] ([voteQuestionID])
GO
ALTER TABLE [dbo].[pv_voteQuestionsOptions] CHECK CONSTRAINT [FK_pv_voteQuestionsOptions_pv_voteQuestions]
GO
ALTER TABLE [dbo].[pv_votes]  WITH CHECK ADD  CONSTRAINT [FK_pv_votes_pv_projects] FOREIGN KEY([projectID])
REFERENCES [dbo].[pv_projects] ([projectID])
GO
ALTER TABLE [dbo].[pv_votes] CHECK CONSTRAINT [FK_pv_votes_pv_projects]
GO
ALTER TABLE [dbo].[pv_votes]  WITH CHECK ADD  CONSTRAINT [FK_pv_votes_pv_propposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_votes] CHECK CONSTRAINT [FK_pv_votes_pv_propposals]
GO
ALTER TABLE [dbo].[pv_votes]  WITH CHECK ADD  CONSTRAINT [FK_pv_votes_pv_voteQuestions] FOREIGN KEY([questionID])
REFERENCES [dbo].[pv_voteQuestions] ([voteQuestionID])
GO
ALTER TABLE [dbo].[pv_votes] CHECK CONSTRAINT [FK_pv_votes_pv_voteQuestions]
GO
ALTER TABLE [dbo].[pv_votes]  WITH CHECK ADD  CONSTRAINT [FK_pv_votes_pv_voteQuestionsOptions] FOREIGN KEY([optionID])
REFERENCES [dbo].[pv_voteQuestionsOptions] ([voteQuestionOptionsID])
GO
ALTER TABLE [dbo].[pv_votes] CHECK CONSTRAINT [FK_pv_votes_pv_voteQuestionsOptions]
GO
ALTER TABLE [dbo].[pv_votes]  WITH CHECK ADD  CONSTRAINT [FK_pv_votes_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votes] CHECK CONSTRAINT [FK_pv_votes_pv_votings]
GO
ALTER TABLE [dbo].[pv_votingCore]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingCore_pv_votingCoreResultTypes] FOREIGN KEY([votingCoreResultTypeID])
REFERENCES [dbo].[pv_votingCoreResultTypes] ([votingCoreResultTypeID])
GO
ALTER TABLE [dbo].[pv_votingCore] CHECK CONSTRAINT [FK_pv_votingCore_pv_votingCoreResultTypes]
GO
ALTER TABLE [dbo].[pv_votingCore]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingCore_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votingCore] CHECK CONSTRAINT [FK_pv_votingCore_pv_votings]
GO
ALTER TABLE [dbo].[pv_votingNotification]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingNotification_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votingNotification] CHECK CONSTRAINT [FK_pv_votingNotification_pv_votings]
GO
ALTER TABLE [dbo].[pv_votingPeriod]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingPeriod_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votingPeriod] CHECK CONSTRAINT [FK_pv_votingPeriod_pv_votings]
GO
ALTER TABLE [dbo].[pv_votingResult]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingResult_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votingResult] CHECK CONSTRAINT [FK_pv_votingResult_pv_votings]
GO
ALTER TABLE [dbo].[pv_votings]  WITH CHECK ADD  CONSTRAINT [FK_pv_votings_pv_projects] FOREIGN KEY([projectID])
REFERENCES [dbo].[pv_projects] ([projectID])
GO
ALTER TABLE [dbo].[pv_votings] CHECK CONSTRAINT [FK_pv_votings_pv_projects]
GO
ALTER TABLE [dbo].[pv_votings]  WITH CHECK ADD  CONSTRAINT [FK_pv_votings_pv_proposals] FOREIGN KEY([proposalID])
REFERENCES [dbo].[pv_propposals] ([proposalID])
GO
ALTER TABLE [dbo].[pv_votings] CHECK CONSTRAINT [FK_pv_votings_pv_proposals]
GO
ALTER TABLE [dbo].[pv_votings]  WITH CHECK ADD  CONSTRAINT [FK_pv_votings_pv_votingStatuses] FOREIGN KEY([votingStatusID])
REFERENCES [dbo].[pv_votingStatuses] ([votingStatusID])
GO
ALTER TABLE [dbo].[pv_votings] CHECK CONSTRAINT [FK_pv_votings_pv_votingStatuses]
GO
ALTER TABLE [dbo].[pv_votingTargetGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingTargetGroups_pv_groups] FOREIGN KEY([groupID])
REFERENCES [dbo].[pv_groups] ([groupID])
GO
ALTER TABLE [dbo].[pv_votingTargetGroups] CHECK CONSTRAINT [FK_pv_votingTargetGroups_pv_groups]
GO
ALTER TABLE [dbo].[pv_votingTargetGroups]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingTargetGroups_pv_votingCore] FOREIGN KEY([votingCoreID])
REFERENCES [dbo].[pv_votingCore] ([votingCoreID])
GO
ALTER TABLE [dbo].[pv_votingTargetGroups] CHECK CONSTRAINT [FK_pv_votingTargetGroups_pv_votingCore]
GO
ALTER TABLE [dbo].[pv_votingToken]  WITH CHECK ADD  CONSTRAINT [FK_pv_votingToken_pv_votings] FOREIGN KEY([votingID])
REFERENCES [dbo].[pv_votings] ([votingID])
GO
ALTER TABLE [dbo].[pv_votingToken] CHECK CONSTRAINT [FK_pv_votingToken_pv_votings]
GO
ALTER TABLE [dbo].[pv_workflowInstanceParameters]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowInstanceParameters_pv_dataTypes] FOREIGN KEY([dataTypeID])
REFERENCES [dbo].[pv_dataTypes] ([dataTypeID])
GO
ALTER TABLE [dbo].[pv_workflowInstanceParameters] CHECK CONSTRAINT [FK_pv_workflowInstanceParameters_pv_dataTypes]
GO
ALTER TABLE [dbo].[pv_workflowInstanceParameters]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowInstanceParameters_pv_workFlowsInstances] FOREIGN KEY([workflowInstanceID])
REFERENCES [dbo].[pv_workFlowsInstances] ([workFlowID])
GO
ALTER TABLE [dbo].[pv_workflowInstanceParameters] CHECK CONSTRAINT [FK_pv_workflowInstanceParameters_pv_workFlowsInstances]
GO
ALTER TABLE [dbo].[pv_workflowLogs]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowLogs_pv_users] FOREIGN KEY([userID])
REFERENCES [dbo].[pv_users] ([userID])
GO
ALTER TABLE [dbo].[pv_workflowLogs] CHECK CONSTRAINT [FK_pv_workflowLogs_pv_users]
GO
ALTER TABLE [dbo].[pv_workflowLogs]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowLogs_pv_workflowLogTypes] FOREIGN KEY([workflowLogTypeID])
REFERENCES [dbo].[pv_workflowLogTypes] ([workflowLogTypeID])
GO
ALTER TABLE [dbo].[pv_workflowLogs] CHECK CONSTRAINT [FK_pv_workflowLogs_pv_workflowLogTypes]
GO
ALTER TABLE [dbo].[pv_workflowLogs]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowLogs_pv_workFlows] FOREIGN KEY([workflowInstanceID])
REFERENCES [dbo].[pv_workFlowsInstances] ([workFlowID])
GO
ALTER TABLE [dbo].[pv_workflowLogs] CHECK CONSTRAINT [FK_pv_workflowLogs_pv_workFlows]
GO
ALTER TABLE [dbo].[pv_workflowParameters]  WITH CHECK ADD  CONSTRAINT [FK_pv_workflowParameters_pv_workflowDefinitions] FOREIGN KEY([workflowDefinitionID])
REFERENCES [dbo].[pv_workflowDefinitions] ([workflowDefinitionID])
GO
ALTER TABLE [dbo].[pv_workflowParameters] CHECK CONSTRAINT [FK_pv_workflowParameters_pv_workflowDefinitions]
GO
ALTER TABLE [dbo].[pv_workFlowsInstances]  WITH CHECK ADD  CONSTRAINT [FK_pv_workFlows_pv_proposalDocument] FOREIGN KEY([proposalDocumentID])
REFERENCES [dbo].[pv_proposalDocument] ([proposalDocumentID])
GO
ALTER TABLE [dbo].[pv_workFlowsInstances] CHECK CONSTRAINT [FK_pv_workFlows_pv_proposalDocument]
GO
ALTER TABLE [dbo].[pv_workFlowsInstances]  WITH CHECK ADD  CONSTRAINT [FK_pv_workFlows_pv_validationStatus] FOREIGN KEY([validationStatusID])
REFERENCES [dbo].[pv_validationStatus] ([validationStatusID])
GO
ALTER TABLE [dbo].[pv_workFlowsInstances] CHECK CONSTRAINT [FK_pv_workFlows_pv_validationStatus]
GO
ALTER TABLE [dbo].[pv_workFlowsInstances]  WITH CHECK ADD  CONSTRAINT [FK_pv_workFlows_pv_workflowDefinitions] FOREIGN KEY([workflowsDefinitionID])
REFERENCES [dbo].[pv_workflowDefinitions] ([workflowDefinitionID])
GO
ALTER TABLE [dbo].[pv_workFlowsInstances] CHECK CONSTRAINT [FK_pv_workFlows_pv_workflowDefinitions]
GO
/****** Object:  StoredProcedure [dbo].[invertir]    Script Date: 6/10/2025 7:47:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[invertir]
    @proposalID INT, -- ID de la propuesta
    @userID INT, -- ID del inversionista
    @amount DECIMAL(18,2), -- Monto invertido
    @paymentMethodID INT -- Método de pago
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aquí iría la lógica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
/****** Object:  StoredProcedure [dbo].[revisarPropuesta]    Script Date: 6/10/2025 7:47:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[revisarPropuesta]
    @proposalID INT, -- ID de la propuesta a revisar
    @reviewerID INT, -- ID del revisor
    @validationResult NVARCHAR(255), -- Resultado de la validación (aprobado/rechazado)
    @aiPayload NVARCHAR(MAX) = NULL -- Payload para IA (opcional)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aquí iría la lógica completa, pero por ahora solo retornamos 0
    RETURN 0;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateUpdateProposal]    Script Date: 6/10/2025 7:47:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CreateUpdateProposal]
  @ProposalID INT,
  @Name NVARCHAR(150),
  @UserID INT,
  @ProposalTypeID INT, -- Quitamos el = NULL para hacerlo obligatorio
  @IntegrityHash VARBINARY(512) = NULL,
  @Status NVARCHAR(50) OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRANSACTION;
  BEGIN TRY
    -- Validar que @ProposalTypeID no sea NULL
    IF @ProposalTypeID IS NULL
      THROW 50002, 'El ProposalTypeID es obligatorio.', 1;

    -- Generar un integrityHash predeterminado si es NULL
    DECLARE @FinalIntegrityHash VARBINARY(512);
    SET @FinalIntegrityHash = ISNULL(@IntegrityHash, HASHBYTES('SHA2_256', CAST(NEWID() AS NVARCHAR(36))));

    IF @ProposalID IS NULL
      BEGIN
        INSERT INTO pv_propposals (name, userID, proposalTypeID, createdAt, lastUpdate, integrityHash)
        VALUES (@Name, @UserID, @ProposalTypeID, GETDATE(), GETDATE(), @FinalIntegrityHash);
        SET @ProposalID = SCOPE_IDENTITY();
        SET @Status = 'Pending';
      END
    ELSE
      BEGIN
        UPDATE pv_propposals
        SET name = @Name, 
            userID = @UserID, 
            proposalTypeID = @ProposalTypeID, 
            lastUpdate = GETDATE(), 
            integrityHash = @FinalIntegrityHash
        WHERE proposalID = @ProposalID AND userID = @UserID;
        SET @Status = 'Pending';
      END

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    THROW 50001, @ErrorMessage, 1;
  END CATCH;
END;
GO
GO
ALTER DATABASE [Caso3DB] SET  READ_WRITE 
GO
