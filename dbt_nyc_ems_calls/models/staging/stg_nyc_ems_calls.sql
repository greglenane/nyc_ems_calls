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

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(valid_dispatch_rspns_time_indc) = 'y' then true
                when lower(valid_dispatch_rspns_time_indc) = 'n' then false
                else null  -- Handle unexpected values
            end as boolean
        ) as valid_dispatch_rspns_time_indc,

        dispatch_response_seconds_qy,
        first_activation_datetime,
        first_on_scene_datetime,

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(valid_incident_rspns_time_indc) = 'y' then true
                when lower(valid_incident_rspns_time_indc) = 'n' then false
                else null
            end as boolean
        ) as valid_incident_rspns_time_indc,

        incident_response_seconds_qy,
        incident_travel_tm_seconds_qy,
        incident_close_datetime,
        
        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(held_indicator) = 'y' then true
                when lower(held_indicator) = 'n' then false
                else null
            end as boolean
        ) as held_indicator,

        incident_disposition_code,
        borough,
        incident_dispatch_area,
        zipcode,
        policeprecinct,
        citycouncildistrict,
        communitydistrict,
        communityschooldistrict,
        congressionaldistrict,

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(reopen_indicator) = 'y' then true
                when lower(reopen_indicator) = 'n' then false
                else null
            end as boolean
        ) as reopen_indicator,

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(special_event_indicator) = 'y' then true
                when lower(special_event_indicator) = 'n' then false
                else null
            end as boolean
        ) as special_event_indicator,

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(standby_indicator) = 'y' then true
                when lower(standby_indicator) = 'n' then false
                else null
            end as boolean
        ) as standby_indicator,

        -- Convert 'Y' to TRUE and 'N' to FALSE, then cast as BOOLEAN
        cast(
            case 
                when lower(transfer_indicator) = 'y' then true
                when lower(transfer_indicator) = 'n' then false
                else null
            end as boolean
        ) as transfer_indicator,

        first_to_hosp_datetime,
        first_hosp_arrival_datetime

    from source_nyc_ems_calls
)

select * from final

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}