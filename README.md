# Pewlett-Hackard-Analysis

## Overview of the Analysis

In this project we analyzed how many employees are nearing retirement and the employees eligible for the mentorship program. This information will help the organization plan for these vacancies and improve their hiring process.

We will perform these technical analysis:
 - Run a query in SQL for the total number of retiring employees by Title, save a Table in the database named Retirement Titles and export its data as retirement_titles.csv.
 - Run a query in SQL for the employee number, first and last name, and most recent title, save a table in the database named Unique Title and export its data as unique_titles.csv
 - Run a query in SQL for the number of titles filled by employees who are retiring, save a table named Retiring Titles and export its data as retiring_titles.csv.
 - Run a query in SQL for the current employees born in 1965 who are eligible for the mentorship program, save a table in the database named Mentorship Eligibility and export its data as mentorship_eligibility.csv. 

For this project we used ERD to design our table relationships, PGAdmin for our querying, PostgresSQL to store our database and VSCode to edit and save our schema and query files.

## Results

--Deliverable 1: Find the number of Retiring Employees by Title

We designed our table relationships in ERD to illustrate how objects relate to each other.

![This is an image](/EmployeeDB.png)

We used PostgreSQL to create our database named PH-Employee_DB based on the ERD structure.

Once we had the main structure created we ran queries to find employees eligible for retirement who were born between 1952 and 1955 and ordered them by employee number. We did this by joining the employees and titles tables. We then saved the results in a .csv file. A new table was created and named Retirement Titles.

![This is an image](/Data/retirement_titles.png)

We also removed duplicate entries and queried for current employees, making sure not to include former employees. This was accomplished by searching for recent titles. Those results were exported to a .csv file. A new table was created named Unique Titles.

![This is an image](/Data/unique_titles.png)

We proceeded to narrow our search to retrieve the number of employees by their most recent job title who are about to retire. This new table was named Retiring Titles. The data from that table was exported to a .csv file.

![This is an image](/Data/retiring_titles.png)

```
SELECT e.emp_no, --retrieve emp_no, first_name, and last_name from Employees
	e.first_name,
	e.last_name,
	ti.title, --retrieve title, from_date and to_date from Titles
	ti.from_date,
	ti.to_date
INTO retirement_titles --Name of new table
FROM employees AS e -- alias for employees table
	INNER JOIN titles AS ti --return records that have matches between tables, alias for titles table
		ON (e.emp_no = ti.emp_no) --columns where we are matching data
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') -- filter by employees born between 1952 and 1955
ORDER BY e.emp_no; --order by employee number

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO Unique_Titles
FROM retirement_titles 
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

-- Retrieve the number of titles from the Unique Titles table.
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;
```


-- Deliverable 2: For our next deliverable, we needed to find employees that would be eligible for a mentorship program. The targeted employees would be born in the year 1965. We exported the dated into a .csv file. For this query we made sure to capture only current employees. That would result in an accurate count of eligible employees for the mentorship program. 

![This is an image](/Data/mentorship_eligibility.png)

```
SELECT DISTINCT ON (e.emp_no,de.emp_no,ti.emp_no) e.emp_no, --retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
	e.first_name,
	e.last_name,
	e.birth_date, 
	de.from_date, --retrieve from_date and to_date from Department Employee
	de.to_date,
    ti.title -- --retrieve title from Titles
INTO Mentorship_Eligibility --Name of new table
FROM employees AS e -- alias for employees table
	INNER JOIN dept_emp AS de --return records that have matches between tables, alias for department employee
		ON (e.emp_no = de.emp_no) --columns where we are matching data
    INNER JOIN titles AS ti --return records that have matches between tables, alias for titles
        ON (e.emp_no = ti.emp_no) -- columns where we are matching data
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') -- filter by employees born in the year 1965
AND (de.to_date = '9999-01-01') --filter for only current employees
ORDER BY e.emp_no; --order by employee number
```

## Summary

Currently there are 72,458 active employees of retirement age. This would create a huge vacancy for the nine departments, but in particular filling the senior engineers and senior staff title roles will be critical. To prepare for the "silver tsunami", Pewlett Hackward will need to institue a mentiorship program that will target employees nearing retirement age. The number of employees born in 1965 who are eligible for the mentorship program is 1,549. This does not seem to be an adequate number considering how many employees will be leaving. 
- Running a query for the eligible employees by title can provide some insight on what departments may lack mentors.
- Running a query for eligible employees who were born two years earlier (1963) in addition to employees born in 1965 may provide more of a comfortable cushion for Pewlett Hackward and provide the support each department will need to sustain a successful operation. It would also include additional managers which is the smallest number represented.

This is the mentorship eligibiliy by title based on the 1,549 employees born in 1965
![This is an image](/Data/mentorship_eligibility_by_title.png)


This is the output if we were to extend the mentorship eligibility for employees born between 1963 and 1965. The number of eligible employees is 38,401. 
![This is an image](/Data/mentorship_eligibility_extended.png)


This is the mentorship eligibiliy by title based on the 38,401 employees born in 1963 and 1965.
![This is an image](/Data/mentorship_eligibility_extended_by_title.png)