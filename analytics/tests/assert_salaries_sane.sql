

{{ config(severity = 'warn') }}

select
    job_id,
    search_term,
    job_title,
    salary_min,
    salary_max,
    salary_avg,
    salary_period,
    salary_currency
from {{ ref('stg_job_postings') }}
where salary_period = 'year'
    and salary_currency = 'USD'
    and coalesce(salary_max, salary_max) >= 1000000
    and lower(salary_currency) = 'usd'
