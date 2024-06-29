-- CTEs
# Common Table Expressions se utiliza para hacer calculos mas avanzados
# Estos se pueden hacer con subqueries pero visualmente CTEs son mas comprensibles

# Hallar el salario promedio entre hombres y mujeres
with CTE_Example (GENDER, Avg_sal, Sal_Max, Sal_Min, Count_Sal)  as 
(
select gender, avg(salary) as avg_sal, max(salary) as max_sal, min(salary) as min_sal, count(salary) as coun_sal
from parks_and_recreation.employee_demographics as demo
join parks_and_recreation.employee_salary as sal
	on demo.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from CTE_Example
;

# Tablas temporales dentro de otras
with CTE_Example as 
(
select employee_id, gender, birth_date
from parks_and_recreation.employee_demographics as demo
where birth_date > '1985-01-01'
),
CTE_Example2 as
(
select employee_id, salary
from parks_and_recreation.employee_salary
where salary > 50000
)
select *
from CTE_Example
join CTE_Example2
	on CTE_Example.employee_id = CTE_Example2.employee_id
;

-- TEMPORARY TABLES
# Se usan mas que nada para guardar resultados intermedios de queries complejos
# Y para manipular data antes de meterla en una tabla permanente

create temporary table temp_table
(
firstName varchar(50), lastName varchar(50), favoriteMovie varchar(100)
);

select *
from temp_table;

insert into temp_table
values('Gerardo', 'Fernandez', '300: El imperio de un millon');

create temporary table sal_over50k
select *
from parks_and_recreation.employee_salary
where salary >= 50000;

select *
from sal_over50k;

-- STORED PROCEDURES
# Son maneras de guardar el codigo sql que puedes reusar una y otra vez (como funciones)

create procedure largeSalaries()
select *
from parks_and_recreation.employee_salary
where salary >= 50000;
call largeSalaries();

DELIMITER $$ # Se utiliza para tener multiples queries dentro de una funcion
CREATE PROCEDURE largeSalaries2()
BEGIN
    SELECT *
    FROM parks_and_recreation.employee_salary
    WHERE salary BETWEEN 10000 AND 50000;
END $$
DELIMITER ;
call largeSalaries2();

# PARAMETROS
DELIMITER $$
CREATE PROCEDURE employeeSal(employee_id_param int) 
BEGIN
	select salary
    from parks_and_recreation.employee_salary
    where employee_id = employee_id_param;
end $$
DELIMITER ;

call employeeSal(1)

-- TRIGGERS
# Un trigger es un bloque de codigo que se ejecuta automaticamente cuando un evento toma lugar en una tabla en especifico

# Cuando se agregue una fila a employee_salary agregarla tambien a employee_demo
DELIMITER $$
create trigger employeeInsert
	after insert on parks_and_recreation.employee_salary
    for each row
begin 
	insert into parks_and_recreation.employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
DELIMITER ;

insert into parks_and_recreation.employee_salary (employee_id, first_name, last_name, occupation, salary,
dept_id)
values (13, 'Jean', 'Rodriguez', 'Entertaiment', 1000000, null);

-- EVENTS
# Un evento toma lugar cuando es programado

show variables like 'event%';

DELIMITER $$
create event delete60
on schedule every 15 second
do
begin
	delete 
    from parks_and_recreation.employee_demographics
    where age >= 60;
end $$
DELIMITER ;