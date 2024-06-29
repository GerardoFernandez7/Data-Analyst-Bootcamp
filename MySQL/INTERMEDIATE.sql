-- INNER JOINS
# Te permite combinar 2 tablas o mas si tienen una columna en comun
# inner join = join 
select demo.employee_id, age , occupation
from employee_demographics as demo
join employee_salary as sal
	on demo.employee_id = sal.employee_id;
    
-- OUTER JOINS 
select *
from employee_demographics as demo
left join employee_salary as sal
	on demo.employee_id = sal.employee_id;
# Con left join se pone a la derecha la informacion nueva y antigua de las filas que hacen match
# Con right join se hacen null las que no hacen match

-- SELF JOIN
# Es un join en el que amarras la tabla a ella misma
# En este ejemplo ponemos la misma tabla a la der sumando 1 posicion (eliminando a Leslie) 
select *
from employee_salary as emp1
join employee_salary as emp2
	on emp1.employee_id + 1 = emp2.employee_id;
    
-- JOINING MULTIPLE TABLES 
select *
# Esta es una tabla de referencia, ya que su contenido no cambia constantemente
from parks_departments;

# Unimos demo con sal y sal con dep
select *
from employee_demographics as demo
join employee_salary as sal
	on demo.employee_id = sal.employee_id
join parks_departments as dep
	on sal.dept_id = dep.department_id; 

-- UNIONS
# Permite combinar filas juntas como las columnas en JOIN pero con filas '
# Union por defecto tiene distinct, si no lo queremos usamos ALL
select *
from employee_demographics
union
select *
from employee_salary;

select first_name, last_name, 'Old Man' as Etiqueta
from employee_demographics
where age >= 40 and gender = 'Male'
union
select first_name, last_name, 'Old Female'
from employee_demographics
where age >= 40 and gender = 'Female'
union
select first_name, last_name, 'Highly Paid'
from employee_salary
where salary > 70000
order by first_name
;

-- STRING FUNCTIONS
select length('Flores');

select first_name, length(first_name) as cant_letras
from employee_demographics
order by cant_letras
;

select upper('flores');

select lower('FLoreS');

# Trim elimina los espacios en blanco, RTRIM y LTRIM eliminan los espacios de un solo lado
select trim('                   Flores                        '), ltrim('                   Flores                        '), rtrim('                   Flores                        ');

# LEFT y RIGHT solo imprimen la cantidad de letras indicadas contadas desde ese lado
select first_name, left(first_name, 4), right(first_name, 4)
from employee_demographics;

# SUBSTRING permite crear pequenas cadenas a partir de la posicion ingresada y luego la cantidad de caracteres a la derecha
select substring('flores', 3, 4);

select birth_date, substring(birth_date,1,4) as birth_year
from employee_demographics;

# REPLACE reemplaza dos caracteres
select replace('oso', 's', 'r');

# LOCATE devuelve la posicion encontrada
select locate('r', 'Fernandez');

select first_name, locate('An', first_name)
from employee_demographics;

# CONCAT junta el contenido de dos columnas
select first_name, last_name, concat(first_name, ' ', last_name) as full_name
from employee_demographics;

-- CASE Statements
SELECT first_name, last_name,
CASE
    WHEN age <= 30 THEN 'Joven'
    WHEN age between 30 and 50 then 'Adulto'
    WHEN age > 50 then 'Viejo'
END as age_group
FROM employee_demographics;

select *
from employee_salary;

# Pay Increase and Bonus:
# > 50 000 = +5%
# < 50 000 = +7%
# Finance dept = +10%
select first_name, last_name, salary,
case
    when salary < 50000 then salary * 0.05
    when salary > 50000 then salary * 0.07
end as Pay_Increase,
case
	when dept_id = 6 then salary * 0.1
end as Finance_Bonus
from employee_salary;

-- SUBQUERIES 
# Son queries dentro de otros queries y van dentro de parentesis
select *
from employee_demographics
where employee_id in
					(select employee_id
                    from employee_salary
                    where dept_id = 1);
                    
select first_name, salary,
(select avg(salary)
from employee_salary)
from employee_salary;

-- WINDOW FUNCTIONS
# Es como group by pero en vez de agrupar todo en una sola fila, agrupa todo en particiones.

select dem.employee_id, dem.first_name, gender, salary, avg(salary) over(partition by gender) as avg_salary_partition
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.employee_id, dem.first_name, gender, salary, sum(salary) over(partition by gender) as sum_salary_partition
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

# Rolling total
select dem.employee_id, dem.first_name, gender, salary, sum(salary) over(partition by gender order by dem.employee_id) as Rolling_Total
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

# ROW_NUMBER() Agrega el numero de fila
select dem.employee_id, dem.first_name, gender, salary, row_number() over(partition by gender order by salary desc)
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

# RANK() pone el rango segun order by y es posicional DENSE_RANK() pone el rango segun order by y es numerico
select dem.employee_id, dem.first_name, gender, salary, 
row_number() over(partition by gender order by salary desc) as rownumber,
rank() over(partition by gender order by salary desc) as rankk,
dense_rank() over(partition by gender order by salary desc) as dense_rankk
from employee_demographics as dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;
