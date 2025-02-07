use world_layoffs;

select * from layoffs;


-- Remove Duplicates
-- Standardize the Data
-- Null Values or blank values
-- Remove any columns

-- 1. Removing Duplicates
create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select * from layoffs_staging;

select *, row_number() over () from layoffs;

select *,
       row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as
    (select *,
       row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
    from layoffs_staging)
select * from duplicate_cte where row_num > 1;

select * from layoffs_staging where company = 'Casper';

CREATE TABLE `layoffs_staging2` (
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

select * from layoffs_staging2;

insert into layoffs_staging2
select *,
       row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
    from layoffs_staging;

select * from layoffs_staging2 where row_num > 1;

delete from layoffs_staging2 where row_num > 1;


-- Standardizing Data
select company, trim(company) from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select * from layoffs_staging2 where industry like 'Cry%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Cry%';

select distinct country from layoffs_staging2 order by 1;

select country, count(1) from layoffs_staging2 where country like 'United States%' group by country;

update layoffs_staging2
set country = 'United States'
where country like 'United States%';

update layoffs_staging2
set country = trim(country);

select `date`, str_to_date(`date`, '%m/%d/%Y') from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2 -- never do this on the main tables, only do it on staging tables
modify column `date` DATE;

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2 where industry is null or industry = '';

select  l1.company, l1.location, l2.location, l1.industry, l2. industry
from layoffs_staging2 l1
join layoffs_staging2 l2
    on l1.company = l2.company
where (l1.industry is null or l1.industry = '')
and l2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 l1
join layoffs_staging2 l2
    on l1.company = l2.company and l1.location = l2.location
set l1.industry = l2.industry
where (l1.industry is null or l1.industry = '')
and l2.industry is not null;

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select count(1) from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
commit;

alter table layoffs_staging2
drop column row_num;
