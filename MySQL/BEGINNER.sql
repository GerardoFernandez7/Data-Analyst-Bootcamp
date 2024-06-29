-- STATEMENTS
# DISTINCT
select distinct salary
from parks_and_recreation.employee_salary;

# PEMDAS
# Parenthesis-Exponential-Multiplication-Division-Addition-Substraction
select *, (dept_id + 5) + 5
from parks_and_recreation.employee_salary;

# * = everything

# % = anything

# _ = an exact character

-- WHERE Statement
select *
from parks_and_recreation.employee_salary
where salary >= 50000 and dept_id = 1;

-- LIKE Statement
select *
from parks_and_recreation.employee_demographics
where first_name like 'J___%';

select *
from parks_and_recreation.employee_demographics
where birth_date like '1989%';

-- GROUP BY
select gender, avg(age), max(age), min(age), count(age)
from parks_and_recreation.employee_demographics
group by gender;

select occupation, salary
from parks_and_recreation.employee_salary
group by occupation, salary;

-- ORDER BY
select *
from parks_and_recreation.employee_demographics
order by first_name asc; 

select *
from parks_and_recreation.employee_demographics
order by first_name, age; 

-- HAVING
select gender, avg(age)
from parks_and_recreation.employee_demographics
group by gender
having avg(age) > 40;

# having se usa especificamente despues de group by seguido de una funcion como avg, 
# No se puede usar where	

select occupation, avg(salary)
from parks_and_recreation.employee_salary
where occupation like '%manager%' 
group by occupation
having avg(salary) > 70000;

-- ALIASING & LIMIT
select first_name, avg(age) as avg_age
from parks_and_recreation.employee_demographics
group by first_name
having avg_age > 10
limit 4;