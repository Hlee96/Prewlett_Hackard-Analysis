CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
and (hire_date between '1985-01-01' and '1988-12-31');
-- second condition is a tuple
-- place each condition in a group

-- Count function works in a similar fashion as the python method
-- Number of employees retiring
-- select into tells postgress that instead of generating a list of results the data is saved as a 
-- new table
select count(first_name)
Into retirement_info
from employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
and (hire_date between '1985-01-01' and '1988-12-31');

select * from retirement_info

drop table retirement_info;

-- Create new table for retiring employees
select emp_no, first_name, last_name
into retirement_info
from employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from retirement_info;

-- Joining departments and dept_manager tables
-- only the columns we want to view in each table
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
-- points to the first table to be joine, departments
FROM departments
-- Second table to be joined
INNER JOIN dept_manager
-- Where to look for matches
ON departments.dept_no = dept_manager.dept_no;

Select d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
Inner Join dept_manager as dm
ON d.dept_no=dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

select ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date
FROM retirement_info as ri
Left Join dept_emp as de
On ri.emp_no=de.emp_no;

select ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no=de.emp_no
WHERE de.to_date=('9999-01-01');

-- employee count by department number
-- count was used on the employee numbers
select count(ce.emp_no), de.dept_no
from current_emp as ce
left join dept_emp as de
on ce.emp_no=de.emp_no
GROUP BY  de.dept_no
ORDER BY de.dept_no;

create table dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT Null,
	from_date DATE Not Null,
	to_date DATE NOT null,
	Primary Key (emp_no,dept_no));