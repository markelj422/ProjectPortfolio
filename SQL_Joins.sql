--Using character names from show "The Office" for examples

--How to Create Tables
USE SQLTutorial

CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

CREATE TABLE EmployeeSalary
(EmployeeId int,
JobTitle varchar(50),
Salary int)

--How to Insert Data Into Tables

INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

SELECT * FROM EmployeeDemographics  --To view inserted data

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

SELECT * FROM EmployeeSalary  --To view inserted data

-- Inner/Full/Left/Right/Outer Joins 
--Inserting Data to Fully Showcase Joins

Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Insert into EmployeeSalary VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)

--Find what columns to join 
SELECT *
FROM EmployeeDemographics

SELECT * 
FROM EmployeeSalary    

--Inner Join
SELECT *
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

--Full Outer Join
SELECT *
FROM EmployeeDemographics
FULL OUTER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

--Left Outer Join
SELECT *
FROM EmployeeDemographics
LEFT OUTER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

--Right Outer Join
SELECT *
FROM EmployeeDemographics
RIGHT OUTER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId


--Examples:

SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary    --If column is in both tables, specify which table you want to use from
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

--Notice how using different tables with same columns is different for Left/Right Joins
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary   
FROM EmployeeDemographics
RIGHT JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

SELECT EmployeeSalary.EmployeeID, FirstName, LastName, JobTitle, Salary       --Identical except it has ID '1010' 
FROM EmployeeDemographics
RIGHT JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

--^^ Left Join
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary   
FROM EmployeeDemographics
LEFT JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId

SELECT EmployeeSalary.EmployeeID, FirstName, LastName, JobTitle, Salary       --Identical but no ID's because were joining left table but viewing right table
FROM EmployeeDemographics
LEFT JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId


--Let's say we wanted to identify the employees who make the most money (Not including Michael Scott)
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, Salary
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId
WHERE FirstName != 'Michael'
ORDER BY Salary DESC

--Let's say we want to calculate our average salary for employees that are salesmen
SELECT JobTitle, AVG(Salary) as AverageSalary
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle
