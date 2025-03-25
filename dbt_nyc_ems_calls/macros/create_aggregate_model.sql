{% macro create_aggregate_model(column_name) %}

with cte as (

    select * from {{ ref("dim_nyc_ems_calls") }}

),

final as(
    select 
        {{ column_name }},
        incident_date,
        avg(dispatch_response_seconds_qy) over (partition by {{ column_name }} order by incident_date) as avg_dispatch_response,
        avg(incident_response_seconds_qy) over (partition by {{ column_name }} order by incident_date) as avg_incident_response,
        avg(incident_travel_tm_seconds_qy) over (partition by {{ column_name }} order by incident_date) as avg_incident_travel_time,
    from cte

)

select * from final

{% endmacro %}