-- En la mayoria de EDT se tiene mas o menos una logica de lo que se quiere encontrar, pero como en este caso no es asi 
-- sacare varios datos interesantes de este dataset que en la vida cotidiana nos podrian ser utiles

select * 
from layoffstaging2;

# Maximo de despidos
select max(total_laid_off)
from layoffstaging2;

# Que tan grandes son los despidos en porcentajes
select max(percentage_laid_off),  min(percentage_laid_off)
from layoffstaging2
where percentage_laid_off is not null;

# Cuales companies tienes 100% de despidos
select *
from layoffstaging2
where percentage_laid_off = 1;
-- Estas son mayormente startups

# Que tan grandes eran estas companies basado en los millones de fondos recaudados
select *
from layoffstaging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

# Top 5 companies con la mayor cantidad de despidos totales
select dense_rank() over(order by total_laid_off desc) as ranks, company, total_laid_off
from layoffstaging2
limit 5;

# Top 10 companies con la mayor suma de despidos: subquerie	
select dense_rank() over(order by Suma_Despidos desc) as ranks, company, Suma_Despidos
from 
( select company, sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by company
) as aggregated
order by Suma_Despidos desc
limit 11;

# Top 10 locations con la mayor suma de despidos: subquerie
select dense_rank() over(order by Suma_Despidos desc) as ranks, location, Suma_Despidos
from 
( select location, sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by location
) as aggregated
order by Suma_Despidos desc
limit 10;

# Top 10 countrys con la mayor suma de despidos: subquerie
select dense_rank() over(order by Suma_Despidos desc) as ranks, country, Suma_Despidos
from 
( select country, sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by country
) as aggregated
order by Suma_Despidos desc
limit 10;

# Suma total de despidos a traves de los years
select year(date) as 'Year', sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by year(date)
order by 1;

# Suma total de despidos por industria
select industry, sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by industry
order by 2 desc;

#  Suma total de despidos por stage
select stage, sum(total_laid_off) as Suma_Despidos
from layoffstaging2
group by stage
order by 2 desc;

# Cantidad de despidos por years: CTE
with Company_Year as 
(
  select company, year(date) AS Years, sum(total_laid_off) as Suma_Despidos
  from layoffstaging2
  group by company, year(date)
)
, Company_Year_Rank as (
  select company, Years, Suma_Despidos, dense_rank() over(partition by Years order by Suma_Despidos desc) as ranks
  from Company_Year
)
select company, Years, Suma_Despidos, ranks
from Company_Year_Rank
where ranks <= 3
and Years is not null
order by Years asc, Suma_Despidos desc;

# Rolling Total de despidos por mes: subquerie
select month, Suma_Despidos, sum(Suma_Despidos) over(order by month) as Rolling_Total
from 
( select substring(`date`, 1, 7) as month, sum(total_laid_off) as Suma_Despidos
    from layoffstaging2
    group by month
) as monthly_totals
order by month;

# Ahora en un CTE para que podamos hacer queries a partir del rolling total
with dateCTE as 
(
select substring(date,1,7) as dates, SUM(total_laid_off)as total_laid_off
from layoffstaging2
group by dates
order by dates
)
select dates, sum(total_laid_off) over(order by dates) as rolling_total_layoffs
from dateCTE;