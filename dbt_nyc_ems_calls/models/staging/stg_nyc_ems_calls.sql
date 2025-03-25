with source_nyc_ems_calls as (

    select * from {{ source('nyc_ems_calls_dataset', 'nyc_ems_calls') }}

),

final as (

    select 
        cad_incident_id,
        incident_datetime,
        initial_call_type,
        initial_severity_level_code,
        final_call_type,
        final_severity_level_code,
        first_assignment_datetime,
        {{ col_to_boolean('valid_dispatch_rspns_time_indc') }},
        dispatch_response_seconds_qy,
        first_activation_datetime,
        first_on_scene_datetime,
        {{ col_to_boolean('valid_incident_rspns_time_indc') }},
        incident_response_seconds_qy,
        incident_travel_tm_seconds_qy,
        incident_close_datetime,
        {{ col_to_boolean('held_indicator') }},
        incident_disposition_code,
        borough,
        incident_dispatch_area,
        zipcode,
        policeprecinct,
        citycouncildistrict,
        communitydistrict,
        communityschooldistrict,
        congressionaldistrict,
        {{ col_to_boolean('reopen_indicator') }},
        {{ col_to_boolean('special_event_indicator') }},
        {{ col_to_boolean('standby_indicator') }},
        {{ col_to_boolean('transfer_indicator') }},
        first_to_hosp_datetime,
        first_hosp_arrival_datetime

    from source_nyc_ems_calls
)

select * from final

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}