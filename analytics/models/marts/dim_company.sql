
with job_postings as (
    select * from {{ ref('fct_job_postings') }}
)

select 
    company_name,
    count(1) as total_job_postings,
    avg(
        CASE
            WHEN salary_currency = 'USD' AND salary_period = 'year' 
            THEN salary_avg
        END) as avg_salary_year
from job_postings
where company_name is not null
group by 1
