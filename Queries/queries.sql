-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';


-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- use left join to create a new table of current employees who are retirement-eligible employees
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Check new table containing only the current employees who are eligible for retirement 
SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- CREATE New table for Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO Emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM Emp_count;
SELECT * FROM salaries;
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;

DROP TABLE emp_info CASCADE

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name	
--INTO sales_info
FROM retirement_info as ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name	
--INTO sales_deve
FROM retirement_info as ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

--Deliverable 1: The Number of Retiring Employees by Title
SELECT e.emp_no, --retrieve emp_no, first_name, and last_name from Employees
	e.first_name,
	e.last_name,
	ti.title, --retrieve title, from_date and to_date from Titles
	ti.from_date,
	ti.to_date
--INTO retirement_titles --Name of new table
FROM employees AS e -- alias for employees table
	INNER JOIN titles AS ti --return records that have matches between tables, alias for titles table
		ON (e.emp_no = ti.emp_no) --columns where we are matching data
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') -- filter by employees born between 1952 and 1955
ORDER BY e.emp_no; --order by employee number

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

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO Unique_Titles
FROM retirement_titles 
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

DROP TABLE Unique_Titles CASCADE

-- Retrieve the number of titles from the Unique Titles table.
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

DROP TABLE retiring_titles CASCADE

SELECT * FROM unique_titles;
SELECT * FROM retiring_titles;


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