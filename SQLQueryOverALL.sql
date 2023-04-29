/*
Basic SQL Project For Practice

Here are a few basic problems related to employee demographics and salary that can be solved using SQL:

1) Retrieve a list of employees along with their basic information such as name, gender, date of birth, and salary.

2) Calculate the average salary of all employees in the company.

3) Retrieve a list of employees who earn more than $100,000 per year.

4) Retrieve a list of employees who earn less than $50,000 per year and have been with the company for more than 5 years.

5) Calculate the total number of male and female employees in the company.

6) Calculate the average salary of male and female employees separately.

7) Retrieve a list of employees who have joined the company in the last 6 months.

8) Retrieve a list of employees who have a job title of 'Manager' and earn more than $80,000 per year.

9) Calculate the average salary of employees by department.

10) Retrieve a list of employees who have the highest salary in their respective departments. 
*/

----------------------------------------------------------------------------------------------------------------------------------------


----- Retrieve a list of employees along with their basic information such as name, gender, date of birth, and salary. -----

Select FirstName,LastName,Gender,BirthDay,Salary
From JichuProject.dbo.EmployeeInfo As EmpInfo
Inner Join JichuProject.dbo.EmployeeSalaryInfo As Empsal
On EmpInfo.EmployeeID = Empsal.EmployeeID



----- Calculate the average salary of all employees in the company. -----

Select avg (Salary) As AverageSalary
From JichuProject.dbo.EmployeeSalaryInfo



----- Retrieve a list of Employees who earn more than $100,000 per year. -----

Select *
From JichuProject.dbo.EmployeeInfo As EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo As EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Where Salary >= 100000



----- Retrieve a list of employees who earn less than $50,000 per year and have been with the company for more than 5 years. -----

Select *
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID

Where  Salary <= 50000 and
 DATEDIFF (Year,HiredDate,GetDate()) = 5



----- Calculate the total number of male and female employees in the company. -----

Select Gender, Count (Gender) AS TotalCountofGender
From JichuProject.dbo.EmployeeInfo
Group by Gender



----- Calculate the average salary of male and female employees separately. -----

Select  Gender , avg(salary) as AVGofDiffirentGender
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group By Gender 

/* For Male Average Salary */
Select  avg (Salary) as MaleAverageSalary
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
where Gender = 'male'


/* For Female Average Salary */
Select  avg (Salary) as FemaleAverageSalary
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
where Gender = 'Female'



----- Retrieve a list of employees who have joined the company in the last 6 months. -----

Select *
From JichuProject.dbo.EmployeeInfo
Where DATEDIFF (Month,HiredDate,GetDate()) < 6
Order by HiredDate



----- Retrieve a list of employees who have a job title of 'Manager' and earn more than $160,000 per year. -----

Select *
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Where JobTitle = 'Manager' and Salary >= 160000



----- Calculate the average salary of employees by department. -----

Select JobTitle, avg (Salary) as AverageSalaryPerDeparment
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by JobTitle
Order by AverageSalaryPerDeparment desc



----- Retrieve a list of employees who have the highest salary in their respective departments. -----

Drop Table #temp_MaxSalary 

Create Table #temp_MaxSalary 
(Department varchar (50),
MaxSalary int 
)

Insert into #temp_MaxSalary
Select Department , Max (salary) AS MaxSalary
From JichuProject.dbo.EmployeeInfo AS EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo AS EmpSal
on EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by Department

/*Checking Syntax = Select * From #temp_MaxSalary*/

select FirstName,LastName,Age,Gender,JobTitle,Salary,MaxSalary
From JichuProject.dbo.EmployeeInfo as EmpInfo
join JichuProject.dbo.EmployeeSalaryInfo  as EmpSal 
on EmpInfo.EmployeeID = EmpSal.EmployeeID 
Join #temp_MaxSalary as MaxSalary
On MaxSalary.Department = EmpInfo.Department
Where Salary >= MaxSalary
