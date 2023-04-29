/*
1. Retrieve a list of employees along with their basic information such as name, gender, date of birth, department, job title, and salary, sorted by salary in descending order.

2. Calculate the total number of employees in each department and display the result along with the department name.

3. Retrieve a list of employees who have the same job title and are in the same department.

4. Calculate the average salary of employees in each department, and display the result along with the department name.

5. Retrieve a list of employees who have a salary that is greater than the average salary of their respective departments.

6. Calculate the total salary of all employees in the company.

7. Calculate the median salary of all employees in the company.

8. Identify the department with the highest average age of employees,and then determine the top 3 job titles with the highest average salary in that department.

9. Calculate the maximum salary for each department, and display the result along with the department name.

10. Calculate the minimum and maximum salary for each job title, and display the result along with the job title.
*/

----------------------------------------------------------------------------------------------------------------------------------------


----- Retrieve a list of employees along with their basic information such as name, gender, date of birth, department, job title, and salary, sorted by salary in descending order. -----

Select FirstName + ' ' + LastName AS FullName, Gender, BirthDay, JobTitle,Salary 
From JichuProject.dbo.EmployeeInfo AS EmpInfo
join JichuProject.dbo.EmployeeSalaryInfo AS EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Order by Salary desc



----- Calculate the total number of employees in each department and display the result along with the department name. -----

Select Jobtitle, COUNT(Jobtitle) as DepartmentMember
From JichuProject.dbo.EmployeeSalaryInfo
Group by jobtitle
Order by DepartmentMember desc



----- Retrieve a list of employees who have the same Gender and  the same Jobtitle. -----

Select *
From JichuProject.dbo.EmployeeInfo as Empinfo
Join JichuProject.dbo.EmployeeSalaryInfo as Empsal
On Empinfo.EmployeeID = Empsal.EmployeeID
where gender = 'Male'
order by JobTitle


Select *
From JichuProject.dbo.EmployeeInfo as Empinfo
Join JichuProject.dbo.EmployeeSalaryInfo as Empsal
On Empinfo.EmployeeID = Empsal.EmployeeID
where gender = 'FeMale'
order by JobTitle



----- Calculate the average salary of employees in each department, and display the result along with the department name. -----

Select Department, Avg(Salary) as AverageSalaryPerDepartment 
From JichuProject.dbo.EmployeeInfo AS EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by Department
Order by AverageSalaryPerDepartment desc


----- Retrieve a list of employees who have a salary that is greater than the average salary of their respective departments. -----

Drop table if exists  #temp_avgsal

Create Table #temp_avgSal
(
Jobtitle varchar (50),
AvgSalary int
)

insert into #temp_avgSal
select JobTitle ,avg (salary)
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
on EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by JobTitle
/* Checking Syntax = Select * From #temp_avgSal */


Select FirstName + ' ' + LastName as FullName, Age , Gender,Department,Salary , AvgSalary
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal on EmpInfo.EmployeeID = EmpSal.EmployeeID
join #temp_avgSal as Avgsal on EmpSal.JobTitle = Avgsal.Jobtitle
where salary > AvgSalary
order by Department



----- Calculate the total salary of all employees in the company. -----

Select sum(salary) AS TotalSalaryOFallEmployeesInTheCompany
From JichuProject.dbo.EmployeeInfo as Empinfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
on Empinfo.EmployeeID = EmpSal.EmployeeID



----- Calculate the median salary of all employees in the company. -----

Select distinct PERCENTILE_DISC(.5) Within Group (order by Salary)
Over (Partition By 1) As MedianSalaryOfallCompany
From JichuProject.dbo.EmployeeSalaryInfo


/* 7.5 Calculate the median salary of Each Department in the company. */

Select distinct Department, PERCENTILE_DISC(.5) Within Group (order by Salary)
Over (Partition By Department) As MedianSalaryPerDepartment
From JichuProject.dbo.EmployeeSalaryInfo as EmpInfo
Join JichuProject.dbo.EmployeeInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Order by MedianSalaryPerDepartment desc



----- Identify the Each department with the highest average age of employees,and then determine the top 1 job titles with the highest average salary in that department. -----

/*Temp Table for Average age */
drop Table #temp_Avg

Create Table #Temp_Avg
(
Jobtitle varchar (50),
AvgAGE varchar (50)
)
insert into #Temp_Avg 
Select JobTitle, Avg (age) AS AvgAGE
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by JobTitle
/* Checking Syntax = Select * From #Temp_Avg */


/*Temp Table for Max Salary Per Department */
Drop Table #Temp_MaxSal

Create Table #Temp_MaxSal
(
Jobtitle varchar(50),
MaxSal int
)

Insert Into #Temp_MaxSal

Select JobTitle, Max(salary) AS MaxSalaryPerDepartment
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group By JobTitle
/* Checking Syntax = Select * From #Temp_MaxSal */


/*The Real Query*/
Select FirstName,LastName,Age,Gender,Department,Salary,MaxSal
From JichuProject.dbo.EmployeeInfo as EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo as EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Join #Temp_Avg as AGEavg
On Ageavg.Jobtitle = EmpSal. JobTitle
Join #Temp_MaxSal as Salmax
on Salmax.Jobtitle = AGEavg.Jobtitle
where AvgAGE <= Age and Salary >= Maxsal
order by MaxSal Desc

/*The manager with the right Age is not the top salary in there department*/



----- Calculate the maximum salary for each department, and display the result along with the department name. -----

Select Department, Max (salary) AS MaxSalaryPerDepartment
From JichuProject.dbo.EmployeeInfo AS EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo AS EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by Department
Order by MaxSalaryPerDepartment desc


----- Calculate the minimum and maximum salary for each job title, and display the result along with the job title. -----

Select JobTitle, Min(salary) as MinimumSalary , Max(salary) as MaximumSalary
From JichuProject.dbo.EmployeeSalaryInfo
Group by JobTitle
Order by MinimumSalary Desc