

with source as 
(
    SELECT 
    *
    FROM {{ source('jobs', 'raw_job_postings') }}
    where error is not TRUE
)

, cleaned as 
(
    select 
        job_id,
        job_title,
        trim(company_name) as company_name,
        job_location,
        regexp_replace(job_via, '^via', '') as job_via,
        job_posted_at,
        job_salary,
        job_schedule_type,
        job_work_from_home,
        job_extensions_raw,
        job_detected_extensions_raw,
        search_time,
        search_date,
        search_term,
        search_location
    from source
)
select 
    *
from cleaned
