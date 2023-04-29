/*
1.Write a query to display the total number of employees in each department.

2.Write a query to display the total number of male and female employees in each department.

3.Write a query to display the average age of employees in each department.

4.Write a query to display the highest salary among employees of each gender in each department.

5.Write a query to display the top 5 departments with the highest average salary.

6.Write a query to display the top 5 departments with the highest percentage of female employees.

7.Write a query to display the age distribution of employees in each department (e.g., how many employees are between 20-30, 31-40, etc.).

8.Write a query to display the average salary of employees in each age range (e.g., 20-30, 31-40, etc.).

9.Write a query to display the number of employees who have been with the company for less than 1 year, 1-5 years, 6-10 years, and more than 10 years.

10.Write a query to display the top 5 departments with the highest percentage of employees who have a college degree.
*/

----------------------------------------------------------------------------------------------------------------------------------------


-----  Write a query to display the total number of employees in each department. -----

Select Department, Count(EmployeeID) AS TotalEmpPerDepartment
From JichuProject.dbo.EmployeeInfo 
Group by Department



-----  Write a query to display the total number of male and female employees in each department. -----

Select Department,Gender,count ( gender ) AS CountOfGenderPerDepartment
From JichuProject.dbo.EmployeeInfo
Group by Gender,Gender ,Department



-----  Write a query to display the average age of employees in each department. -----

Select Department , avg (Age) as AvgAgePerDepartment
From JichuProject.dbo.EmployeeInfo
Group by Department



-----  Write a query to display the highest salary among employees of each gender in each department. -----

Select  Department , Gender, MAX(salary) AS HighestSalary 
From JichuProject.dbo.EmployeeInfo AS EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo AS EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
Group by Department, Gender



-----  Write a query to display the top 3 departments with the highest average salary. -----

Select Department, Avg(Salary) AS HighestAVGSalary
From JichuProject.dbo.EmployeeInfo As Empinfo
Join JichuProject.dbo.EmployeeSalaryInfo As EmpSal
On Empinfo.EmployeeID = EmpSal.EmployeeID
Group by Department
order by AVG(salary) desc
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;



-----  Write a query to display the top 3 departments with the highest percentage of female employees. -----

WITH CTE_FemaleCount AS (
    SELECT Department, COUNT(*) AS FemaleCount
    FROM JichuProject.dbo.EmployeeInfo
    WHERE Gender = 'Female'
    GROUP BY Department
), CTE_TotalCount AS (
    SELECT Department, COUNT(*) AS TotalCount
    FROM JichuProject.dbo.EmployeeInfo
    GROUP BY Department
)


SELECT CTE_FemaleCount.Department, 
    100.0 * CTE_FemaleCount.FemaleCount / CTE_TotalCount.TotalCount AS FemalePercentage
FROM CTE_FemaleCount
JOIN CTE_TotalCount ON CTE_FemaleCount.Department = CTE_TotalCount.Department
ORDER BY FemalePercentage desc
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;



-----  Write a query to display the age distribution of employees in each department (e.g., how many employees are between 20-30, 31-50, etc.). -----

With CTE_Babyage as (
Select Department, count (*) AS BabyAge
From JichuProject.dbo.EmployeeInfo
Where Age between '20' And '30'	
Group By Department
), CTE_Oldbaby as (
Select Department, count (*) as Oldbaby
From JichuProject.dbo.EmployeeInfo
Where Age between '31' and '50'
group by Department

), CTE_DepartTolCount as (
Select Department, count (*) AS DepartTolCount
From JichuProject.dbo.EmployeeInfo
Group By Department
)

Select CTE_DepartTolCount.Department,
  CTE_DepartTolCount.DepartTolCount - CTE_Babyage.Babyage as Early20s,
  CTE_DepartTolCount.DepartTolCount - CTE_Oldbaby.Oldbaby as Late30s
From CTE_babyage 
Join CTE_DepartTolCount 
On CTE_Babyage.Department = CTE_DepartTolCount.Department
Join  CTE_Oldbaby
On  CTE_Oldbaby.Department = CTE_DepartTolCount.Department



-----  Write a query to display the average salary of employees in each age range (e.g., 20-30, 31-50, etc.). -----

With CTE_AvgSalaryForEarly20s as  (
Select Avg(Salary) as AvgSalaryForEarly20s
From JichuProject.dbo.EmployeeInfo As EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo As EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
where Age between '20' and '30'
), CTE_AvgSakaryForLate30s as  (
Select avg(salary) As AvgSakaryForLate30s
From JichuProject.dbo.EmployeeInfo As EmpInfo
Join JichuProject.dbo.EmployeeSalaryInfo As EmpSal
On EmpInfo.EmployeeID = EmpSal.EmployeeID
where Age between '31' and '50' 
)

SELECT Early20s.AvgSalaryForEarly20s, Late30s.AvgSakaryForLate30s
FROM CTE_AvgSalaryForEarly20s AS Early20s
CROSS JOIN CTE_AvgSakaryForLate30s AS Late30s;



-----  Write a query to display the number of employees who have been with the company for less than 1 year, 1-5 years, 6-10 years, and more than 10 years. -----

With CTE_EmpLessThanAYear as (
Select count (*) AS EmpLessThanAYear
From JichuProject.dbo.EmployeeInfo
where DATEDIFF(MONTH,HiredDate,GETDATE()) < 11 
), CTE_Between1and5Years As (
Select count (*) AS Between1and5Years
From JichuProject.dbo.EmployeeInfo
where DATEDIFF(YEAR,HiredDate,GETDATE()) < 5
), CTE_MoreThan5 as (
Select count (*) AS MoreThan5Years
From JichuProject.dbo.EmployeeInfo
where DATEDIFF(YEAR,HiredDate,GETDATE()) > 5
)
Select LessYear.EmpLessThanAYear, NormalYear.Between1and5Years, LongYear.MoreThan5Years
From CTE_EmpLessThanAYear as LessYear
Cross join CTE_Between1and5Years as NormalYear
Cross Join CTE_MoreThan5 as LongYear



-----  Write a query to display the top 3 departments with the highest percentage of employees who have a college degree. -----

With CTE_DegreeHolder as (
Select Department, count(*) AS  DegreeHolder
From JichuProject.dbo.EmployeeInfo
where CollegeStatus = 'Graduate'
Group  by Department
), CTE_TotalEmp AS (
Select Department, Count(*) AS TotalEmp
From JichuProject.dbo.EmployeeInfo
Group by Department
)

Select  degree.Department,
100*degree.DegreeHolder / TotalEmp. TotalEmp as HighestPercentageOfEmployeeWithDegree
From CTE_DegreeHolder as Degree
Join CTE_TotalEmp as TotalEmp
On Degree.Department = TotalEmp.Department
order by HighestPercentageOfEmployeeWithDegree desc
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;



--For Checking--
--Select Department, count(*) AS  DegreeHolder
--From JichuProject.dbo.EmployeeInfo
--where CollegeStatus = 'Graduate'
--Group  by Department

--Select Department, Count(*) AS TotalEmp
--From JichuProject.dbo.EmployeeInfo
--Group by Department

----------------------------------------------------------------------------------------------------------------------------------------