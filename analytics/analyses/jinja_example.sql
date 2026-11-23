
{% set roles = ['data analyst', 'data scientist', 'data engineer'] -%}

{% for role in roles -%}
    select
        search_term,
        count(1) as total_rows
    from {{ref('stg_job_postings')}}
    where lower(search_term) like '%{{ role | title }}%'
    group by 1
    {{ "union all" if not loop.last }}
{%- endfor %}



