use world_layoffs;

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select *
from layoffs_staging2
where total_laid_off = 12000;
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(date), max(date)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

select substring(`date`, 1, 7) as month, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by 1
order by 2 desc;

SELECT company, YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 desc;

with Company_Year (company, years, total_laid_off) as
         (SELECT company, YEAR(`date`), SUM(total_laid_off)
          FROM layoffs_staging2
          GROUP BY company, YEAR(`date`)),
     company_year_rank as
         (SELECT *,
                 DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
          FROM Company_Year
          WHERE years IS NOT NULL)
select *
from company_year_rank
where Ranking <= 5;