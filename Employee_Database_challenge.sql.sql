--Deliverable 1: The Number of Retiring Employees by Title
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

-- Deliverable 2: Using the ERD you created in this module as a reference and your knowledge of SQL queries, 
-- create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965 
-- and December 31, 1965.

SELECT DISTINCT ON (e.emp_no,de.emp_no,ti.emp_no) e.emp_no, --retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
	e.first_name,
	e.last_name,
	e.birth_date, 
	de.from_date, --retrieve from_date and to_date from Department Employee
	de.to_date,
    ti.title
INTO Mentorship_Eligibility --Name of new table
FROM employees AS e -- alias for employees table
	INNER JOIN dept_emp AS de --return records that have matches between tables, alias for titles table
		ON (e.emp_no = de.emp_no) --columns where we are matching data
    INNER JOIN titles AS ti
        ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') -- filter by employees born in the year 1965
AND (de.to_date = '9999-01-01') --filter for only current employees
ORDER BY e.emp_no; --order by employee number