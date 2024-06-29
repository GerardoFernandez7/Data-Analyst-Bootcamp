# 1. Remove Duplicates
# 2. Standardize the data
# 3. Null values or blank values
# 4. Remove unnecesary columns or Rows

create table layoffStaging
like layoffs;

select *
from layoffstaging;

# Instertamos todo en una nueva tabla para dejar la original intacta
insert layoffstaging
select *
from layoffs;

# 1.
with duplicateCTE as 
(
select *, row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffstaging
)
select *
from duplicateCTE
where row_num >=2
;

select *
from layoffstaging
where company = 'casper';

CREATE TABLE `layoffstaging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffstaging2;

insert into layoffstaging2
select *, row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffstaging;

delete
from layoffstaging2
where row_num > 1;

# 2.
# Eliminar espacios en blanco
select company, trim(company)
from layoffstaging2;

update layoffstaging2
set company = trim(company);

# Hacer que las industrias con nombres similares sean iguales
select distinct industry
from layoffstaging2
order by 1;

update layoffstaging2
set industry = 'Crypto'
where industry like 'Crypto%';

# Eliminar puntos de la columna country
select distinct country
from layoffstaging2;

select distinct country, trim(trailing '.' from country) # Trailing elimina lo que le digas
from layoffstaging2
order by 1;

update layoffstaging2
set country = trim(trailing '.' from country); 

# Poner la fecha en formato estandar
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffstaging2;

update layoffstaging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

# Pasar date a formato fecha (estaba en text)
alter table layoffstaging2
modify column `date` date;

# 3.
# Convertir espacios en blancos en nulls
update layoffstaging2
set industry = null, company = null, location = null, total_laid_off = null, stage = null, 
country = null, funds_raised_millions = null
where industry = '' or company = '' or location = '' or total_laid_off = '' or stage = '' or 
country = '' or funds_raised_millions = '';

# Agregar la industria a las filas que no tienen a partir de otras que si 
select *
from layoffstaging2
where industry is null;

select t1.industry, t2.industry
from layoffstaging2 as t1
join layoffstaging2 as t2
	on t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

update layoffstaging2 as t1
join layoffstaging2 as t2
	on t1.industry = t2.industry
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

# 4. 
# total_laid_off y percetage_laid_off son columnas importantes por lo que eliminaremos las que sean null ya que no nos sirven
select *
from layoffstaging2
where total_laid_off is null and percentage_laid_off is null;

delete 
from layoffstaging2
where total_laid_off is null and percentage_laid_off is null;

# Ya no necesitamos row_num 
alter table layoffstaging2
drop column row_num;

# Eliminar las filas que no tengan company
delete
from layoffstaging2
where company is null;