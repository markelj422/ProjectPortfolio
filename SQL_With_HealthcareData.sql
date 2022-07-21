-------------------------------Section 5-------------------------------
----------------------------Retrieving Data----------------------------
Use SQLCourse_DB

IF OBJECT_ID('TestTable') IS NOT NULL DROP TABLE TestTable
GO

Create Table TestTable 
	(PatientID varchar(255) Not Null Primary Key
	,PatientName varchar(255) Not Null
	,PatientState varchar(255) Not Null
	,Gender varchar(255) Not Null
	,Visits int Null
	,Charges int Null Default 0)

INSERT INTO TestTable
           (PatientID
           ,PatientName
           ,PatientState
           ,Gender
           ,Visits
		   ,Charges)
     VALUES
	 ('12345','John','AL','M','3','200')
	,('12346','Jane','AK','F','1','400')
	,('12347','Alex','AZ','F','6','900')
	,('12348','Bob','CA','M','7','8000')
	,('12349','Josh','CO','M','12','19000')
	,('12350','Stephanie','FL','F','18','25000')
	,('12351','Amber','GA','F','4','400')
	,('12352','Brittany','GA','F','6','4000')
	,('12353','Bill','UT','M','8','5000')
	,('12354','Nate','WY','M','22','28000')
	,('12355','Joe','GA','M','8','1900')
	,('12356','Garret','GA','M','1','900')
	,('12357','Jill','UT','F','8','8000')
	,('12358','Justin','WY','M','2','300')
	,('12359','Bret','UT','M','2','5000')
	,('12360','Kellie','WY','F','20','29000')
	,('12361','Gerald','GA','M','3','1900')
	,('12362','Rudy','GA','M','1','400')
	,('12363','Ruby','UT','F','4','2000')
	,('12364','Ava','WY','F','6','3300')
	,('12365','Liam','AL','M','4','1200')
	,('12366','Rich','AK','M','7','4400')
	,('12367','Alice','AZ','F','9','1900')
	,('12368','Kris','CA','M',null,'1000')
	,('12369','Arthur','CO','M','15','9000')


Select * from TestTable

---- SELECT TOP ----
Select Top 10 * From TestTable

---- SELECT DISTINCT ----
Select Distinct * From TestTable

Select Distinct 
	PatientState
From TestTable


---- WHERE ----
Select
	*
From TestTable
Where PatientState = 'GA'
or Gender = 'F'


	Select
	*
	From TestTable
	where not Gender = 'F'

Select 
PatientName
,PatientState
From TestTable
Where Charges between '900' and '10000'


---- IN within WHERE ----
Select 
PatientName
,PatientState
From TestTable
Where PatientName in ('John','Brittany','Amber')


---- WHERE WITH WILDCARD FUNCTIONS ----
Select 
PatientName
,PatientState
From TestTable
Where PatientName Like 'J%'
	and PatientName Like '%E'

Select 
PatientName
,PatientState
From TestTable
Where PatientName Like 'Ru_y'

Select 
PatientName
From TestTable
Where Visits is not null  


---- ORDER BY ----
Select 
	PatientName
	,PatientState
From TestTable
Where Gender = 'M'
Order By 2 Asc


---- SELECT COUNT ----
Select COUNT(Distinct PatientState) From TestTable


---- GROUP BY ----
Select 
	Gender 
	,COUNT(Distinct PatientState) 
From TestTable
Group By Gender


---- ORDER BY ----
Select 
	PatientState
	,Count(*)
From TestTable
Group By PatientState
Order By 1 Desc


---- AGGREGATE FUNCTIONS ----
Select 
Gender
,Min(Charges)
,Max(Charges)
From TestTable
Where PatientState in ('FL','GA','CA')
Group By Gender
Order By 3 Asc


Select Top 3
	PatientName
	,Sum(Charges)
From TestTable
Group By PatientName
Order By 2 desc


Select Top 3
	PatientState
	,Sum(Charges)
From TestTable
Group By PatientState
Order By 2 asc

--This will give you an error... you cannot SUM people (varchar)**
Select top 3
	PatientState
	,Sum(PatientName)
From TestTable
Group By PatientState
Order By 2 asc


Select 
	PatientState
	,AVG(Charges)
	,COUNT(PatientID)
	,Sum(Charges)
	From TestTable
	group By PatientState
	Order By 4 desc


---- AS ----
Select 
	PatientState
	,AVG(Charges) As 'AvgCharge'
	,COUNT(PatientID) As 'NumberofPatients'
	,Sum(Charges) As 'SumofCharges'
	From TestTable
	group By PatientState
	Order By 2 desc


---- CONCAT ----
Select 
	Concat(PatientState, Gender) As 'Stategender_BadExample'
	,Concat(PatientState ,' - ', Gender) As 'StateGender_GoodExample'
	,Count(Distinct PatientName) as 'CountofPatients'
From TestTable
Group By PatientState,Gender


---- HAVING ----
Select 
	PatientState
	,Sum(Charges)
From TestTable
Group By PatientState
Having Sum(Charges) <> '9000'
Order By 1 asc


---- CASE WHEN ----
Select Distinct 
	PatientID
	,PatientName
	,PatientState
	,Case When PatientState = 'GA' Then 'Georgia'
		  When PatientState = 'AL' Then 'Alabama'
		  When PatientState = 'AK' Then 'Alaska'
		  When PatientState = 'AZ' Then 'Arizona'
		  When PatientState = 'UT' Then 'Utah'
		  Else PatientState
		  End as 'PatientState'
From TestTable
Where PatientState in ('GA','AL','AK','AZ','UT')


Select * From TestTable

Select Distinct 
	PatientID
	,PatientName
	,PatientState
	,Gender
	,Case When Gender = 'M' Then 'Male'
		  Else Gender 
		  End as Gender
From TestTable
Where Gender = 'M'
