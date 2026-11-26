
{{config(
    materialized='ephemeral'
)}}

select
    *
from {{ ref('stg_job_postings') }}
where  search_date <= cast('{{ var("as_of", run_started_at.strftime("%Y-%m-%d")) }}' as date)
qualify row_number() over (partition by job_id order by search_time desc) = 1

