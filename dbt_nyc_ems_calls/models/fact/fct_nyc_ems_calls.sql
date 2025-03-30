with ems_calls as (
    select * from {{ ref('stg_nyc_ems_calls') }}
),

call_type as (
    select * from {{ ref('call_type') }}
),

ems_zones as (
    select * from {{ ref('ems_zones') }}
),

incident_disposition as (
    select * from {{ ref('incident_disposition') }}
),

final as (

    select 
        ems_calls.*,
        extract(date from ems_calls.incident_datetime) as incident_date,
        concat(extract(year from ems_calls.incident_datetime), '-', extract(month from ems_calls.incident_datetime)) as incident_year_month,
        initial_type.description as initial_call_description,
        final_type.description as final_call_description,
        zones.description as incident_area_description,
        dispo.description as disposition_description,

    from ems_calls

    left join call_type initial_type on 
        ems_calls.initial_call_type = initial_type.call_type

    left join call_type final_type on
        ems_calls.final_call_type = final_type.call_type 
    
    left join ems_zones zones on
        ems_calls.incident_dispatch_area = zones.zone 

    left join incident_disposition dispo on
        ems_calls.incident_disposition_code = dispo.incident_disposition_code

)

select * from final