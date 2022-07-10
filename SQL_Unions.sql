--Using Union, Union All with "The Office" Data we created 
--Union allows us to select all of the data from both tables into a SINGLE output where all data is in SINGLE column

--Creating a table for the Warehouse Employee's demographics
CREATE TABLE WarehouseEmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

INSERT INTO WarehouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')



SELECT *
FROM EmployeeDemographics

SELECT * 
FROM WarehouseEmployeeDemographics

--Full Join showcasing matching columns and data
SELECT * 
FROM EmployeeDemographics
FULL JOIN WarehouseEmployeeDemographics
	ON EmployeeDemographics.EmployeeID =
	WarehouseEmployeeDemographics.EmployeeID


--UNION (Place between two SELECT statements)
--Data from seperate columns will now be in one single column
SELECT *
FROM EmployeeDemographics
UNION
SELECT * 
FROM WarehouseEmployeeDemographics


-- UNION ALL puts ALL data into columns regardless of duplicates, etc.
--Notice that 'Darryl Philbin' is listed twice instead of once
SELECT *
FROM EmployeeDemographics
UNION ALL
SELECT * 
FROM WarehouseEmployeeDemographics
ORDER BY EmployeeID


--Let's try another example when the columns aren't an exact match 
SELECT *
FROM EmployeeDemographics

SELECT * 
FROM EmployeeSalary
ORDER BY EmployeeId


--This still works because there is a same number of columns along with the same data types.
--You shouldn't choose this way as the data in firstname and age column are formatted unneatly, so be sure that the data you're selecting is the same when using UNION
SELECT EmployeeID, FirstName, Age
FROM EmployeeDemographics
UNION
SELECT EmployeeId, JobTitle, Salary
FROM EmployeeSalary
ORDER BY EmployeeId