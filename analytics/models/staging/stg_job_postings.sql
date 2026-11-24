
{% set extension_keywords = [
    "No degree mentioned",
    "Health insurance",
    "Dental insurance",
    "Paid time off"] 
%}

with source as 
(
    SELECT 
    *
    FROM {{ source('jobs', 'raw_job_postings') }}
    where error is not TRUE
    and job_id is not null
)

, parsed as (
    select
        *
        , from_json(job_extensions_raw, 'array<string>') as job_extensions
    from source
)

, cleaned as (
    select 
        job_id,
        job_title,
        trim(company_name) as company_name,
        job_location,
        regexp_replace(job_via, '^via', '') as source_platform,
        job_posted_at,
        job_salary,
        job_schedule_type,
        job_work_from_home,
        search_time,
        search_date,
        search_term,
        search_location,
        {{ parse_salary('job_salary', 'min') }} AS salary_min,
        {{ parse_salary('job_salary', 'max') }} AS salary_max,
        ({{ parse_salary('job_salary', 'min') }} + {{ parse_salary('job_salary', 'max') }}) / 2 AS salary_avg,
        NULLIF(REGEXP_EXTRACT(job_salary, 'an? (year|hour|month|day|week)$', 1), '') AS salary_period,
        CASE
            WHEN job_salary IS NOT NULL
            THEN COALESCE(NULLIF(TRIM(REGEXP_EXTRACT(job_salary, '^([^0-9]+)', 1)), ''), 'USD')
        END AS salary_currency,
        {% for keyword in extension_keywords -%}
        array_contains(
            job_extensions,
            "{{ keyword }}"
        ) as has_{{ slugify(keyword) }}
        {{ ", " if not loop.last }}
        {% endfor %}
    from parsed
)
select 
    *
from cleaned
qualify row_number() over (partition by job_id order by search_date desc) = 1
