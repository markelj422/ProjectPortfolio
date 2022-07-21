USE SQLCourse_DB
--Create Database SQLCourse_DB

IF OBJECT_ID('TestTable') IS NOT NULL DROP TABLE TestTable
GO
IF OBJECT_ID('HospitalTable') IS NOT NULL DROP TABLE HospitalTable
GO

Create Table TestTable 
	(PatientID varchar(255) Not Null Primary Key
	,LocationID varchar(255) Not Null 
	,PatientName varchar(255) Not Null 
	,PatientState varchar(255) Not Null
	,Gender varchar(255) Not Null
	,Visits int Null
	,Charges int Null Default 0)

INSERT INTO TestTable
           (PatientID
		   ,LocationID
           ,PatientName
           ,PatientState
           ,Gender
           ,Visits
		   ,Charges)
     VALUES
	 ('12345','785522','John','AL','M','3','200')
	,('12346','785623','Jane','AK','F','1','400')
	,('12347','785724','Alex','AZ','F','6','900')
	,('12348','785825','Bob','CA','M','7','8000')
	,('12349','785926','Josh','CO','M','12','19000')
	,('12350','786027','Stephanie','FL','F','18','25000')
	,('12351','786128','Amber','GA','F','4','400')
	,('12352','786229','Brittany','GA','F','6','4000')
	,('12353','786330','Bill','UT','M','8','5000')
	,('12354','786431','Nate','WY','M','22','28000')
	,('12355','785522','Joe','GA','M','8','1900')
	,('12356','785623','Garret','GA','M','1','900')
	,('12357','785724','Jill','UT','F','8','8000')
	,('12358','785825','Justin','WY','M','2','300')
	,('12359','785926','Bret','UT','M','2','5000')
	,('12360','786027','Kellie','WY','F','20','29000')
	,('12361','786229','Gerald','GA','M','3','1900')
	,('12362','786330','Rudy','GA','M','1','400')
	,('12363','786431','Ruby','UT','F','4','2000')
	,('12364','785724','Ava','WY','F','6','3300')
	,('12365','785926','Liam','AL','M','4','1200')
	,('12366','786229','Rich','AK','M','7','4400')
	,('12367','786330','Alice','AZ','F','9','1900')
	,('12368','786532','Kris','CA','M',null,'1000')
	,('12369','786431','Arthur','CO','M','15','9000')

CREATE TABLE HospitalTable 
	(LocationID varchar(255) Not Null Primary Key,
	LocationName varchar(255))

INSERT INTO HospitalTable
           (LocationID
           ,LocationName)
     VALUES
		('785522','Evergreen Clinic')
		,('785623','Twin Mountains Hospital')
		,('785724','Big Heart Community Hospital')
		,('785825','Pioneer Clinic')
		,('785926','Fairmont Hospital Center')
		,('786027','Angelstone Community Hospital')
		,('786128','Genesis Hospital Center')
		,('786229','Principal Medical Clinic')
		,('786330','Fairview General Hospital')
		,('786431','Guardian Medical Clinic')
		,('786532','Memorial Medical Center')

---- Round ----
Select 
	PatientID
	,PatientName
	,Round(Charges + 0.2555,2) as Charges
From TestTable 


---- Cast and Convert ----
Select 
	PatientID
	,PatientName
	,Round(Charges + 0.2555,2) as Charges
	,Cast(Round(Charges + 0.2555,2) as Decimal (12,2)) as ChargesCast
	,Convert(Decimal (12,3),Round(Charges + 0.2555,2)) as ChargesConvert
From TestTable 


---- Format ----
Select 
	PatientID
	,PatientName
	,Round(Charges + 0.2555,2) as Charges
	,Format(Round(Charges + 0.2555,2),'$#,###.##','en-US') as ChargesFormat
From TestTable 


---- Upper and Lower ----
Select 
	PatientName
	,Upper(PatientName) as UpperPatientName
	,Lower(PatientName) as LowerPatientName
From TestTable


---- IsNull ----
Select 
PatientName
,IsNull(Visits,0) as Visits
From TestTable
Where Visits is null
Order By 2 desc


---- Nullif ----
Update TestTable
Set Visits = 0 
Where PatientID = '12368'

Select * 
From TestTable

Select 
LocationName
,Sum(Charges) as 'Charges' 
,Sum(Charges)/Nullif(Sum(Visits),0) as 'ChargesPerVisit'
From HospitalTable
Inner Join TestTable
on TestTable.LocationID = HospitalTable.LocationID
Group By LocationName


---- Inner Queries (Nested Query) ----
--How many states have more than 2 patients?

Select Count(*) as 'Count'
From (
Select 
	PatientState
	,Count(*) as 'Count'
From TestTable
Group By PatientState
Having Count(*) > 2) as A1


---- Stored Procedures ----
Create Procedure SelectAllPatients 
As
Select * From TestTable

Exec SelectAllPatients

Create Procedure LocationCharges
As
Select 
	LocationName
	,Sum(Charges) as Charges
From TestTable
Inner Join HospitalTable
on HospitalTable.LocationID = TestTable.LocationID
Group By LocationName
Order By LocationName asc

Exec LocationCharges


---- Updating Data Using Another Table ----
Alter Table TestTable 
Add LocationName varchar (255)

Select * from TestTable

Update TestTable
Set TestTable.LocationName = HospitalTable.LocationName
From TestTable
Inner Join HospitalTable
on HospitalTable.LocationID = TestTable.LocationID


		---- Constraints ----

---- List of Constraints ----
--Not Null    [Sec. 4]
--Primary Key [Sec. 4]
	-- Primary Key is Combo of Not Null and Unique
--Foreign Key [Sec. 7]
--Unique 
--Check


Alter Table TestTable
Drop Constraint PK__TestTabl__970EC346A314D8BC
	--Get Cnstraint Name from Object Exporer--
	
Alter Table TestTable
Drop Constraint [DF__TestTable__Charg__7A3223E8]


---- Left and Right ----
Update TestTable
Set Gender = 'Male' 
Where Gender = 'M'

Update TestTable
Set Gender = 'Female' 
Where Gender = 'F'

Select * from TestTable

Select
	PatientName
	,Left(Gender,1) as Gender
	, Right(LocationID,4) as SimpleLocationID
From TestTable


---- Trim ----
Select 
	LocationName
	,Trim(LocationName) as LocationName
From HospitalTable