
with job_postings as (
    select job_id 
    from {{ ref('fct_job_postings') }}
    {% if var('job_title', None) %}
    where search_term = '{{ var('job_title') }}'
    {% endif %}
)

, bridge as (
    select
        *
    from {{ ref('bridge_job_skills') }}
)

, skills as (
    select
        *
    from {{ ref('dim_skills') }}
)

select 
    display_name,
    category,
    count(distinct jp.job_id) as demand_count,
    round(count(distinct jp.job_id) / (select count(distinct job_id) from job_postings) *100, 1) as demand_percentage
    

from bridge b
inner join job_postings jp on b.job_id = jp.job_id
inner join skills s on b.skill_id = s.skill_id
group by 1,2
order by 4 desc
