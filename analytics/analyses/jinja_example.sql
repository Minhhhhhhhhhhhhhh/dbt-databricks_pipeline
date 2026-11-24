
{% set roles = dbt_utils.get_column_values(table = ref('stg_job_postings'), column = 'search_term') -%}

{% for role in roles -%}
    select
        search_term,
        count(1) as total_rows
    from {{ref('stg_job_postings')}}
    where search_term like '%{{ role | title }}%'
    group by 1
    {{ "union all " if not loop.last }}
{%- endfor %}



