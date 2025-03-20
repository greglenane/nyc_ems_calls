with source_nyc_ems_calls as (

    select * from {{ source('nyc_ems_calls_dataset', 'nyc_ems_calls') }}
),

final as (

    select * from source_nyc_ems_calls
)

select * from final