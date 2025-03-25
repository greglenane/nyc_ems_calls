{% macro col_to_boolean(column_name) %}
    case
        when lower({{ column_name }}) = 'y' then true
        when lower({{ column_name }}) = 'n' then false
        else null
    end as {{ column_name }}
{% endmacro %}