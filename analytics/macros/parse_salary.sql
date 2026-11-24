{% macro parse_salary(extract_column, part) -%}
    {%- if part == 'min' -%}
        {%- set segment = "REGEXP_EXTRACT(SPLIT(" ~ extract_column ~ ", '–')[0], '([0-9][0-9,.]*)', 1)" -%}
    {%- else -%}
        {%- set segment = "REGEXP_EXTRACT(ELEMENT_AT(SPLIT(" ~ extract_column ~ ", '–'), -1), '([0-9][0-9,.]*)', 1)" -%}
    {%- endif -%}

    TRY_CAST(REPLACE({{ segment }}, ',', '') AS DECIMAL(15, 2))
    * CASE UPPER(REGEXP_EXTRACT({{ extract_column }}, '[0-9][0-9,.]*([KkMm])', 1))
        WHEN 'K' THEN 1000
        WHEN 'M' THEN 1000000
        ELSE 1
      END
{%- endmacro %}
